/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AB
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Triton IVI UI.
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

Entity {
    Transform {
        id: transform
        property real userAngle: 0.0
        matrix: {
            var m = Qt.matrix4x4();
            m.scale(vehicle3DView.scaleFactor);
            return m;
        }
    }

    Entity {
        Mesh {
            id: mesh
            meshName: "^chrome_4$"
            source: vehicle3DView.carObjFilePath
        }
        components: [transform, mesh, chromeMaterial]
    }

    Entity {
        Mesh {
            id: shell
            meshName: "shell"
            source: vehicle3DView.carObjFilePath
        }
        components: [transform, shell, grayMaterial]
    }

    Entity {
        Mesh {
            id: matt_black
            meshName: "matt_black"
            source: vehicle3DView.carObjFilePath
        }
        components: [transform, matt_black, blackMaterial]
    }

    Entity {
        Mesh {
            id: glass
            meshName: "^glass_4$"
            source: vehicle3DView.carObjFilePath
        }
        components: [transform, glass, glassMaterial]
    }

    Entity {
        Mesh {
            id: license_plates
            meshName: "^licence_plates$"
            source: vehicle3DView.carObjFilePath
        }
        components: [transform, license_plates, whiteMaterial]
    }

    Entity {
        Mesh {
            id: taillights
            meshName: "^taillights$"
            source: vehicle3DView.carObjFilePath
        }
        components: [transform, taillights, taillightsMaterial]
    }

    Entity {
        Mesh {
            id: interior
            meshName: "^interior$"
            source: vehicle3DView.carObjFilePath
        }
        components: [transform, interior, interiorMaterial]
    }

}
