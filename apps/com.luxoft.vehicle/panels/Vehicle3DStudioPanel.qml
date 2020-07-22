/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
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

import QtQuick 2.12
import QtQuick.Controls 2.3
import QtStudio3D.OpenGL 2.5

import shared.utils 1.0
import shared.Style 1.0
import shared.Sizes 1.0

import "../helpers" 1.0

Item {
    id: root

    anchors.fill: parent

    property real lastCameraAngle: 0.0
    property real roofOpenProgress: 0.0
    property bool leftDoorOpen: false
    property bool rightDoorOpen: false
    property bool trunkOpen: false
    property color vehicleColor

    property bool readyToChanges: false

    QtObject {
        id: d
        property var trajectory: []
        property var trajectoryV: []
    }

    onLeftDoorOpenChanged: {
        if (leftDoorOpen) {
            presentation.leftDoorAngle = 60;
        } else {
            presentation.leftDoorAngle = 0;
        }
    }

    onRightDoorOpenChanged: {
        if (rightDoorOpen) {
            presentation.rightDoorAngle = -60;
        } else {
            presentation.rightDoorAngle = 0;
        }
    }

    onTrunkOpenChanged: {
        if (trunkOpen) {
            presentation.trunkAngle = 30;
        } else {
            presentation.trunkAngle = 0;
        }
    }

    MouseArea {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: Sizes.dp(652)
        z: 40

        onReleased: {
            d.trajectory = []
        }

        onPositionChanged: {
            if (pressed) {
                d.trajectory.push(mouseX);
                d.trajectoryV.push(mouseY);
                if (d.trajectory.length > 2) {
                    var dx = 0;
                    var coef = 0.5;
                    for (var i = 1; i < d.trajectory.length; ++i) {
                        dx += d.trajectory[i] - d.trajectory[i - 1];
                    }

                    if (dx !== 0) {
                        presentation.angleHorizontal -= dx * coef;
                        root.lastCameraAngle = presentation.angleHorizontal - 270;
                    }

                    d.trajectory = [];
                }
            }
        }
    }

    Connections {
        id: readyToChangeConnection
        target: studio3D
        property int fc: 0
        function onFrameUpdate() {
            fc += 1;
            // skip first 10 frames to be sure that all content is ready
            if (fc > 10) {
                studio3D.opacity = 1.0;
                readyToChangeConnection.target = null;
                root.readyToChanges = true;
            }
        }
    }

    Studio3D {
        id: studio3D
        opacity: 0
        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(200)
        anchors.left: parent.left
        anchors.leftMargin: Sizes.dp(60)
        height: Sizes.dp(380)
        width: Sizes.dp(960)

       ViewerSettings {
           scaleMode: ViewerSettings.ScaleModeFit
//           uncomment to display render statistics from ogl-runtime
//           showRenderStats: true
       }

        Presentation {
            id: presentation
            source: Paths.localQt3DStudioPresentationAsset("vehicle3dStudio.uia")

            property real angleHorizontal: (270.0 + root.lastCameraAngle) % 360
            property real angleVertical: 2.0
            property real leftDoorAngle: 0.0
            property real rightDoorAngle: 0.0
            property real trunkAngle: 0
            property vector3d sunRoofRotation: Qt.vector3d(90.0, 0.0, 0.0)
            property vector3d sunRoofPosition:  Qt.vector3d(0.0, 0.044, -2.464)

            AnimationController {
                progress: root.roofOpenProgress
                animation: ParallelAnimation {

                    Vector3dAnimation {
                        target: presentation
                        property: "sunRoofRotation"
                        duration: 4000
                        easing.type: Easing.OutElastic
                        from: Qt.vector3d(0.0, -90.0, 0.0)
                        to: Qt.vector3d(-6.0, -90.0, 0.0)
                    }

                    Vector3dAnimation {
                        target: presentation
                        property: "sunRoofPosition"
                        duration: 4000
                        easing.type: Easing.Linear
                        from: Qt.vector3d(-25.315, 0.00, 12.818)
                        to: Qt.vector3d(37.0, 1, 12.818)
                    }
                }
            }

            Behavior on angleHorizontal { SmoothedAnimation { velocity: 200 } }
            Behavior on leftDoorAngle { SmoothedAnimation { duration: 3500 } }
            Behavior on rightDoorAngle { SmoothedAnimation { duration: 3500 } }
            Behavior on rightDoorAngle { SmoothedAnimation { duration: 3500 } }
            Behavior on trunkAngle { SmoothedAnimation { duration: 3500 } }

            DataInput {
                name: "vehicleRotation"
                value: Qt.vector3d(0, presentation.angleHorizontal, presentation.angleVertical)
            }

            DataInput {
                name: "leftDoorRotation"
                value: Qt.vector3d(0, presentation.leftDoorAngle, 0)
            }

            DataInput {
                name: "rightDoorRotation"
                value: Qt.vector3d(0, presentation.rightDoorAngle, 0)
            }

            DataInput {
                name: "sunRoofRotation"
                value: presentation.sunRoofRotation
            }

            DataInput {
                name: "sunRoofPosition"
                value: presentation.sunRoofPosition
            }

            DataInput {
                name: "trunkRotation"
                value: Qt.vector3d(presentation.trunkAngle, -89.991, 0)
            }

            DataInput {
                name: "diffuseColor"
                value: Qt.vector4d(root.vehicleColor.r
                                   , root.vehicleColor.g
                                   , root.vehicleColor.b
                                   , root.vehicleColor.a)
            }
        }
    }
}

