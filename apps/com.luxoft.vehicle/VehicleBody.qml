/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AB
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 IVI UI.
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
    id: root

    property bool loaded: false

    Transform {
        id: transform
        property real userAngle: 0.0
    }

    components: [transform]

    Entity {
        Mesh {
            id: mesh
            source: "assets/models/chrome.obj"
            //ToDo: this has to be replaced with an actual loading signal or something more clear
            onGeometryChanged: root.loaded = true
        }
        components: [mesh, chromeMaterial]
    }

    Entity {
        Mesh {
            id: shell
            source: "assets/models/shell.obj"
        }
        components: [shell, whiteHood]
    }

    Entity {
        Mesh {
            id: matt_black
            source: "assets/models/matt_black.obj"
        }
        components: [matt_black, blackMaterial]
    }

    Entity {
        Mesh {
            id: glass
            source: "assets/models/glass_4.obj"
        }
        components: [glass, glassMaterial]
    }

    Entity {
        Mesh {
            id: license_plates
            source: "assets/models/licence_plates.obj"
        }
        components: [license_plates, whiteMaterial]
    }

    Entity {
        Mesh {
            id: frontLights
            source: "assets/models/front_ights.obj"
        }
        PhongAlphaMaterial {
            id: frontLightsMaterial
            diffuse: "gray"
            specular: "gray"
            shininess: 512
            alpha: 0.7
        }
        components: [frontLights, frontLightsMaterial]
    }

    Entity {
        Mesh {
            id: taillights
            source: "assets/models/taillights.obj"
        }
        components: [taillights, taillightsMaterial]
    }

    Entity {
        Mesh {
            id: interior
            source: "assets/models/interior.obj"
        }
        components: [interior, interiorMaterial]
    }

}
