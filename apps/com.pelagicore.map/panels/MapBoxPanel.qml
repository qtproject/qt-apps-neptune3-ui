/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 IVI UI.
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

import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtLocation 5.9
import QtPositioning 5.9

import utils 1.0
import com.pelagicore.styles.neptune 3.0
import animations 1.0
import "../controls"
import "../helpers"

Item {
    id: root

    property alias mapInteractive: mainMap.enabled
    property alias plugin: mainMap.plugin
    property alias center: mainMap.center
    property alias visibleRegion: mainMap.visibleRegion
    readonly property alias mapReady: mainMap.mapReady
    property alias activeMapType: mainMap.activeMapType
    readonly property alias supportedMapTypes: mainMap.supportedMapTypes
    property alias tilt: mainMap.tilt
    property alias bearing: mainMap.bearing
    property alias zoomLevel: mainMap.zoomLevel
    property alias mapHeader: header

    property string destination
    property RouteModel model
    property string routeDistance
    property string routeTime
    property var routeSegments
    property string homeRouteTime
    property string workRouteTime
    property var destCoord: QtPositioning.coordinate()

    property bool offlineMapsEnabled
    property bool navigationMode
    property bool guidanceMode
    property var currentLocation

    property Helper helper: Helper {}

    signal openSearchTextInput()
    signal maximizeMap()
    signal startNavigationRequested()
    signal stopNavigationRequested()
    signal showRouteRequested(var destCoord, var description)

    function zoomIn() {
        mainMap.zoomLevel += 1.0;
    }

    function zoomOut() {
        mainMap.zoomLevel -= 1.0;
    }

    Map {
        id: mainMap
        anchors.fill: parent
        anchors.topMargin: (root.state === "Widget3Rows") ? header.height/2 : 0
        Behavior on anchors.topMargin { DefaultNumberAnimation {} }
        Behavior on center { enabled: root.mapInteractive; CoordinateAnimation { easing.type: Easing.InOutCirc; duration: 540 } }
        Behavior on tilt { DefaultSmoothedAnimation {} }
        zoomLevel: 10
        copyrightsVisible: false // customize the default (c) appearance below in MapCopyrightNotice
        gesture {
            enabled: root.mapInteractive
            // effectively disable the rotation gesture
            acceptedGestures: MapGestureArea.PanGesture | MapGestureArea.PinchGesture | MapGestureArea.FlickGesture
        }

        onErrorChanged: {
            console.warn("Map error:", error, errorString)
        }

        BusyIndicator {
            anchors.centerIn: parent
            running: !mapReady
            visible: running
        }

        MapItemView {
            autoFitViewport: true
            model: root.guidanceMode ? root.model : null
            delegate: MapRoute {
                route: routeData
                line.color: "#798bd9"
                line.width: NeptuneStyle.dp(3)
                smooth: true
                opacity: NeptuneStyle.opacityHigh
            }
        }

        MapQuickItem {
            id: destMarker
            anchorPoint: Qt.point(markerImage.width * 0.5, markerImage.height * 0.8)
            coordinate: root.destCoord ? root.destCoord : QtPositioning.coordinate()
            visible: root.navigationMode && root.destCoord.isValid

            sourceItem: Image {
                id: markerImage
                source: Qt.resolvedUrl("../assets/pin-destination.png")
                width: NeptuneStyle.dp(139/2)
                height: NeptuneStyle.dp(161/2)
            }
        }

        MapQuickItem {
            id: posMarker
            anchorPoint: Qt.point(posImage.width * 0.5, posImage.height * 0.5)
            coordinate: root.routeSegments && root.routeSegments[0] ? root.routeSegments[0].path[0]
                                                                       : QtPositioning.coordinate()
            visible: root.guidanceMode

            sourceItem: Image {
                id: posImage
                source: Qt.resolvedUrl("../assets/pin-your-position.png")
                width: NeptuneStyle.dp(116/2)
                height: NeptuneStyle.dp(135/2)
            }
            rotation: root.routeSegments ? root.routeSegments[0].path[0].azimuthTo(root.routeSegments[0].path[1])
                                               : 0
        }
    }

    Image {
        id: mask
        anchors.fill: mainMap
        source: helper.localAsset("bg-home-navigation-overlay", NeptuneStyle.theme)
        visible: root.state === "Maximized"
        scale: root.state === "Maximized" ? 1 : 1.6
        Behavior on scale {
            DefaultNumberAnimation { }
        }
    }

    MapHeaderPanel {
        id: header
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: guidanceMode ? NeptuneStyle.dp(810) : 0
        anchors.top: parent.top
        opacity: root.state !== "Widget1Row" ? 1 : 0
        Behavior on opacity { DefaultNumberAnimation {} }
        Behavior on anchors.rightMargin { DefaultNumberAnimation {} }
        visible: opacity > 0
        state: root.state

        offlineMapsEnabled: root.offlineMapsEnabled
        navigationMode: root.navigationMode
        guidanceMode: root.guidanceMode
        currentLocation: root.currentLocation
        destination: root.destination
        routeDistance: root.routeDistance
        routeTime: root.routeTime
        homeRouteTime: root.homeRouteTime
        workRouteTime: root.workRouteTime

        onOpenSearchTextInput: root.openSearchTextInput()
        onStartNavigation: {
            root.startNavigationRequested();
            root.maximizeMap();
            root.guidanceMode = true;
        }
        onStopNavigation: {
            root.stopNavigationRequested();
            root.navigationMode = false;
            root.guidanceMode = false;
        }
        onShowRoute: {
            root.showRouteRequested(destCoord, description);
            root.center = destCoord;
            root.navigationMode = true;
            root.maximizeMap();
        }
    }

    ToolButton {
        anchors.left: parent.left
        anchors.leftMargin: NeptuneStyle.dp(27)
        anchors.top: header.bottom
        anchors.topMargin: NeptuneStyle.dp(240)
        checkable: true
        opacity: root.state === "Maximized" ? 1 : 0
        Behavior on opacity { DefaultNumberAnimation {} }
        visible: opacity > 0
        width: NeptuneStyle.dp(background.sourceSize.width)
        height: width
        background: Image {
            fillMode: Image.PreserveAspectFit
            source: helper.localAsset("floating-button-bg", NeptuneStyle.theme)
        }
        icon.source: checked ? Qt.resolvedUrl("../assets/ic-3D_ON.png") : Qt.resolvedUrl("../assets/ic-3D_OFF.png")
        onClicked: mainMap.tilt = checked ? mainMap.maximumTilt : mainMap.minimumTilt;
    }

    ToolButton {
        anchors.right: parent.right
        anchors.rightMargin: NeptuneStyle.dp(27)
        anchors.top: header.bottom
        anchors.topMargin: NeptuneStyle.dp(240)
        checkable: true
        opacity: root.state === "Maximized" ? 1 : 0
        Behavior on opacity { DefaultNumberAnimation {} }
        visible: opacity > 0
        width: NeptuneStyle.dp(background.sourceSize.width)
        height: width
        background: Image {
            fillMode: Image.PreserveAspectFit
            source: helper.localAsset("floating-button-bg", NeptuneStyle.theme)
        }
        enabled: !checked
        checked: mainMap.center === root.currentLocation
        icon.source: checked ? Qt.resolvedUrl("../assets/ic-my-position_ON.png") : Qt.resolvedUrl("../assets/ic-my-position_OFF.png")
        onToggled: mainMap.center = root.currentLocation;
    }

    MapCopyrightNotice {
        anchors.left: mainMap.left
        anchors.bottom: mainMap.bottom
        anchors.leftMargin: NeptuneStyle.dp(45 * .5)
        mapSource: mainMap
        styleSheet: "* { color: '%1'; font-family: '%2'; font-size: %3px}"
        .arg(NeptuneStyle.contrastColor).arg(NeptuneStyle.fontFamily).arg(NeptuneStyle.fontSizeXXS)
    }
}
