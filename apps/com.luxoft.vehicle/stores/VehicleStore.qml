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
import QtApplicationManager.Application 2.0



QtObject {
    id: root

    property bool leftDoorOpened: false
    property bool rightDoorOpened: false
    property bool trunkOpened: false
    property real roofOpenProgress: 0.0
    property real cameraAngleView: 0.0
    property string model3DVersion: "optimized"
    property bool qt3DStudioAvailable: false
    property color vehicle3DstudioColor

    // here we use loader to prevent build failures in case when Qt3DStudio is not available in the libs
    property Loader qt3DStudioAvailableChecker: Loader {
        visible: false
        source: "../helpers/Qt3DStudioAvailable.qml"
        onLoaded: {
            root.qt3DStudioAvailable = true
            source = ""
        }
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
        intentIds: "vehicle-control"
        onRequestReceived: {
            var action  = request.parameters["action"];
            var side    = request.parameters["side"];
            var part    = request.parameters["part"];

            switch (part) {
                case "trunk":
                    if (action === "open") {
                        root.trunkOpened = true;
                        uiSettings.trunkOpen = true;
                    }
                    if (action === "close") {
                        root.trunkOpened = false;
                        uiSettings.trunkOpen = false;
                    }
                break; //trunk
                case "sunroof":
                    if (action === "open") {
                        root.roofOpenProgress = 1.0;
                        uiSettings.roofOpenProgress = 1.0;
                    }
                    if (action === "close") {
                        root.roofOpenProgress = 0.0;
                        uiSettings.roofOpenProgress = 0.0;
                    }
                break; //sunroof
                case "door":
                    if (side === "left") {
                        if (action === "open") {
                            root.leftDoorOpened = true;
                            uiSettings.door1Open = true;
                        }
                        if (action === "close") {
                            root.leftDoorOpened = false;
                            uiSettings.door1Open  = false;
                        }
                    }
                    if (side === "right") {
                        if (action === "open") {
                            root.rightDoorOpened = true;
                            uiSettings.door2Open  = true;
                        }
                        if (action === "close") {
                            root.rightDoorOpened = false;
                            uiSettings.door2Open  = false;
                        }
                    }
                break; //door
            }//switch
        }
    }

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
}
