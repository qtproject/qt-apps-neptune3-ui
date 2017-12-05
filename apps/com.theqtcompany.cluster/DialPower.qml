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

Item {
    id: root
    width: 560
    height: width

    //public
    property int ePower
    property string drivetrain

    //private
    Item {
        id: d
        property real scaleRatio: Math.min(parent.width / 560, parent.height / 560 )
    }

    Component.onCompleted: {
        scaleCanvas.requestPaint();
    }

    function power2Angle(power) {
        if (power < -25) {
            return -210;
        } else if (power <= 0) {
            //-25 to 0 %
            //map to -210degree to -180degree
            return ((power + 25) / 25 * 30 - 210);
        } else if (power <= 100) {
            //0 to 100 %
            //map to -180degree to 0degree
            return ((power) / 100 * 180 - 180);
        } else {
            return 0;
        }
    }

    onEPowerChanged: {
         dialFrame.highLightAng = power2Angle(ePower);
    }

    DialFrame {
        id: dialFrame
        anchors.centerIn: parent
        width: 560 * d.scaleRatio
        height: 560 * d.scaleRatio
        minAng: -210
        maxAng: 0
        zeroAng: -180
    }

    Image {
        x: 31 * d.scaleRatio
        y: 107 * d.scaleRatio
        width: 71 * d.scaleRatio
        height: 294 * d.scaleRatio
        source: "./img/dial-energy-areas.png"
    }

    Text {
        x: 260 * d.scaleRatio
        y: 165 * d.scaleRatio
        width: 40 * d.scaleRatio
        text: "PRND"
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignHCenter
        font.family: "Open Sans Light"
        color: "black"
        opacity: 0.4
        font.pixelSize: 34 * d.scaleRatio
    }

    Text {
        x: 265 * d.scaleRatio
        y: 222 * d.scaleRatio
        width: 40 * d.scaleRatio
        text: ePower
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignHCenter
        font.family: "Open Sans SemiBold"
        color: "black"
        opacity: 0.94
        font.pixelSize: 80 * d.scaleRatio
    }

    Text {
        x: 248 * d.scaleRatio
        y: 324 * d.scaleRatio
        text: "% power"
        font.family: "Open Sans Light"
        color: "black"
        opacity: 0.4
        font.pixelSize: 18 * d.scaleRatio
    }

    Text {
        x: 272 * d.scaleRatio
        y: 445 * d.scaleRatio
        text: "km"
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignHCenter
        font.family: "Open Sans Light"
        color: "black"
        opacity: 0.4
        font.pixelSize: 18 * d.scaleRatio
    }

    Image {
        x: 176 * d.scaleRatio
        y: 483 * d.scaleRatio
        width: 23 * d.scaleRatio
        height: 14 * d.scaleRatio
        source: "./img/ic-battery.png"
    }

    Text {
        x: 207 * d.scaleRatio
        y: 464 * d.scaleRatio
        text: "184"
        font.family: "open sans"
        color: "black"
        opacity: 0.94
        font.pixelSize: 34 * d.scaleRatio
    }

    Text {
        x: 303 * d.scaleRatio
        y: 464 * d.scaleRatio
        text: "21"
        font.family: "open sans"
        color: "black"
        opacity: 0.94
        font.pixelSize: 34 * d.scaleRatio
    }

    Image {
        x: 353 * d.scaleRatio
        y: 477 * d.scaleRatio
        width: 24 * d.scaleRatio
        height: 21 * d.scaleRatio
        source: "./img/ic-chargingstation.png"
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
        property real scaleLineLength: 8 * d.scaleRatio
        property real scaleLineWidth: 2 * d.scaleRatio
        property real scaleLineBlank: 8 * d.scaleRatio
        property real scaleWordBlank: 42 * d.scaleRatio

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, scaleCanvas.width, scaleCanvas.height);
            ctx.globalCompositeOperation = "source-over";
            drawScalesLine(ctx);
            drawScalesWord(ctx);
        }

        function drawScalesLine(ctx) {
            ctx.save();
            ctx.beginPath();
            ctx.lineWidth = scaleLineWidth;
            ctx.strokeStyle = "#916E51";

            var radin;
            for (var i = -25; i <= 100; i += 25) {
                radin = power2Angle(i) / 180 * Math.PI;
                ctx.moveTo(
                        centerX + Math.cos(radin) * (radius - scaleLineBlank - scaleLineLength),
                        centerY + Math.sin(radin) * (radius - scaleLineBlank - scaleLineLength));
                ctx.lineTo(
                        centerX + Math.cos(radin) * (radius - scaleLineBlank),
                        centerY + Math.sin(radin) * (radius - scaleLineBlank));
            }
            ctx.stroke();
            ctx.restore();
        }

        function drawScalesWord(ctx) {
            ctx.save();
            ctx.globalAlpha = 0.6;
            ctx.font = 22 * d.scaleRatio + "px Open Sans Light";
            ctx.fillStyle = "black";
            ctx.textBaseline = "middle";
            ctx.textAlign = "center";

            var radin;
            for (var i = 0; i <= 100; i += 25) {
                radin = power2Angle(i) / 180 * Math.PI;
                ctx.fillText(
                        i,
                        centerX + Math.cos(radin) * (radius - scaleWordBlank),
                        centerY + Math.sin(radin) * (radius - scaleWordBlank));
            }
            ctx.restore();
        }
    }
}
