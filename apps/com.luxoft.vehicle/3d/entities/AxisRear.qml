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

import QtQuick 2.0
import Qt3D.Core 2.0
import Qt3D.Render 2.9
import Qt3D.Extras 2.9
import Qt3D.Input 2.0
import QtQuick.Scene3D 2.0

import "../../helpers" 1.0

Entity {
    id: root
    property string version

    function animate() {
        rotationAnimation.start()
    }

    Transform {
        id: transform
        property real userAngle: 0.0
        matrix: {
            var m = Qt.matrix4x4()
            var yOffset = 6
            var zOffset = -30
            m.translate(Qt.vector3d(0, yOffset, zOffset))
            m.rotate(userAngle, Qt.vector3d(1, 0, 0))
            m.translate(Qt.vector3d(0, -yOffset, -zOffset))
            return m
        }
    }

    components: [transform]

    Entity {
        Mesh {
            id: wheelMesh
            source: Paths.getModelPath("rear_wheel_chrome"
                    , root.version.length == 0 ? "optimized" : root.version)
        }
        components: [wheelMesh, wheelChromeMaterial]
    }

    Entity {
        Mesh {
            id: tiresMesh
            source: Paths.getModelPath("rear_tires", root.version)
        }
        components: [tiresMesh, rubberMaterial]
    }

    NumberAnimation {
        id: rotationAnimation
        target: transform
        property: "userAngle"
        duration: 1000
        from: transform.userAngle
        to: 360
        loops: Animation.Infinite
    }
}
