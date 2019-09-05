/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Copyright (C) 2018 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 UI.
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

import QtQuick 2.11
import QtQuick.Controls 2.2
import shared.Style 1.0

NeptuneWindowItem {
    id: root

    // When the window is being displayed as a widget, that's the height its UI should have
    property int widgetHeight: 0

    // Currrent window height
    //
    // The window is kept maximized and it's clipped to fit currentHeight
    // Application code relayouts *all* of its contents so that they fit currentHeight
    property int currentHeight: 0

    // Currrent window width
    property int currentWidth: 0

    // State if the main window in the neptune system UI
    // Valid values are: "Widget1Row", "Widget2Rows", "Widget3Rows", "Maximized" and "Minimized"
    // See also: window, widgetHeight
    property string windowState

    /*
        Margins of the exposed rectangular area of the apps main window

        The area of the apps main window that is directly visible to the user (ie, exposed) and not occluded
        by other items in the system ui is defined by a rectangle anchored to all screen edges.
     */
    property real exposedRectBottomMargin
    property real exposedRectTopMargin

    /*
        Whether a performance monitor overlay is enabled on the primary window
     */
    property bool windowPerfMonitorEnabled: root.appInfo.windowPerfMonitorEnabled

    onWindowChanged: {
        if (window) {
            window.setWindowProperty("neptuneWidgetHeight", widgetHeight);
            window.setWindowProperty("neptuneCurrentWidth", currentWidth);
            window.setWindowProperty("neptuneCurrentHeight", currentHeight);
            window.setWindowProperty("neptuneState", windowState);
            window.setWindowProperty("exposedRectBottomMargin", exposedRectBottomMargin);
            window.setWindowProperty("exposedRectTopMargin", exposedRectTopMargin);
            window.setWindowProperty("performanceMonitorEnabled", windowPerfMonitorEnabled);
        }
    }

    onWidgetHeightChanged: {
        if (window)
            window.setWindowProperty("neptuneWidgetHeight", widgetHeight);
    }
    onCurrentWidthChanged: {
        if (window)
            window.setWindowProperty("neptuneCurrentWidth", currentWidth);
    }
    onCurrentHeightChanged: {
        if (window)
            window.setWindowProperty("neptuneCurrentHeight", currentHeight);
    }
    onWindowStateChanged: {
        if (window)
            window.setWindowProperty("neptuneState", windowState);
    }
    onExposedRectBottomMarginChanged: {
        if (window)
            window.setWindowProperty("exposedRectBottomMargin", exposedRectBottomMargin);
    }
    onExposedRectTopMarginChanged: {
        if (window)
            window.setWindowProperty("exposedRectTopMargin", exposedRectTopMargin);
    }
    onWindowPerfMonitorEnabledChanged: {
        if (window)
            window.setWindowProperty("performanceMonitorEnabled", windowPerfMonitorEnabled);
    }
}
