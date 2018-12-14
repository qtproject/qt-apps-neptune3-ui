/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Copyright (C) 2018 Pelagicore AG
** Copyright (C) 2017 The Qt Company Ltd.
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

import QtQuick 2.9
import QtQuick.Controls 2.3
import "../helpers" 1.0
import shared.Style 1.0
import shared.Sizes 1.0

Item {
    id: root
    width: Sizes.dp(560)
    height: width

    //public
    property int ePower
    property int drivetrain: 0
    property int remainingKm: 180
    property int remainingPower: 20

    //private
    QtObject {
        id: d

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
            PropertyChanges { target: signBattery; opacity: 0; x: Sizes.dp(176); y: Sizes.dp(483) }
            PropertyChanges { target: signBatteryRemain; opacity: 0 }
            PropertyChanges { target: signChargeStation; opacity: 0 }
            PropertyChanges { target: signKM; opacity: 0; x: Sizes.dp(272); y: Sizes.dp(480) }
            PropertyChanges { target: signKMRemain; opacity: 0; x: Sizes.dp(207); y: Sizes.dp(464) }
            PropertyChanges { target: signPower; opacity: 0 }
        },
        State {
            name: "normal"
            PropertyChanges { target: scaleEnergyArea; opacity: 1 }
            PropertyChanges { target: graduation; opacity: 1; maxDrawValue: 105 }
            PropertyChanges { target: graduationNumber; opacity: Style.opacityMedium }
            PropertyChanges { target: indicatorDrivetrain; opacity: 1 }
            PropertyChanges { target: indicatorEPower; opacity: Style.opacityHigh }
            PropertyChanges { target: signBattery; opacity: 1; x: Sizes.dp(176); y: Sizes.dp(483) }
            PropertyChanges { target: signBatteryRemain; opacity: Style.opacityHigh }
            PropertyChanges { target: signChargeStation; opacity: 1 }
            PropertyChanges { target: signKM; opacity: Style.opacityLow; x: Sizes.dp(272); y: Sizes.dp(480) }
            PropertyChanges { target: signKMRemain; opacity: Style.opacityHigh; x: Sizes.dp(207); y: Sizes.dp(464) }
            PropertyChanges { target: signPower; opacity: Style.opacityLow }
        },
        State {
            name: "navi"
            PropertyChanges { target: scaleEnergyArea; opacity: 0 }
            PropertyChanges { target: graduation; opacity: 0; maxDrawValue: 105 }
            PropertyChanges { target: graduationNumber; opacity: 0 }
            PropertyChanges { target: indicatorDrivetrain; opacity: 1 }
            PropertyChanges { target: indicatorEPower; opacity: Style.opacityHigh }
            PropertyChanges { target: signBattery; opacity: 1; x: Sizes.dp(210); y: Sizes.dp(380) }
            PropertyChanges { target: signBatteryRemain; opacity: 0 }
            PropertyChanges { target: signChargeStation; opacity: 0 }
            PropertyChanges { target: signKM; opacity: Style.opacityLow; x: Sizes.dp(330); y: Sizes.dp(375) }
            PropertyChanges { target: signKMRemain; opacity: Style.opacityHigh; x: Sizes.dp(250); y: Sizes.dp(362) }
            PropertyChanges { target: signPower; opacity: Style.opacityLow }
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
    DialFramePanel {
        id: dialFrame
        width: Sizes.dp(560)
        height: width
        anchors.centerIn: parent
        state: parent.state
        minAng: -210
        maxAng: 0
        zeroAng: -180
        positiveColor: Style.accentColor
        negativeColor: "#80447191"
        highLightAng: d.power2Angle(d.ePower)
    }

    Image {
        id: scaleEnergyArea
        x: Sizes.dp(31)
        y: Sizes.dp(107)
        width: Sizes.dp(71)
        height: Sizes.dp(294)
        source: Utils.localAsset("dial-energy-areas", Style.theme)
    }

    Item {//PRND
        id: indicatorDrivetrain
        x: Sizes.dp(240)
        y: Sizes.dp(165)
        width: Sizes.dp(40)
        opacity: 1
        Label {
            id: indicatorDrivetrainP
            anchors.left: parent.left
            text: "P"
            verticalAlignment: Text.AlignTop
            horizontalAlignment: Text.AlignHCenter
            font.weight: (root.drivetrain === 0) ? Font.Normal : Font.Light
            opacity: (root.drivetrain === 0) ? Style.opacityHigh : Style.opacityLow
            font.pixelSize: Sizes.dp(34)
        }
        Label {
            id: indicatorDrivetrainR
            anchors.left: indicatorDrivetrainP.right
            text: "R"
            verticalAlignment: Text.AlignTop
            horizontalAlignment: Text.AlignHCenter
            font.weight: (root.drivetrain === 3) ? Font.Normal : Font.Light
            opacity: (root.drivetrain === 3) ? Style.opacityHigh : Style.opacityLow
            font.pixelSize: Sizes.dp(34)
        }
        Label {
            id: indicatorDrivetrainN
            anchors.left: indicatorDrivetrainR.right
            text: "N"
            verticalAlignment: Text.AlignTop
            horizontalAlignment: Text.AlignHCenter
            font.weight: (root.drivetrain === 1) ? Font.Normal : Font.Light
            opacity: (root.drivetrain === 1) ? Style.opacityHigh : Style.opacityLow
            font.pixelSize: Sizes.dp(34)
        }
        Label {
            anchors.left: indicatorDrivetrainN.right
            text: "D"
            verticalAlignment: Text.AlignTop
            horizontalAlignment: Text.AlignHCenter
            font.weight: (root.drivetrain === 2) ? Font.Normal : Font.Light
            opacity: (root.drivetrain === 2) ? Style.opacityHigh : Style.opacityLow
            font.pixelSize: Sizes.dp(34)
        }
    }

    Label {
        id: indicatorEPower
        x: Sizes.dp(265)
        y: Sizes.dp(222)
        width: Sizes.dp(40)
        text: Math.abs( Math.round(d.ePower) )
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignHCenter
        font.weight: Font.DemiBold
        opacity: Style.opacityHigh
        font.pixelSize: Sizes.dp(80)
    }

    Label {
        id: signPower
        x: Sizes.dp(248)
        y: Sizes.dp(324)
        text: qsTr("% power")
        font.weight: Font.Light
        opacity: Style.opacityLow
        font.pixelSize: Sizes.dp(18)
    }

    Label {
        id: signKM
        x: Sizes.dp(272)
        y: Sizes.dp(480)
        text: qsTr("km")
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignHCenter
        font.weight: Font.Light
        opacity: Style.opacityLow
        font.pixelSize: Sizes.dp(18)
    }

    Image {
        id: signBattery
        x: Sizes.dp(176)
        y: Sizes.dp(483)
        width: Sizes.dp(23)
        height: Sizes.dp(14)
        source: Utils.localAsset("ic-battery", Style.theme)
    }

    Label {
        id: signKMRemain
        x: Sizes.dp(207)
        y: Sizes.dp(464)
        width: Sizes.dp(70)
        horizontalAlignment: root.state !== "navi" ? Text.AlignLeft : Text.AlignHCenter
        text: root.remainingKm
        font.weight: Font.Light
        opacity: Style.opacityHigh
        font.pixelSize: Sizes.dp(34)
    }

    Label {
        id: signBatteryRemain
        x: Sizes.dp(303)
        y: Sizes.dp(464)
        width: Sizes.dp(50)
        text: root.remainingPower
        font.weight: Font.Light
        horizontalAlignment: Text.AlignRight
        opacity: Style.opacityHigh
        font.pixelSize: Sizes.dp(34)
    }

    Image {
        id: signChargeStation
        x: Sizes.dp(353)
        y: Sizes.dp(474)
        width: Sizes.dp(24)
        height: Sizes.dp(21)
        source: Utils.localAsset("ic-chargingstation", Style.theme)
    }

    Repeater{
        id: graduationNumber
        anchors.centerIn: parent
        width: Sizes.dp(520)
        height: width
        opacity: Style.opacityMedium

        //size and layout
        readonly property real radius: width / 2 - Sizes.dp(50)
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

            opacity: graduationNumber.opacity
            font.weight: Font.Light
            font.pixelSize: Sizes.dp(22)
        }
    }

    Canvas {
        id: graduation
        anchors.centerIn: parent
        width: Sizes.dp(520)
        height: width
        renderTarget: Canvas.Image

        readonly property real radius: graduation.width / 2
        readonly property real centerX: graduation.width / 2
        readonly property real centerY: graduation.height / 2
        readonly property real scaleLineLength: Sizes.dp(8)
        readonly property real scaleLineWidth: Sizes.dp(2)
        readonly property real scaleLineBlank: Sizes.dp(8)

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
