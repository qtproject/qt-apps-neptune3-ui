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
import QtQuick.Controls 2.3

Item {
    id: vehicle3DView

    property alias roofOpenProgress: roof.openProgress
    readonly property real scaleFactor: 0.1

    property alias leftDoorOpen: leftDoor.open
    property alias rightDoorOpen: rightDoor.open
    property alias trunkOpen: trunk.open

    Image {
        anchors.fill: parent
        source: "assets/images/back.png"

        //ToDo: Replace later with an actual splash screen
        BusyIndicator {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 80
            running: !body.loaded
        }
    }

    Scene3D {
        anchors.fill: parent
        aspects: ["input", "logic"] // TODO: This generates warning. Need investigate why.
        focus: true

        Entity {
            RenderSettings {
                id: renderSettings
                activeFrameGraph: VehicleFrameGraph {
                    clearColor: "transparent"
                    camera: camera
                }
                // NB: this should work once https://codereview.qt-project.org/#/c/208218/ is merged
                renderPolicy: RenderSettings.OnDemand
            }

            InputSettings {
                id: inputSettings
            }

            Entity {
                components: [
                    DirectionalLight {
                        worldDirection: Qt.vector3d(1, -1, -1).normalized()
                        color: "white"
                        intensity: 0.3
                    },
                    DirectionalLight {
                        worldDirection: Qt.vector3d(-1, -1, 1).normalized()
                        color: "white"
                        intensity: 0.3
                    }
                ]
            }

            components: [inputSettings, renderSettings]

            // Uncomment this camera and use it for from up to down renderer to take a screenshot
            // Camera {
            //     id: updownRendererCamera
            //     projectionType: CameraLens.PerspectiveProjection
            //     fieldOfView: 25
            //     nearPlane: 0.1
            //     farPlane: 100.0
            //     position: Qt.vector3d(0, 24, 1)
            //     viewCenter: Qt.vector3d(0, 0, 1)
            //     upVector: Qt.vector3d(0.0, 0.0, 1.0)
            // }

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

            PhongMaterial {
                id: blackMaterial
                diffuse: "#000000"
                specular: "#121212"
                shininess: 10
            }

            PhongMaterial {
                id: whiteHood
                diffuse: "#FFFFFF"
                specular: "#FFFFFF"
                shininess: 1
            }

            PhongMaterial {
                id: chromeMaterial
                ambient: "#000000"
                diffuse: "#858687"
                specular: "#858687"
                shininess: 8
            }

            PhongAlphaMaterial {
                id: taillightsMaterial
                diffuse: "red"
                specular: "#d14545"
                alpha: 0.85
                shininess: 512
            }

            PhongMaterial {
                id: interiorMaterial
                diffuse: "#927B51"
            }

            PhongMaterial {
                id: whiteMaterial
                ambient: "#606060"
                diffuse: "white"
                specular: "white"
                shininess: 128
            }

            PhongAlphaMaterial {
                id: glassMaterial
                ambient: "black"
                diffuse: "black"
                specular: "black"
                alpha: 0.9
            }

            VehicleCameraController {
                camera: camera
            }

            VehicleShadow {}
            VehicleAxisFront {}
            VehicleAxisRear {}
            VehicleSeats {}
            VehicleRearDoor { id: trunk }
            VehicleLeftDoor { id: leftDoor }
            VehicleRightDoor { id: rightDoor }
            VehicleRoof { id: roof }
            VehicleBody { id: body }
        }
    }
}
