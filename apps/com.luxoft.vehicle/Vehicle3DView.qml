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

Item {
    id: vehicle3DView

    //ToDo: This "file:" thing is a hack to make Qt3D load by relative address
    readonly property string carObjFilePath: "file:assets/models/car.obj"
    property alias roofSliderValue: sunRoof.roofSliderValue
    readonly property real scaleFactor: 0.1

    function openLeftDoor() {
        leftDoor.openDoor()
    }

    function openRightDoor() {
        rightDoor.openDoor()
    }

    function closeLeftDoor() {
        leftDoor.closeDoor()
    }

    function closeRightDoor() {
        rightDoor.closeDoor()
    }

    function animateWheels() {
        axisFront.animate()
        axisRear.animate()
    }

    function openRoof() {
        sunRoof.openRoof()
    }

    function closeRoof() {
        sunRoof.closeRoof()
    }

    function openRearDoor() {
        rearDoor.openDoor()
    }

    function closeRearDoor() {
        roof.openRoof()
    }

    Scene3D {
        anchors.fill: parent
        aspects: ["input", "logic"]
        focus: true

        Entity {
            RenderSettings {
                id: renderSettings
                activeFrameGraph: VehicleFrameGraph {
                    clearColor: "transparent"
                    camera: camera
                }
            }

            SkyboxEntity {
                baseName: "file:assets/cubemap/triton-car-3D-environment"
                extension: ".png"
                gammaCorrect: true
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

            Camera {
                id: camera
                projectionType: CameraLens.PerspectiveProjection
                fieldOfView: 45
                nearPlane: 0.1
                farPlane: 1000.0
                position: Qt.vector3d(0, 3.2, 8.0)
                viewCenter: Qt.vector3d(0, 0, 0)
                upVector: Qt.vector3d(0.0, 1.0, 0.0)
            }

            PhongMaterial {
                id: blackMaterial
                diffuse: "#000000"
                specular: "#121212"
                shininess: 10
            }

            PhongMaterial {
                id: grayMaterial
                diffuse: "#d9d9d9"
                specular: "#121212"
                shininess: 64
            }

            PhongMaterial {
                id: chromeMaterial
                ambient: "#404040"
                diffuse: "#666666"
                specular: "#C6C6C6"
                shininess: 76.8
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

            VehicleShadow {
            }

            VehicleAxisFront {
                id: axisFront
            }

            VehicleAxisRear {
                id: axisRear
            }

            VehicleSeats {
            }

//            VehicleRearDoor { //TODO: NO REAR DOOR

//            }
            VehicleLeftDoor {
                id: leftDoor
            }

            VehicleRightDoor {
                id: rightDoor
            }

            VehicleRoof {
                id: sunRoof
            }

            VehicleBody {
            }
        }
    }
}
