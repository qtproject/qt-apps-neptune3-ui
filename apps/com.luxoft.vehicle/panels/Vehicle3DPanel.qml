/****************************************************************************
**
** Copyright (C) 2017-2018 Luxoft GmbH
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
import QtQuick.Controls 2.3

import shared.com.pelagicore.styles.neptune 3.0

import "../helpers/pathsProvider.js" as Paths
import "../3d/materials"
import "../3d/entities"
import "../3d/settings"

Item {
    id: root

    //ToDo: This is a part of a work around for the Scene3D windows&macOS bug
    property real roofOpenProgress: 0.0
    property bool leftDoorOpen: false
    property bool rightDoorOpen: false
    property bool trunkOpen: false
    property bool clusterView: false

    //ToDo: This is a part of a work around for the Scene3D windows&macOS bug
    Loader {
        anchors.fill: parent
        active: root.visible
        sourceComponent: sceneComponent
    }

    Component {
        id: sceneComponent
        Item {
            anchors.fill: parent
            Image {
                anchors.fill: parent
                source: Paths.getImagePath("back.png")

                //ToDo: Replace later with an actual splash screen
                BusyIndicator {
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: NeptuneStyle.dp(80)
                    running: !body.loaded
                }
            }

            Scene3D {
                anchors.fill: parent
                aspects: ["input", "logic"]
                focus: false

                Entity {
                    RenderSettings {
                        id: renderSettings
                        activeFrameGraph: FrameGraph {
                            clearColor: "transparent"
                            camera: camera
                        }
                        // NB: this should work once https://codereview.qt-project.org/#/c/208218/ is merged
                        renderPolicy: RenderSettings.OnDemand
                    }

                    InputSettings {
                        id: inputSettings
                    }

                    components: [inputSettings, renderSettings]

                    Camera {
                        id: camera
                        projectionType: CameraLens.PerspectiveProjection
                        fieldOfView: 25
                        nearPlane: 0.1
                        farPlane: 100.0
                        position: Qt.vector3d(0, 2, 15)
                        viewCenter: Qt.vector3d(0, 1.6, 0)
                        upVector: Qt.vector3d(0.0, 1.0, 0.0)
                    }

                    CameraController {
                        camera: camera
                        enabled: !root.clusterView
                    }

                    CookTorranceMaterial {
                        id: blackMaterial
                        albedo: "black"
                        metalness: 0.5
                        roughness: 0.8
                    }

                    CookTorranceMaterial {
                        id: whiteHood
                        albedo: "white"
                        metalness: 0.1
                        roughness: 0.35
                    }

                    CookTorranceMaterial {
                        id: chromeMaterial
                        albedo: "black"
                        metalness: 0.1
                        roughness: 0.2
                    }

                    CookTorranceMaterial {
                        id: taillightsMaterial
                        albedo: "red"
                        metalness: 0.1
                        roughness: 0.2
                        alpha: 0.5
                    }

                    CookTorranceMaterial {
                        id: interiorMaterial
                        albedo: "gray"
                        metalness: 1.0
                        roughness: 0.1
                    }

                    CookTorranceMaterial {
                        id: whiteMaterial
                        albedo: "white"
                        metalness: 0.5
                        roughness: 0.5
                    }

                    CookTorranceMaterial {
                        id: glassMaterial
                        albedo: "black"
                        metalness: 0.1
                        roughness: 0.1
                        alpha: 0.8
                    }

                    Shadow {}
                    AxisFront {}
                    AxisRear {}
                    Seats {}
                    RearDoor {
                        id: trunk
                        open: root.trunkOpen
                    }
                    LeftDoor {
                        id: leftDoor
                        open: root.leftDoorOpen
                    }
                    RightDoor {
                        id: rightDoor
                        open: root.rightDoorOpen
                    }
                    Roof {
                        id: roof
                        openProgress: root.roofOpenProgress
                    }
                    Body { id: body }
                }
            }
        }
    }
}
