/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 UI.
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

/*!
    \qmltype ScalableColorOverlay
    \inqmlmodule effects
    \inherits ShaderEffect
    \since 5.13
    \brief The scalable color overlay component of Neptune 3.

    The ScalableColorOverlay alters the colors of the source item by applying an overlay color,
    it scales according to image source scale factor.

    \section2 Example Usage

    The following example uses \l{ScalableColorOverlay}:

    \qml
    import QtQuick 2.10
    import shared.effects 1.0

    Item {
        id: root

        Image {
            id: img
            source: "path to image"
            ScalableColorOverlay {
                anchors.fill: parent
                source: img
                color: "red"
            }
        }
    }
    \endqml
*/

ShaderEffect {
    /*!
        \qmlproperty url ScalableColorOverlay::source

        This property defines the source item that provides the source pixels for the effect.
    */
    property variant source

    /*!
        \qmlproperty url ScalableColorOverlay::color

        This property defines the RGBA color value which is used to colorize the source.
        By default, the property is set to "transparent".
    */
    property color color: "transparent"
    vertexShader: "
            uniform highp mat4 qt_Matrix;
            attribute highp vec4 qt_Vertex;
            attribute highp vec2 qt_MultiTexCoord0;
            varying highp vec2 coord;
            void main() {
                coord = qt_MultiTexCoord0;
                gl_Position = qt_Matrix * qt_Vertex;
            }"
    fragmentShader: "
            varying highp vec2 coord;
            uniform sampler2D source;
            uniform lowp float qt_Opacity;
            uniform highp vec4 color;
            void main() {
                lowp vec4 tex = texture2D(source, coord);
                gl_FragColor = vec4(mix(tex.rgb/max(tex.a, 0.00390625),
                            color.rgb/max(color.a, 0.00390625), color.a) * tex.a, tex.a) * qt_Opacity;
            }"
}
