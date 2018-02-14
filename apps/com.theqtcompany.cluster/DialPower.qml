/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Copyright (C) 2018 Pelagicore AG
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

import com.pelagicore.styles.triton 1.0

Item {
    id: root
    width: 560
    height: width

    //public
    property int ePower
    property int drivetrain : 0

    //private
    QtObject {
        id: d
        readonly property real scaleRatio: Math.min(root.width / 560, root.height / 560 )

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

        property int ePowerOverride
        property bool overrideEPower: false
        readonly property int ePower: overrideEPower ? ePowerOverride : root.ePower

        readonly property string sourceSuffix: root.TritonStyle.theme === TritonStyle.Dark ? "-dark.png" : ".png"
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
            PropertyChanges { target: signBattery; opacity: 0; x: 176 * d.scaleRatio; y: 483 * d.scaleRatio }
            PropertyChanges { target: signBatteryRemain; opacity: 0 }
            PropertyChanges { target: signChargeStation; opacity: 0 }
            PropertyChanges { target: signKM; opacity: 0; x: 272 * d.scaleRatio; y: 445 * d.scaleRatio }
            PropertyChanges { target: signKMRemain; opacity: 0; x: 207 * d.scaleRatio; y: 464 * d.scaleRatio }
            PropertyChanges { target: signPower; opacity: 0 }
        },
        State {
            name: "normal"
            PropertyChanges { target: scaleEnergyArea; opacity: 1 }
            PropertyChanges { target: graduation; opacity: 1; maxDrawValue: 105 }
            PropertyChanges { target: graduationNumber; opacity:  0.6 }
            PropertyChanges { target: indicatorDrivetrain; opacity: 1 }
            PropertyChanges { target: indicatorEPower; opacity: 0.94 }
            PropertyChanges { target: signBattery; opacity: 1; x: 176 * d.scaleRatio; y: 483 * d.scaleRatio }
            PropertyChanges { target: signBatteryRemain; opacity: 0.94 }
            PropertyChanges { target: signChargeStation; opacity: 1 }
            PropertyChanges { target: signKM; opacity: 0.4; x: 272 * d.scaleRatio; y: 445 * d.scaleRatio }
            PropertyChanges { target: signKMRemain; opacity: 0.94; x: 207 * d.scaleRatio; y: 464 * d.scaleRatio }
            PropertyChanges { target: signPower; opacity: 0.4 }
        },
        State {
            name: "navi"
            PropertyChanges { target: scaleEnergyArea; opacity: 0 }
            PropertyChanges { target: graduation; opacity: 0; maxDrawValue: 105 }
            PropertyChanges { target: graduationNumber; opacity: 0 }
            PropertyChanges { target: indicatorDrivetrain; opacity: 1 }
            PropertyChanges { target: indicatorEPower; opacity: 0.94 }
            PropertyChanges { target: signBattery; opacity: 1; x: 210 * d.scaleRatio; y: 380 * d.scaleRatio }
            PropertyChanges { target: signBatteryRemain; opacity: 0 }
            PropertyChanges { target: signChargeStation; opacity: 0 }
            PropertyChanges { target: signKM; opacity: 0.4; x: 330 * d.scaleRatio; y: 375 * d.scaleRatio }
            PropertyChanges { target: signKMRemain; opacity: 0.94; x: 250 * d.scaleRatio; y: 362 * d.scaleRatio }
            PropertyChanges { target: signPower; opacity: 0.4 }
        }
    ]

    transitions: [
        Transition {
            from: "stopped"
            to: "*"
            reversible: false
            SequentialAnimation{
                //wait DialFrame to start (1600ms)
                PauseAnimation { duration: 1600 }
                //fade in (640ms)
                PropertyAnimation { targets: [scaleEnergyArea, graduation, graduationNumber]; property: "opacity"; duration: 130 }
                PropertyAnimation { target: graduation; property: "maxDrawValue"; duration: 370 }
                PropertyAnimation {
                    targets: [indicatorDrivetrain, indicatorEPower, signBattery, signBatteryRemain, signChargeStation, signKM, signKMRemain, signPower]
                    property: "opacity"
                    duration: 140
                }

                //test the highLight
                ScriptAction { script: {
                    d.ePowerOverride = 0;
                    d.overrideEPower = true;
                }}
                PropertyAnimation { target: d; property: "ePowerOverride"; to: 100; duration: 540 }
                PropertyAnimation { target: d; property: "ePowerOverride"; to: 0; duration: 540 }
                PropertyAnimation { target: d; property: "ePowerOverride"; to: root.ePower; duration: 540 }
                ScriptAction { script: {
                    d.overrideEPower = false;
                }}
            }
        },
        Transition {
            from: "normal"
            to: "stopped"
            reversible: false
            SequentialAnimation{
                //fade out (390ms)
                PropertyAnimation {
                    targets: [indicatorDrivetrain, indicatorEPower, signBattery, signBatteryRemain, signChargeStation, signKM, signKMRemain, signPower]
                    property: "opacity"
                    duration: 130
                }
                PropertyAnimation { target: graduation; property: "maxDrawValue"; duration: 130 }
                PropertyAnimation { targets: [scaleEnergyArea, graduation, graduationNumber]; property: "opacity"; duration: 130 }
            }
        },
        Transition {
            from: "normal"
            to: "navi"
            reversible: false
            SequentialAnimation{
                //fade out (160ms)
                PropertyAnimation { targets: [scaleEnergyArea, graduation, graduationNumber]; property: "opacity"; duration: 80 }
                PropertyAnimation {
                    targets: [indicatorDrivetrain, indicatorEPower, signBattery, signBatteryRemain, signChargeStation, signKM, signKMRemain, signPower]
                    property: "opacity"
                    to: 0
                    duration: 80
                }
                //wait DialFrame to shrink(160ms)
                PropertyAnimation {
                    targets: [indicatorDrivetrain, indicatorEPower, signBattery, signBatteryRemain, signChargeStation, signKM, signKMRemain, signPower]
                    properties: "x,y"
                    duration: 160
                }
                //fade in (160ms)
                PropertyAnimation {
                    targets: [indicatorDrivetrain, indicatorEPower, signBattery, signBatteryRemain, signChargeStation, signKM, signKMRemain, signPower]
                    property: "opacity"
                    duration: 130
                }
            }
        },
        Transition {
            from: "navi"
            to: "normal"
            reversible: false
            SequentialAnimation{
                //fade out (160ms)
                PropertyAnimation {
                    targets: [indicatorDrivetrain, indicatorEPower, signBattery, signBatteryRemain, signChargeStation, signKM, signKMRemain, signPower]
                    property: "opacity"
                    to: 0
                    duration: 160
                }
                //wait DialFrame to expand(160ms)
                PropertyAnimation {
                    targets: [indicatorDrivetrain, indicatorEPower, signBattery, signBatteryRemain, signChargeStation, signKM, signKMRemain, signPower]
                    properties: "x,y"
                    duration: 160
                }
                //fade in (160ms)
                PropertyAnimation { targets: [scaleEnergyArea, graduation, graduationNumber]; property: "opacity"; duration: 80 }
                PropertyAnimation {
                    targets: [indicatorDrivetrain, indicatorEPower, signBattery, signBatteryRemain, signChargeStation, signKM, signKMRemain, signPower]
                    property: "opacity"
                    duration: 80
                }
            }
        },
        Transition {
            from: "navi"
            to: "stopped"
            reversible: false
            SequentialAnimation{
                //fade out (640ms)
                PropertyAnimation { targets: [scaleEnergyArea, graduation, graduationNumber]; property: "opacity"; duration: 100 }
                PropertyAnimation {
                    targets: [indicatorDrivetrain, indicatorEPower, signBattery, signBatteryRemain, signChargeStation, signKM, signKMRemain, signPower]
                    properties: "opacity"
                    duration: 200
                }
                PropertyAnimation {
                    targets: [indicatorDrivetrain, indicatorEPower, signBattery, signBatteryRemain, signChargeStation, signKM, signKMRemain, signPower]
                    properties: "x, y"
                    duration: 200
                }
            }
        }
    ]

    //visual components
    DialFrame {
        id: dialFrame
        width: 560 * d.scaleRatio
        height: width
        anchors.centerIn: parent
        state: parent.state
        minAng: -210
        maxAng: 0
        zeroAng: -180
        positiveColor: "#fba054"
        negativeColor: "#80447191"
        highLightAng: d.power2Angle(d.ePower)
    }

    Image {
        id: scaleEnergyArea
        x: 31 * d.scaleRatio
        y: 107 * d.scaleRatio
        width: 71 * d.scaleRatio
        height: 294 * d.scaleRatio
        source: "./img/dial-energy-areas" + d.sourceSuffix
    }

    Item {//PRND
        id: indicatorDrivetrain
        x: 240 * d.scaleRatio
        y: 165 * d.scaleRatio
        width: 40 * d.scaleRatio
        opacity: 1
        Text {
            id: indicatorDrivetrainP
            anchors.left: parent.left
            text: "P"
            verticalAlignment: Text.AlignTop
            horizontalAlignment: Text.AlignHCenter
            font.family: "Open Sans"
            font.weight: (root.drivetrain === 0) ? Font.Normal : Font.Light
            color: TritonStyle.primaryTextColor
            opacity: (root.drivetrain === 0) ? 0.94 : 0.4
            font.pixelSize: 34 * d.scaleRatio
        }
        Text {
            id: indicatorDrivetrainR
            anchors.left: indicatorDrivetrainP.right
            text: "R"
            verticalAlignment: Text.AlignTop
            horizontalAlignment: Text.AlignHCenter
            font.family: "Open Sans"
            font.weight: (root.drivetrain === 3) ? Font.Normal : Font.Light
            color: TritonStyle.primaryTextColor
            opacity: (root.drivetrain === 3) ? 0.94 : 0.4
            font.pixelSize: 34 * d.scaleRatio
        }
        Text {
            id: indicatorDrivetrainN
            anchors.left: indicatorDrivetrainR.right
            text: "N"
            verticalAlignment: Text.AlignTop
            horizontalAlignment: Text.AlignHCenter
            font.family: "Open Sans"
            font.weight: (root.drivetrain === 1) ? Font.Normal : Font.Light
            color: TritonStyle.primaryTextColor
            opacity: (root.drivetrain === 1) ? 0.94 : 0.4
            font.pixelSize: 34 * d.scaleRatio
        }
        Text {
            anchors.left: indicatorDrivetrainN.right
            text: "D"
            verticalAlignment: Text.AlignTop
            horizontalAlignment: Text.AlignHCenter
            font.family: "Open Sans"
            font.weight: (root.drivetrain === 2) ? Font.Normal : Font.Light
            color: TritonStyle.primaryTextColor
            opacity: (root.drivetrain === 2) ? 0.94 : 0.4
            font.pixelSize: 34 * d.scaleRatio
        }
    }

    Text {
        id: indicatorEPower
        x: 265 * d.scaleRatio
        y: 222 * d.scaleRatio
        width: 40 * d.scaleRatio
        text: Math.abs( Math.round(d.ePower) )
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignHCenter
        font.family: "Open Sans"
        font.weight: Font.DemiBold
        color: TritonStyle.primaryTextColor
        opacity: 0.94
        font.pixelSize: 80 * d.scaleRatio
    }

    Text {
        id: signPower
        x: 248 * d.scaleRatio
        y: 324 * d.scaleRatio
        text: qsTr("% power")
        font.family: "Open Sans"
        font.weight: Font.Light
        color: TritonStyle.primaryTextColor
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
        font.family: "Open Sans"
        font.weight: Font.Light
        color: TritonStyle.primaryTextColor
        opacity: 0.4
        font.pixelSize: 18 * d.scaleRatio
    }

    Image {
        id: signBattery
        x: 176 * d.scaleRatio
        y: 483 * d.scaleRatio
        width: 23 * d.scaleRatio
        height: 14 * d.scaleRatio
        source: "./img/ic-battery" + d.sourceSuffix
    }

    Text {
        id: signKMRemain
        x: 207 * d.scaleRatio
        y: 464 * d.scaleRatio
        text: "184"
        font.family: "Open Sans"
        font.weight: Font.Light
        color: TritonStyle.primaryTextColor
        opacity: 0.94
        font.pixelSize: 34 * d.scaleRatio
    }

    Text {
        id: signBatteryRemain
        x: 303 * d.scaleRatio
        y: 464 * d.scaleRatio
        text: "21"
        font.family: "Open Sans"
        font.weight: Font.Light
        color: TritonStyle.primaryTextColor
        opacity: 0.94
        font.pixelSize: 34 * d.scaleRatio
    }

    Image {
        id: signChargeStation
        x: 353 * d.scaleRatio
        y: 477 * d.scaleRatio
        width: 24 * d.scaleRatio
        height: 21 * d.scaleRatio
        source: "./img/ic-chargingstation"  + d.sourceSuffix
    }

    Repeater{
        id: graduationNumber
        anchors.centerIn: parent
        width: 520 * d.scaleRatio
        height: width
        opacity: 0.6

        //size and layout
        readonly property real radius: width / 2 - 50 * d.scaleRatio
        readonly property real centerX: width / 2
        readonly property real centerY: height / 2

        model: [0, 25, 50, 75, 100]
        delegate: Label {
            property int angle: d.power2Angle(modelData)
            property real radin: angle / 180 * Math.PI

            text: modelData
            x: graduationNumber.centerX + Math.cos(radin) * graduationNumber.radius
            y: graduationNumber.centerY + Math.sin(radin) * graduationNumber.radius
            visible: (modelData < graduation.maxDrawValue) ? true : false

            color: TritonStyle.primaryTextColor
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
        renderTarget: Canvas.Image

        readonly property real radius: graduation.width / 2
        readonly property real centerX: graduation.width / 2
        readonly property real centerY: graduation.height / 2
        readonly property real scaleLineLength: 8 * d.scaleRatio
        readonly property real scaleLineWidth: 2 * d.scaleRatio
        readonly property real scaleLineBlank: 8 * d.scaleRatio

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
