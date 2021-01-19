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

    // This timer is used to make the order of creation transparent
    // 1) read settings (reread to be sure, it's a synch op), get chosen runtime
    // 2) load the chosen model
    Timer {
        id: delayTimer
        interval: 1
        running: true
        onTriggered: {
            store.read3DSettings();
            loadVehiclePanel();
        }
    }

    // This timer is a workaround to prevent 3DStudio presentation from too fast reload
    Timer {
        id: studioReloadTimer
        interval: 2000
        running: false
        onTriggered: {
            loadVehiclePanel();
        }
    }

    // we don't change visible manually, it is changed by sysui, when another app is called
    // or the same app is called again, even if it is maximized right now
    onVisibleChanged: {
        // the app was already launched and is restored (e.g. Vehicle -> Home -> Vehicle)
        if (root.store.runtime3D === "qt3d") {
            if (visible && !!vehicle3DPanelLoader.item) {
                // vehicle is loaded, but it is hidden (AUTOSUITE-1598)
                // we force redraw, to make it visible
                vehicle3DPanelLoader.item.forceRedraw();
            }
        } else if (root.store.runtime3D === "3DStudio") {
            if (!visible && !!vehicle3DPanelLoader.item) {
                vehicle3DPanelLoader.source = "" // force to remove current instance
            }

            if (visible) {
                vehicleProxyPanel.opacity = 1.0; // enable proxy with the progress bar
                studioReloadTimer.start();
            }
        }
    }

    function loadVehiclePanel() {
        vehicle3DPanelLoader.active = false;
        vehicle3DPanelLoader.setSource(
                store.runtime3D === "qt3d" || store.runtime3D === ""
                        ? "../panels/Vehicle3DPanel.qml" : "../panels/Vehicle3DStudioPanel.qml"
                , {
                        "leftDoorOpen": root.store.leftDoorOpened
                        , "rightDoorOpen": root.store.rightDoorOpened
                        , "trunkOpen": root.store.trunkOpened
                        , "roofOpenProgress": root.store.roofOpenProgress
                        , "lastCameraAngle": root.store.cameraAngleView
                        , "modelVersion": root.store.model3DVersion
                        , "vehicleColor": root.store.vehicle3DstudioColor
                });
        vehicle3DPanelLoader.active = store.allowOpenGLContent;
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
            function onLastCameraAngleChanged() {
                root.store.cameraAngleView = target.lastCameraAngle;
            }
        }

        VehicleProxyPanel {
            id: vehicleProxyPanel
            z: 9999
            visible: opacity != 0.0
            errorText: store.allowOpenGLContent
                ? ""
                : qsTr("The 3D car model is disabled in this runtime environment")
            Behavior on opacity {
                DefaultNumberAnimation {}
            }
        }

        Loader {
            id: vehicle3DPanelLoader
            anchors.fill: parent
            active: false
            asynchronous: true

            onItemChanged: {
                if (item) {
                    var currentRuntimeQt3D = store.runtime3D === "qt3d";
                    if (currentRuntimeQt3D) {
                        item.modelVersion = Qt.binding( function() {return root.store.model3DVersion});
                    } else {
                        item.vehicleColor = Qt.binding( function() {return root.store.vehicle3DstudioColor});
                    }

                    vehicleProxyPanel.opacity = Qt.binding(() => !!item && item.readyToChanges ? 0.0 : 1.0);

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
        roofOpenProgress: root.store.roofOpenProgress
        qt3DStudioAvailable: root.store.qt3DStudioAvailable

        enableOpacityMasks: store.allowOpenGLContent

        onLeftDoorClicked: root.store.setLeftDoor()
        onRightDoorClicked: root.store.setRightDoor()
        onTrunkClicked: root.store.setTrunk()
        onNewRoofOpenProgressRequested: root.store.setRoofOpenProgress(progress)

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
