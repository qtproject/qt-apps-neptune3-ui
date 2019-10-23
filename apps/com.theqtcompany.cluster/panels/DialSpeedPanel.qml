/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Copyright (C) 2018 Pelagicore AG
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 Cluster UI.
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
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Shapes 1.0
import shared.controls 1.0
import "../helpers" 1.0
import shared.Style 1.0
import shared.Sizes 1.0

Item {
    id: root
    width: Sizes.dp(560)
    height: width

    //public
    property real speed
    property real speedLimit
    property real cruiseSpeed

    //private
    QtObject {
        id: d
        function speed2Angle(speed) {
            if (speed < 0) {
                return -240;
            } else if (speed < 140) {
                //0 to 140 kmh
                //map to -240degree to -30degree
                return (speed / 140 * 210 - 240);
            } else if (speed <= 260) {
                //140 o 260 kmh
                //map to -30degree to 30degree
                return ((speed - 140) / 120 * 60 - 30);
            } else {
                return 30;
            }
        }
    }

    //states and transitions
    state: "stopped"
    states: [
        State {
            name: "stopped"
            PropertyChanges { target: graduation; opacity: 0; maxDrawValue: 0 }
            PropertyChanges { target: graduationNumber; opacity: 0 }
            PropertyChanges { target: indicatorSpeed; opacity: 0 }
            PropertyChanges { target: signKMH; opacity: 0 }
            PropertyChanges { target: indicatorSpdLimit; opacity: 0 }
            PropertyChanges { target: indicatorCruise; visible: false; x: Sizes.dp(285); y: Sizes.dp(466) }
        },
        State {
            name: "normal"
            PropertyChanges { target: graduation; opacity: 1; maxDrawValue: 265 }
            PropertyChanges { target: graduationNumber; opacity: Style.opacityMedium }
            PropertyChanges { target: indicatorSpeed; opacity: Style.opacityHigh }
            PropertyChanges { target: signKMH; opacity: Style.opacityLow }
            PropertyChanges { target: indicatorSpdLimit; opacity: 1 }
            PropertyChanges { target: indicatorCruise; visible: true; x: Sizes.dp(285); y: Sizes.dp(466) }
        },
        State {
            name: "navi"
            PropertyChanges { target: graduation; opacity: 0; maxDrawValue: 265 }
            PropertyChanges { target: graduationNumber; opacity: 0 }
            PropertyChanges { target: indicatorSpeed; opacity: Style.opacityHigh }
            PropertyChanges { target: signKMH; opacity: Style.opacityLow }
            PropertyChanges { target: indicatorSpdLimit; opacity: 1 }
            PropertyChanges { target: indicatorCruise; visible: true; x: Sizes.dp(285); y: Sizes.dp(374) }
        }
    ]

    transitions: [
        Transition {
            from: "stopped"
            to: "normal"
            reversible: false
            SequentialAnimation{
                //wait DialFrame to start (1600ms)
                PauseAnimation { duration: 1600 }
                //fade in (640ms)
                PropertyAnimation { targets: [graduation, graduationNumber]; property: "opacity"; duration: 130 }
                PropertyAnimation { target: graduation; property: "maxDrawValue"; duration: 370 }
                PropertyAction {
                    targets: [indicatorCruise, indicatorCruiseBg]
                    properties: "visible, x, y"
                }
                PropertyAnimation {
                    targets: [indicatorSpeed, signKMH, indicatorSpdLimit]
                    property: "opacity"
                    duration: 140
                }
                //test the highLight (1080ms)
                PropertyAnimation { target: root; properties: "speed, speedLimit, cruiseSpeed"; from: 0; to: 260; duration: 540 }
                PropertyAnimation { target: root; properties: "speed, speedLimit, cruiseSpeed"; from: 260; to: 0; duration: 540 }
                ParallelAnimation {
                    //restore to actual values
                    PropertyAction { target: root; property: "speed"; value: speed }
                    PropertyAction { target: root; property: "speedLimit"; value: speedLimit }
                    PropertyAction { target: root; property: "cruiseSpeed"; value: cruiseSpeed }
                }
            }
        },
        Transition {
            from: "normal"
            to: "stopped"
            reversible: false
            SequentialAnimation{
                //fade out (390ms)
                PropertyAnimation {
                    targets: [indicatorSpeed, signKMH, indicatorSpdLimit, indicatorCruise, indicatorCruiseBg]
                    properties: "opacity, x, y"
                    duration: 130
                }
                PropertyAnimation { target: graduation; property: "maxDrawValue"; duration: 130 }
                PropertyAnimation { targets: [graduation, graduationNumber]; property: "opacity"; duration: 130 }
            }
        },
        Transition {
            from: "normal"
            to: "navi"
            reversible: false
            SequentialAnimation{
                //fade out (160ms)
                PropertyAnimation { targets: [graduation, graduationNumber]; property: "opacity"; duration: 80 }
                PropertyAnimation {
                    targets: [indicatorSpeed, signKMH, indicatorSpdLimit, indicatorCruise, indicatorCruiseBg]
                    properties: "opacity"
                    to: 0
                    duration: 80
                }
                //wait DialFrame to shrink(160ms)
                PropertyAnimation {
                    targets: [indicatorSpeed, signKMH, indicatorSpdLimit, indicatorCruise, indicatorCruiseBg]
                    properties: "x, y"
                    duration: 160
                }
                //fade in (160ms)
                PropertyAnimation {
                    targets: [indicatorSpeed, signKMH, indicatorSpdLimit, indicatorCruise, indicatorCruiseBg]
                    properties: "opacity"
                    to: 1.0
                    duration: 160
                }
            }
        },
        Transition {
            from: "navi"
            to: "normal"
            reversible: false
            SequentialAnimation{
                //fade out (160ms)
                PropertyAnimation {
                    targets: [indicatorSpeed, signKMH, indicatorSpdLimit, indicatorCruise, indicatorCruiseBg]
                    properties: "opacity"
                    to: 0
                    duration: 160
                }
                //wait DialFrame to expand(160ms)
                PropertyAnimation {
                    targets: [indicatorSpeed, signKMH, indicatorSpdLimit, indicatorCruise, indicatorCruiseBg]
                    properties: "x, y"
                    duration: 160
                }
                //fade in (160ms)
                PropertyAnimation { targets: [graduation, graduationNumber]; property: "opacity"; duration: 80 }
                PropertyAnimation {
                    targets: [indicatorSpeed, signKMH, indicatorSpdLimit, indicatorCruise, indicatorCruiseBg]
                    properties: "opacity"
                    to: 1.0
                    duration: 80
                }
            }
        },
        Transition {
            from: "stopped"
            to: "navi"
            reversible: false
            SequentialAnimation{
                //wait DialFrame to start (1600ms)
                PauseAnimation { duration: 1600 }
                //fade in (640ms)
                PropertyAnimation { targets: [graduation, graduationNumber]; property: "opacity"; duration: 130 }
                PropertyAnimation { target: graduation; property: "maxDrawValue"; duration: 370 }
                PropertyAnimation {
                    targets: [indicatorSpeed, signKMH, indicatorSpdLimit, indicatorCruise, indicatorCruiseBg]
                    properties: "opacity, x, y"
                    duration: 140
                }
                //test the highLight (1080ms)
                PropertyAnimation { target: root; properties: "speed, speedLimit, cruiseSpeed"; from: 0; to: 260; duration: 540 }
                PropertyAnimation { target: root; properties: "speed, speedLimit, cruiseSpeed"; from: 260; to: 0; duration: 540 }
            }
        },
        Transition {
            from: "navi"
            to: "stopped"
            SequentialAnimation{
                //fade out (640ms)
                PropertyAnimation { targets: [graduation, graduationNumber]; property: "opacity"; duration: 130 }
                PropertyAnimation {
                    targets: [indicatorSpeed, signKMH, indicatorSpdLimit, indicatorCruise, indicatorCruiseBg]
                    properties: "opacity"
                    duration: 100
                }
                PropertyAnimation {
                    targets: [indicatorSpeed, signKMH, indicatorSpdLimit, indicatorCruise, indicatorCruiseBg]
                    properties: "x, y"
                    duration: 100
                }
            }
        }
    ]

    Behavior on cruiseSpeed {
        NumberAnimation { easing.type: Easing.OutCubic; duration: 5000 }
    }

    onSpeedChanged: {
        dialFrame.highLightAng = d.speed2Angle(speed);
    }

    //visual components
    DialFramePanel {
        id: dialFrame
        anchors.centerIn: parent
        width: Sizes.dp(560)
        height: width
        state: parent.state
        minAng: -240
        maxAng: 30
        zeroAng: -240
    }

    Label {
        id: indicatorSpeed
        anchors.centerIn: dialFrame
        width: Sizes.dp(40)
        text: Math.round(speed)
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignHCenter
        font.weight: Font.DemiBold
        opacity: Style.opacityHigh
        font.pixelSize: Sizes.dp(80)
    }

    Label {
        id: signKMH
        anchors.horizontalCenter: parent.horizontalCenter
        y: Sizes.dp(325)
        text: qsTr("km/h")
        font.weight: Font.Light
        opacity: Style.opacityLow
        font.pixelSize: Sizes.dp(18)
    }

    Image {
        id: indicatorSpdLimit
        x: Sizes.dp(330)
        y: Sizes.dp(342)
        width: Sizes.dp(140)
        height: Sizes.dp(140)
        visible: root.speedLimit !== 0
        source: Utils.localAsset(root.speed > root.speedLimit ? "speed-limit-badge-red" : "speed-limit-badge")
        Label {
            anchors.centerIn: parent
            text: Math.round(speedLimit)
            opacity: Style.opacityHigh
            font.pixelSize: Sizes.dp(34)
            color: root.Style.theme === Style.Dark ? Style.mainColor : Style.contrastColor
        }
    }

    Rectangle {
        id: cruiseSource
        visible: false
        color: "transparent"
        width: Sizes.dp(370)
        height: width
        anchors.centerIn: parent
        Image {
            id: cruiseShadow
            width: Sizes.dp(370)
            height: width
            anchors.centerIn: parent
            source: Utils.localAsset("dial-cruise-circle-shadow")
        }
        Image {
            id: cruiseCircle
            width: Sizes.dp(330)
            height: width
            anchors.centerIn: parent
            source: Utils.localAsset("dial-cruise-circle", Style.theme)
        }
    }

    Shape {
        id: cruiseMask
        x: Sizes.dp(-1000)
        y: Sizes.dp(-1000)
        width: Sizes.dp(370)
        height: width
        visible: true

        ShapePath {
            id: cruiseMaskPath
            readonly property real radius: cruiseMask.width / 2
            readonly property real centerX: cruiseMask.width / 2
            readonly property real centerY: cruiseMask.height / 2

            readonly property real zeroRadin: dialFrame.zeroAng / 180 * Math.PI
            readonly property real cruiseRadin: d.speed2Angle(cruiseSpeed) / 180 * Math.PI
            readonly property bool isPositive: cruiseRadin >= zeroRadin ? true : false

            fillColor: "black"
            strokeColor: "transparent"
            strokeWidth: 0
            startX: cruiseMaskPath.centerX
            startY: cruiseMaskPath.centerY
            PathLine {
                x: cruiseMaskPath.centerX
                y: cruiseMaskPath.centerY + cruiseMaskPath.radius
            }
            PathArc {
                x: cruiseMaskPath.centerX + Math.cos(cruiseMaskPath.cruiseRadin) * cruiseMaskPath.radius
                y: cruiseMaskPath.centerY + Math.sin(cruiseMaskPath.cruiseRadin) * cruiseMaskPath.radius
                radiusX: cruiseMaskPath.centerX
                radiusY: cruiseMaskPath.centerY
                direction: cruiseMaskPath.isPositive? PathArc.Clockwise : PathArc.Counterclockwise
                useLargeArc: cruiseMaskPath.cruiseRadin >= -Math.PI / 2 ? true : false
            }
            PathLine {
                x: cruiseMaskPath.centerX
                y: cruiseMaskPath.centerY
            }
        }
    }

    OpacityMask {
        id: indicatorCruiseCircle
        opacity: (root.cruiseSpeed >= 30) ? 1 : 0.0
        visible: indicatorCruise.visible
        maskSource: cruiseMask
        source: cruiseSource
        anchors.fill: cruiseSource
        Behavior on opacity {
            NumberAnimation { easing.type: Easing.OutCubic; duration: 500 }
        }
    }

    Image {
        id: indicatorCruiseBg
        opacity: (root.cruiseSpeed >= 30) ? 1 : 0.0
        visible: indicatorCruise.visible
        x: Sizes.dp(237) - indicatorCruise.contentWidth / 2
        y: indicatorCruise.y + Sizes.dp(4)
        width: Sizes.dp(35)
        height: Sizes.dp(31)
        source: Utils.localAsset("ic-acc", Style.theme)
        Behavior on opacity {
            NumberAnimation { easing.type: Easing.OutCubic; duration: 270 }
        }
        Behavior on x {
            NumberAnimation { easing.type: Easing.OutCubic; duration: 270 }
        }
    }

    Label {
        id: indicatorCruise
        opacity: (root.cruiseSpeed >= 30) ? Style.opacityHigh : 0.0
        anchors.horizontalCenter: parent.horizontalCenter
        y: Sizes.dp(466)
        text:  Math.round(cruiseSpeed)
        font.weight: Font.Light
        font.pixelSize: Sizes.dp(34)
        Behavior on opacity {
            NumberAnimation { easing.type: Easing.OutCubic; duration: 500 }
        }
    }

    Repeater{
        id: graduationNumber
        anchors.centerIn: parent
        width: Sizes.dp(520)
        height: width
        opacity: Style.opacityMedium

        //size and layout
        readonly property real radius: width / 2 - Sizes.dp(55)
        readonly property real centerX: width / 2
        readonly property real centerY: height / 2

        model: [0, 20, 40, 60, 80, 100, 120, 140, 200]
        delegate: Label {
            readonly property int angle: d.speed2Angle(modelData)
            readonly property real radin: angle / 180 * Math.PI

            text: modelData
            x: graduationNumber.centerX + Math.cos(radin) * graduationNumber.radius
            y: graduationNumber.centerY + Math.sin(radin) * graduationNumber.radius
            visible: (modelData < graduation.maxDrawValue) ? true : false

            opacity: graduationNumber.opacity
            font.weight: Font.Light
            font.pixelSize: Sizes.dp(22)
        }
    }

    Canvas {
        id: graduation
        anchors.centerIn: parent
        width: Sizes.dp(520)
        height: width
        renderTarget: Canvas.FramebufferObject

        readonly property real radius: graduation.width / 2
        readonly property real centerX: graduation.width / 2
        readonly property real centerY: graduation.height / 2
        readonly property real scaleLineLong: Sizes.dp(8)
        readonly property real scaleLineShort: Sizes.dp(4)
        readonly property real scaleLineWidth: Sizes.dp(2)
        readonly property real speedLimitLineWidth: Sizes.dp(4)
        readonly property real scaleLineBlank: Sizes.dp(8)
        readonly property real scaleWordBlank: Sizes.dp(40)
        //for startup animation
        property int maxDrawValue: 260
        onMaxDrawValueChanged: {
            requestPaint();
        }
        Component.onCompleted: {
            requestPaint();
        }
        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0,0,graduation.width,graduation.height);
            ctx.globalCompositeOperation = "source-over";
            drawScalesLine(ctx);
        }
        function drawScalesLine(ctx) {
            ctx.save();

            var radin, i;
            var majorTicks = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 200, 260]
            var minorTicks = [155, 170, 185, 215, 230, 245]

            ctx.beginPath();
            ctx.lineWidth = scaleLineWidth;
            ctx.strokeStyle = "#916E51";
            ctx.globalAlpha = 1;
            for (i in majorTicks) {
                if (majorTicks[i] <= maxDrawValue) {
                    radin = d.speed2Angle(majorTicks[i]) / 180 * Math.PI;
                    ctx.moveTo(
                            centerX + Math.cos(radin) * (radius - scaleLineBlank - scaleLineLong),
                            centerY + Math.sin(radin) * (radius - scaleLineBlank - scaleLineLong));
                    ctx.lineTo(
                            centerX + Math.cos(radin) * (radius - scaleLineBlank),
                            centerY + Math.sin(radin) * (radius - scaleLineBlank));
                }
            }
            ctx.stroke();

            ctx.beginPath();
            ctx.lineWidth = scaleLineWidth;
            ctx.strokeStyle = "#916E51";
            ctx.globalAlpha = 0.4;
            for (i in minorTicks) {
                if (minorTicks[i] <= maxDrawValue) {
                    radin = d.speed2Angle(minorTicks[i]) / 180 * Math.PI;
                    ctx.moveTo(
                            centerX + Math.cos(radin) * (radius - scaleLineBlank - scaleLineShort),
                            centerY + Math.sin(radin) * (radius - scaleLineBlank - scaleLineShort));
                    ctx.lineTo(
                            centerX + Math.cos(radin) * (radius - scaleLineBlank),
                            centerY + Math.sin(radin) * (radius - scaleLineBlank));
                }
            }
            ctx.stroke();
            ctx.restore();
        }
    }

    Shape {
        id: graduationSpdLimit
        anchors.fill: graduation
        visible: speedLimit >= 30 ? true : false
        opacity: graduation.opacity

        ShapePath {
            id: spdLimitPath
            readonly property real spdLimitRadin: d.speed2Angle(speedLimit) / 180 * Math.PI

            strokeColor: "white"
            strokeWidth: graduation.speedLimitLineWidth
            startX: graduation.centerX + Math.cos(spdLimitPath.spdLimitRadin) * (graduation.radius - graduation.scaleLineBlank - graduation.scaleLineLong)
            startY: graduation.centerY + Math.sin(spdLimitPath.spdLimitRadin) * (graduation.radius - graduation.scaleLineBlank - graduation.scaleLineLong)

            PathLine {
                x: graduation.centerX + Math.cos(spdLimitPath.spdLimitRadin) * (graduation.radius - graduation.scaleLineBlank)
                y: graduation.centerY + Math.sin(spdLimitPath.spdLimitRadin) * (graduation.radius - graduation.scaleLineBlank)

            }
        }

    }
}
