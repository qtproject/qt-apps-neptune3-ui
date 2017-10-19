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

#ifndef MOUSETOUCHADAPTOR_H
#define MOUSETOUCHADAPTOR_H

#include <QAbstractNativeEventFilter>
#include <QLoggingCategory>
#include <QObject>
#include <QTouchDevice>
#include <QWindow>

#include <xcb/xcb.h>

Q_DECLARE_LOGGING_CATEGORY(mouseTouchAdaptor)

/*
   Converts native mouse events into touch events

   Useful for emulating touch interaction using a mouse device since touch input
   follows a completely different code path from mouse events in Qt.
 */
class MouseTouchAdaptor : public QObject, public QAbstractNativeEventFilter {
public:
    static MouseTouchAdaptor *instance();
    virtual ~MouseTouchAdaptor();

    bool nativeEventFilter(const QByteArray &eventType, void *message, long *result) override;
private:
    MouseTouchAdaptor();
    void queryForXInput2();
    bool handleButtonPress(WId windowId, uint32_t detail, uint32_t modifiers, int x, int y);
    bool handleButtonRelease(WId windowId, uint32_t detail, uint32_t, int x, int y);
    bool handleMotionNotify(WId windowId, uint32_t modifiers, int x, int y);
    QWindow *findQWindowWithXWindowID(WId windowId);
    bool handleXI2Event(xcb_ge_event_t *event);

    static MouseTouchAdaptor *m_instance;

    QTouchDevice *m_touchDevice;
    bool m_haveXInput2{false};
    bool m_leftButtonIsPressed{false};
};

#endif // MOUSETOUCHADAPTOR_H
