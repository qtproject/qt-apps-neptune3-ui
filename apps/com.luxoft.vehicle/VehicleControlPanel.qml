/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AB
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
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.2

Item {
    id: root

    width: 1080
    height: 1920 * 0.60

    signal locksOpen
    signal locksClose
    signal doorsOpen
    signal doorsClose
    signal roofOpen
    signal roofClose
    signal trunkOpen
    signal trunkClose

    LinearGradient {
        id: controlPanelBackground

        anchors.fill: root
        start: Qt.point(0, 0)
        end: Qt.point(0, root.height)
        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: "#eee9e6"
            }
            GradientStop {
                position: 1.0
                color: "#c6c1be"
            }
        }
    }

    Item {
        id: controlButtons

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 80
        anchors.topMargin: 80
        width: 100
        height: 460

        ColumnLayout {
            spacing: 10

            VehicleVerticalMenuButton {
                id: supportButton

                text: qsTr("support")
                sourceUp: "assets/images/ic-driving-support-off.png"
                sourceDown: "assets/images/ic-driving-support-on.png"
                onClicked: controlPages.currentItem = supportItem
                down: controlPages.currentItem == supportItem
            }

            VehicleVerticalMenuButton {
                id: energyButton

                text: qsTr("energy")
                sourceUp: "assets/images/ic-energy-off.png"
                sourceDown: "assets/images/ic-energy-on.png"
                onClicked: controlPages.currentItem = energyItem
                down: controlPages.currentItem == energyItem
            }

            VehicleVerticalMenuButton {
                id: doorsButton

                text: qsTr("doors")
                sourceUp: "assets/images/ic-doors-off.png"
                sourceDown: "assets/images/ic-doors-on.png"
                onClicked: controlPages.currentItem = doorsItem
                down: controlPages.currentItem == doorsItem
            }

            VehicleVerticalMenuButton {
                id: tiresButton

                text: qsTr("tires")
                sourceUp: "assets/images/ic-tires-off.png"
                sourceDown: "assets/images/ic-tires-on.png"
                onClicked: controlPages.currentItem = tiresItem
                down: controlPages.currentItem == tiresItem
            }
        }
    }

    Item {
        id: controlPages

        anchors.fill: parent
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 280
        anchors.topMargin: 80
        property Item currentItem: doorsItem

        Item {
            id: supportItem

            visible: controlPages.currentItem == supportItem
            anchors.fill: parent

            ListView {
                anchors.fill: parent

                spacing: 2
                orientation: Qt.Vertical
                model: VehicleControlModel

                delegate: Rectangle {
                    width: controlPages.width * 0.9
                    height: 80
                    color: "transparent"
                    border.width: 1
                    border.color: "black"

                    Text {
                        text: name
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                    }

                    Rectangle {
                        color: active ? "red" : "green"
                        width: 10
                        height: 10
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                    }
                }
            }
        }

        Item {
            id: energyItem

            visible: controlPages.currentItem == energyItem
            anchors.fill: parent

            RowLayout {
                id: energyControls

                spacing: 0

                VehicleHorizontalMenuButton {
                    id: presetnTopConfig

                    state: "LEFT"
                    text: qsTr("Present")
                }

                VehicleHorizontalMenuButton {
                    id: dayTopConfig

                    text: qsTr("1 day")
                }

                VehicleHorizontalMenuButton {
                    id: weekTopConfig

                    text: qsTr("1 week")
                }

                VehicleHorizontalMenuButton {
                    id: monthTopConfig

                    state: "RIGHT"
                    text: qsTr("1 month")
                }
            }

            Image {
                id: energyImage

                source: "assets/images/energy.png"
                anchors.top: energyControls.bottom
                anchors.left: energyControls.left
                anchors.topMargin: 20
            }
        }

        Item {
            id: doorsItem

            visible: controlPages.currentItem == doorsItem
            anchors.fill: parent
            property Item currentItem: doorsConfig

            Image {
                id: roofImage

                source: "assets/images/roof.png"
                anchors.top: vehicleOpenableConfig.bottom
                anchors.left: vehicleOpenableConfig.left
                width: 470
                height: 670
            }

            RectangularGlow {
                anchors.fill: vehicleOpenableConfig
                glowRadius: 35
                spread: 0.2
                color: "#eee9e6"
                cornerRadius: 30
            }

            Item {
                id: vehicleOpenableConfig

                width: 740
                height: 50

                RowLayout {
                    spacing: 0

                    VehicleHorizontalMenuButton {
                        state: "LEFT"
                        text: qsTr("Locks")
                        onClicked: doorsItem.currentItem = locksConfig
                        down: doorsItem.currentItem == locksConfig
                    }

                    VehicleHorizontalMenuButton {
                        text: qsTr("Sun roof")
                        onClicked: doorsItem.currentItem = roofConfig
                        down: doorsItem.currentItem == roofConfig
                    }

                    VehicleHorizontalMenuButton {
                        text: qsTr("Doors")
                        onClicked: doorsItem.currentItem = doorsConfig
                        down: doorsItem.currentItem == doorsConfig
                    }

                    VehicleHorizontalMenuButton {
                        state: "RIGHT"
                        text: qsTr("Trunk")
                        onClicked: doorsItem.currentItem = trunkConfig
                        down: doorsItem.currentItem == trunkConfig
                    }
                }
            }

            Item {
                id: locksConfig

                visible: doorsItem.currentItem == locksConfig
                anchors.top: vehicleOpenableConfig.bottom
                anchors.right: vehicleOpenableConfig.right
                anchors.topMargin: 100
                width: 200
                height: 500

                VehicleButton {
                    id: locksCloseButton

                    anchors.top: parent.top
                    text: qsTr("Close")
                    onClicked: root.roofClose()
                }

                VehicleButton {
                    id: locksOpenButton

                    anchors.bottom: parent.bottom
                    text: qsTr("Open")
                    onClicked: root.roofOpen()
                }
            }

            Item {
                id: roofConfig

                visible: doorsItem.currentItem == roofConfig
                anchors.top: vehicleOpenableConfig.bottom
                anchors.right: vehicleOpenableConfig.right
                anchors.topMargin: 100
                width: 200
                height: 500

                VehicleButton {
                    id: roofCloseButton

                    anchors.top: parent.top
                    text: qsTr("Close")
                    onClicked: root.roofClose()
                }

                VehicleButton {
                    id: roofOpenButton

                    anchors.bottom: parent.bottom
                    text: qsTr("Open")
                    onClicked: root.roofOpen()
                }
            }

            Item {
                id: doorsConfig

                visible: doorsItem.currentItem == doorsConfig
                anchors.top: vehicleOpenableConfig.bottom
                anchors.right: vehicleOpenableConfig.right
                anchors.topMargin: 100
                width: 200
                height: 500

                VehicleButton {
                    id: closeButton

                    anchors.top: parent.top
                    text: qsTr("Close")
                    onClicked: root.doorsClose()
                }

                VehicleButton {
                    id: openButton

                    anchors.bottom: parent.bottom
                    text: qsTr("Open")
                    onClicked: root.doorsOpen()
                }
            }

            Item {
                id: trunkConfig

                visible: doorsItem.currentItem == trunkConfig
                anchors.top: vehicleOpenableConfig.bottom
                anchors.right: vehicleOpenableConfig.right
                anchors.topMargin: 100
                width: 200
                height: 500

                VehicleButton {
                    id: trunkCloseButton

                    anchors.top: parent.top
                    text: qsTr("Close")
                    onClicked: root.trunkClose()
                }

                VehicleButton {
                    id: trunkOpenButton

                    anchors.bottom: parent.bottom
                    text: qsTr("Open")
                    onClicked: root.trunkOpen()
                }
            }
        }

        Item {
            id: tiresItem

            visible: controlPages.currentItem == tiresItem
            anchors.fill: parent

            Image {
                id: tiresImage

                source: "assets/images/tires.png"
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: 50
            }

            VehicleButton {
                id: calibrateButton

                anchors.top: tiresImage.bottom
                anchors.right: tiresImage.right
                text: qsTr("Calibrate")
            }
        }
    }
}
