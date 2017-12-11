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

    Connections {
        target: root
        onHighLightAngChanged: {
            highLightMask.requestPaint();
        }
    }

    //public
    property real highLightAng: zeroAng
    property real zeroAng: minAng
    property real maxAng: 90
    property real minAng: -270

    //public functions
    function state2begin() {
        if (state === "stopped")
            state = "normal"
    }
    function state2Navigation() {
        if (state === "normal")
            state = "navi"
    }
    function state2Normal() {
        if (state === "navi")
            state = "normal"
    }
    function state2end() {
        if (state === "normal" || state === "navi"){
            state = "stopped"
        }
    }

    //private
    Item {
        id: d
        property real scaleRatio: Math.min ( parent.width / 560, parent.height / 560 )
    }

    //states and transitions
    state: "stopped"
    states: [
        State {
            name: "stopped"
            PropertyChanges { target: highLightOut; opacity: 0 }
            PropertyChanges { target: highLightIn; opacity: 0 }
            PropertyChanges { target: innerCircle; opacity: 0; width: 100 * d.scaleRatio }
            PropertyChanges { target: innerCircleShadow; opacity: 0; width: 112 * d.scaleRatio }
            PropertyChanges { target: outBg; opacity: 0; width: 140 * d.scaleRatio }
            PropertyChanges { target: outEdge; opacity: 0; width: 140 * d.scaleRatio }
            PropertyChanges { target: outShadow; opacity: 0; width: 150 * d.scaleRatio }
        },
        State {
            name: "normal"
            PropertyChanges { target: highLightOut; opacity: 1 }
            PropertyChanges { target: highLightIn; opacity: 1 }
            PropertyChanges { target: innerCircle; opacity: 1; width: 310 * d.scaleRatio }
            PropertyChanges { target: innerCircleShadow; opacity: 1; width: 350 * d.scaleRatio }
            PropertyChanges { target: outBg; opacity: 1; width: 520 * d.scaleRatio }
            PropertyChanges { target: outEdge; opacity: 1; width: 520 * d.scaleRatio }
            PropertyChanges { target: outShadow; opacity: 1; width: 560 * d.scaleRatio }
        },
        State {
            name: "navi"
            PropertyChanges { target: highLightOut; opacity: 1 }
            PropertyChanges { target: highLightIn; opacity: 1 }
            PropertyChanges { target: innerCircle; opacity: 1; width: 310 * d.scaleRatio }
            PropertyChanges { target: innerCircleShadow; opacity: 1; width: 350 * d.scaleRatio }
            PropertyChanges { target: outBg; opacity: 1; width: 340 * d.scaleRatio }
            PropertyChanges { target: outEdge; opacity: 1; width: 340 * d.scaleRatio }
            PropertyChanges { target: outShadow; opacity: 1; width: 366.15 * d.scaleRatio }
        }
    ]

    transitions: [
        Transition {
            from: "stopped"
            to: "normal"
            reversible: true
            SequentialAnimation{
                ParallelAnimation {
                    PropertyAnimation { targets: [innerCircle, innerCircleShadow]; properties: "opacity, width"; duration: 270 }
                    SequentialAnimation {
                        PauseAnimation { duration: 70 }
                        PropertyAnimation { targets: [outBg, outEdge, outShadow]; properties: "opacity, width"; duration: 270 }
                    }
                }
                PauseAnimation { duration: 270 }
                PropertyAnimation { target: highLightOut; property: "opacity"; duration: 130 }
                //wait outside components to hide
                PauseAnimation { duration: 2000 }
            }
        },
        Transition {
            from: "normal"
            to: "navi"
            reversible: true
            SequentialAnimation{
                //wait parent components to shrink
                PauseAnimation { duration: 500 }
                ParallelAnimation {
                    PropertyAnimation { targets: [innerCircle, innerCircleShadow]; properties: "opacity, width"; duration: 270 }
                    SequentialAnimation {
                        PauseAnimation { duration: 70 }
                        PropertyAnimation { targets: [outBg, outEdge, outShadow]; properties: "opacity, width"; duration: 270 }
                    }
                }
            }
        },
        Transition {
            from: "navi"
            to: "stopped"
            reversible: true
            SequentialAnimation{
                //wait outside components to hide
                PauseAnimation { duration: 1000 }
                ParallelAnimation {
                    PropertyAnimation { targets: [innerCircle, innerCircleShadow]; properties: "opacity, width"; duration: 270 }
                    SequentialAnimation {
                        PauseAnimation { duration: 70 }
                        PropertyAnimation { targets: [outBg, outEdge, outShadow]; properties: "opacity, width"; duration: 270 }
                    }
                }
                PauseAnimation { duration: 270 }
                PropertyAnimation { target: highLightOut; property: "opacity"; duration: 130 }
            }
        }
    ]

    //visual components
    Image {
        id: outBg
        anchors.centerIn: parent
        width: 520 * d.scaleRatio
        height: width
        source: "./img/dial-outer-circle-bg.png"
    }

    Image {
        id: outEdge
        z: 1
        anchors.centerIn: parent
        width: 520 * d.scaleRatio
        height: width
        source: "./img/dial-outer-circle-edge.png"
    }

    Image {
        id: outShadow
        z: 1
        anchors.centerIn: parent
        width: 560 * d.scaleRatio
        height: width
        source: "./img/dial-outer-circle-shadow.png"
    }

    Image {
        id: highLightSource
        anchors.fill: outBg
        source: "./img/dial_highlight.png"
        visible: false
    }

    Canvas {
        id: highLightMask
        anchors.fill: highLightSource
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
        anchors.fill: highLightSource
    }

    Image {
        id: highLightOutMask
        visible: false
        anchors.fill: highLightSource
        source: "./img/highlight-mask.png"
    }

    OpacityMask {
        id: highLightOut
        visible: true
        maskSource: highLightOutMask
        source: highLight
        anchors.fill: highLightSource
    }

    Image {
        id: highLightInMask
        visible: false
        width: innerCircle.width// + 2
        height: width
        anchors.centerIn: innerCircle
        source: "./img/highlight-mask-inner.png"
    }

    FastBlur {
        id: highLightInBlur
        visible: false
        source: highLight
        anchors.fill: highLight
        radius: 60
        cached: true
    }

    OpacityMask {
        id: highLightIn
        visible: true
        maskSource: highLightInMask
        source: highLightInBlur
        anchors.fill: highLightInMask
    }

    Image {
        id: innerCircle
        visible: true
        width: 310 * d.scaleRatio
        height: width
        anchors.centerIn: parent
        source: "./img/dial-inner-circle.png"
    }

    Image {
        id: innerCircleShadow
        visible: true
        width: 350 * d.scaleRatio
        height: width
        anchors.centerIn: parent
        source: "./img/dial-inner-circle_shadow.png"
    }
}
