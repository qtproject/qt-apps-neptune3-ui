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
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Shapes 1.12

import shared.Sizes 1.0
import shared.Style 1.0

/*
    A lucee component for rounded gauge
*/
Item {
    id: root
    /*
        Gauge radius
    */
    property real radius: Sizes.dp(1000)
    /*
        Gauge width
    */
    property real strokeWidth: Sizes.dp(30)

    /*
        Gauge filled value. Range -1.0 .. 1.0
    */
    property real   value: 0.0
    /*
        Text value on top
    */
    property string valueText: ""
    /*
        Units for text value on top
    */
    property string valueUnits: ""
    /*
        Defines the if shown left or right "(" vs ")"
    */
    property bool isLeft: true
    /*
        Defines labels text color
    */
    property color fontColor: "#454545"
    /*
        Url for icon under the gauge
    */
    property alias icon: gaugeIcon.source
    /*
        Color for border lines
    */
    property color penColor: "#545454"

    width: Sizes.dp(70)
    height: Sizes.dp(360)

    QtObject {
        id: d
        /*
            Defines center point for circular part
        */
        property real cx: root.isLeft ? root.radius + root.strokeWidth * 0.5 + darkCircle.strokeWidth :
                               - root.radius - root.strokeWidth * 0.5 - darkCircle.strokeWidth + root.width
        property real cy: root.height * 0.5
        /*!
            Defines samples count for objects with shaders, increase for smoothness
        */
        readonly property int layerSamples: 4
    }

    /*
        Top label for value + units
    */
    ClusterUnitsLabel{
        anchors.horizontalCenter: root.horizontalCenter
        anchors.bottom: root.top
        anchors.bottomMargin: Sizes.dp(14)
        value: root.valueText
        units: root.valueUnits
        pixelSize: Sizes.dp(35)
    }

    /*
        Rectangle used as container for shader
    */
    Rectangle {
        id: gaugeRect
        anchors.fill: parent
        color: root.value > 0 ? "#6db218" : "yellow" //green-yellow
        opacity: 0.7

        layer.enabled: true
        layer.samples: d.layerSamples

        layer.samplerName: "rectSource"
        layer.effect: ShaderEffect {
            /*
                Shader inside. Uses shape object as mask and applies percent value
            */
            property var  shapeSource: shape
            /*
                Progress value 0.0 .. 1.0
            */
            property real value: Math.abs(root.value)

            fragmentShader: "
                uniform lowp sampler2D shapeSource;
                uniform lowp sampler2D rectSource;
                uniform lowp float qt_Opacity;
                varying highp vec2 qt_TexCoord0;
                uniform highp float value;

                void main() {
                    gl_FragColor = (
                        //top opcaity part
                        vec4(0.329, 0.329, 0.329, 1.0)
                        * texture2D(shapeSource, qt_TexCoord0).a
                        * (1.0 - step(1.0 - value, qt_TexCoord0.y))) * qt_Opacity

                        //lower gauge part (value)
                        + texture2D(rectSource, qt_TexCoord0)
                          * texture2D(shapeSource, qt_TexCoord0).a
                          * step(1.0 - value, qt_TexCoord0.y
                        ) ;
                }"
        }
    }

    /*
        Sets the circle shape mask, drawn into memory
    */
    Shape{
        id: shape

        visible: false
        width: gaugeRect.width
        height: gaugeRect.height
        layer.enabled: true
        layer.samples: d.layerSamples

        ShapePath{
            fillColor: "transparent"
            strokeColor: "white"
            strokeWidth: root.strokeWidth
            startX: 0; startY: 0

            PathAngleArc{
                id: arc
                centerX: d.cx; centerY: d.cy
                radiusX: root.radius; radiusY: root.radius
                startAngle: root.isLeft ? 90 : 270
                sweepAngle: 180
            }
        }
    }

    /*
        Outer dark circle stripe
    */
    Shape{
        id: darkCircle

        readonly property real strokeWidth: Sizes.dp(4)
        readonly property real radius: root.radius +
                                       root.strokeWidth / 2 +
                                       strokeWidth / 2 - 0.5

        layer.enabled: true; layer.samples: d.layerSamples
        anchors.fill: parent

        ShapePath{
            fillColor: "transparent"
            strokeColor: root.penColor
            strokeWidth: darkCircle.strokeWidth

            PathAngleArc{
                centerX: d.cx; centerY: d.cy
                radiusX: darkCircle.radius
                radiusY: darkCircle.radius
                startAngle: root.isLeft ? 90 : 270
                sweepAngle: 180
            }
        }
    }

    /*
        Horizontal top line
    */
    Rectangle {
        id: topLine
        height: Sizes.dp(1)
        width: Sizes.dp(50)
        anchors.top: parent.top
        color: root.penColor
        x: root.isLeft ? parent.width - width : 0
    }

    /*
        Horizontal bottom line
    */
    Rectangle {
        height: Sizes.dp(1)
        width: topLine.width
        anchors.bottom: parent.bottom
        color: root.penColor
        x: topLine.x
    }

    /*
        Bottom icon
    */
    Image {
        id: gaugeIcon
        x: Sizes.dp(176)
        y: Sizes.dp(483)
        width: Sizes.dp(43)
        height: Sizes.dp(24)
        fillMode: Image.PreserveAspectFit
        anchors.horizontalCenter: root.horizontalCenter
        anchors.top: root.bottom
        anchors.topMargin: Sizes.dp(15)
    }
}
