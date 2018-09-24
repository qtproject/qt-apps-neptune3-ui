/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Copyright (C) 2018 Pelagicore AG
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
import QtGraphicalEffects 1.0
import QtQuick.Shapes 1.0

import shared.com.pelagicore.styles.neptune 3.0

Item {
    id: root
    width: 560
    height: width

    //public
    property real highLightAng: zeroAng
    property real zeroAng: minAng
    property real maxAng: 90
    property real minAng: -270
    property color positiveColor: NeptuneStyle.accentColor
    property color negativeColor: NeptuneStyle.accentColor

    //private
    QtObject {
        id: d
        readonly property real scaleRatio: Math.min ( root.width / 560, root.height / 560 )

        readonly property real maxRadin: (root.maxAng > 90) ? (Math.PI / 2) : (root.maxAng / 180 * Math.PI)
        readonly property real minRadin: (root.minAng < -270) ? (-Math.PI * 3 / 2) : (root.minAng / 180 * Math.PI)
        readonly property real zeroRadin: (root.zeroAng > root.maxAng || root.zeroAng < root.minAng) ?
                                root.minRadin : (root.zeroAng / 180 * Math.PI)
        readonly property real highLightRadin: (root.highLightAng < root.minAng) ?
                                root.minRadin : (root.highLightAng > root.maxAng) ?
                                              root.maxRadin : (root.highLightAng / 180 * Math.PI)
        readonly property bool isPositive: (root.highLightAng >= root.zeroAng) ? true : false
        readonly property color fillColor: isPositive ? root.positiveColor : root.negativeColor
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
                //wait outside components to fade out(160ms)
                PauseAnimation { duration: 160 }
                //shrink the dialframe (160ms)
                ParallelAnimation {
                    PropertyAnimation { targets: [innerCircle, innerCircleShadow]; properties: "opacity, width"; duration: 130 }
                    SequentialAnimation {
                        PauseAnimation { duration: 30 }
                        PropertyAnimation { targets: [outBg, outEdge, outSmallBg, outShadow]; properties: "opacity, width"; duration: 130 }
                    }
                }
                //wait outside components to fade in(160ms)
                PauseAnimation { duration: 160 }
            }
        },
        Transition {
            from: "navi"
            to: "normal"
            reversible: false
            SequentialAnimation{
                //wait outside components to fade out(160ms)
                PauseAnimation { duration: 160 }
                //expand the dialframe (160ms)
                ParallelAnimation {
                    PropertyAnimation { targets: [innerCircle, innerCircleShadow]; properties: "opacity, width"; duration: 130 }
                    SequentialAnimation {
                        PauseAnimation { duration: 30 }
                        PropertyAnimation { targets: [outBg, outEdge, outSmallBg, outShadow]; properties: "opacity, width"; duration: 130 }
                    }
                }
                //wait outside components to fade(160ms)
                PauseAnimation { duration: 160 }
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

    //visual components
    Image {
        id: outSmallBg
        width: 560 * d.scaleRatio
        height: width
        anchors.centerIn: parent
        visible: true
        readonly property string sourceSuffix: NeptuneStyle.theme === NeptuneStyle.Dark ? "-dark.png" : ".png"
        source: "./img/dial-small-bg" + sourceSuffix
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

    Shape {
        id: highLightOut
        visible: true
        anchors.fill: outBg

        ShapePath {
            id: highLightOutPath
            readonly property real centerX: highLightOut.width / 2
            readonly property real centerY: highLightOut.height / 2
            readonly property real radiusIn: innerCircle.width / 2
            readonly property real radiusOut: highLightOut.width / 2

            fillColor: d.fillColor
            strokeColor: "transparent"
            strokeWidth: 0
            startX: highLightOutPath.centerX + Math.cos(d.zeroRadin) * highLightOutPath.radiusIn
            startY: highLightOutPath.centerY + Math.sin(d.zeroRadin) * highLightOutPath.radiusIn
            PathLine {
                x: highLightOutPath.centerX + Math.cos(d.zeroRadin) * highLightOutPath.radiusOut
                y: highLightOutPath.centerY + Math.sin(d.zeroRadin) * highLightOutPath.radiusOut
            }
            PathArc {
                x: highLightOutPath.centerX + Math.cos(d.highLightRadin) * highLightOutPath.radiusOut
                y: highLightOutPath.centerY + Math.sin(d.highLightRadin) * highLightOutPath.radiusOut
                radiusX: highLightOutPath.radiusOut
                radiusY: highLightOutPath.radiusOut
                direction: d.isPositive? PathArc.Clockwise : PathArc.Counterclockwise
                useLargeArc: (root.highLightAng - root.zeroAng) >= 180 ? true : false
            }
            PathLine {
                x: highLightOutPath.centerX + Math.cos(d.highLightRadin) * highLightOutPath.radiusIn
                y: highLightOutPath.centerY + Math.sin(d.highLightRadin) * highLightOutPath.radiusIn
            }
            PathArc {
                x: highLightOutPath.centerX + Math.cos(d.zeroRadin) * highLightOutPath.radiusIn
                y: highLightOutPath.centerY + Math.sin(d.zeroRadin) * highLightOutPath.radiusIn
                radiusX: highLightOutPath.radiusIn
                radiusY: highLightOutPath.radiusIn
                direction: d.isPositive? PathArc.Counterclockwise : PathArc.Clockwise
                useLargeArc: (root.highLightAng - root.zeroAng) >= 180 ? true : false
            }
        }
    }


    Shape {
        id: highLightInSource
        visible: true
        width: outBg.width
        height: outBg.height
        x: -1000
        y: -1000

        ShapePath {
            id: highLightInPath
            readonly property real centerX: highLightInSource.width / 2
            readonly property real centerY: highLightInSource.height / 2
            readonly property real radius: highLightInSource.width / 2

            fillGradient: RadialGradient {
                centerX: highLightInPath.centerX
                centerY: highLightInPath.centerY
                focalX: centerX
                focalY: centerY
                centerRadius: highLightInPath.radius
                GradientStop { position: 0;   color: Qt.rgba( d.fillColor.r, d.fillColor.g, d.fillColor.b, 0) }
                GradientStop { position: 0.4; color: Qt.rgba( d.fillColor.r, d.fillColor.g, d.fillColor.b, d.fillColor.a * 0.2) }
                GradientStop { position: 0.8; color: Qt.rgba( d.fillColor.r, d.fillColor.g, d.fillColor.b, d.fillColor.a * 0.3) }
                GradientStop { position: 1;   color: Qt.rgba( d.fillColor.r, d.fillColor.g, d.fillColor.b, d.fillColor.a * 0.4) }
            }
            strokeColor: "transparent"
            strokeWidth: 0
            startX: highLightInPath.centerX
            startY: highLightInPath.centerY
            PathLine {
                x: highLightInPath.centerX + Math.cos(d.zeroRadin) * highLightInPath.radius
                y: highLightInPath.centerY + Math.sin(d.zeroRadin) * highLightInPath.radius
            }
            PathArc {
                x: highLightInPath.centerX + Math.cos(d.highLightRadin) * highLightInPath.radius
                y: highLightInPath.centerY + Math.sin(d.highLightRadin) * highLightInPath.radius
                radiusX: highLightInPath.centerX
                radiusY: highLightInPath.centerY
                direction: d.isPositive? PathArc.Clockwise : PathArc.Counterclockwise
                useLargeArc: (root.highLightAng - root.zeroAng) >= 180 ? true : false
            }
            PathLine {
                x: highLightInPath.centerX
                y: highLightInPath.centerY
            }
        }
    }

    FastBlur {
        id: highLightIn
        anchors.fill: innerCircle
        source: highLightInSource
        radius: 48
        cached: true
        visible: true
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
