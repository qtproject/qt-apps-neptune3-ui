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

import QtQuick 2.8
import shared.com.pelagicore.remotesettings 1.0
import shared.com.pelagicore.drivedata 1.0
import shared.com.pelagicore.systeminfo 1.0
import QtApplicationManager.Application 2.0
import QtApplicationManager 2.0
import Qt.labs.settings 1.0

QtObject {
    id: root

    property bool leftDoorOpened: false
    property bool rightDoorOpened: false
    property bool trunkOpened: false
    property real roofOpenProgress: 0.0
    property real cameraAngleView: 0.0
    property string model3DVersion: ""
    property string runtime3D: ""
    property bool qt3DStudioAvailable: false
    property color vehicle3DstudioColor

    readonly property SystemInfo systemInfo: SystemInfo {}
    // here we use loader to prevent build failures in case
    // when Qt3DStudio is not available in the libs
    property Loader qt3DStudioAvailableChecker: Loader {
        visible: false
        source: "../helpers/Qt3DStudioAvailable.qml"
        onLoaded: {
            root.qt3DStudioAvailable = systemInfo.allow3dStudioPresentations
            source = ""
        }
    }

    readonly property bool allowOpenGLContent: systemInfo.allowOpenGLContent

    property Settings settings3D : Settings {}
    function setRuntime(runtime) {
        settings3D.setValue("runtime3D", runtime);
        settings3D.sync();
    }
    function setModelQuality(version) {
        settings3D.setValue("modelQuality", version);
        settings3D.sync();
    }
    function read3DSettings() {
        root.model3DVersion = settings3D.value("modelQuality", "optimized");
        var runtime = settings3D.value("runtime3D", "qt3d");
        if (!root.qt3DStudioAvailable) {
            settings3D.setValue("runtime3D", "qt3d");
            root.runtime3D = "qt3d";
        } else {
            root.runtime3D = runtime;
        }
    }
    function showNotificationAboutChange() {
        var notification = ApplicationInterface.createNotification();
        notification.body = qsTr("Please restart the Vehicle App to use selected runtime");
        notification.summary = settings3D.value("runtime3D", "qt3d") === "qt3d"
                ? qsTr("Qt3D Runtime is requested")
                : qsTr("Qt 3D Studio Runtime is requested");
        notification.sticky = true;
        notification.show();
    }

    property real speed: cluster.speed

    property ListModel controlModel : ListModel {
        ListElement { name: QT_TR_NOOP("Fees"); active: false; icon: "fees" }
        ListElement { name: QT_TR_NOOP("Hill Descent Control"); active: true; icon: "hill-descent-control" }
        ListElement { name: QT_TR_NOOP("Traffic Jam Assist"); active: false; icon: "traffic-jam-assist" }
        ListElement { name: QT_TR_NOOP("Intelligent speed adaptation"); active: false; icon: "intelligent-speed-adaptation" }
        ListElement { name: QT_TR_NOOP("Fees"); active: true; icon: "fees" }
        ListElement { name: QT_TR_NOOP("Hill Descent Control"); active: false; icon: "hill-descent-control" }
        ListElement { name: QT_TR_NOOP("Traffic Jam Assist"); active: false; icon: "traffic-jam-assist" }
    }

    property ListModel menuModel : ListModel {
        ListElement { icon: "ic-driving-support"; text: QT_TRANSLATE_NOOP("VehicleToolsColumn", "support"); objectName: "vehicleViewToolButton_support" }
        ListElement { icon: "ic-energy"; text: QT_TRANSLATE_NOOP("VehicleToolsColumn", "energy"); objectName: "vehicleViewToolButton_energy" }
        ListElement { icon: "ic-doors"; text: QT_TRANSLATE_NOOP("VehicleToolsColumn", "doors && <br/>sunroof"); objectName: "vehicleViewToolButton_doors" }
        ListElement { icon: "ic-tires"; text: QT_TRANSLATE_NOOP("VehicleToolsColumn", "tires"); objectName: "vehicleViewToolButton_tires" }
        ListElement { icon: "ic-3d-settings"; text: QT_TRANSLATE_NOOP("VehicleToolsColumn", "options"); objectName: "vehicleViewToolButton_options" }
    }

    property ListModel qualityModel : ListModel {
        ListElement { name: QT_TR_NOOP("High"); quality: "original" }
        ListElement { name: QT_TR_NOOP("Medium"); quality: "optimized" }
        ListElement { name: QT_TR_NOOP("Low"); quality: "mixedFormats" }
    }


    property UISettings uiSettings: UISettings {
        onDoor1OpenChanged: {
            root.leftDoorOpened = uiSettings.door1Open
        }
        onDoor2OpenChanged: {
            root.rightDoorOpened = uiSettings.door2Open
        }
        onTrunkOpenChanged: {
            root.trunkOpened = uiSettings.trunkOpen
        }
        onRoofOpenProgressChanged: {
            root.roofOpenProgress = uiSettings.roofOpenProgress
        }
    }

    property InstrumentCluster cluster: InstrumentCluster { id: cluster }

    readonly property IntentHandler intentHandler: IntentHandler {
        intentIds: ["vehicle-control", "activate-app"]
        onRequestReceived: {
            switch (request.intentId) {
            case "vehicle-control":
                var action  = request.parameters["action"];
                var side    = request.parameters["side"];
                var part    = request.parameters["part"];

                switch (part) {
                    case "trunk":
                        if (action === "open") {
                            uiSettings.trunkOpen = true;
                        } else if (action === "close") {
                            uiSettings.trunkOpen = false;
                        }
                        break; //trunk
                    case "sunroof":
                        if (action === "open") {
                            uiSettings.roofOpenProgress = 1.0;
                        } else if (action === "close") {
                            uiSettings.roofOpenProgress = 0.0;
                        }
                        break; //sunroof
                    case "door":
                        if (side === "left") {
                            if (action === "open") {
                                uiSettings.door1Open = true;
                            } else if (action === "close") {
                                uiSettings.door1Open  = false;
                            }
                        } else if (side === "right") {
                            if (action === "open") {
                                uiSettings.door2Open  = true;
                            } else if (action === "close") {
                                uiSettings.door2Open  = false;
                            }
                        }
                        break; //door
                    default:
                        break;
                } //switch part

                root.requestRaiseAppReceived();
                request.sendReply({ "done": true })
                break;
            case "activate-app":
                root.requestRaiseAppReceived();
                request.sendReply({ "done": true })
                break;
            default:
                break;
            } //switch intent id
        }
    }

    signal requestRaiseAppReceived()

    function setTrunk() {
        if (root.trunkOpened) {
            root.trunkOpened = false;
            uiSettings.trunkOpen = false;
        } else {
            root.trunkOpened = true;
            uiSettings.trunkOpen = true;
        }
    }

    function setLeftDoor() {
        if (root.leftDoorOpened) {
            root.leftDoorOpened = false;
            uiSettings.door1Open = root.leftDoorOpened;
        } else {
            root.leftDoorOpened = true;
            uiSettings.door1Open = root.leftDoorOpened;
        }
    }

    function setRightDoor() {
        if (root.rightDoorOpened) {
            root.rightDoorOpened = false;
            uiSettings.door2Open = root.rightDoorOpened;
        } else {
            root.rightDoorOpened = true;
            uiSettings.door2Open = root.rightDoorOpened;
        }
    }

    function setRoofOpenProgress(value) {
        root.roofOpenProgress = value;
        uiSettings.roofOpenProgress = value;
    }

    function createIntentToMap(intentId, params) {
        IntentClient.sendIntentRequest(intentId, "com.pelagicore.map", params);
    }
}
