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
    id: root

    readonly property string carObjFilePath: "file:assets/models/car.obj"

    function openDoors() {
        openLeftDoor()
        openRightDoor()
    }

    function closeDoors() {
        closeLeftDoor()
        closeRightDoor()
    }

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

    function animateWheels(speed) {
        axisFront.speed(speed)
        axisRear.speed(speed)
    }

    function openRoof() {
        roof.openRoof()
    }

    function closeRoof() {
        roof.closeRoof()
    }

    function openRearDoor() {
        rearDoor.openDoor()
    }

    function closeRearDoor() {
        roof.openRoof()
    }

    Image {
        anchors.fill: parent
        source: "assets/images/back.png"
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

            InputSettings {
                id: inputSettings
            }

            components: [inputSettings, renderSettings]

            Camera {
                id: camera
                projectionType: CameraLens.PerspectiveProjection
                fieldOfView: 45
                nearPlane: 0.1
                farPlane: 1000.0
                position: Qt.vector3d(0, 4, 8.0)
                viewCenter: Qt.vector3d(0, 1, 0)
                upVector: Qt.vector3d(0.0, 1.0, 0.0)
            }

            VehicleCameraController {
                camera: camera
            }

            PlaneMesh {
                id: floor
                width: 250
                height: 250
            }

            PhongMaterial {
                id: material
                ambient: "gray"
                specular: "white"
            }

            Transform {
                id: floorScale
                translation: Qt.vector3d(0, -2, 0)
            }

            Entity {
                components: [floor, material, floorScale]
            }

            VehicleBody {
                material: material
                meshTitle: "body"
                meshSource: carObjFilePath
            }

            VehicleLeftDoor {
                id: leftDoor
                material: material
                meshTitle: "door_left"
                meshSource: carObjFilePath
            }

            VehicleRightDoor {
                id: rightDoor
                material: material
                meshTitle: "door_right"
                meshSource: carObjFilePath
            }

            VehicleRearDoor {
                id: rearDoor
                material: material
                meshTitle: "door_rear"
                meshSource: carObjFilePath
            }

            VehicleAxisFront {
                id: axisFront
                material: material
                meshTitle: "axis_fron"
                meshSource: carObjFilePath
            }

            VehicleAxisRear {
                id: axisRear
                material: material
                meshTitle: "axis_rear"
                meshSource: carObjFilePath
            }

            VehicleRoof {
                id: roof
                material: material
                meshTitle: "roof"
                meshSource: carObjFilePath
            }
        }
    }
}
