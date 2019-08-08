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

import QtQuick 2.2

import shared.utils 1.0

import shared.Sizes 1.0
import shared.animations 1.0

import "../panels" 1.0
import "../stores" 1.0

Item {
    id: root

    property VehicleStore store
    property bool currentRuntimeQt3D: true

    Item {
        id: car3dPanel
        anchors.top: root.top
        anchors.left: root.left
        anchors.right: root.right
        height: Sizes.dp(652)

        // at the application startup it doesn't receive full screen window,
        // in that moment the car model is scaled awfully, so we wait till the app window is rescaled properly
        visible: parent.height > 2 * Sizes.dp(652)

        Connections {
            id: delayedConns
            target: null
            onLastCameraAngleChanged: root.store.cameraAngleView = target.lastCameraAngle
            onReadyToChanges: {
                controlPanel.allowToChange3DSettings = true
                vehicleProxyPanel.showBusyIndicator = false
                vehicleProxyPanel.z = vehicleProxyPanel.parent.z;
            }
        }

        VehicleProxyPanel {
            id: vehicleProxyPanel
            showBusyIndicator: true
        }

        Loader {
            id: car3dPanelLoader
            anchors.fill: parent
            active: !root.store.qt3DStudioAvailable || root.currentRuntimeQt3D
            source: "../panels/Vehicle3DPanel.qml"
            opacity: active ? 1.0 : 0.0
            Behavior on opacity {
                DefaultNumberAnimation {}
            }

            onLoaded: {
                delayedConns.target = item
                item.leftDoorOpen = Qt.binding( function() {return root.store.leftDoorOpened} )
                item.rightDoorOpen = Qt.binding( function() {return root.store.rightDoorOpened})
                item.trunkOpen = Qt.binding( function() {return  root.store.trunkOpened})
                item.roofOpenProgress = Qt.binding( function() {return root.store.roofOpenProgress})
                item.modelVersion = Qt.binding( function() {return root.store.model3DVersion})
                item.lastCameraAngle = root.store.cameraAngleView
            }
        }

        Loader {
            id: car3dStudioPanellLoader
            anchors.fill: parent
            active: root.store.qt3DStudioAvailable && !root.currentRuntimeQt3D
            source: "../panels/Vehicle3DStudioPanel.qml"
            opacity: active ? 1.0 : 0.0
            Behavior on opacity {
                DefaultNumberAnimation {}
            }

            onLoaded: {
                delayedConns.target = item
                item.leftDoorOpen = Qt.binding( function() {return root.store.leftDoorOpened} )
                item.rightDoorOpen = Qt.binding( function() {return root.store.rightDoorOpened})
                item.trunkOpen = Qt.binding( function() {return  root.store.trunkOpened})
                item.roofOpenProgress = Qt.binding( function() {return root.store.roofOpenProgress})
                item.vehicleColor = Qt.binding( function() {return root.store.vehicle3DstudioColor})
                item.lastCameraAngle = root.store.cameraAngleView
            }
        }
    }

    Vehicle3DControlPanel {
        id: controlPanel

        anchors.top: car3dPanel.bottom
        anchors.topMargin: Sizes.dp(80)
        anchors.rightMargin: Sizes.dp(30)
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: parent.bottom
        menuModel: store.menuModel
        qualityModel: store.qualityModel
        controlModel: store.controlModel
        leftDoorOpened: root.store.leftDoorOpened
        rightDoorOpened: root.store.rightDoorOpened
        trunkOpened: root.store.trunkOpened
        qt3DStudioAvailable: root.store.qt3DStudioAvailable


        onLeftDoorClicked: root.store.setLeftDoor()
        onRightDoorClicked: root.store.setRightDoor()
        onTrunkClicked: root.store.setTrunk()
        onRoofOpenProgressChanged: root.store.setRoofOpenProgress(value)

        onRuntimeChanged: {
            vehicleProxyPanel.z = vehicleProxyPanel.parent.z + 1;
            vehicleProxyPanel.showBusyIndicator = true;
            root.currentRuntimeQt3D = qt3d;
        }

        onQualityChanged: {
            // check is needed to prevent segfault when signal is emitted during initialization
            if (root.store.model3DVersion !== quality) {
                var src = car3dPanelLoader.source
                vehicleProxyPanel.z = vehicleProxyPanel.parent.z + 1;
                vehicleProxyPanel.showBusyIndicator = true;
                car3dPanelLoader.setSource("")
                root.store.model3DVersion = quality;
                car3dPanelLoader.setSource(src)
            } else {
                allowToChange3DSettings = true;
            }
        }

    }
}
