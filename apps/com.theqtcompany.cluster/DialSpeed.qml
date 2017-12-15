/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Triton Cluster UI.
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
import QtGraphicalEffects 1.0

Item {
    id: root
    width: 560
    height: width

    //public
    property real speed
    property real speedLimit
    property real cruiseSpeed

    //private
    Item {
        id: d
        readonly property real scaleRatio: Math.min(parent.width / 560, parent.height/ 560)
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
            PropertyChanges { target: indicatorCruiseCircle; opacity: 0 }
            PropertyChanges { target: indicatorCruiseBg; opacity: 0; x: 237 * d.scaleRatio; y: 472 * d.scaleRatio }
            PropertyChanges { target: indicatorCruise; opacity: 0; x: 285 * d.scaleRatio; y: 466 * d.scaleRatio }
        },
        State {
            name: "normal"
            PropertyChanges { target: graduation; opacity: 1; maxDrawValue: 265 }
            PropertyChanges { target: graduationNumber; opacity: 0.6 }
            PropertyChanges { target: indicatorSpeed; opacity: 0.94 }
            PropertyChanges { target: signKMH; opacity: 0.4 }
            PropertyChanges { target: indicatorSpdLimit; opacity: 1 }
            PropertyChanges { target: indicatorCruiseCircle; opacity: 1 }
            PropertyChanges { target: indicatorCruiseBg; opacity: 1; x: 237 * d.scaleRatio; y: 472 * d.scaleRatio }
            PropertyChanges { target: indicatorCruise; opacity: 0.94; x: 285 * d.scaleRatio; y: 466 * d.scaleRatio }
        },
        State {
            name: "navi"
            PropertyChanges { target: graduation; opacity: 0; maxDrawValue: 265 }
            PropertyChanges { target: graduationNumber; opacity: 0 }
            PropertyChanges { target: indicatorSpeed; opacity: 0.94 }
            PropertyChanges { target: signKMH; opacity: 0.4 }
            PropertyChanges { target: indicatorSpdLimit; opacity: 1 }
            PropertyChanges { target: indicatorCruiseCircle; opacity: 0 }
            PropertyChanges { target: indicatorCruiseBg; opacity: 1; x: 237 * d.scaleRatio; y: 380 * d.scaleRatio }
            PropertyChanges { target: indicatorCruise; opacity: 0.94; x: 285 * d.scaleRatio; y: 374 * d.scaleRatio }
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
                PropertyAnimation {
                    targets: [indicatorSpeed, signKMH, indicatorSpdLimit, indicatorCruiseCircle, indicatorCruiseBg, indicatorCruise]
                    properties: "opacity, x, y"
                    duration: 140
                }
                //test the highLight (1080ms)
                PropertyAnimation { target: root; properties: "speed, speedLimit, cruiseSpeed"; from: 0; to: 260; duration: 540 }
                PropertyAnimation { target: root; properties: "speed, speedLimit, cruiseSpeed"; from: 260; to: 0; duration: 540 }
            }
        },
        Transition {
            from: "normal"
            to: "stopped"
            reversible: false
            SequentialAnimation{
                //fade out (390ms)
                PropertyAnimation {
                    targets: [indicatorSpeed, signKMH, indicatorSpdLimit, indicatorCruiseCircle, indicatorCruiseBg, indicatorCruise]
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
                //fade out (320ms)
                PropertyAnimation { targets: [graduation, graduationNumber]; property: "opacity"; duration: 130 }
                PropertyAnimation {
                    targets: [indicatorSpeed, signKMH, indicatorSpdLimit, indicatorCruiseCircle, indicatorCruiseBg, indicatorCruise]
                    properties: "opacity"
                    to: 0
                    duration: 130
                }
                PauseAnimation { duration: 60 }
                //wait DialFrame to shrink(320ms)
                PropertyAnimation {
                    targets: [indicatorSpeed, signKMH, indicatorSpdLimit, indicatorCruiseCircle, indicatorCruiseBg, indicatorCruise]
                    properties: "x, y"
                    duration: 320
                }
                //fade in (130ms)
                PropertyAnimation {
                    targets: [indicatorSpeed, signKMH, indicatorSpdLimit, indicatorCruiseCircle, indicatorCruiseBg, indicatorCruise]
                    properties: "opacity"
                    duration: 130
                }
            }
        },
        Transition {
            from: "navi"
            to: "normal"
            reversible: false
            SequentialAnimation{
                //fade out (320ms)
                PropertyAnimation {
                    targets: [indicatorSpeed, signKMH, indicatorSpdLimit, indicatorCruiseCircle, indicatorCruiseBg, indicatorCruise]
                    properties: "opacity"
                    to: 0
                    duration: 130
                }
                PauseAnimation { duration: 190 }
                //wait DialFrame to expand(320ms)
                PropertyAnimation {
                    targets: [indicatorSpeed, signKMH, indicatorSpdLimit, indicatorCruiseCircle, indicatorCruiseBg, indicatorCruise]
                    properties: "x, y"
                    duration: 320
                }
                //fade in (260ms)
                PropertyAnimation { targets: [graduation, graduationNumber]; property: "opacity"; duration: 130 }
                PropertyAnimation {
                    targets: [indicatorSpeed, signKMH, indicatorSpdLimit, indicatorCruiseCircle, indicatorCruiseBg, indicatorCruise]
                    properties: "opacity"
                    duration: 130
                }
            }
        },
        Transition {
            from: "navi"
            to: "stopped"
            SequentialAnimation{
                //fade out (640ms)
                PropertyAnimation { targets: [graduation, graduationNumber]; property: "opacity"; duration: 130 }
                PropertyAnimation {
                    targets: [indicatorSpeed, signKMH, indicatorSpdLimit, indicatorCruiseCircle, indicatorCruiseBg, indicatorCruise]
                    properties: "opacity"
                    duration: 100
                }
                PropertyAnimation {
                    targets: [indicatorSpeed, signKMH, indicatorSpdLimit, indicatorCruiseCircle, indicatorCruiseBg, indicatorCruise]
                    properties: "x, y"
                    duration: 100
                }
            }
        }
    ]

    Behavior on speed {
        NumberAnimation { easing.type: Easing.OutCubic; duration: 2000 }
    }

    Behavior on speedLimit {
        NumberAnimation { easing.type: Easing.OutCubic; duration: 2000 }
    }

    Behavior on cruiseSpeed {
        NumberAnimation { easing.type: Easing.OutCubic; duration: 2000 }
    }

    onSpeedLimitChanged: {
        graduation.requestPaint();
    }

    onSpeedChanged: {
        dialFrame.highLightAng = d.speed2Angle(speed);
    }

    onCruiseSpeedChanged: {
        cruiseMask.requestPaint();
    }

    //visual components
    DialFrame {
        id: dialFrame
        anchors.centerIn: parent
        width: 560 * d.scaleRatio
        height: width
        state: parent.state
        minAng: -240
        maxAng: 30
        zeroAng: -240
    }

    Text {
        id: indicatorSpeed
        x: 257 * d.scaleRatio
        y: 218 * d.scaleRatio
        width: 40 * d.scaleRatio
        text: Math.round(speed)
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignHCenter
        font.family: "Open Sans SemiBold"
        color: "black"
        opacity: 0.94
        font.pixelSize: 80 * d.scaleRatio
    }

    Text {
        id: signKMH
        x: 260 * d.scaleRatio
        y: 325 * d.scaleRatio
        text: qsTr("km/h")
        font.family: "Open Sans Light"
        color: "black"
        opacity: 0.4
        font.pixelSize: 18 * d.scaleRatio
    }

    Image {
        id: indicatorSpdLimit
        x: 330* d.scaleRatio
        y: 342 * d.scaleRatio
        width: 140 * d.scaleRatio
        height: 140 * d.scaleRatio
        source: "./img/speed-limit-badge.png"
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: Math.round(speedLimit)
            font.family: "open sans"
            color: "black"
            opacity: 0.94
            font.pixelSize: 34 * d.scaleRatio
        }
    }

    Rectangle {
        id: cruiseSource
        visible: false
        color: "transparent"
        width: 370 * d.scaleRatio
        height: width
        anchors.centerIn: parent
        Image {
            id: cruiseShadow
            width: 370 * d.scaleRatio
            height: width
            anchors.centerIn: parent
            source: "./img/dial-cruise-circle-shadow.png"
        }
        Image {
            id: cruiseCircle
            width: 330 * d.scaleRatio
            height: width
            anchors.centerIn: parent
            source: "./img/dial-cruise-circle.png"
        }
    }

    Canvas {
        id: cruiseMask
        anchors.centerIn: parent
        width: 370 * d.scaleRatio
        height: width
        renderTarget: Canvas.Image
        visible: false

        readonly property real radius: cruiseMask.width / 2
        readonly property real centerX: cruiseMask.width / 2
        readonly property real centerY: cruiseMask.height / 2

        readonly property real maxRadin: (dialFrame.maxAng > 90) ?
                        (Math.PI / 2) : (dialFrame.maxAng / 180 * Math.PI)
        readonly property real minRadin: (dialFrame.minAng < -270) ?
                        (-Math.PI * 3 / 2) : (dialFrame.minAng / 180 * Math.PI)
        readonly property real zeroRadin: (dialFrame.zeroAng > dialFrame.maxAng || dialFrame.zeroAng < dialFrame.minAng) ?
                        minRadin : (dialFrame.zeroAng / 180 * Math.PI)

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, cruiseMask.width, cruiseMask.height);
            ctx.globalCompositeOperation = "source-over";
            ctx.lineWidth = 0;
            ctx.fillStyle = "black";

            var radin = d.speed2Angle(cruiseSpeed) / 180 * Math.PI
            var isPositive = radin >= zeroRadin ? true : false
            var sixOClockRadin = -270 / 180 * Math.PI

            ctx.beginPath();
            ctx.moveTo(centerX, centerY); //center of the circule
            ctx.lineTo(centerX, centerY + radius); //start line
            ctx.arc(centerX, centerY, radius, sixOClockRadin, radin, !isPositive);//arc line
            ctx.closePath();
            ctx.fill();
        }
    }

    OpacityMask {
        id: indicatorCruiseCircle
        visible: true
        maskSource: cruiseMask
        source: cruiseSource
        anchors.fill: cruiseMask
    }

    Image {
        id: indicatorCruiseBg
        visible: true
        x: 237 * d.scaleRatio
        y: 472 * d.scaleRatio
        width: 35 * d.scaleRatio
        height: 31 * d.scaleRatio
        source: "./img/ic-acc.png"
    }

    Text {
        id: indicatorCruise
        visible: true
        opacity: 0.94
        x: 280 * d.scaleRatio
        y: 466 * d.scaleRatio
        text:  Math.round(cruiseSpeed)
        font.family: "open sans"
        color: "black"
        font.pixelSize: 34 * d.scaleRatio
    }

    Repeater{
        id: graduationNumber
        anchors.centerIn: parent
        width: 520 * d.scaleRatio
        height: width
        opacity: 0.6

        //size and layout
        readonly property real radius: width / 2 - 55 * d.scaleRatio
        readonly property real centerX: width / 2
        readonly property real centerY: height / 2

        model: [0, 20, 40, 60, 80, 100, 120, 140, 200]
        delegate: Text {
            readonly property int angle: d.speed2Angle(modelData)
            readonly property real radin: angle / 180 * Math.PI

            text: modelData
            x: graduationNumber.centerX + Math.cos(radin) * graduationNumber.radius
            y: graduationNumber.centerY + Math.sin(radin) * graduationNumber.radius
            visible: (modelData < graduation.maxDrawValue) ? true : false

            color: "black"
            opacity: graduationNumber.opacity
            font.family: "Open Sans"
            font.weight: Font.Light
            font.pixelSize: 22 * d.scaleRatio
        }
    }

    Canvas {
        id: graduation
        anchors.centerIn: parent
        width: 520 * d.scaleRatio
        height: width
        renderTarget: Canvas.FramebufferObject

        readonly property real radius: graduation.width / 2
        readonly property real centerX: graduation.width / 2
        readonly property real centerY: graduation.height / 2
        readonly property real scaleLineLong: 8 * d.scaleRatio
        readonly property real scaleLineShort: 4 * d.scaleRatio
        readonly property real scaleLineWidth: 2 * d.scaleRatio
        readonly property real speedLimitLineWidth: 4 * d.scaleRatio;
        readonly property real scaleLineBlank: 8 * d.scaleRatio
        readonly property real scaleWordBlank: 40 * d.scaleRatio

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
            drawSpeedLimit(ctx);
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

        function drawSpeedLimit(ctx) {
            ctx.save();
            ctx.beginPath();
            ctx.lineWidth = speedLimitLineWidth;
            ctx.strokeStyle = "white"

            if (speedLimit <= maxDrawValue) {
                var radin = d.speed2Angle(speedLimit) / 180 * Math.PI;
                ctx.moveTo(
                            centerX + Math.cos(radin) * (radius-scaleLineBlank - scaleLineLong),
                            centerY + Math.sin(radin) * (radius - scaleLineBlank - scaleLineLong));
                ctx.lineTo(
                            centerX + Math.cos(radin) * (radius - scaleLineBlank),
                            centerY + Math.sin(radin) * (radius - scaleLineBlank));
            }
            ctx.stroke();
            ctx.restore();
        }
    }
}
