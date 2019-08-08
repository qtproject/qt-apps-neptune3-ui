/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Copyright (C) 2018 Pelagicore AG
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

import QtQuick 2.2
import Qt3D.Core 2.0
import Qt3D.Render 2.0

import "../../helpers" 1.0

Material {
    id: root

    property color albedo: "red"
    property real metalness: 1.0
    property real roughness: 1.0
    property real ao: 1.0
    property real alpha: 1.0

    parameters: [
        Parameter {
            name: "albedo"
            value: albedo
        },
        Parameter {
            name: "metalness"
            value: metalness
        },
        Parameter {
            name: "roughness"
            value: roughness
        },
        Parameter {
            name: "ao"
            value: ao
        },
        Parameter {
            name: "alpha"
            value: alpha
        }
    ]

    effect : Effect {
        property string vertex: Paths.getMaterialPath("pbr_shader.vert")
        property string fragment: Paths.getMaterialPath("pbr_shader.frag")

        ShaderProgram {
            id: es2Shader
            vertexShaderCode: loadSource(parent.vertex)
            fragmentShaderCode: loadSource(parent.fragment)
        }

        techniques: [
            Technique {
                graphicsApiFilter {
                    api: GraphicsApiFilter.OpenGLES
                    profile: GraphicsApiFilter.CoreProfile
                    majorVersion: 2
                    minorVersion: 0
                }
                renderPasses: RenderPass {
                    shaderProgram: es2Shader
                }
            },
            Technique {
                graphicsApiFilter {
                    api: GraphicsApiFilter.OpenGL
                    profile: GraphicsApiFilter.NoProfile
                    majorVersion: 2
                    minorVersion: 0
                }
                renderPasses: RenderPass {
                    shaderProgram: es2Shader
                }
            }
        ]
    }
}

