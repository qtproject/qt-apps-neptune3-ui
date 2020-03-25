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

import QtQuick 2.10
import QtLocation 5.9
import QtPositioning 5.14
import QtQuick.Controls 2.13

import shared.animations 1.0
import shared.Style 1.0
import shared.Sizes 1.0

import "../helpers" 1.0
import "../panels" 1.0

Item {
    id: root

    property alias mapCenter: mainMap.center
    property alias mapZoomLevel: mainMap.zoomLevel
    property alias mapTilt: mainMap.tilt
    property alias mapBearing: mainMap.bearing
    property alias mapReady: mainMap.mapReady
    property alias activeMapType: mainMap.activeMapType
    property var path
    property var mapPlugin
    property bool allowMapRendering


    property string nextTurnDistanceMeasuredIn
    property real nextTurnDistance
    property string naviGuideDirection

    state: "initial"
    states: [
        State {
            // just a map w/o any additional items in it
            name: "initial"
            PropertyChanges {
                target: posMarker
                coordinate: QtPositioning.coordinate()
                rotation: 0.0
                visible: false
            }
            PropertyChanges {
                target: destMarker
                visible: false
                coordinate: QtPositioning.coordinate()
            }
            PropertyChanges {
                target: pathView
                visible: false
                path: []
            }
        },
        State {
            name: "demo_driving"
            PropertyChanges {
                target: posMarker
                coordinate: root.mapCenter
                rotation: 0.0
                visible: true
            }
            PropertyChanges {
                target: destMarker
                visible: true
                coordinate: root.path[root.path.length - 1]
            }
            PropertyChanges {
                target: pathView
                visible: true
                path: root.path
            }
            PropertyChanges {
                target: instructions
                visible: root.naviGuideDirection !== ""
            }
        }
    ]

    Map {
        id: mainMap
        anchors.fill: parent
        enabled: false
        Behavior on tilt { DefaultSmoothedAnimation {} }
        zoomLevel: 10
        plugin: root.mapPlugin
        copyrightsVisible: false
        visible: root.allowMapRendering

        MapPolyline {
            id: pathView
            line.color: Style.accentColor
            line.width: Sizes.dp(8)
            smooth: true
            opacity: Style.opacityHigh
        }

        MapQuickItem {
            id: destMarker
            anchorPoint: Qt.point(markerImage.width * 0.5, markerImage.height * 0.8)
            sourceItem: Image {
                id: markerImage
                source: Qt.resolvedUrl("../assets/pin-destination.png")
                width: Sizes.dp(139/2)
                height: Sizes.dp(161/2)
            }
        }

        Item {
            id: instructions
            visible: false
            anchors.top: posMarker.bottom
            anchors.topMargin: Sizes.dp(100)
            anchors.horizontalCenter: posMarker.horizontalCenter
            width: Sizes.dp(660)
            height: Sizes.dp(100)

            Rectangle {
                anchors.fill: parent
                opacity: 0.5
                color: Style.theme === Style.Dark ? "black" : "white"
                radius: 10
            }

            Label {
                width: Sizes.dp(400)
                height: Sizes.dp(100)
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: Sizes.dp(30)
                opacity: 0.9
                font.pixelSize: Sizes.fontSizeXL
                font.bold: true
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Next turn: ") + root.nextTurnDistance
                      + " " + root.nextTurnDistanceMeasuredIn
            }

            Image {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: Sizes.dp(30)
                source: root.naviGuideDirection !== ""
                    ? Helper.localAsset(root.naviGuideDirection, Style.theme)
                    : ""
            }
        }

        MapQuickItem {
            id: posMarker
            anchorPoint: Qt.point(posImage.width * 0.5, posImage.height * 0.5)
            sourceItem: Image {
                id: posImage
                source: Qt.resolvedUrl("../assets/pin-your-position.png")
                width: Sizes.dp(116/2)
                height: Sizes.dp(135/2)
            }
        }
    }

    Loader {
        active: !root.allowMapRendering
        anchors.fill: root
        sourceComponent: ProxyErrorPanel {
            anchors.fill: parent
            clusterWindow: true
            errorText: qsTr("The map is disabled in this runtime environment")
        }
    }
}
