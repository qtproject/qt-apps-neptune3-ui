/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AG
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

import QtQuick 2.8
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtLocation 5.9
import QtPositioning 5.9

import utils 1.0
import com.pelagicore.styles.triton 1.0
import controls 1.0 as TritonControls
import animations 1.0

Item {
    id: root

    property alias mapInteractive: mainMap.enabled
    property alias plugin: mainMap.plugin
    property alias center: mainMap.center
    property alias visibleRegion: mainMap.visibleRegion
    property alias mapReady: mainMap.mapReady
    property alias activeMapType: mainMap.activeMapType
    property alias supportedMapTypes: mainMap.supportedMapTypes
    property alias tilt: mainMap.tilt
    property alias bearing: mainMap.bearing
    property alias zoomLevel: mainMap.zoomLevel

    signal openSearchTextInput()

    function zoomIn() {
        mainMap.zoomLevel += 1.0;
    }

    function zoomOut() {
        mainMap.zoomLevel -= 1.0;
    }


    Map {
        id: mainMap
        anchors.fill: parent
        anchors.topMargin: (root.state === "Widget3Rows") || (root.state === "Maximized") ? header.height/2 : 0
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
    }

    Item {
        id: header
        height: backgroundImage.sourceSize.height
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        opacity: root.state && root.state !== "Widget1Row" ? 1 : 0
        visible: opacity > 0
        Behavior on opacity {
            SequentialAnimation {
                PauseAnimation { duration: 180 }
                DefaultNumberAnimation {}
            }
        }

        Image {
            id: backgroundImage
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: root.state === "Widget1Row" ? -header.height : (root.state === "Widget2Rows" ? -header.height/2 : 0 )
            Behavior on anchors.topMargin { DefaultNumberAnimation {} }
            fillMode: Image.TileHorizontally
            source: Qt.resolvedUrl("assets/navigation-widget-overlay-top.png")
        }

        Row {
            id: firstRow
            anchors.top: parent.top
            anchors.topMargin: Style.vspan(.4)
            anchors.horizontalCenter: parent.horizontalCenter
            width: header.width - Style.hspan(2)

            Item {
                id: label
                width: firstRow.width / 2
                height: invitationText.paintedHeight
                anchors.verticalCenter: parent.verticalCenter
                opacity: visible ? 1.0 : 0.0
                Label {
                    id: invitationText
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    width: parent.width/2
                    wrapMode: Text.WordWrap
                    font.pixelSize: Style.fontSizeS
                    text: qsTr("Where do you wanna go today?")
                }
                Behavior on opacity { DefaultNumberAnimation { } }
            }

            Button {
                id: searchButton
                width: parent.width / 2
                height: parent.height
                scale: pressed ? 1.1 : 1.0
                Behavior on scale { NumberAnimation { duration: 50 } }

                background: Rectangle {
                    color: "lightgray"
                    radius: height / 2
                }
                contentItem: Item {
                    Row {
                        anchors.centerIn: parent
                        spacing: Style.hspan(0.3)
                        Image {
                            anchors.verticalCenter: parent.verticalCenter
                            fillMode: Image.Pad
                            source: Qt.resolvedUrl("assets/ic-search.png")
                        }
                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            text: qsTr("Search")
                            font.pixelSize: Style.fontSizeS
                        }
                    }
                }
                onClicked: openSearchTextInput()
            }
        }
        RowLayout {
            id: secondRow
            anchors.top: firstRow.bottom
            anchors.left: parent.left
            anchors.leftMargin: Style.hspan(1)
            anchors.right: parent.right
            anchors.rightMargin: Style.hspan(1.5)
            opacity: (root.state == "Widget3Rows") || (root.state == "Maximized") ? 1 : 0
            Behavior on opacity {
                SequentialAnimation {
                    PauseAnimation { duration: 180 }
                    DefaultNumberAnimation {}
                }
            }
            visible: opacity > 0
            height: parent.height/2
            MapToolButton {
                id: buttonGoHome
                Layout.preferredWidth: secondRow.width/2
                Layout.fillWidth: true
                anchors.verticalCenter: parent.verticalCenter
                iconSource: Qt.resolvedUrl("assets/ic-search.png")

                text: qsTr("Home")
                extendedText: "17 min"
                secondaryText: "Welandergatan 29"
            }
            MapToolButton {
                id: buttonGoWork
                Layout.preferredWidth: secondRow.width/2
                Layout.fillWidth: true
                anchors.verticalCenter: parent.verticalCenter
                iconSource: Qt.resolvedUrl("assets/ic-work.png")
                text: qsTr("Work")
                extendedText: "23 min"
                secondaryText: "Östra Hamngatan 20"
            }
        }
    }

    MapCopyrightNotice {
        anchors.left: mainMap.left
        anchors.bottom: mainMap.bottom
        anchors.leftMargin: Style.hspan(.5)
        mapSource: mainMap
        styleSheet: "* { color: '%1'; font-family: '%2'; font-size: %3px}"
        .arg(TritonStyle.primaryTextColor).arg(TritonStyle.fontFamily).arg(TritonStyle.fontSizeXXS)
    }
}
