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
import shared.controls 1.0
import shared.utils 1.0
import shared.animations 1.0
import shared.Sizes 1.0

/*!
    \qmltype ApplicationCCWindow
    \inqmlmodule application.windows
    \inherits NeptuneWindow
    \since 5.12
    \brief The application center console window of a Neptune 3 application.

    The application center console window of a Neptune 3 application is displayed on the Center Console.
    This component also provides APIs for interacting with system UI and for positioning
    the application's visual elements.

    See \l{Neptune 3 UI App Development} for best practices on how to use the APIs.

    \section2 Example Usage

    The following example uses \l{ApplicationCCWindow} as a root element:

    \qml
    import QtQuick 2.10
    import application.windows 1.0

    ApplicationCCWindow {
        id: root
        Background {
            anchors.fill: parent
        }
        Content {
            x: root.exposedRect.x
            y: root.exposedRect.x
            width: root.exposedRect.width
            height: root.exposedRect.height
        }
    }
    \endqml

*/

NeptuneWindow {
    id: root

    // A window can be occluded by some other UI elements such as floating widgets, virtual keyboards
    // etc. In such cases you will want to relayout to that the important content is contained within
    // exposedRect boundaries.

    /*!
        \qmlproperty rect ApplicationCCWindow::exposedRect
        \readonly

        This property holds the area of the window that is exposed to the user (ie, not blocked or
        occluded by other UI elements)
    */
    readonly property rect exposedRect: Qt.rect(0, d.exposedRectTopMargin, d.currentWidth, d.exposedRectHeight)

    /*!
        \qmlproperty int ApplicationCCWindow::targetHeight
        \readonly

        This property holds the target height of the application. This property will be updated
        when the neptune state is being changed.
    */


    readonly property int targetHeight: neptuneState === "Maximized" ? root.height : d.widgetHeight;

    /*!
        \qmlproperty int ApplicationCCWindow::currentHeight
        This property holds the current height of the application.
    */

    property int currentHeight

    /*!
        \qmlproperty string ApplicationCCWindow::neptuneState
        This property holds the current state of the application. The valid values for neptuneState are
        (Maximized, Minimized, Widget1Row, Widget2Rows or Widget3Rows)
    */

    property string neptuneState

    QtObject {
        id: d
        property real exposedRectTopMargin: 0
        Behavior on exposedRectTopMargin {DefaultNumberAnimation{}}
        property real exposedRectBottomMargin: 0
        Behavior on exposedRectBottomMargin {DefaultNumberAnimation{}}
        property int widgetHeight: 0
        property int currentWidth: 0
        property int exposedRectHeight: Math.min(root.currentHeight, root.height - exposedRectBottomMargin - exposedRectTopMargin);
        property int activationCount: 0
        property var validNeptuneStates: ["Maximized", "Minimized", "Widget1Row", "Widget2Rows", "Widget3Rows"]
    }

    function riseWindow() {
        root.setWindowProperty("activationCount", d.activationCount++)
    }

    onWindowPropertyChanged: {
        switch (name) {
        case "exposedRectBottomMargin":
            d.exposedRectBottomMargin = value;
            break;
        case "exposedRectTopMargin":
            d.exposedRectTopMargin = value;
            break;
        case "neptuneWidgetHeight":
            d.widgetHeight = value;
            break;
        case "neptuneCurrentWidth":
            d.currentWidth = value;
            break;
        case "neptuneCurrentHeight":
            root.currentHeight = value;
            break;
        case "neptuneState":
            if (d.validNeptuneStates.includes(value)) {
                root.neptuneState = value;
            }
            break;
        case "performanceMonitorEnabled":
            monitorOverlay.fpsVisible = value;
            break;
        }
    }

    Component.onCompleted: {
        root.width = Sizes.dp(Config.centerConsoleWidth)
        root.height = Sizes.dp(Config.centerConsoleHeight)
    }

    MonitorOverlay {
        id: monitorOverlay
        x: root.exposedRect.x
        y: root.exposedRect.y
        width: root.exposedRect.width - Sizes.dp(100)
        height: root.exposedRect.height - Sizes.dp(50)
        fpsVisible: false
        window: root
        z: 9999
    }
}
