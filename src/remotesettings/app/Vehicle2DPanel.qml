/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
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

import QtQuick
import Qt5Compat.GraphicalEffects


Item {
    id: root

    property bool trunkOpen: false
    property bool leftDoorOpen: false
    property bool rightDoorOpen: false
    property bool roofOpen: false

    property var d: QtObject {
        property real scaleFactor: root.height / base.sourceSize.height
    }

    SequentialAnimation {
        running: trunkOpened || leftDoorOpened || roofOpen || rightDoorOpened
        loops: Animation.Infinite

        PropertyAnimation {
            targets: [sunroofAlarm, trunkAlarm, leftDooralarm, rightDooralarm]
            properties: "opacity"
            from: 0.0
            to: 1.0
            duration: 1000
        }

        PropertyAnimation {
            targets: [sunroofAlarm, trunkAlarm, leftDooralarm, rightDooralarm]
            properties: "opacity"
            from: 1.0
            to: 0.0
            duration: 1000
        }
    }

    Image {
        source: "qrc:/assets/ic_background.png"
        fillMode: Image.PreserveAspectCrop
        anchors.centerIn: parent
        scale: d.scaleFactor

        Rectangle {
            anchors.top: parent.top
            anchors.topMargin: -300
            anchors.left: parent.left
            anchors.leftMargin: 670
            width: 400
            height: 500
            color: "transparent"

            RadialGradient {
                anchors.fill: parent
                horizontalRadius: parent.width * .8
                verticalRadius: parent.height * .8
                angle: -20
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "white" }
                    GradientStop { position: 0.6; color: "transparent" }
                }
            }
        }

        Rectangle {
            anchors.top: parent.top
            anchors.topMargin: -300
            anchors.left: parent.left
            anchors.leftMargin: 850
            width: 400
            height: 500
            color: "transparent"

            RadialGradient {
                anchors.fill: parent
                horizontalRadius: parent.width * .8
                verticalRadius: parent.height * .8
                angle: 20
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "white" }
                    GradientStop { position: 0.6; color: "transparent" }
                }
            }
        }
    }

    Image {
        id: base

        source: "qrc:/assets/ic_bodyVehicle.png"
        fillMode: Image.PreserveAspectCrop
        anchors.centerIn: parent
        scale: d.scaleFactor
    }

    Image {
        id: sunroof

        source: "qrc:/assets/ic_roofClosedVehicle.png"
        fillMode: Image.PreserveAspectCrop
        anchors.centerIn: parent
        scale: d.scaleFactor
        visible: sunroofOpened.opacity !== 1.0
    }

    Image {
        id: sunroofOpened

        source: "qrc:/assets/ic_roofOpenedVehicle.png"
        opacity: root.roofOpen ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation {} }
        fillMode: Image.PreserveAspectCrop
        anchors.centerIn: parent
        scale: d.scaleFactor
    }

    Image {
        id: sunroofAlarm

        source: "qrc:/assets/ic_roofAlarmVehicle.png"
        visible: roofOpen
        fillMode: Image.PreserveAspectCrop
        anchors.centerIn: parent
        scale: d.scaleFactor
    }

    Image {
        id: leftDoor

        source: "qrc:/assets/ic_leftDoorClosedVehicle.png"
        visible: root.leftDoorOpen ? 0.0 : 1.0
        fillMode: Image.PreserveAspectCrop
        anchors.centerIn: parent
        scale: d.scaleFactor
    }

    Image {
        id: leftDoorOpenedCarPart

        source: "qrc:/assets/ic_leftDoorOpenedVehicleCarPart.png"
        visible: root.leftDoorOpen ? 1.0 : 0.0
        fillMode: Image.PreserveAspectCrop
        anchors.centerIn: parent
        scale: d.scaleFactor
    }

    Image {
        id: leftDoorOpened

        source: "qrc:/assets/ic_leftDoorOpenedVehicle.png"
        opacity: root.leftDoorOpen ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation {} }
        fillMode: Image.PreserveAspectCrop
        anchors.centerIn: parent
        scale: d.scaleFactor
    }

    Image {
        id: leftDooralarm

        source: "qrc:/assets/ic_leftDoorAlarmVehicle.png"
        visible: leftDoorOpen
        fillMode: Image.PreserveAspectCrop
        anchors.centerIn: parent
        scale: d.scaleFactor
    }

    Image {
        id: rightDoor

        source: "qrc:/assets/ic_rightDoorClosedVehicle.png"
        visible: root.rightDoorOpen ? 0.0 : 1.0
        fillMode: Image.PreserveAspectCrop
        anchors.centerIn: parent
        scale: d.scaleFactor
    }

    Image {
        id: rightDoorOpenedCarPart

        source: "qrc:/assets/ic_rightDoorOpenedVehicleCarPart.png"
        visible: root.rightDoorOpen ? 1.0 : 0.0
        fillMode: Image.PreserveAspectCrop
        anchors.centerIn: parent
        scale: d.scaleFactor
    }

    Image {
        id: rightDoorOpened

        source: "qrc:/assets/ic_rightDoorOpenedVehicle.png"
        opacity: root.rightDoorOpen ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation {} }
        fillMode: Image.PreserveAspectCrop
        anchors.centerIn: parent
        scale: d.scaleFactor
    }

    Image {
        id: rightDooralarm

        source: "qrc:/assets/ic_rightDoorAlarmVehicle.png"
        visible: rightDoorOpen
        fillMode: Image.PreserveAspectCrop
        anchors.centerIn: parent
        scale: d.scaleFactor
    }

    Image {
        id: trunk

        source: "qrc:/assets/ic_trunkClosedVehicle.png"
        visible: trunkOpened.opacity !== 1.0
        fillMode: Image.PreserveAspectCrop
        anchors.centerIn: parent
        scale: d.scaleFactor
    }

    Image {
        id: trunkOpened

        source: "qrc:/assets/ic_trunkOpenedVehicle.png"
        opacity: root.trunkOpen ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation {} }
        fillMode: Image.PreserveAspectCrop
        anchors.centerIn: parent
        scale: d.scaleFactor
    }

    Image {
        id: trunkAlarm

        source: "qrc:/assets/ic_trunkAlarmVehicle.png"
        visible: trunkOpen
        fillMode: Image.PreserveAspectCrop
        anchors.centerIn: parent
        scale: d.scaleFactor
    }
}
