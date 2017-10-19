/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Triton IVI UI.
**
** $QT_BEGIN_LICENSE:GPL-QTAS$
** Commercial License Usage
** Licensees holding valid commercial Qt Automotive Suite licenses may use
** this file in accordance with the commercial license agreement provided
** with the Software or, alternatively, in accordance with the terms
** contained in a written agreement between you and The Qt Company.  For
** licensing terms and conditions see https://www.qt.io/terms-conditions.
** For further information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 or (at your option) any later version
** approved by the KDE Free Qt Foundation. The licenses are as published by
** the Free Software Foundation and appearing in the file LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
** SPDX-License-Identifier: GPL-3.0
**
****************************************************************************/

#include "MouseTouchAdaptor.h"

#include <QGuiApplication>
#include <QMouseEvent>
#include <QTest>

#include <qpa/qplatformnativeinterface.h>
#include <qpa/qwindowsysteminterface.h>

#include <X11/extensions/XInput2.h>
#include <X11/extensions/XI2proto.h>

Q_LOGGING_CATEGORY(mouseTouchAdaptor, "mousetouchadaptor")

using QTest::QTouchEventSequence;

namespace {

Qt::MouseButton xcbButtonToQtMouseButton(xcb_button_t detail)
{
    switch (detail) {
        case 1: return Qt::LeftButton;
        case 2: return Qt::MidButton;
        case 3: return Qt::RightButton;
        // don't care about the rest
        default: return Qt::NoButton;
    }
}

void xi2PrepareXIGenericDeviceEvent(xcb_ge_event_t *event)
{
    // xcb event structs contain stuff that wasn't on the wire, the full_sequence field
    // adds an extra 4 bytes and generic events cookie data is on the wire right after the standard 32 bytes.
    // Move this data back to have the same layout in memory as it was on the wire
    // and allow casting, overwriting the full_sequence field.
    memmove((char*) event + 32, (char*) event + 36, event->length * 4);
}

qreal fixed1616ToReal(FP1616 val)
{
    return qreal(val) / 0x10000;
}

} // anonymous namespace

MouseTouchAdaptor *MouseTouchAdaptor::m_instance = nullptr;

MouseTouchAdaptor *MouseTouchAdaptor::instance()
{
    if (!m_instance) {
        new MouseTouchAdaptor;
    }
    return m_instance;
}

MouseTouchAdaptor::MouseTouchAdaptor()
{
    Q_ASSERT(!m_instance);
    m_instance = this;

    qGuiApp->installNativeEventFilter(this);

    // Create a fake touch device to deliver our synthesized events
    m_touchDevice = new QTouchDevice;
    m_touchDevice->setType(QTouchDevice::TouchScreen);
    QWindowSystemInterface::registerTouchDevice(m_touchDevice);

    queryForXInput2();
}

MouseTouchAdaptor::~MouseTouchAdaptor()
{
    Q_ASSERT(m_instance);
    m_instance = nullptr;
}

void MouseTouchAdaptor::queryForXInput2()
{
    QPlatformNativeInterface *nativeInterface = qGuiApp->platformNativeInterface();
    Display *xDisplay = static_cast<Display*>(nativeInterface->nativeResourceForIntegration("Display"));

    int xiOpCode, xiEventBase, xiErrorBase;
    if (xDisplay && XQueryExtension(xDisplay, "XInputExtension", &xiOpCode, &xiEventBase, &xiErrorBase)) {
        // 2.0 is enough for our needs
        int xiMajor = 2;
        int xi2Minor = 0;
        m_haveXInput2 = XIQueryVersion(xDisplay, &xiMajor, &xi2Minor) != BadRequest;
    }
}

bool MouseTouchAdaptor::nativeEventFilter(const QByteArray &eventType, void *message, long * /*result*/)
{
    if (eventType != "xcb_generic_event_t") {
        qCDebug(mouseTouchAdaptor) << "Non XCB native event received. Ignoring.";
        return false;
    }

    xcb_generic_event_t *xcbEvent = static_cast<xcb_generic_event_t *>(message);

    switch (xcbEvent->response_type & ~0x80) {
        case XCB_BUTTON_PRESS: {
            auto xcbPress = reinterpret_cast<xcb_button_press_event_t *>(xcbEvent);
            return handleButtonPress(static_cast<WId>(xcbPress->event), xcbPress->detail, 0,
                    xcbPress->event_x, xcbPress->event_y);
        }
        case XCB_BUTTON_RELEASE: {
            auto xcbRelease = reinterpret_cast<xcb_button_release_event_t *>(xcbEvent);
            return handleButtonRelease(static_cast<WId>(xcbRelease->event), xcbRelease->detail, 0,
                    xcbRelease->event_x, xcbRelease->event_y);
        }
        case XCB_MOTION_NOTIFY: {
            auto xcbMotion = reinterpret_cast<xcb_motion_notify_event_t *>(xcbEvent);
            return handleMotionNotify(static_cast<WId>(xcbMotion->event), 0,
                                      xcbMotion->event_x, xcbMotion->event_y);
        }
        case XCB_GE_GENERIC:
            if (m_haveXInput2) {
                return handleXI2Event(reinterpret_cast<xcb_ge_event_t *>(xcbEvent));
            } else {
                return false;
            }
        default:
            return false;
    };
}

bool MouseTouchAdaptor::handleButtonPress(WId windowId, uint32_t detail, uint32_t /*modifiers*/, int x, int y)
{
    Qt::MouseButton button = xcbButtonToQtMouseButton(detail);

    // Filter out the other mouse buttons
    if (button != Qt::LeftButton)
        return true;

    QWindow *targetWindow = findQWindowWithXWindowID(windowId);

    QPoint windowPos(x / targetWindow->devicePixelRatio(), y / targetWindow->devicePixelRatio());

    QTouchEventSequence touchEvent = QTest::touchEvent(targetWindow, m_touchDevice, false /* autoCommit */);
    touchEvent.press(0 /* touchId */, windowPos);
    touchEvent.commit(false /* processEvents */);

    m_leftButtonIsPressed = true;
    return true;
}

bool MouseTouchAdaptor::handleButtonRelease(WId windowId, uint32_t detail, uint32_t, int x, int y)
{
    Qt::MouseButton button = xcbButtonToQtMouseButton(detail);

    // Don't eat the event if it wasn't a left mouse press
    if (button != Qt::LeftButton)
        return false;

    QWindow *targetWindow = findQWindowWithXWindowID(windowId);

    QPoint windowPos(x / targetWindow->devicePixelRatio(), y / targetWindow->devicePixelRatio());

    QTouchEventSequence touchEvent = QTest::touchEvent(targetWindow, m_touchDevice, false /* autoCommit */);
    touchEvent.release(0 /* touchId */, windowPos);
    touchEvent.commit(false /* processEvents */);

    m_leftButtonIsPressed = false;
    return true;
}

bool MouseTouchAdaptor::handleMotionNotify(WId windowId, uint32_t /*modifiers*/, int x, int y)
{
    if (!m_leftButtonIsPressed)
        return true;

    QWindow *targetWindow = findQWindowWithXWindowID(windowId);

    QPoint windowPos(x / targetWindow->devicePixelRatio(), y / targetWindow->devicePixelRatio());

    QTouchEventSequence touchEvent = QTest::touchEvent(targetWindow, m_touchDevice, false /* autoCommit */);
    touchEvent.move(0 /* touchId */, windowPos);
    touchEvent.commit(false /* processEvents */);

    return true;
}

QWindow *MouseTouchAdaptor::findQWindowWithXWindowID(WId windowId)
{
    QWindowList windowList = QGuiApplication::topLevelWindows();
    QWindow *foundWindow = nullptr;

    int i = 0;
    while (!foundWindow && i < windowList.count()) {
        QWindow *window = windowList[i];
        if (window->winId() == windowId)
            foundWindow = window;
        else
            ++i;
    }

    Q_ASSERT(foundWindow);
    return foundWindow;
}

bool MouseTouchAdaptor::handleXI2Event(xcb_ge_event_t *event)
{
    xi2PrepareXIGenericDeviceEvent(event);
    xXIGenericDeviceEvent *xiEvent = reinterpret_cast<xXIGenericDeviceEvent *>(event);
    xXIDeviceEvent *xiDeviceEvent = 0;

    switch (xiEvent->evtype) {
    case XI_ButtonPress:
    case XI_ButtonRelease:
    case XI_Motion:
        xiDeviceEvent = reinterpret_cast<xXIDeviceEvent *>(event);
        break;
    default:
        break;
    }

    if (!xiDeviceEvent)
        return false;

    switch (xiDeviceEvent->evtype) {
    case XI_ButtonPress:
        return handleButtonPress(
                static_cast<WId>(xiDeviceEvent->event),
                xiDeviceEvent->detail,
                xiDeviceEvent->mods.base_mods,
                fixed1616ToReal(xiDeviceEvent->event_x),
                fixed1616ToReal(xiDeviceEvent->event_y));
    case XI_ButtonRelease:
        return handleButtonRelease(
                static_cast<WId>(xiDeviceEvent->event),
                xiDeviceEvent->detail,
                    xiDeviceEvent->mods.base_mods,
                fixed1616ToReal(xiDeviceEvent->event_x),
                fixed1616ToReal(xiDeviceEvent->event_y));
    case XI_Motion:
        return handleMotionNotify(
                static_cast<WId>(xiDeviceEvent->event),
                xiDeviceEvent->mods.base_mods,
                fixed1616ToReal(xiDeviceEvent->event_x),
                fixed1616ToReal(xiDeviceEvent->event_y));
        return true;
    default:
        return false;
    }
}
