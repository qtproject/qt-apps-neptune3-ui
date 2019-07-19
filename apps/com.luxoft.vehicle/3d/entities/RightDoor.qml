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

import shared.animations 1.0

import "../../helpers" 1.0

Entity {
    id: root

    Transform {
        id: transform
        property real userAngle: root.open ? -55 : 0
        Behavior on userAngle { DefaultNumberAnimation { duration: 1000 } }
        matrix: {
            var m = Qt.matrix4x4();
            var xOffset = 1.65;
            var yOffset = 1.4;
            var zOffset = 1.4;
            m.translate( Qt.vector3d(-xOffset, yOffset, zOffset))
            m.rotate(userAngle, Qt.vector3d(0, -1, 0))
            m.translate( Qt.vector3d(xOffset, -yOffset, -zOffset))
            return m;
        }
    }

    property bool open: false
    property string version

    components: [transform]

    Entity {
        Mesh {
            id: mesh
            source: Paths.getModelPath("silver_paint_2"
                    , root.version.length == 0 ? "optimized" : root.version)
        }
        components: [mesh, whiteHood]
    }

    Entity {
        Mesh {
            id: glass
            source: Paths.getModelPath("glass_2"
                    , root.version.length == 0 ? "optimized" : root.version)
        }
        components: [glass, glassMaterial]
    }

    Entity {
        Mesh {
            id: chrome
            source: Paths.getModelPath("chrome_3"
                    , root.version.length == 0 ? "optimized" : root.version)
        }
        components: [chrome, chromeMaterial]
    }

    Entity {
        Mesh {
            id: black1
            source: Paths.getModelPath("black_3"
                    , root.version.length == 0 ? "optimized" : root.version)
        }
        components: [black1, blackMaterial]
    }
}
