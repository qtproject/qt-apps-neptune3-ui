/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 Cluster UI.
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
import QtQuick.Layouts 1.3
import "../controls" 1.0
import "../helpers" 1.0
import shared.Sizes 1.0
import Qt.SafeRenderer 1.1

Item {
    id: root

    //all sizes and positions are calculated from this width and height and fixed
    //no scaling is handled
    width: 1920
    height: 720

    //public
    property bool lowBeamHeadLightOn: true
    property bool highBeamHeadLightOn: true
    property bool fogLightOn: true
    property bool stabilityControlOn: true
    property bool seatBeltFastenOn: true
    property bool leftTurnOn: true
    property bool rightTurnOn: true
    property bool absFailureOn: true
    property bool parkingBrakeOn: true
    property bool lowTyrePressureOn: true
    property bool brakeFailureOn: true
    property bool airbagFailureOn: true
    property bool blinker: false

    Sizes.onScaleChanged: {
        //scaling is not handled by safe renderer ui part, but postion changes are passed,
        //on scaling (development purpose), safe telltales are hided on non-safe ui side
        if (Sizes.scale !== 1.0)
            root.opacity = 0.0;
        else
            root.opacity = 1.0;
    }

    //heartbeat timer, sends heartbeat with wait interval
    //on safe side if no more heartbeats got, error message appears,...
    Timer {
        repeat: true
        interval: 500
        running: true
        onTriggered: {
            SafeMessage.sendHeartBeat(1000)
        }
    }

    SafeText {
        objectName: "errorText"
        id: safeErrorText
        width: 800
        height: 100
        text: "Error occurred. Recovering..."
        color: "white"
        runtimeEditable: true
        font.bold: true
        font.pixelSize: 40
        font.family: "DejaVu Sans"
        visible: false
        anchors.centerIn: root
        horizontalAlignment: Text.AlignHCenter
    }

    Item {
        id: leftSafePart

        width: 960
        height: 720

        SafeText {
            id: speedLabel
            objectName: "speedTextLabel"
            width: 140
            height: 45
            text: "Speed"
            color: "white"
            font.bold: true
            font.pixelSize: 40
            font.family: "DejaVu Sans"
            visible: false
            horizontalAlignment: Text.AlignHCenter
            x: 221
            y: 288
        }

        SafeText {
            objectName: "speedText"
            id: safeSpeedText
            width: 190
            height: 90
            text: "0"
            color: "white"
            runtimeEditable: true
            font.bold: true
            font.pixelSize: 80
            font.family: "DejaVu Sans"
            visible: false
            horizontalAlignment: Text.AlignHCenter
            x: 191
            y: 347
        }

        SafeText {
            objectName: "speedUnitsText"
            width: 110
            height: 45
            color: "white"
            font.bold: true
            font.pixelSize: 40
            font.family: "DejaVu Sans"
            text: "km/h"
            visible: false
            horizontalAlignment: Text.AlignHCenter
            x: 248
            y: 446
        }

        Row{
            id: leftRow
            width: 444
            height: 58
            x: 219
            y: 23
            spacing: 22
            LayoutMirroring.enabled: false

            SafeImage {
                objectName: "telltalesLowBeam"
                width: 42
                height: 32
                opacity: root.lowBeamHeadLightOn ? 1 : 0
                source: "../assets/telltales/ic-low-beam.png"
                anchors.verticalCenter: parent.verticalCenter
            }

            SafeImage {
                objectName: "telltalesHighBeam"
                width: 42
                height: 27
                opacity: root.highBeamHeadLightOn ? 1 : 0
                source: "../assets/telltales/ic-high-beam.png"
                anchors.verticalCenter: parent.verticalCenter
            }

            SafeImage {
                objectName: "telltalesFogLights"
                width: 34
                height: 34
                opacity:  root.fogLightOn ? 1 : 0
                source: "../assets/telltales/ic-fog-lights.png"
                anchors.verticalCenter: parent.verticalCenter
            }

            SafeImage {
                objectName: "telltalesStabilityControl"
                width: 30
                height: 33
                opacity: root.stabilityControlOn ? 1 : 0
                source: "../assets/telltales/ic-stability-control.png"
                anchors.verticalCenter: parent.verticalCenter
            }

            SafeImage {
                objectName: "telltalesSeatBelt"
                width: 25
                height: 35
                opacity: root.seatBeltFastenOn ? 1 : 0
                source: "../assets/telltales/ic-seat-belt.png"
                anchors.verticalCenter: parent.verticalCenter
            }

            SafeImage {
                objectName: "telltalesLeftTurn"
                width: 53
                height: 48
                opacity: blinker && root.leftTurnOn ? 1 : 0
                source: "../assets/telltales/ic-left-turn.png"
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    Item {
        id: rightSafePart

        x: 960
        width: 960
        height: 720

        SafeText {
            id: powerLabel
            objectName: "powerTextLabel"
            width: 140
            height: 45
            text: "Power"
            color: "white"
            font.bold: true
            font.pixelSize: 40
            font.family: "DejaVu Sans"
            visible: false
            horizontalAlignment: Text.AlignHCenter
            x: 609
            y: 277

        }

        SafeText {
            objectName: "powerText"
            id: safePowerText
            width: 190
            height: 90
            text: "0"
            color: "white"
            runtimeEditable: true
            font.bold: true
            font.pixelSize: 80
            font.family: "DejaVu Sans"
            visible: false
            horizontalAlignment: Text.AlignHCenter
            x: 576
            y: 336

        }

        SafeText {
            objectName: "powerUnitsText"
            id: powerUnitsText
            width: 100
            height: 45
            color: "white"
            font.bold: true
            font.pixelSize: 40
            font.family: "DejaVu Sans"
            text: "%"
            visible: false
            horizontalAlignment: Text.AlignHCenter
            x: 629
            y: 435
        }

        Row {
            id: rightRow
            anchors.left: rightSafePart.left
            anchors.leftMargin: 405
            width: 444
            height: 58
            y: 23
            spacing: 22
            LayoutMirroring.enabled: false

            SafeImage {
                width: 53
                height: 48
                objectName: "telltalesRightTurn"
                opacity: blinker && root.rightTurnOn ? 1 : 0
                source: "../assets/telltales/ic-right-turn.png"
                anchors.verticalCenter: parent.verticalCenter
            }

            SafeImage {
                width: 40
                height: 30
                objectName: "telltalesAbsFault"
                opacity: root.absFailureOn ? 1 : 0
                source: "../assets/telltales/ic-abs-fault.png"
                anchors.verticalCenter: parent.verticalCenter
            }

            SafeImage {
                width: 40
                height: 30
                objectName: "telltalesParkingBrake"
                opacity: root.parkingBrakeOn ? 1 : 0
                source: "../assets/telltales/ic-parking-brake.png"
                anchors.verticalCenter: parent.verticalCenter
            }

            SafeImage {
                width: 34
                height: 30
                objectName: "telltalesTyrePressure"
                opacity: root.lowTyrePressureOn ? 1 : 0
                source: "../assets/telltales/ic-tire-pressure.png"
                anchors.verticalCenter: parent.verticalCenter
            }

            SafeImage {
                width: 40
                height: 30
                objectName: "telltalesBrakeFault"
                opacity: root.brakeFailureOn ? 1 : 0
                source: "../assets/telltales/ic-brake-fault.png"
                anchors.verticalCenter: parent.verticalCenter
            }

            SafeImage {
                width: 35
                height: 34
                objectName: "telltalesAirbag"
                opacity: root.airbagFailureOn ? 1 : 0
                source: "../assets/telltales/ic-airbag.png"
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}

