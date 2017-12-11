/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Triton Cluster UI.
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

import QtQuick 2.9
import QtQuick.Controls 1.4

Item {
    id: root
    width: 560
    height: width

    onEPowerChanged: {
         dialFrame.highLightAng = d.power2Angle(ePower);
    }

    //public
    property int ePower
    property string drivetrain : "PRND"

    //public functions
    function state2begin() {
        if (state === "stopped") {
            dialFrame.state2begin();
            state = "normal";
        }
    }
    function state2Navigation() {
        if (state === "normal") {
            dialFrame.state2Navigation();
            state = "navi";
        }
    }
    function state2Normal() {
        if (state === "navi") {
            dialFrame.state2Normal();
            state = "normal";
        }
    }
    function state2end() {
        if (state === "normal" || state === "navi"){
            dialFrame.state2end();
            state = "stopped";
        }
    }

    //private
    Item {
        id: d
        property real scaleRatio: Math.min(parent.width / 560, parent.height / 560 )

        function power2Angle(power) {
            if (power < -25) {
                return -210;
            } else if (power <= 0) {
                //-25 to 0 %
                //map to -210degree to -180degree
                return ((power + 25) / 25 * 30 - 210);
            } else if (power <= 100) {
                //0 to 100 %
                //map to -180degree to 0degree
                return ((power) / 100 * 180 - 180);
            } else {
                return 0;
            }
        }
    }

    //states and transitions
    state: "stopped"
    states: [
        State {
            name: "stopped"
            PropertyChanges { target: scaleEnergyArea; opacity: 0 }
            PropertyChanges { target: graduation; opacity: 0; maxDrawValue: -25 }
            PropertyChanges { target: graduationNumber; opacity: 0 }
            PropertyChanges { target: indicatorDrivetrain; opacity: 0 }
            PropertyChanges { target: indicatorEPower; opacity: 0 }
            PropertyChanges { target: signBattery; opacity: 0 }
            PropertyChanges { target: signBatteryRemain; opacity: 0 }
            PropertyChanges { target: signChargeStation; opacity: 0 }
            PropertyChanges { target: signKM; opacity: 0 }
            PropertyChanges { target: signKMRemain; opacity: 0 }
            PropertyChanges { target: signPower; opacity: 0 }
        },
        State {
            name: "normal"
            PropertyChanges { target: scaleEnergyArea; opacity: 1 }
            PropertyChanges { target: graduation; opacity: 1; maxDrawValue: 105 }
            PropertyChanges { target: graduationNumber; opacity:  0.6 }
            PropertyChanges { target: indicatorDrivetrain; opacity: 0.4 }
            PropertyChanges { target: indicatorEPower; opacity: 0.94 }
            PropertyChanges { target: signBattery; opacity: 1; x: 176 * d.scaleRatio; y: 483 * d.scaleRatio }
            PropertyChanges { target: signBatteryRemain; opacity: 0.94 }
            PropertyChanges { target: signChargeStation; opacity: 1 }
            PropertyChanges { target: signKM; opacity: 0.4 }
            PropertyChanges { target: signKMRemain; opacity: 0.94 }
            PropertyChanges { target: signPower; opacity: 0.4 }
        },
        State {
            name: "navi"
            PropertyChanges { target: scaleEnergyArea; opacity: 0 }
            PropertyChanges { target: graduation; opacity: 0; maxDrawValue: 105 }
            PropertyChanges { target: graduationNumber; opacity: 0 }
            PropertyChanges { target: indicatorDrivetrain; opacity: 0.4 }
            PropertyChanges { target: indicatorEPower; opacity: 0.94 }
            PropertyChanges { target: signBattery; opacity: 1; x: 210 * d.scaleRatio; y: 380 * d.scaleRatio }
            PropertyChanges { target: signBatteryRemain; opacity: 0 }
            PropertyChanges { target: signChargeStation; opacity: 0 }
            PropertyChanges { target: signKM; opacity: 0.4; x: 330 * d.scaleRatio; y: 375 * d.scaleRatio }
            PropertyChanges { target: signKMRemain; opacity: 0.94; x: 260 * d.scaleRatio; y: 365 * d.scaleRatio }
            PropertyChanges { target: signPower; opacity: 0.4 }
        }
    ]

    transitions: [
        Transition {
            from: "stopped"
            to: "normal"
            reversible: false
            SequentialAnimation{
                //wait DialFrame to start
                PauseAnimation { duration: 270 }
                PropertyAnimation { targets: [scaleEnergyArea, graduation, graduationNumber]; property: "opacity"; duration: 100 }
                PropertyAnimation { target: graduation; property: "maxDrawValue"; duration: 540 }
                PropertyAnimation {
                    targets: [indicatorDrivetrain, indicatorEPower, signBattery, signBatteryRemain, signChargeStation, signKM, signKMRemain, signPower]
                    property: "opacity"
                    duration: 200
                }
                PropertyAnimation { target: root; property: "ePower"; to: 100; duration: 540 }
                PropertyAnimation { target: root; property: "ePower"; to: 0; duration: 540 }
            }
        },
        Transition {
            from: "normal"
            to: "stopped"
            reversible: false
            SequentialAnimation{
                PropertyAnimation { targets: [scaleEnergyArea, graduation, graduationNumber]; property: "opacity"; duration: 100 }
                PropertyAnimation { target: graduation; property: "maxDrawValue"; duration: 540 }
                PropertyAnimation {
                    targets: [indicatorDrivetrain, indicatorEPower, signBattery, signBatteryRemain, signChargeStation, signKM, signKMRemain, signPower]
                    property: "opacity"
                    duration: 200
                }
            }
        },
        Transition {
            from: "normal"
            to: "navi"
            reversible: true
            SequentialAnimation{
                PropertyAnimation { targets: [scaleEnergyArea, graduation, graduationNumber]; property: "opacity"; duration: 100 }
                PropertyAnimation {
                    targets: [indicatorDrivetrain, indicatorEPower, signBattery, signBatteryRemain, signChargeStation, signKM, signKMRemain, signPower]
                    properties: "opacity, x, y"
                    duration: 200
                }
                //wait DialFrame to expand
                PauseAnimation { duration: 300 }
            }
        },
        Transition {
            from: "navi"
            to: "stopped"
            reversible: false
            SequentialAnimation{
                PropertyAnimation { targets: [scaleEnergyArea, graduation, graduationNumber]; property: "opacity"; duration: 100 }
                PropertyAnimation {
                    targets: [indicatorDrivetrain, indicatorEPower, signBattery, signBatteryRemain, signChargeStation, signKM, signKMRemain, signPower]
                    properties: "opacity, x, y"
                    duration: 200
                }
            }
        }
    ]

    //visual components
    DialFrame {
        id: dialFrame
        anchors.centerIn: parent
        width: 560 * d.scaleRatio
        height: width
        minAng: -210
        maxAng: 0
        zeroAng: -180
    }

    Image {
        id: scaleEnergyArea
        x: 31 * d.scaleRatio
        y: 107 * d.scaleRatio
        width: 71 * d.scaleRatio
        height: 294 * d.scaleRatio
        source: "./img/dial-energy-areas.png"
    }

    Text {
        id: indicatorDrivetrain
        x: 260 * d.scaleRatio
        y: 165 * d.scaleRatio
        width: 40 * d.scaleRatio
        text: drivetrain
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignHCenter
        font.family: "Open Sans Light"
        color: "black"
        opacity: 0.4
        font.pixelSize: 34 * d.scaleRatio
    }

    Text {
        id: indicatorEPower
        x: 265 * d.scaleRatio
        y: 222 * d.scaleRatio
        width: 40 * d.scaleRatio
        text: Math.round(ePower)
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignHCenter
        font.family: "Open Sans SemiBold"
        color: "black"
        opacity: 0.94
        font.pixelSize: 80 * d.scaleRatio
    }

    Text {
        id: signPower
        x: 248 * d.scaleRatio
        y: 324 * d.scaleRatio
        text: qsTr("% power")
        font.family: "Open Sans Light"
        color: "black"
        opacity: 0.4
        font.pixelSize: 18 * d.scaleRatio
    }

    Text {
        id: signKM
        x: 272 * d.scaleRatio
        y: 445 * d.scaleRatio
        text: qsTr("km")
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignHCenter
        font.family: "Open Sans Light"
        color: "black"
        opacity: 0.4
        font.pixelSize: 18 * d.scaleRatio
    }

    Image {
        id: signBattery
        x: 176 * d.scaleRatio
        y: 483 * d.scaleRatio
        width: 23 * d.scaleRatio
        height: 14 * d.scaleRatio
        source: "./img/ic-battery.png"
    }

    Text {
        id: signKMRemain
        x: 207 * d.scaleRatio
        y: 464 * d.scaleRatio
        text: "184"
        font.family: "open sans"
        color: "black"
        opacity: 0.94
        font.pixelSize: 34 * d.scaleRatio
    }

    Text {
        id: signBatteryRemain
        x: 303 * d.scaleRatio
        y: 464 * d.scaleRatio
        text: "21"
        font.family: "open sans"
        color: "black"
        opacity: 0.94
        font.pixelSize: 34 * d.scaleRatio
    }

    Image {
        id: signChargeStation
        x: 353 * d.scaleRatio
        y: 477 * d.scaleRatio
        width: 24 * d.scaleRatio
        height: 21 * d.scaleRatio
        source: "./img/ic-chargingstation.png"
    }

//    Repeater{
//        id: graduation
//        anchors.centerIn: parent
//        width: 520 * d.scaleRatio
//        height: width

//        //size and layout
//        property real radius: (graduation.width / 2) - 16 * d.scaleRatio
//        property real centerX: graduation.width / 2 * 1.075
//        property real centerY: graduation.height / 2 * 1.075

//        //for startup animation
//        property int maxDrawValue: -25

//        model: [-25, 0, 25, 50, 75, 100]
//        delegate: Rectangle {
//            property int value: modelData
//            property int angle: d.power2Angle(value)
//            property real radin: angle / 180 * Math.PI

//            x: graduation.centerX + Math.cos(radin) * graduation.radius + Math.sin(radin) * height / 2
//            y: graduation.centerY + Math.sin(radin) * graduation.radius + Math.cos(radin) * height / 2
//            width: 8 * d.scaleRatio
//            height: 2 * d.scaleRatio
//            visible: (value < graduation.maxDrawValue) ? true : false

//            color: "#916E51"
//            opacity: graduation.opacity
//            transformOrigin: Item.TopLeft
//            rotation: angle
//        }
//    }

    Repeater{
        id: graduationNumber
        anchors.centerIn: parent
        width: 520 * d.scaleRatio
        height: width
        opacity: 0.6

        //size and layout
        property real radius: width / 2 - 50 * d.scaleRatio
        property real centerX: width / 2
        property real centerY: height / 2

        model: [0, 25, 50, 75, 100]
        delegate: Label {
            property int angle: d.power2Angle(modelData)
            property real radin: angle / 180 * Math.PI

            text: modelData
            x: graduationNumber.centerX + Math.cos(radin) * graduationNumber.radius
            y: graduationNumber.centerY + Math.sin(radin) * graduationNumber.radius
            visible: (modelData < graduation.maxDrawValue) ? true : false

            color: "black"
            opacity: graduationNumber.opacity
            font.family: "Open Sans"
            font.weight: Font.Light
            font.pixelSize: 22 * d.scaleRatio
        }
    }

    Canvas {
        id: graduation
        anchors.centerIn: parent
        width: 520 * d.scaleRatio
        height: width
        renderTarget: Canvas.FramebufferObject

        property real radius: graduation.width / 2
        property real centerX: graduation.width / 2
        property real centerY: graduation.height / 2
        property real scaleLineLength: 8 * d.scaleRatio
        property real scaleLineWidth: 2 * d.scaleRatio
        property real scaleLineBlank: 8 * d.scaleRatio

        //for startup animation
        property int maxDrawValue: 100
        onMaxDrawValueChanged: {
            requestPaint();
        }
        Component.onCompleted: {
            requestPaint();
        }

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, graduation.width, graduation.height);
            ctx.globalCompositeOperation = "source-over";

            ctx.beginPath();
            ctx.lineWidth = scaleLineWidth;
            ctx.strokeStyle = "#916E51";

            var radin;
            for (var i = -25; i <= maxDrawValue && i <= 100; i += 25) {
                radin = d.power2Angle(i) / 180 * Math.PI;
                ctx.moveTo(
                        centerX + Math.cos(radin) * (radius - scaleLineBlank - scaleLineLength),
                        centerY + Math.sin(radin) * (radius - scaleLineBlank - scaleLineLength));
                ctx.lineTo(
                        centerX + Math.cos(radin) * (radius - scaleLineBlank),
                        centerY + Math.sin(radin) * (radius - scaleLineBlank));
            }
            ctx.stroke();
        }
    }
}
