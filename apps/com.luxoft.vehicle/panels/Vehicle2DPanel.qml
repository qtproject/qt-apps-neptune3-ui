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

import QtQuick 2.9
import QtGraphicalEffects 1.12

import shared.animations 1.0
import shared.Sizes 1.0

import "../controls" 1.0
import "../helpers" 1.0

Item {
    id: root

    height: base.height
    width: base.width

    property bool trunkOpen: false
    property bool leftDoorOpen: false
    property bool rightDoorOpen: false
    property bool roofOpen: false
    property real speed: 0.0

    SequentialAnimation {
        running: speed > 0.0 && (trunkOpened || leftDoorOpened || roofOpen || rightDoorOpened)
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
        id: background
        anchors.topMargin: -Sizes.dp(68)
        anchors.fill: parent
        source: Paths.getImagePath("ic_background.png")
        width: Sizes.dp(sourceSize.width)
        height: Sizes.dp(sourceSize.height)
    }

    Rectangle {
        anchors.top: parent.top
        anchors.topMargin: -Sizes.dp(300)
        anchors.left: parent.left
        anchors.leftMargin: Sizes.dp(670)
        width: Sizes.dp(400)
        height: Sizes.dp(500)
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
        anchors.topMargin: -Sizes.dp(300)
        anchors.right: parent.right
        anchors.rightMargin: Sizes.dp(670)
        width: Sizes.dp(400)
        height: Sizes.dp(500)
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

    Image {
        id: base
        anchors.fill: parent
        source: Paths.getImagePath("ic_bodyVehicle.png")
        width: Sizes.dp(sourceSize.width)
        height: Sizes.dp(sourceSize.height)
    }

    Image {
        id: sunroof

        anchors.fill: parent
        source: Paths.getImagePath("ic_roofClosedVehicle.png")
        width: Sizes.dp(sourceSize.width)
        height: Sizes.dp(sourceSize.height)
        visible: sunroofOpened.opacity !== 1.0
    }

    Image {
        id: sunroofOpened

        anchors.fill: parent
        source: Paths.getImagePath("ic_roofOpenedVehicle.png")
        width: Sizes.dp(sourceSize.width)
        height: Sizes.dp(sourceSize.height)
        opacity: root.roofOpen ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation {} }
    }

    Image {
        id: sunroofAlarm

        anchors.fill: parent
        source: Paths.getImagePath("ic_roofAlarmVehicle.png")
        visible: roofOpen && root.speed > 0
        width: Sizes.dp(sourceSize.width)
        height: Sizes.dp(sourceSize.height)
    }

    Image {
        id: leftDoor

        anchors.fill: parent
        source: Paths.getImagePath("ic_leftDoorClosedVehicle.png")
        width: Sizes.dp(sourceSize.width)
        height: Sizes.dp(sourceSize.height)
        visible: root.leftDoorOpen ? 0.0 : 1.0
    }

    Image {
        id: leftDoorOpenedCarPart

        anchors.fill: parent
        source: Paths.getImagePath("ic_leftDoorOpenedVehicleCarPart.png")
        width: Sizes.dp(sourceSize.width)
        height: Sizes.dp(sourceSize.height)
        visible: root.leftDoorOpen ? 1.0 : 0.0
    }

    Image {
        id: leftDoorOpened

        anchors.fill: parent
        source: Paths.getImagePath("ic_leftDoorOpenedVehicle.png")
        width: Sizes.dp(sourceSize.width)
        height: Sizes.dp(sourceSize.height)
        opacity: root.leftDoorOpen ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation {} }
    }

    Image {
        id: leftDooralarm

        anchors.fill: parent
        source: Paths.getImagePath("ic_leftDoorAlarmVehicle.png")
        visible: leftDoorOpen && root.speed > 0
        width: Sizes.dp(sourceSize.width)
        height: Sizes.dp(sourceSize.height)
    }

    Image {
        id: rightDoor

        anchors.fill: parent
        source: Paths.getImagePath("ic_rightDoorClosedVehicle.png")
        width: Sizes.dp(sourceSize.width)
        height: Sizes.dp(sourceSize.height)
        visible: root.rightDoorOpen ? 0.0 : 1.0
    }

    Image {
        id: rightDoorOpenedCarPart

        anchors.fill: parent
        source: Paths.getImagePath("ic_rightDoorOpenedVehicleCarPart.png")
        width: Sizes.dp(sourceSize.width)
        height: Sizes.dp(sourceSize.height)
        visible: root.rightDoorOpen ? 1.0 : 0.0
    }

    Image {
        id: rightDoorOpened

        anchors.fill: parent
        source: Paths.getImagePath("ic_rightDoorOpenedVehicle.png")
        width: Sizes.dp(sourceSize.width)
        height: Sizes.dp(sourceSize.height)
        opacity: root.rightDoorOpen ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation {} }
    }

    Image {
        id: rightDooralarm

        anchors.fill: parent
        source: Paths.getImagePath("ic_rightDoorAlarmVehicle.png")
        visible: rightDoorOpen && root.speed > 0
        width: Sizes.dp(sourceSize.width)
        height: Sizes.dp(sourceSize.height)
    }

    Image {
        id: trunk

        anchors.fill: parent
        source: Paths.getImagePath("ic_trunkClosedVehicle.png")
        width: Sizes.dp(sourceSize.width)
        height: Sizes.dp(sourceSize.height)
        visible: trunkOpened.opacity !== 1.0
    }

    Image {
        id: trunkOpened

        anchors.fill: parent
        source: Paths.getImagePath("ic_trunkOpenedVehicle.png")
        width: Sizes.dp(sourceSize.width)
        height: Sizes.dp(sourceSize.height)
        opacity: root.trunkOpen ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation {} }
    }

    Image {
        id: trunkAlarm

        anchors.fill: parent
        source: Paths.getImagePath("ic_trunkAlarmVehicle.png")
        visible: trunkOpen && root.speed > 0
        width: Sizes.dp(sourceSize.width)
        height: Sizes.dp(sourceSize.height)
    }
}
