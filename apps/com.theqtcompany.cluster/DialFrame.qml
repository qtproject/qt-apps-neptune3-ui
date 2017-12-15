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
    property real highLightAng: zeroAng
    property real zeroAng: minAng
    property real maxAng: 90
    property real minAng: -270
    property color positiveColor: "#fba054"
    property color negativeColor: "#fba054"

    //private
    Item {
        id: d
        readonly property real scaleRatio: Math.min ( parent.width / 560, parent.height / 560 )

        readonly property real maxRadin: (parent.maxAng > 90) ? (Math.PI / 2) : (parent.maxAng / 180 * Math.PI)
        readonly property real minRadin: (parent.minAng < -270) ? (-Math.PI * 3 / 2) : (parent.minAng / 180 * Math.PI)
        readonly property real zeroRadin: (parent.zeroAng > parent.maxAng || parent.zeroAng < parent.minAng) ?
                                parent.minRadin : (parent.zeroAng / 180 * Math.PI)
        readonly property real highLightRadin: (parent.highLightAng < parent.minAng) ?
                                parent.minRadin : (parent.highLightAng > parent.maxAng) ?
                                              parent.maxRadin : (parent.highLightAng / 180 * Math.PI)
        readonly property bool isPositive: (parent.highLightAng >= parent.zeroAng) ? true : false
        readonly property color fillColor: isPositive ? parent.positiveColor : parent.negativeColor
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
            PropertyChanges { target: outSmallBg; opacity: 0; width: 150 * d.scaleRatio }
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
            PropertyChanges { target: outSmallBg; opacity: 0; width: 560 * d.scaleRatio }
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
            PropertyChanges { target: outSmallBg; opacity: 1; width: 366.15 * d.scaleRatio }
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
                //fade in circles(1280ms)
                ParallelAnimation {
                    PropertyAnimation { targets: [innerCircle, innerCircleShadow]; properties: "opacity"; duration: 1080 }
                    SequentialAnimation {
                        PauseAnimation { duration: 200 }
                        PropertyAnimation { targets: [outBg, outSmallBg, outEdge, outShadow]; properties: "opacity"; duration: 1080 }
                    }
                }
                //expand circles(320ms)
                ParallelAnimation {
                    PropertyAnimation { targets: [innerCircle, innerCircleShadow]; properties: "width"; duration: 270 }
                    SequentialAnimation {
                        PauseAnimation { duration: 50 }
                        PropertyAnimation { targets: [outBg, outSmallBg, outEdge, outShadow]; properties: "width"; duration: 270 }
                    }
                }
                //wait outside components to fade in & fade in the highlights(640ms)
                PauseAnimation { duration: 510 }
                PropertyAnimation { targets: [highLightOut, highLightIn]; property: "opacity"; duration: 130 }
            }
        },
        Transition {
            from: "normal"
            to: "navi"
            reversible: false
            SequentialAnimation{
                //fade out the highlights & wait outside components to fade out(320ms)
                PropertyAnimation { targets: [highLightOut, highLightIn]; property: "opacity"; to: 0; duration: 130 }
                PauseAnimation { duration: 190 }
                //shrink the dialframe (320ms)
                ParallelAnimation {
                    PropertyAnimation { targets: [innerCircle, innerCircleShadow]; properties: "opacity, width"; duration: 270 }
                    SequentialAnimation {
                        PauseAnimation { duration: 50 }
                        PropertyAnimation { targets: [outBg, outEdge, outSmallBg, outShadow]; properties: "opacity, width"; duration: 270 }
                    }
                }
                //wait outside components to fade in & fade in the highlights(320ms)
                PauseAnimation { duration: 190 }
                PropertyAnimation { targets: [highLightOut, highLightIn]; property: "opacity"; to: 1; duration: 130 }
            }
        },
        Transition {
            from: "navi"
            to: "normal"
            reversible: false
            SequentialAnimation{
                //fade out the highlights & wait outside components to fade out(320ms)
                PropertyAnimation { targets: [highLightOut, highLightIn]; property: "opacity"; to: 0; duration: 130 }
                PauseAnimation { duration: 190 }
                //expand the dialframe (320ms)
                ParallelAnimation {
                    PropertyAnimation { targets: [innerCircle, innerCircleShadow]; properties: "opacity, width"; duration: 270 }
                    SequentialAnimation {
                        PauseAnimation { duration: 50 }
                        PropertyAnimation { targets: [outBg, outEdge, outSmallBg, outShadow]; properties: "opacity, width"; duration: 270 }
                    }
                }
                //wait outside components to fade in & fade in the highlights(320ms)
                PauseAnimation { duration: 190 }
                PropertyAnimation { targets: [highLightOut, highLightIn]; property: "opacity"; to: 1; duration: 130 }
            }
        },
        Transition {
            from: "navi"
            to: "stopped"
            reversible: true
            SequentialAnimation{
                PropertyAnimation { targets: [highLightOut, highLightIn]; property: "opacity"; duration: 130 }
                //wait outside components to fade out
                PauseAnimation { duration: 500 }
                ParallelAnimation {
                    PropertyAnimation { targets: [innerCircle, innerCircleShadow]; properties: "opacity, width"; duration: 270 }
                    SequentialAnimation {
                        PauseAnimation { duration: 50 }
                        PropertyAnimation { targets: [outBg, outEdge, outSmallBg, outShadow]; properties: "opacity, width"; duration: 270 }
                    }
                }
            }
        }
    ]

    Connections {
        target: root
        onHighLightAngChanged: {
            highLightOutMask.requestPaint();
            highLightInMask.requestPaint();
        }
        onStateChanged: {
            highLightOutMask.requestPaint();
            highLightInMask.requestPaint();
        }
    }

    Connections {
        target: highLightIn
        onOpacityChanged: {
            if (opacity === 1) {
                highLightInMask.requestPaint();
            }
        }
    }

    Connections {
        target: highLightOut
        onOpacityChanged: {
            if (opacity === 1) {
                highLightOutMask.requestPaint();
            }
        }
    }

    //visual components
    Image {
        id: outSmallBg
        width: 560 * d.scaleRatio
        height: width
        anchors.centerIn: parent
        visible: true
        source: "./img/dial-small-bg.png"
    }

    Image {
        id: outBg
        width: 520 * d.scaleRatio
        height: width
        anchors.centerIn: parent
        visible: true
        source: "./img/dial-outer-circle-bg.png"
    }

    Image {
        id: outEdge
        width: 520 * d.scaleRatio
        height: width
        anchors.centerIn: parent
        z: 1
        visible: true
        source: "./img/dial-outer-circle-edge.png"
    }

    Image {
        id: outShadow
        width: 560 * d.scaleRatio
        height: width
        anchors.centerIn: parent
        z: 1
        visible: true
        source: "./img/dial-outer-circle-shadow.png"
    }

    Rectangle {
        id: highLightOutSource
        anchors.fill: outBg
        anchors.centerIn: parent
        visible: false
        color: d.fillColor
    }

    Canvas {
        id: highLightOutMask
        anchors.fill: highLightOutSource
        renderTarget: Canvas.Image
        visible: false

        readonly property real radiusIn: innerCircle.width / 2
        readonly property real radiusOut: highLightOutMask.width / 2
        readonly property real centerX: highLightOutMask.width / 2
        readonly property real centerY: highLightOutMask.height / 2

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, highLightOutMask.width, highLightOutMask.height);
            ctx.globalCompositeOperation = "source-over";
            ctx.lineWidth = 0;
            ctx.fillStyle = "black";
            ctx.beginPath();
            //start point
            ctx.moveTo(
                        centerX + Math.cos(d.zeroRadin) * radiusIn,
                        centerY + Math.sin(d.zeroRadin) * radiusIn);
            //start line
            ctx.lineTo(
                        centerX + Math.cos(d.zeroRadin) * radiusOut,
                        centerY + Math.sin(d.zeroRadin) * radiusOut);
            //arc to end line
            ctx.arc(
                        centerX,
                        centerY,
                        radiusOut,
                        d.zeroRadin,
                        d.highLightRadin,
                        !d.isPositive);
            //end line
            ctx.lineTo(
                        centerX + Math.cos(d.highLightRadin) * radiusIn,
                        centerY + Math.sin(d.highLightRadin) * radiusIn);
            //arc to start line
            ctx.arc(
                        centerX,
                        centerY,
                        radiusIn,
                        d.highLightRadin,
                        d.zeroRadin,
                        d.isPositive);
            ctx.fill();
        }
    }

    OpacityMask {
        id: highLightOut
        anchors.fill: highLightOutSource
        visible: true
        maskSource: highLightOutMask
        source: highLightOutSource
    }

    RadialGradient {
        id: highLightInSource
        anchors.fill: innerCircle
        visible: false

        gradient: Gradient {
            GradientStop { position: 0;   color: Qt.rgba( d.fillColor.r, d.fillColor.g, d.fillColor.b, 0) }
            GradientStop { position: 0.5; color: Qt.rgba( d.fillColor.r, d.fillColor.g, d.fillColor.b, 0.4) }
            GradientStop { position: 1;   color: Qt.rgba( d.fillColor.r, d.fillColor.g, d.fillColor.b, 1) }
        }
    }

    Canvas {
        id: highLightInMask
        anchors.fill: parent
        visible: false

        renderTarget: Canvas.Image

        readonly property real radius: highLightInMask.width / 2
        readonly property real centerX: highLightInMask.width / 2
        readonly property real centerY: highLightInMask.height / 2

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, highLightInMask.width, highLightInMask.height);
            ctx.globalCompositeOperation = "source-over";
            ctx.lineWidth = 0;
            ctx.fillStyle = "black";
            ctx.beginPath();
            ctx.moveTo(centerX, centerY); //center of the circule
            //start line
            ctx.lineTo(
                        centerX + Math.cos(d.zeroRadin) * radius,
                        centerY + Math.sin(d.zeroRadin) * radius);
            //arc
            ctx.arc(
                        centerX,
                        centerY,
                        radius,
                        d.zeroRadin,
                        d.highLightRadin,
                        !d.isPositive);
            ctx.closePath();
            ctx.fill();
        }
    }

    FastBlur {
        id: highLightInMaskBlur
        anchors.fill: highLightInMask
        visible: false
        source: highLightInMask
        radius: 60
        cached: true
    }

    OpacityMask {
        id: highLightIn
        anchors.fill: highLightInSource
        visible: true
        maskSource: highLightInMaskBlur
        source: highLightInSource
    }

    Image {
        id: innerCircle
        width: 310 * d.scaleRatio
        height: width
        anchors.centerIn: parent
        visible: true
        source: "./img/dial-inner-circle.png"
    }

    Image {
        id: innerCircleShadow
        width: 350 * d.scaleRatio
        height: width
        anchors.centerIn: parent
        visible: true
        source: "./img/dial-inner-circle_shadow.png"
    }
}
