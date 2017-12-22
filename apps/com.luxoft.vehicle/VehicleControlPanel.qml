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
import com.pelagicore.settings 1.0

Item {
    id: root

    width: 1080
    height: 1920 * 0.60

    property bool locksOpened: false
    property bool leftDoorOpened: false
    property bool rightDoorOpened: false
    property bool roofOpened: false
    property bool trunkOpened: false

    property real roofSliderValue: 0.0
    readonly property var uiSettings: UISettings {}

    Behavior on roofSliderValue {
       NumberAnimation { duration: 1000 }
   }

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
        anchors.leftMargin: 70
        anchors.topMargin: 74
        width: 100
        height: 460

        ColumnLayout {
            spacing: 20

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

    //ToDo: Better to put it in a separate component later
    Item {
        id: controlPages

        anchors.fill: parent
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 262
        anchors.topMargin: 74
        property Item currentItem: doorsItem

        Item {
            id: supportItem

            visible: controlPages.currentItem == supportItem
            anchors.fill: parent

            ListView {
                width: 820
                height: (spacing + 50) * 7

                spacing: 44
                orientation: Qt.Vertical
                interactive: false
                model: VehicleControlModel
                delegate: Item {
                    width: parent.width * 0.9
                    height: 50

                    Image {
                        id: supportDelegateIconImage
                        anchors.left: parent.left
                        anchors.leftMargin: 30
                        source: "assets/images/" + icon
                    }

                    ColorOverlay {
                        anchors.fill: supportDelegateIconImage
                        source: supportDelegateIconImage
                        color: "#171717"
                    }

                    Text {
                        text: qsTranslate("VehicleControlModel", name)
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: supportDelegateIconImage.right
                        anchors.leftMargin: 28

                        font {
                            pixelSize: 26
                            family: "Open Sans"
                            weight: Font.Light
                        }
                        opacity: 0.94
                        color: "#171717"
                    }

                    Switch {
                        anchors.top: parent.top
                        anchors.topMargin: 2
                        anchors.right: parent.right
                        anchors.rightMargin: 2
                        checked: active
                    }

                    Rectangle {
                        height: 1
                        width: parent.width
                        color: "#bfbbb9"
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: -18
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                    }
                }
            }
        }

        Item {
            id: energyItem

            visible: controlPages.currentItem == energyItem
            anchors.fill: parent

            //ToDo: this button row deserves it's own component
            RowLayout {
                id: energyControls

                spacing: 0

                VehicleHorizontalMenuButton {
                    id: presetnTopConfig

                    state: "LEFT"
                    text: qsTr("Present")
                    onPressedChanged: (z = pressed ? 100 : 0)
                }

                VehicleHorizontalMenuButton {
                    id: dayTopConfig

                    text: qsTr("1 day")
                    onPressedChanged: (z = pressed ? 100 : 0)
                }

                VehicleHorizontalMenuButton {
                    id: weekTopConfig

                    text: qsTr("1 week")
                    onPressedChanged: (z = pressed ? 100 : 0)
                }

                VehicleHorizontalMenuButton {
                    id: monthTopConfig

                    state: "RIGHT"
                    text: qsTr("1 month")
                    onPressedChanged: (z = pressed ? 100 : 0)
                }
            }

            Image {
                id: energyGraph

                anchors.top: energyControls.bottom
                anchors.left: energyControls.left
                anchors.topMargin: 40
                anchors.leftMargin: 10
                source: "assets/images/energy-graph.png"
            }

            Text {
                id: energyGraphTitle

                anchors.top: energyGraph.bottom
                anchors.topMargin: 46
                anchors.left: energyGraph.left
                anchors.leftMargin: 34

                text: qsTr("Projected distance to empty")
                font {
                    pixelSize: 26
                    family: "Open Sans"
                }
                opacity: 0.94
                color: "#171717"
            }

            Item {
                id: chargingInfoItem

                anchors.top: energyGraphTitle.bottom
                anchors.topMargin: 24
                width: parent.width
                height: 340

                Rectangle {
                    height: 1
                    width: 750
                    color: "#bfbbb9"
                }

                Text {
                    anchors.top: parent.top
                    anchors.topMargin: 16
                    anchors.left: parent.left
                    anchors.leftMargin: 40
                    text: qsTr("184")
                    font {
                        pixelSize: 32
                        family: "Open Sans"
                    }
                    opacity: 0.94
                    color: "#171717"

                    Text {
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 2
                        anchors.left: parent.right
                        anchors.leftMargin: 12

                        text: qsTr("km")
                        font {
                            pixelSize: 18
                            family: "Open Sans"
                            weight: Font.Light
                        }
                        opacity: 0.4
                        color: "#171717"
                    }
                }

                Text {
                    anchors.top: parent.top
                    anchors.topMargin: 114
                    anchors.left: parent.left
                    anchors.leftMargin: 42

                    text: qsTr("Charging stations")
                    font {
                        pixelSize: 26
                        family: "Open Sans"
                    }
                    opacity: 0.94
                    color: "#171717"
                }

                VehicleButton {
                    anchors.top: parent.top
                    anchors.topMargin: 102
                    anchors.right: parent.right
                    anchors.rightMargin: 80
                    state: "SMALL"
                    text: qsTr("Show on map")
                }

                Rectangle {
                    height: 1
                    width: 750
                    color: "#bfbbb9"
                    anchors.top: parent.top
                    anchors.topMargin: 168
                }

                //ToDo: this probably should be in a model later
                Item {
                    id: chargingStatioRouteOne

                    anchors.top: parent.top
                    anchors.topMargin: 180
                    anchors.left: parent.left
                    anchors.leftMargin: 40
                    width: parent.width
                    height: 60

                    Text {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("21")
                        font {
                            pixelSize: 32
                            family: "Open Sans"
                        }
                        opacity: 0.94
                        color: "#171717"

                        Text {
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 2
                            anchors.left: parent.right
                            anchors.leftMargin: 10

                            text: qsTr("km")
                            font {
                                pixelSize: 18
                                family: "Open Sans"
                                weight: Font.Light
                            }
                            opacity: 0.4
                            color: "#171717"
                        }
                    }

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 100
                        anchors.verticalCenter: parent.verticalCenter

                        text: qsTr("Donald Weese Ct, Las Vegas")
                        font {
                            pixelSize: 26
                            family: "Open Sans"
                        }
                        opacity: 0.94
                        color: "#171717"
                    }

                    VehicleButton {
                        anchors.right: parent.right
                        anchors.rightMargin: 120
                        state: "SMALL"
                        text: qsTr("Route")
                    }
                }

                //ToDo: this probably should be in a model later
                Item {
                    id: chargingStatioRouteTwo

                    anchors.top: parent.top
                    anchors.topMargin: 245
                    anchors.left: parent.left
                    anchors.leftMargin: 40
                    width: parent.width
                    height: 60

                    Text {
                        text: qsTr("27")

                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        font {
                            pixelSize: 32
                            family: "Open Sans"
                        }
                        opacity: 0.94
                        color: "#171717"

                        Text {
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 2
                            anchors.left: parent.right
                            anchors.leftMargin: 10

                            text: qsTr("km")
                            font {
                                pixelSize: 18
                                family: "Open Sans"
                                weight: Font.Light
                            }
                            opacity: 0.4
                            color: "#171717"
                        }
                    }

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 100
                        anchors.verticalCenter: parent.verticalCenter

                        text: qsTr("Faiss Dr, Las Vegas")
                        font {
                            pixelSize: 26
                            family: "Open Sans"
                        }
                        opacity: 0.94
                        color: "#171717"
                    }

                    VehicleButton {
                        anchors.right: parent.right
                        anchors.rightMargin: 120
                        state: "SMALL"
                        text: qsTr("Route")
                    }
                }
            }
        }

        Item {
            id: doorsItem

            visible: controlPages.currentItem == doorsItem
            anchors.fill: parent
            property Item currentItem: doorsConfig

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
                        width: vehicleOpenableConfig.width / 3
                        state: "LEFT"
                        text: qsTr("Sun roof")
                        down: doorsItem.currentItem == roofConfig
                        onClicked: doorsItem.currentItem = roofConfig
                        onPressedChanged: (z = pressed ? 100 : 0)
                    }

                    VehicleHorizontalMenuButton {
                        width: vehicleOpenableConfig.width / 3
                        text: qsTr("Doors")
                        down: doorsItem.currentItem == doorsConfig
                        onClicked: doorsItem.currentItem = doorsConfig
                        onPressedChanged: (z = pressed ? 100 : 0)
                    }

                    VehicleHorizontalMenuButton {
                        width: vehicleOpenableConfig.width / 3
                        state: "RIGHT"
                        text: qsTr("Trunk")
                        down: doorsItem.currentItem == trunkConfig
                        onClicked: doorsItem.currentItem = trunkConfig
                        onPressedChanged: (z = pressed ? 100 : 0)
                    }
                }
            }

            Item {
                id: roofConfig

                visible: doorsItem.currentItem == roofConfig
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
                        height: 450 - 120 * roofSliderValue
                        clip: true

                        Image {
                            anchors.bottom: parent.bottom
                            width: 470
                            height: 670
                            source: "assets/images/car-top-close-roof.png"
                        }
                    }

                    MouseArea {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: roofImageClosed.top
                        anchors.topMargin: 160
                        width: 300
                        height: 200

                        onMouseXChanged: {
                            if (pressed && containsMouse)
                                root.roofSliderValue = mouse.y / height
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
                        root.roofSliderValue = 0.0
                        root.roofOpened = false
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
                        root.roofSliderValue = 1.0
                        root.roofOpened = true
                    }
                }
            }

            Item {
                id: doorsConfig

                visible: doorsItem.currentItem == doorsConfig
                anchors.top: vehicleOpenableConfig.bottom
                anchors.right: vehicleOpenableConfig.right
                anchors.fill: parent

                readonly property string openRightDoorSource: "assets/images/ic-door-open.png"
                readonly property string closeRightDoorSource: "assets/images/ic-door-closed.png"
                readonly property string openLeftDoorSource: "assets/images/ic-door-open-flip.png"
                readonly property string closeLeftDoorSource: "assets/images/ic-door-closed-flip.png"

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
                        visible: root.leftDoorOpened
                        source: "assets/images/car-top-left-door.png"
                    }
                    Image {
                        anchors.fill: parent
                        visible: root.rightDoorOpened
                        source: "assets/images/car-top-right-door.png"
                    }

                    //ToDo: It should be a separate button item later
                    Image {
                        anchors.top: parent.top
                        anchors.topMargin: 200
                        anchors.left: parent.left
                        anchors.leftMargin: 40
                        source: "assets/images/round-button.png"

                        Image {
                            anchors.centerIn: parent
                            source: root.leftDoorOpened ? doorsConfig.openLeftDoorSource : doorsConfig.closeLeftDoorSource
                        }

                        MouseArea {
                            width: 100
                            height: 100
                            anchors.centerIn: parent

                            onClicked: {
                                root.leftDoorOpened = !root.leftDoorOpened
                                root.uiSettings.door1Open = root.leftDoorOpened
                            }
                            onPressed: (parent.scale = 1.1)
                            onReleased: (parent.scale = 1.0)

                            Connections {
                                target: root.uiSettings
                                onDoor1OpenChanged: {
                                    root.leftDoorOpened = root.uiSettings.door1Open
                                }
                            }
                        }
                    }

                    Image {
                        anchors.top: parent.top
                        anchors.topMargin: 200
                        anchors.right: parent.right
                        anchors.rightMargin: 40
                        source: "assets/images/round-button.png"

                        Image {
                            anchors.centerIn: parent
                            source: root.rightDoorOpened ? doorsConfig.openRightDoorSource : doorsConfig.closeRightDoorSource
                        }

                        MouseArea {
                            width: 100
                            height: 100
                            anchors.centerIn: parent

                            onClicked: {
                                root.rightDoorOpened = !root.rightDoorOpened
                                root.uiSettings.door2Open = root.rightDoorOpened
                            }
                            onPressed: (parent.scale = 1.1)
                            onReleased: (parent.scale = 1.0)

                            Connections {
                                target: root.uiSettings
                                onDoor2OpenChanged: {
                                    root.rightDoorOpened = root.uiSettings.door2Open
                                }
                            }
                        }
                    }
                }
            }

            Item {
                id: trunkConfig

                visible: doorsItem.currentItem == trunkConfig
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
                        visible: root.trunkOpened
                        source: "assets/images/car-top-trunk.png"
                    }

                    VehicleButton {
                        id: trunkCloseButton

                        anchors.top: parent.bottom
                        anchors.topMargin: 30
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: root.trunkOpened ? qsTr("Close") : qsTr("Open")

                        onClicked: root.trunkOpened = !root.trunkOpened
                    }
                }
            }
        }

        Item {
            id: tiresItem

            visible: controlPages.currentItem == tiresItem
            anchors.fill: parent

            Image {
                anchors.top: parent.top
                anchors.topMargin: 44
                anchors.left: parent.left
                anchors.leftMargin: 100

                source: "assets/images/car-tires.png"

                Image {
                    anchors.top: parent.top
                    anchors.topMargin: 80
                    anchors.left: parent.left
                    anchors.leftMargin: 26
                    source: "assets/images/tire.png"

                    Text {
                        anchors.right: parent.left
                        anchors.rightMargin: 26
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("240")
                        font {
                            pixelSize: 32
                            family: "Open Sans"
                        }
                        opacity: 0.94
                        color: "#171717"

                        Text {
                            anchors.top: parent.bottom
                            anchors.topMargin: -6
                            anchors.right: parent.right

                            text: qsTr("kPa")
                            font {
                                pixelSize: 18
                                family: "Open Sans"
                                weight: Font.Light
                            }
                            opacity: 0.4
                            color: "#171717"
                        }
                    }
                }

                Image {
                    anchors.top: parent.top
                    anchors.topMargin: 80
                    anchors.right: parent.right
                    anchors.rightMargin: 26
                    source: "assets/images/tire.png"

                    Text {
                        anchors.left: parent.right
                        anchors.leftMargin: 26
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("240")
                        font {
                            pixelSize: 32
                            family: "Open Sans"
                        }
                        opacity: 0.94
                        color: "#171717"

                        Text {
                            anchors.top: parent.bottom
                            anchors.topMargin: -6
                            anchors.right: parent.right
                            text: qsTr("kPa")
                            font {
                                pixelSize: 18
                                family: "Open Sans"
                                weight: Font.Light
                            }
                            opacity: 0.4
                            color: "#171717"
                        }
                    }
                }

                Image {
                    anchors.top: parent.top
                    anchors.topMargin: 350
                    anchors.left: parent.left
                    anchors.leftMargin: 26
                    source: "assets/images/tire.png"

                    Text {
                        anchors.right: parent.left
                        anchors.rightMargin: 26
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("240")
                        font {
                            pixelSize: 32
                            family: "Open Sans"
                        }
                        opacity: 0.94
                        color: "#171717"

                        Text {
                            anchors.top: parent.bottom
                            anchors.topMargin: -6
                            anchors.right: parent.right

                            text: qsTr("kPa")
                            font {
                                pixelSize: 18
                                family: "Open Sans"
                                weight: Font.Light
                            }
                            opacity: 0.4
                            color: "#171717"
                        }
                    }
                }

                Image {
                    anchors.top: parent.top
                    anchors.topMargin: 350
                    anchors.right: parent.right
                    anchors.rightMargin: 26
                    source: "assets/images/tire.png"

                    Text {
                        anchors.left: parent.right
                        anchors.leftMargin: 26
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("240")
                        font {
                            pixelSize: 32
                            family: "Open Sans"
                        }
                        opacity: 0.94
                        color: "#171717"

                        Text {
                            anchors.top: parent.bottom
                            anchors.topMargin: -6
                            anchors.right: parent.right
                            text: qsTr("kPa")
                            font {
                                pixelSize: 18
                                family: "Open Sans"
                                weight: Font.Light
                            }
                            opacity: 0.4
                            color: "#171717"
                        }
                    }
                }
            }

            Text {
                anchors.right: parent.right
                anchors.rightMargin: 92
                anchors.top: parent.top
                anchors.topMargin: 132

                text: qsTr("Normal load")
                font {
                    pixelSize: 26
                    family: "Open Sans"
                }
                opacity: 0.94
                color: "#171717"

                Text {
                    anchors.top: parent.bottom
                    anchors.topMargin: 10
                    anchors.right: parent.right

                    text: qsTr("Target: 240 kPa")
                    font {
                        pixelSize: 22
                        family: "Open Sans"
                        weight: Font.Light
                    }
                    opacity: 0.94
                    color: "#171717"
                }
            }


            Text {
                anchors.right: parent.right
                anchors.rightMargin: 92
                anchors.top: parent.top
                anchors.topMargin: 270

                text: qsTr("Max load")
                font {
                    pixelSize: 26
                    family: "Open Sans"
                }
                opacity: 0.94
                color: "#171717"

                Text {
                    anchors.top: parent.bottom
                    anchors.topMargin: 10
                    anchors.right: parent.right

                    text: qsTr("Target: 270 kPa")
                    font {
                        pixelSize: 22
                        family: "Open Sans"
                        weight: Font.Light
                    }
                    opacity: 0.94
                    color: "#171717"
                }
            }

            VehicleButton {
                id: calibrateButton

                anchors.top: parent.top
                anchors.topMargin: 570
                anchors.right: parent.right
                anchors.rightMargin: 92
                text: qsTr("Calibrate")
                iconSource: "assets/images/calibrate.png"
            }
        }
    }
}
