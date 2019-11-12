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
import "../helpers"  1.0

Item {
    id: root

    property VehicleStore store
    Timer {
        id: delayTimer
        interval: 1
        running: true
        onTriggered: {
            store.read3DSettings();
            loadVehiclePanel();
        }
    }

    onVisibleChanged: {
        if (!visible) {
            vehicle3DPanelLoader.active = false;
        } else {
            if (!delayTimer.running && !vehicle3DPanelLoader.active)
                loadVehiclePanel();
        }
    }

    function loadVehiclePanel() {
        vehicle3DPanelLoader.active = false;
        vehicle3DPanelLoader.setSource(
                store.runtime3D === "qt3d" || store.runtime3D === ""
                        ? "../panels/Vehicle3DPanel.qml" : "../panels/Vehicle3DStudioPanel.qml"
                , {
                        "leftDoorOpen": root.store.leftDoorOpened
                        , "rightDoorOpen": root.store.rightDoorOpen
                        , "trunkOpen": root.store.trunkOpen
                        , "roofOpenProgress": root.store.roofOpenProgress
                        , "lastCameraAngle": root.store.lastCameraAngle
                        , "modelVersion": root.store.modelVersion
                        , "vehicleColor": root.store.vehicle3DstudioColor
                });
        vehicle3DPanelLoader.active = true;
    }

    Item {
        id: car3dPanel
        anchors.top: root.top
        anchors.left: root.left
        anchors.right: root.right
        height: Sizes.dp(652)

        // at the application startup it doesn't receive full screen window,
        // in that moment the car model is scaled awfully, so we wait till the app window is rescaled properly
        visible: parent.height > 2 * Sizes.dp(652)

        Image {
            anchors.fill: parent
            source: Paths.getImagePath("sceneBackground.png")
        }

        Connections {
            target: vehicle3DPanelLoader.item
            onLastCameraAngleChanged: root.store.cameraAngleView = target.lastCameraAngle
        }

        VehicleProxyPanel {
            id: vehicleProxyPanel
            z: 9999
        }

        // In some cases Scene3D doesn't create anything, such cases are really hard to reproduce,
        // in these situations UI is frozen, timer is used to check that rendering is started
        Timer {
            id: reloadTimer
            interval: 30000
            onTriggered: {
                // if after 30s qt3d scene doesn't respond even with first frame we try to reload it
                if (store.runtime3D === "qt3d" && !vehicle3DPanelLoader.item.renderStarted) {
                    vehicle3DPanelLoader.active = false;
                    vehicle3DPanelLoader.setSource("");
                    vehicle3DPanelLoader.active = true;
                    loadVehiclePanel();
                }
            }
        }

        Loader {
            id: vehicle3DPanelLoader
            anchors.fill: parent
            active: false
            opacity: active ? 1.0 : 0.0
            asynchronous: true
            Behavior on opacity {
                DefaultNumberAnimation {}
            }

            onItemChanged: {
                if (item) {
                    var currentRuntimeQt3D = store.runtime3D === "qt3d";
                    reloadTimer.running = currentRuntimeQt3D;
                    if (currentRuntimeQt3D) {
                        item.modelVersion = Qt.binding( function() {return root.store.model3DVersion});
                        reloadTimer.running = Qt.binding( function() {return item ? !item.renderStarted : false} );
                    } else {
                        item.vehicleColor = Qt.binding( function() {return root.store.vehicle3DstudioColor});
                        reloadTimer.stop();
                    }

                    vehicleProxyPanel.visible = Qt.binding( function() {return !item.readyToChanges} );

                    item.leftDoorOpen = Qt.binding( function() {return root.store.leftDoorOpened} );
                    item.rightDoorOpen = Qt.binding( function() {return root.store.rightDoorOpened});
                    item.trunkOpen = Qt.binding( function() {return  root.store.trunkOpened});
                    item.roofOpenProgress = Qt.binding( function() {return root.store.roofOpenProgress});
                    item.lastCameraAngle = root.store.cameraAngleView;
                }
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
        menuModel: root.store.menuModel
        qualityModel: root.store.qualityModel
        quality: root.store.model3DVersion
        controlModel: root.store.controlModel
        runtime: root.store.runtime3D
        leftDoorOpened: root.store.leftDoorOpened
        rightDoorOpened: root.store.rightDoorOpened
        trunkOpened: root.store.trunkOpened
        qt3DStudioAvailable: root.store.qt3DStudioAvailable


        onLeftDoorClicked: root.store.setLeftDoor()
        onRightDoorClicked: root.store.setRightDoor()
        onTrunkClicked: root.store.setTrunk()
        onRoofOpenProgressChanged: root.store.setRoofOpenProgress(value)

        onRuntimeChanged: { root.store.setRuntime(runtime); }

        onQualityChanged: {
            if (root.store.model3DVersion !== quality) {
                root.store.model3DVersion = quality;
                root.store.setModelQuality(quality);
            }
        }

        onShowNotificationAboutChange: store.showNotificationAboutChange()
        onIntentToMapRequested: { root.store.createIntentToMap(intentId, params) }
    }
}
