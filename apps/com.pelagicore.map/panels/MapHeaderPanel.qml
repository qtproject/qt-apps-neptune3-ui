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

import QtQuick 2.8
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtPositioning 5.9

import shared.utils 1.0
import shared.Sizes 1.0
import shared.controls 1.0 as NeptuneControls
import shared.animations 1.0

Item {
    id: root

    implicitHeight: headerBackgroundFullscreen.height

    property bool offlineMapsEnabled
    property var currentLocation

    property string neptuneWindowState
    // state is inherited from MapBoxPanel
    // state: ..

    property string destination: ""
    property string routeDistance: ""
    property string routeTime: ""
    property string homeRouteTime: ""
    property string workRouteTime: ""

    // TODO make the locations configurable and dynamic
    readonly property var homeAddressData: QtPositioning.coordinate(57.706436, 12.018661)
    readonly property var workAddressData: QtPositioning.coordinate(57.709545, 11.967005)

    readonly property int destinationButtonrowHeight: Sizes.dp(150)

    signal showDestinationPoint(var destCoord, string description)
    signal showRoute()
    signal startNavigation()
    signal stopNavigation()
    signal openSearchTextInput()

    // Neptune Window is Maximized. Not a widget:
    Loader {
        id: headerBackgroundFullscreen
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(210)
        active: root.neptuneWindowState === "Maximized"
        opacity: root.state === "demo_driving" ? 0.6 : 1.0
        sourceComponent: HeaderBackgroundMaximizedPanel {
            state: root.state
            destinationButtonrowHeight: root.destinationButtonrowHeight
        }
    }

    Loader {
        id: navigationSearchButtonsFullscreen
        width: headerBackgroundFullscreen.width - Sizes.dp(90)
        height: headerBackgroundFullscreen.height
        active: root.neptuneWindowState === "Maximized" && root.state === "initial"
        anchors.top: headerBackgroundFullscreen.top
        anchors.topMargin: Sizes.dp(50)
        anchors.horizontalCenter: headerBackgroundFullscreen.horizontalCenter
        sourceComponent: NavigationSearchPanel {
            offlineMapsEnabled: root.offlineMapsEnabled
            onOpenSearchTextInput: root.openSearchTextInput()
        }
    }

    Loader {
        id: navigationConfirmButtons
        anchors.fill: headerBackgroundFullscreen
        anchors.rightMargin: Sizes.dp(45 * .5)
        active: root.neptuneWindowState === "Maximized"
                && (root.state === "route_selection"
                        || root.state === "destination_selection"
                        || root.state === "demo_driving")
        sourceComponent: NavigationConfirmPanel {
            state: root.state
            destination: root.destination
            routeDistance: root.routeDistance
            routeTime: root.routeTime
            onStartNavigation: root.startNavigation()
            onShowRoute: root.showRoute()
            onStopNavigation: root.stopNavigation()
        }
    }

    Loader {
        id: favoriteDestinationButtonsFullscreen
        anchors.top: headerBackgroundFullscreen.top
        anchors.topMargin: Sizes.dp(164)
        anchors.left: headerBackgroundFullscreen.left
        anchors.leftMargin: Sizes.dp(45)
        anchors.right: headerBackgroundFullscreen.right
        anchors.rightMargin: Sizes.dp(45 * 1.5)
        height: root.destinationButtonrowHeight
        active: root.neptuneWindowState === "Maximized" && root.state === "initial"
        sourceComponent: FavDestinationButtonsPanel {
            offlineMapsEnabled: root.offlineMapsEnabled
            homeAddressData: root.homeAddressData
            workAddressData: root.workAddressData
            homeRouteTime: root.homeRouteTime
            workRouteTime: root.workRouteTime
            onShowDestinationPoint: root.showDestinationPoint(destCoord, description);
        }
    }

    // Neptune Window is shown as the widget:
    Loader {
        id: headerBackgroundWidget
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        active: (root.neptuneWindowState === "Widget2Rows"
                    || root.neptuneWindowState === "Widget3Rows"
                    || root.neptuneWindowState === "Widget1Row")
        opacity: root.neptuneWindowState === "Widget1Row" || root.state === "demo_driving"
                 ? 0.6 : 1.0
        sourceComponent: HeaderBackgroundWidgetPanel {
            neptuneWindowState: root.neptuneWindowState
            state: root.state
        }
    }

    Loader {
        id: navigationSearchButtonsWidget
        // - Sizes.dp(160) compensates the "expand" button in the widget corner
        width: headerBackgroundWidget.width - Sizes.dp(160)
        active: (root.neptuneWindowState === "Widget2Rows"
                    || root.neptuneWindowState === "Widget3Rows"
                    || root.neptuneWindowState === "Widget1Row")
                && root.state === "initial"
        anchors.top: headerBackgroundWidget.top
        anchors.topMargin: Sizes.dp(48)
        anchors.horizontalCenter: headerBackgroundWidget.horizontalCenter
        sourceComponent: NavigationSearchPanel {
            offlineMapsEnabled: root.offlineMapsEnabled
            onOpenSearchTextInput: root.openSearchTextInput()
        }
    }

    Loader {
        id: navigationConfirmButtonsWidget
        // - Sizes.dp(60) compensates the "expand" button in the widget corner
        width: headerBackgroundWidget.width - Sizes.dp(60)
        active: (root.neptuneWindowState !== "Maximized")
                && (root.state === "route_selection"
                    || root.state === "destination_selection"
                    || root.state === "demo_driving")
        anchors.top: headerBackgroundWidget.top
        anchors.topMargin: Sizes.dp(48)
        sourceComponent: NavigationConfirmPanel {
            state: root.state
            neptuneWindowState: root.neptuneWindowState
            destination: root.destination
            routeDistance: root.routeDistance
            routeTime: root.routeTime
            onStartNavigation: root.startNavigation()
            onShowRoute: root.showRoute()
            onStopNavigation: root.stopNavigation()
        }
    }

    Loader {
        id: favoriteDestinationButtonsWidget
        anchors.top: headerBackgroundWidget.top
        anchors.topMargin: Sizes.dp(130)
        anchors.left: headerBackgroundWidget.left
        anchors.leftMargin: Sizes.dp(45)
        anchors.right: headerBackgroundWidget.right
        anchors.rightMargin: Sizes.dp(45 * 1.5)
        height: root.destinationButtonrowHeight
        active: root.neptuneWindowState === "Widget3Rows" && root.state === "initial"
        sourceComponent: FavDestinationButtonsPanel {
            offlineMapsEnabled: root.offlineMapsEnabled
            homeAddressData: root.homeAddressData
            workAddressData: root.workAddressData
            homeRouteTime: root.homeRouteTime
            workRouteTime: root.workRouteTime
            onShowDestinationPoint: root.showDestinationPoint(destCoord, description);
        }
    }
}
