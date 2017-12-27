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
#include "ApplicationInfo.h"

ApplicationInfo::ApplicationInfo(const QObject* application, QObject *parent)
    : QObject(parent), m_application(application)
{
}

void ApplicationInfo::start()
{
    emit startRequested();
}

void ApplicationInfo::stop()
{
    emit stopRequested();
}

void ApplicationInfo::setAsWidget(bool value)
{
    if (value != m_asWidget) {
        m_asWidget = value;
        emit asWidgetChanged();
    }
}

bool ApplicationInfo::asWidget() const
{
    return m_asWidget;
}

void ApplicationInfo::setWindow(QQuickItem * window)
{
    if (window != m_window) {
        m_window = window;
        emit windowChanged();
    }
}

QQuickItem *ApplicationInfo::window() const
{
    return m_window;
}

void ApplicationInfo::setSecondaryWindow(QQuickItem *window)
{
    if (window != m_secondaryWindow) {
        m_secondaryWindow = window;
        emit secondaryWindowChanged();
    }
}

QQuickItem *ApplicationInfo::secondaryWindow() const
{
    return m_secondaryWindow;
}

void ApplicationInfo::setWindowState(const QString &value)
{
    if (m_windowState != value) {
        m_windowState = value;
        emit windowStateChanged();
    }
}

QString ApplicationInfo::windowState() const
{
    return m_windowState;
}

const QObject *ApplicationInfo::application() const
{
    return m_application;
}

int ApplicationInfo::heightRows() const
{
    return m_heightRows;
}

void ApplicationInfo::setHeightRows(int value)
{
    if (value != m_heightRows) {
        m_heightRows = value;
        emit heightRowsChanged();
    }
}

int ApplicationInfo::minHeightRows() const
{
    return m_minHeightRows;
}

void ApplicationInfo::setMinHeightRows(int value)
{
    if (value != m_minHeightRows) {
        m_minHeightRows = value;
        emit minHeightRowsChanged();
    }
}

bool ApplicationInfo::running() const
{
    return m_running;
}

void ApplicationInfo::setRunning(bool value)
{
    if (m_running != value) {
        m_running = value;
        emit runningChanged();
    }
}

bool ApplicationInfo::active() const
{
    return m_active;
}

void ApplicationInfo::setActive(bool value)
{
    if (m_active != value) {
        m_active = value;
        emit activeChanged();
    }
}

bool ApplicationInfo::canBeActive() const
{
    return m_canBeActive;
}

void ApplicationInfo::setCanBeActive(bool value)
{
    if (value != m_canBeActive) {
        m_canBeActive = value;
        emit canBeActiveChanged();
    }
}

QString ApplicationInfo::id() const
{
    return m_application->property("id").toString();
}

QUrl ApplicationInfo::icon() const
{
    return m_application->property("icon").toUrl();
}

QStringList ApplicationInfo::categories() const
{
    return m_application->property("categories").toStringList();
}

void ApplicationInfo::setWidgetHeight(int value)
{
    if (value != m_widgetHeight) {
        m_widgetHeight = value;
        emit widgetHeightChanged();
    }
}
int ApplicationInfo::widgetHeight() const
{
    return m_widgetHeight;
}

void ApplicationInfo::setCurrentHeight(int value)
{
    if (m_currentHeight != value) {
        m_currentHeight = value;
        emit currentHeightChanged();
    }
}

int ApplicationInfo::currentHeight() const
{
    return m_currentHeight;
}

void ApplicationInfo::setCurrentWidth(int value)
{
    if (m_currentWidth != value) {
        m_currentWidth = value;
        emit currentWidthChanged();
    }
}

int ApplicationInfo::currentWidth() const
{
    return m_currentWidth;
}

qreal ApplicationInfo::exposedRectBottomMargin() const
{
    return m_exposedRectBottomMargin;
}

void ApplicationInfo::setExposedRectBottomMargin(qreal value)
{
    if (m_exposedRectBottomMargin != value) {
        m_exposedRectBottomMargin = value;
        emit exposedRectBottomMarginChanged();
    }
}

qreal ApplicationInfo::exposedRectTopMargin() const
{
    return m_exposedRectTopMargin;
}

void ApplicationInfo::setExposedRectTopMargin(qreal value)
{
    if (m_exposedRectTopMargin != value) {
        m_exposedRectTopMargin = value;
        emit exposedRectTopMarginChanged();
    }
}
