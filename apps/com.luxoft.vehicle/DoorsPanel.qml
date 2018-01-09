/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AB
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

import QtQuick 2.9
import QtQuick.Layouts 1.3

import animations 1.0
import com.pelagicore.settings 1.0
import com.pelagicore.styles.triton 1.0

Item {
    id: root

    property bool leftDoorOpen: false
    property bool rightDoorOpen: false
    property bool trunkOpen: false
    property real roofOpenProgress: 0.0

    Behavior on roofOpenProgress {
        enabled: !roofSliderMouseArea.pressed
        DefaultNumberAnimation { duration: 1000 }
    }

    property Item currentItem: doorsConfig

    UISettings {
        id: uiSettings
    }

    Item {
        id: vehicleOpenableConfig

        width: 740
        height: 50

        RowLayout {
            spacing: 0

            VehicleHorizontalMenuButton {
                width: vehicleOpenableConfig.width / 3
                state: "LEFT"
                text: qsTr("Sun roof")
                down: root.currentItem == roofConfig
                onClicked: root.currentItem = roofConfig
                onPressedChanged: (z = pressed ? 100 : 0)
            }

            VehicleHorizontalMenuButton {
                width: vehicleOpenableConfig.width / 3
                text: qsTr("Doors")
                down: root.currentItem == doorsConfig
                onClicked: root.currentItem = doorsConfig
                onPressedChanged: (z = pressed ? 100 : 0)
            }

            VehicleHorizontalMenuButton {
                width: vehicleOpenableConfig.width / 3
                state: "RIGHT"
                text: qsTr("Trunk")
                down: root.currentItem == trunkConfig
                onClicked: root.currentItem = trunkConfig
                onPressedChanged: (z = pressed ? 100 : 0)
            }
        }
    }

    Item {
        id: roofConfig

        visible: root.currentItem == roofConfig
        anchors.top: vehicleOpenableConfig.bottom
        anchors.right: vehicleOpenableConfig.right
        anchors.fill: parent

        Image {
            id: roofImageClosed

            source: "assets/images/car-top.png"
            anchors.top: parent.top
            anchors.topMargin: 32
            width: 470
            height: 670

            Item {
                id: roofImageOpened

                anchors.bottom: parent.bottom
                width: 470
                height: 450 - 120 * root.roofOpenProgress
                clip: true

                Image {
                    anchors.bottom: parent.bottom
                    width: 470
                    height: 670
                    source: "assets/images/car-top-close-roof.png"
                }
            }

            MouseArea {
                id: roofSliderMouseArea
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: roofImageClosed.top
                anchors.topMargin: 160
                width: 300
                height: 200

                onMouseXChanged: {
                    if (pressed && containsMouse)
                        root.roofOpenProgress = mouse.y / height
                }
            }

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: roofImageOpened.top
                anchors.bottomMargin: -30
                source: "assets/images/ic-roof-slider.png"
            }
        }

        VehicleButton {
            id: roofCloseButton

            anchors.top: parent.top
            anchors.topMargin: 100
            anchors.left: parent.left
            anchors.leftMargin: 520
            text: qsTr("Close")
            onClicked: {
                root.roofOpenProgress = 0.0;
            }
        }

        VehicleButton {
            id: roofOpenButton

            anchors.top: parent.top
            anchors.topMargin: 500
            anchors.left: parent.left
            anchors.leftMargin: 520
            text: qsTr("Open")
            onClicked: {
                root.roofOpenProgress = 1.0;
            }
        }
    }

    Item {
        id: doorsConfig

        visible: root.currentItem == doorsConfig
        anchors.top: vehicleOpenableConfig.bottom
        anchors.right: vehicleOpenableConfig.right
        anchors.fill: parent

        readonly property string sourceSuffix: TritonStyle.theme === TritonStyle.Dark ? "-dark.png" : ".png"
        readonly property string openRightDoorSource: "assets/images/ic-door-open" + sourceSuffix
        readonly property string closeRightDoorSource: "assets/images/ic-door-closed" + sourceSuffix
        readonly property string openLeftDoorSource: "assets/images/ic-door-open-flip" + sourceSuffix
        readonly property string closeLeftDoorSource: "assets/images/ic-door-closed-flip" + sourceSuffix

        Image {
            id: doorsImage

            source: "assets/images/car-top.png"
            anchors.top: parent.top
            anchors.topMargin: 32
            anchors.left: parent.left
            anchors.leftMargin: 140
            width: 470
            height: 670

            Image {
                anchors.fill: parent
                visible: root.leftDoorOpen
                source: "assets/images/car-top-left-door.png"
            }
            Image {
                anchors.fill: parent
                visible: root.rightDoorOpen
                source: "assets/images/car-top-right-door.png"
            }

            //ToDo: It should be a separate button item later
            Image {
                anchors.top: parent.top
                anchors.topMargin: 200
                anchors.left: parent.left
                anchors.leftMargin: 40
                source: "assets/images/round-button" + doorsConfig.sourceSuffix

                Image {
                    anchors.centerIn: parent
                    source: root.leftDoorOpen ? doorsConfig.openLeftDoorSource : doorsConfig.closeLeftDoorSource
                }

                MouseArea {
                    width: 100
                    height: 100
                    anchors.centerIn: parent

                    onClicked: {
                        root.leftDoorOpen = !root.leftDoorOpen
                        uiSettings.door1Open = root.leftDoorOpen
                    }
                    onPressed: (parent.scale = 1.1)
                    onReleased: (parent.scale = 1.0)

                    Connections {
                        target: uiSettings
                        onDoor1OpenChanged: {
                            root.leftDoorOpen = uiSettings.door1Open
                        }
                    }
                }
            }

            Image {
                anchors.top: parent.top
                anchors.topMargin: 200
                anchors.right: parent.right
                anchors.rightMargin: 40
                source: "assets/images/round-button" + doorsConfig.sourceSuffix

                Image {
                    anchors.centerIn: parent
                    source: root.rightDoorOpen ? doorsConfig.openRightDoorSource : doorsConfig.closeRightDoorSource
                }

                MouseArea {
                    width: 100
                    height: 100
                    anchors.centerIn: parent

                    onClicked: {
                        root.rightDoorOpen = !root.rightDoorOpen
                        uiSettings.door2Open = root.rightDoorOpen
                    }
                    onPressed: (parent.scale = 1.1)
                    onReleased: (parent.scale = 1.0)

                    Connections {
                        target: uiSettings
                        onDoor2OpenChanged: {
                            root.rightDoorOpen = uiSettings.door2Open
                        }
                    }
                }
            }
        }
    }

    Item {
        id: trunkConfig

        visible: root.currentItem == trunkConfig
        anchors.top: vehicleOpenableConfig.bottom
        anchors.right: vehicleOpenableConfig.right
        anchors.fill: parent

        Image {
            id: trunkImage

            source: "assets/images/car-top-back.png"
            anchors.top: parent.top
            anchors.topMargin: -232
            anchors.left: parent.left
            anchors.leftMargin: 140
            width: 470
            height: 670

            Image {
                anchors.fill: parent
                visible: root.trunkOpen
                source: "assets/images/car-top-trunk.png"
            }

            VehicleButton {
                id: trunkCloseButton

                anchors.top: parent.bottom
                anchors.topMargin: 30
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.trunkOpen ? qsTr("Close") : qsTr("Open")

                onClicked: root.trunkOpen = !root.trunkOpen
            }
        }
    }
}

