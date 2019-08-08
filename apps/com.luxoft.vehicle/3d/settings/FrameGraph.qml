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

import Qt3D.Core 2.0
import Qt3D.Render 2.0

import "../entities" 1.0

RenderSurfaceSelector {
    id: surfaceSelector

    property alias camera: cameraSelector.camera
    property alias clearColor: clearBuffer.clearColor

    RenderStateSet {

        DepthTest {
            id: depth
            depthFunction: DepthTest.Less
        }

        BlendEquation {
            id: blendEq
            blendFunction: BlendEquation.Add
        }

        BlendEquationArguments {
            id: blendEqArgs
            sourceRgb: BlendEquationArguments.SourceAlpha;
            destinationRgb: BlendEquationArguments.OneMinusSourceAlpha
        }

        renderStates: [depth, blendEq, blendEqArgs]

        Viewport {
            id: viewport
            normalizedRect: Qt.rect(0.0, 0.0, 1.0, 1.0)
            SortPolicy {
                sortTypes: [
                    SortPolicy.BackToFront // For alpha blending
                ]
            }
            ClearBuffers {
                id: clearBuffer
                clearColor: "transparent"
                buffers: ClearBuffers.ColorDepthBuffer
                CameraSelector {
                    id: cameraSelector
                }
            }
        }
    }
}
