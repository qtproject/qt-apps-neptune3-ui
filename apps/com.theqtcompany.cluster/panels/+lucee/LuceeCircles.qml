/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
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

import QtQuick 2.12
import QtQuick.Shapes 1.12
import shared.Sizes 1.0
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.2

/*
  A component for left and right parts of circles inside GaugesPanel for lucee style
*/

Item{
    id: root

    /*
        Defines if circles are on the left or right side of panel
    */
    property bool isLeft: true
    /*
        Defines base color for the circles
    */
    property color color: "#545454"

    QtObject {
        id: d
        /*
            Defines center point for circles
        */
        readonly property real cx: isLeft ? width : 0
        readonly property real cy: height / 2
        /*
            Defines samples count for objects with shaders
        */
        readonly property int samplesCount: 4
    }

    /*
        central semi-transparent part
        radius is affected by state transitions
    */
    Shape{
        id: centralCircle

        property real radius: Sizes.dp(450)
        readonly property real strokeWidth: Sizes.dp(70)

        anchors.fill: parent
        opacity: 0.60
        layer.enabled: true
        layer.samples: d.samplesCount
        layer.samplerName: "maskSource"
        layer.effect: ShaderEffect {
            fragmentShader: "
                            uniform lowp sampler2D maskSource;
                            uniform lowp float qt_Opacity;
                            varying highp vec2 qt_TexCoord0;
                            void main() {
                                gl_FragColor = texture2D(maskSource, qt_TexCoord0) * qt_Opacity;
                            }"
        }

        ShapePath{
            fillColor: "transparent"
            strokeColor: root.color
            strokeWidth: centralCircle.strokeWidth

            PathAngleArc{
                id: arc
                centerX: d.cx;  centerY: d.cy
                radiusX: centralCircle.radius
                radiusY: radiusX
                startAngle: root.isLeft ? 90 : 270
                sweepAngle: 180
            }

        }
    }

    /*
        Non-transprent thin circle
    */
    Shape{
        id: centralDarkCircle

        readonly property real strokeWidth: Sizes.dp(4)
        readonly property real radius: centralCircle.radius +
                                       centralCircle.strokeWidth / 2 +
                                       strokeWidth / 2 - 0.5

        layer.enabled: true
        layer.samples: d.samplesCount
        anchors.centerIn: parent
        anchors.fill: parent

        ShapePath{
            fillColor: "transparent"
            strokeColor: root.color
            strokeWidth: centralDarkCircle.strokeWidth

            PathAngleArc{
                centerX: d.cx; centerY: d.cy
                radiusX: centralDarkCircle.radius
                radiusY: radiusX
                startAngle: root.isLeft ? 90 : 270
                sweepAngle: 180
            }
        }
    }

    /*
      Inner circle
    */
    Shape{
        id: centralTranparentCircle

        readonly property real strokeWidth: Sizes.dp(200)
        readonly property real radius: centralDarkCircle.radius +
                                       centralDarkCircle.strokeWidth / 2 +
                                       strokeWidth / 2 - 0.5

        anchors.fill: parent
        x:  root.isLeft ? 0 : width
        layer.enabled: true
        layer.samples: d.samplesCount
        layer.samplerName: "maskSource"
        layer.effect: ShaderEffect {
            property real drawLeft: root.isLeft ? 0.0 : 1.0
            property real signLeft: root.isLeft ? -1.0 : 1.0
            fragmentShader: "
                                #ifdef GL_ES
                                precision mediump float;
                                #endif
                                uniform lowp sampler2D maskSource;
                                uniform lowp float qt_Opacity;
                                varying highp vec2 qt_TexCoord0;
                                uniform highp float drawLeft;
                                uniform highp float signLeft;

                                void main() {
                                    float x = (drawLeft - signLeft * qt_TexCoord0.x) / 2.0;
                                    float y = abs( (qt_TexCoord0.y - 0.5) / 0.205) * 0.75;
                                    vec4 cv = vec4(y);
                                    vec4 ch = vec4(x);
                                    vec4 color = mix(cv, ch, 0.5);

                                    gl_FragColor = color * texture2D(maskSource, qt_TexCoord0).a;
                                }"
        }

        ShapePath{
            fillColor: "transparent"
            strokeColor: root.color
            strokeWidth: centralTranparentCircle.strokeWidth

            PathAngleArc{
                centerX: root.isLeft ? d.cx : 0
                centerY: d.cy
                radiusX: centralTranparentCircle.radius
                radiusY: radiusX
                startAngle: root.isLeft ? 90 : 270
                sweepAngle: 180
            }
        }
    }

    /*
        Two-gradient source for outer circle
    */
    Rectangle{
        id: gradientRect
        visible: false; // should not be visible on screen.
        layer.enabled: true; layer.smooth: true
        width: root.width; height: root.height

        Rectangle{
            x: 0; y: 0
            width: root.width
            height: root.height / 2
            gradient: Gradient {
                GradientStop { position: 0; color: "#b5b5b5" }
                GradientStop { position: 1; color: "#c3c2c2" }
            }
        }

        Rectangle{
            width: root.width
            height: root.height /2
            y: root.height / 2
            gradient: Gradient {
                GradientStop { position: 0; color: "#7b7b7b" }
                GradientStop { position: 1; color: "white" }
            }
        }
    }

    /*
        Outer circle
    */
    Shape{
        id: outerGradientCircle

        readonly property real strokeWidth: Sizes.dp(500)
        readonly property real radius: centralTranparentCircle.radius +
                                       centralTranparentCircle.strokeWidth / 2 +
                                       strokeWidth / 2 - 0.5

        layer.enabled: true
        layer.samples: d.samplesCount
        layer.samplerName: "maskSource"
        layer.effect: ShaderEffect {
            property var colorSource: gradientRect;
            fragmentShader: "
                            uniform lowp sampler2D colorSource;
                            uniform lowp sampler2D maskSource;
                            uniform lowp float qt_Opacity;
                            varying highp vec2 qt_TexCoord0;
                            void main() {
                                gl_FragColor =
                                    texture2D(colorSource, qt_TexCoord0)
                                    * texture2D(maskSource, qt_TexCoord0).a
                                    * qt_Opacity;
                            }
                        "
        }
        opacity: 0.85
        anchors.fill: parent

        ShapePath{
            fillColor: "transparent"
            strokeColor: root.color
            strokeWidth: outerGradientCircle.strokeWidth

            PathAngleArc{
                centerX: d.cx; centerY: d.cy
                radiusX: outerGradientCircle.radius
                radiusY: outerGradientCircle.radius
                startAngle: root.isLeft ? 90 : 270
                sweepAngle: 180
            }
        }
    }

    states: [
        State {
            name: "stopped"
            PropertyChanges { target: centralCircle; radius: Sizes.dp(400);}
        },
        State {
            name: "normal"
            PropertyChanges { target: centralCircle; radius: Sizes.dp(450);}
        }
    ]

    transitions: [
        Transition {
            from: "stopped"
            to: "normal"
            reversible: false
            PropertyAnimation { target: centralCircle; property: "radius"; duration: 1000 }

        },
        Transition {
            from: "normal"
            to: "stopped"
            reversible: false
            PropertyAnimation { target: centralCircle; property: "radius"; duration: 1000 }
        }
    ]

}
