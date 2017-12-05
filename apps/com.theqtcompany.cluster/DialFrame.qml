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
import QtQml.StateMachine 1.0

Item {
    id: root
    width: 560
    height: width

    //public
    property real highLightAng: zeroAng
    property real zeroAng: minAng
    property real maxAng: 90
    property real minAng: -270

    //private
    Item {
        id: d
        property real scaleRatio: Math.min ( parent.width / 560, parent.height / 560 )
    }

    Connections {
        target: dialFrame
        onHighLightAngChanged: {
            highLightMask.requestPaint();
        }
    }

    Image {
        id: outBg
        anchors.centerIn: parent
        width: 520 * d.scaleRatio
        height: 520 * d.scaleRatio
        source: "./img/dial-outer-circle-bg.png"
    }

    Image {
        id: outEdge
        anchors.centerIn: parent
        width: 520 * d.scaleRatio
        height: 520 * d.scaleRatio
        source: "./img/dial-outer-circle-edge.png"
    }

    Image {
        id: outShadow
        anchors.centerIn: parent
        width: 560 * d.scaleRatio
        height: 560 * d.scaleRatio
        source: "./img/dial-outer-circle-shadow.png"
    }

    Image {
        id: highLightSource
        anchors.centerIn: parent
        width: 520 * d.scaleRatio
        height: 520 * d.scaleRatio
        source: "./img/dial_highlight.png"
        visible: false
    }

    Canvas {
        id: highLightMask
        anchors.centerIn: parent
        width: 520 * d.scaleRatio
        height: 520 * d.scaleRatio
        renderTarget: Canvas.FramebufferObject
        visible: false

        property real radius: highLightMask.width / 2
        property real centerX: highLightMask.width / 2
        property real centerY: highLightMask.height / 2
        property real maxRadin: (maxAng > 90) ? (Math.PI / 2) : (maxAng / 180 * Math.PI)
        property real minRadin: (minAng < -270) ? (-Math.PI * 3 / 2) : (minAng / 180 * Math.PI)
        property real zeroRadin: (zeroAng > maxAng || zeroAng < minAng) ? minRadin : (zeroAng / 180 * Math.PI)
        property real highLightRadin: (highLightAng < minAng) ?
                        minRadin : (highLightAng > maxAng) ? maxRadin : (highLightAng / 180 * Math.PI)
        property bool isPositive: (highLightRadin >= zeroRadin) ? true : false

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, highLightMask.width, highLightMask.height);
            ctx.globalCompositeOperation = "source-over";
            ctx.lineWidth = 0;
            ctx.fillStyle = "black";
            ctx.beginPath();
            ctx.moveTo(centerX, centerY); //center of the circule
            //start line
            ctx.lineTo(
                        centerX + Math.cos(zeroRadin) * radius,
                        centerY + Math.sin(zeroRadin) * radius); 
            //arc line
            ctx.arc(
                        centerX,
                        centerY,
                        radius,
                        zeroRadin,
                        highLightRadin,
                        !isPositive);
            ctx.closePath();
            ctx.fill();
        }
    }

    OpacityMask {
        id: highLight
        visible: false
        maskSource: highLightMask
        source: highLightSource
        anchors.fill: highLightMask
    }

    Image {
        id: hightLightOutMask
        visible: false
        width: 520 * d.scaleRatio
        height: 520 * d.scaleRatio
        anchors.centerIn: parent
        source: "./img/highlight-mask.png"
    }

    OpacityMask {
        id: highLightOut
        visible: true
        maskSource: hightLightOutMask
        source: highLight
        anchors.fill: hightLightOutMask
    }

    Image {
        id: hightLightInMask
        visible: false
        width: 310 * d.scaleRatio
        height: 310 * d.scaleRatio
        anchors.centerIn: parent
        source: "./img/highlight-mask-inner.png"
    }

    OpacityMask {
        id: highLightIn
        visible: false
        maskSource: hightLightInMask
        source: highLight
        anchors.fill: hightLightInMask
    }

    FastBlur {
        visible: true
        source: highLightIn
        anchors.fill: highLightIn
        radius: 60
    }

    Image {
        id: innerCircleShadow
        width: 350 * d.scaleRatio
        height: 350 * d.scaleRatio
        anchors.centerIn: parent
        source: "./img/dial-inner-circle_shadow.png"
    }

    Image {
        id: innerCircle
        width: 310 * d.scaleRatio
        height: 310 * d.scaleRatio
        anchors.centerIn: parent
        source: "./img/dial-inner-circle.png"
    }
}
