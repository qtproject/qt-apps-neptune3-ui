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

import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: root
    width: 560
    height: width

    //public
    property int speed
    property int speedLimit
    property int cruiseSpeed

    //private
    Item {
        id: d
        property real scaleRatio: Math.min(parent.width / 560, parent.height/ 560)
    }

    Component.onCompleted: {
        scaleCanvas.requestPaint();
        cruiseMask.requestPaint();
    }
    onSpeedLimitChanged: {
        scaleCanvas.requestPaint();
    }
    onSpeedChanged: {
        dialFrame.highLightAng = speed2Angle(speed);
    }
    onCruiseSpeedChanged: {
        cruiseMask.requestPaint();
    }

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

    DialFrame {
        id: dialFrame
        anchors.centerIn: parent
        width: 560 * d.scaleRatio
        height: 560 * d.scaleRatio
        minAng: -240
        maxAng: 30
        zeroAng: -240
    }
    Text {
        x: 257 * d.scaleRatio
        y: 218 * d.scaleRatio
        width: 40 * d.scaleRatio
        text: speed
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignHCenter
        font.family: "Open Sans SemiBold"
        color: "black"
        opacity: 0.94
        font.pixelSize: 80 * d.scaleRatio
    }
    Text {
        x: 260 * d.scaleRatio
        y: 325 * d.scaleRatio
        text: "km/h"
        font.family: "Open Sans Light"
        color: "black"
        opacity: 0.4
        font.pixelSize: 18 * d.scaleRatio
    }
    Image {
        id: spdLimit
        x: 330* d.scaleRatio
        y: 342 * d.scaleRatio
        width: 140 * d.scaleRatio
        height: 140 * d.scaleRatio
        source: "./img/speed-limit-badge.png"
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: speedLimit
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
        height: 370 * d.scaleRatio
        anchors.centerIn: parent
        Image {
            id: cruiseShadow
            width: 370 * d.scaleRatio
            height: 370 * d.scaleRatio
            anchors.centerIn: parent
            source: "./img/dial-cruise-circle-shadow.png"
        }
       Image {
            id: cruiseCircle
            width: 330 * d.scaleRatio
            height: 330 * d.scaleRatio
            anchors.centerIn: parent
            source: "./img/dial-cruise-circle.png"
        }
    }
    Canvas {
        id: cruiseMask
        anchors.centerIn: parent
        width: 370 * d.scaleRatio
        height: 370 * d.scaleRatio
        renderTarget: Canvas.FramebufferObject
        visible: false

        property real radius: cruiseMask.width / 2
        property real centerX: cruiseMask.width / 2
        property real centerY: cruiseMask.height / 2

        property real maxRadin: (dialFrame.maxAng > 90) ?
                        (Math.PI / 2) : (dialFrame.maxAng / 180 * Math.PI)
        property real minRadin: (dialFrame.minAng < -270) ?
                        (-Math.PI * 3 / 2) : (dialFrame.minAng / 180 * Math.PI)
        property real zeroRadin: (dialFrame.zeroAng > dialFrame.maxAng || dialFrame.zeroAng < dialFrame.minAng) ?
                        minRadin : (dialFrame.zeroAng / 180 * Math.PI)

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, cruiseMask.width, cruiseMask.height);
            ctx.globalCompositeOperation = "source-over";
            ctx.lineWidth = 0;
            ctx.fillStyle = "black";

            var radin = speed2Angle(cruiseSpeed) / 180 * Math.PI
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
        id: cruise
        visible: true
        maskSource: cruiseMask
        source: cruiseSource
        anchors.fill: cruiseMask
    }
    Image {
        id: cruiseImg
        x: 237 * d.scaleRatio
        y: 472 * d.scaleRatio
        width: 35 * d.scaleRatio
        height: 31 * d.scaleRatio
        source: "./img/ic-acc.png"
        visible: true
    }
    Text {
        x: 280 * d.scaleRatio
        y: 466 * d.scaleRatio
        text: cruiseSpeed
        font.family: "open sans"
        color: "black"
        opacity: 0.94
        font.pixelSize: 34 * d.scaleRatio
        visible: true
    }
    Canvas {
        id: scaleCanvas
        anchors.centerIn: parent
        width: 520 * d.scaleRatio
        height: 520 * d.scaleRatio
        renderTarget: Canvas.FramebufferObject

        property real radius: scaleCanvas.width / 2
        property real centerX: scaleCanvas.width / 2
        property real centerY: scaleCanvas.height / 2
        property real scaleLineLong: 8 * d.scaleRatio
        property real scaleLineShort: 4 * d.scaleRatio
        property real scaleLineWidth: 2 * d.scaleRatio
        property real speedLimitLineWidth: 4 * d.scaleRatio;
        property real scaleLineBlank: 8 * d.scaleRatio
        property real scaleWordBlank: 40 * d.scaleRatio

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0,0,scaleCanvas.width,scaleCanvas.height);
            ctx.globalCompositeOperation = "source-over";
            drawScalesLine(ctx);
            drawSpeedLimit(ctx);
            drawScalesWord(ctx);
        }
        function drawScalesLine(ctx) {
            ctx.save();

            ctx.beginPath();
            ctx.lineWidth = scaleLineWidth;
            ctx.strokeStyle = "#916E51";

            var radin;
            for (var i = 0; i<=140; i+=10) {
                radin = speed2Angle(i) / 180 * Math.PI
                ctx.moveTo(
                        centerX + Math.cos(radin) * (radius-scaleLineBlank - scaleLineLong),
                        centerY + Math.sin(radin) * (radius-scaleLineBlank-scaleLineLong));
                ctx.lineTo(
                        centerX + Math.cos(radin)*(radius - scaleLineBlank),
                        centerY + Math.sin(radin) * (radius-scaleLineBlank));
                ctx.stroke();
            }
            for (i = 155; i <= 260; i += 15) {
                radin = speed2Angle(i) / 180 * Math.PI
                if (i == 200 || i == 260) {
                    ctx.globalAlpha = 1.0;
                    ctx.moveTo(
                        centerX + Math.cos(radin) * (radius - scaleLineBlank - scaleLineLong),
                        centerY + Math.sin(radin) * (radius - scaleLineBlank - scaleLineLong));
                    ctx.lineTo(
                        centerX + Math.cos(radin) * (radius - scaleLineBlank),
                        centerY + Math.sin(radin) * (radius - scaleLineBlank));
                } else {
                    ctx.globalAlpha = 0.4;
                    ctx.moveTo(
                        centerX + Math.cos(radin) * (radius - scaleLineBlank - scaleLineShort),
                        centerY + Math.sin(radin) * (radius - scaleLineBlank - scaleLineShort));
                    ctx.lineTo(
                        centerX + Math.cos(radin) * (radius - scaleLineBlank),
                        centerY + Math.sin(radin) * (radius - scaleLineBlank));
                }
                ctx.stroke();
            }
            ctx.restore();
        }

        function drawSpeedLimit(ctx) {
            ctx.save();
            ctx.beginPath();
            ctx.globalAlpha = 1;
            ctx.lineWidth = speedLimitLineWidth;
            ctx.strokeStyle = "white"

            var radin = speed2Angle(speedLimit) / 180 * Math.PI;
            ctx.moveTo(
                        centerX + Math.cos(radin) * (radius-scaleLineBlank - scaleLineLong),
                        centerY + Math.sin(radin) * (radius - scaleLineBlank - scaleLineLong));
            ctx.lineTo(
                        centerX + Math.cos(radin) * (radius - scaleLineBlank),
                        centerY + Math.sin(radin) * (radius - scaleLineBlank));
            ctx.stroke();
            ctx.restore();
        }

        function drawScalesWord(ctx) {
            ctx.save();
            ctx.globalAlpha = 0.6;
            ctx.font = 22*d.scaleRatio + "px Open Sans Light"
            ctx.fillStyle = "black";
            ctx.textBaseline = "middle";
            ctx.textAlign = "center";
            var radin;
            for (var i = 0; i <= 140; i += 20) {
                radin = speed2Angle(i) / 180 * Math.PI;
                ctx.fillText(
                        i,
                        centerX + Math.cos(radin) * (radius - scaleWordBlank),
                        centerY + Math.sin(radin) * (radius - scaleWordBlank));
            }
            radin = speed2Angle(200) / 180 * Math.PI;
            ctx.fillText(
                        200,
                        centerX + Math.cos(radin) * (radius - scaleWordBlank),
                        centerY + Math.sin(radin) * (radius - scaleWordBlank));
            ctx.restore();
        }
    }
}
