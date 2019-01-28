/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Copyright (C) 2018 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 IVI UI.
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
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3


Flickable {
    id: root
    flickableDirection: Flickable.VerticalFlick
    contentHeight: baseLayout.height

    property bool simulationEnabled: false

    ScrollIndicator.vertical: ScrollIndicator { }

    ColumnLayout {
        id: baseLayout
        enabled: instrumentCluster.isInitialized && client.connected
        spacing: 20
        anchors.centerIn: parent

        RowLayout {
            spacing: sc(10)
            Layout.alignment: Qt.AlignHCenter

            // speed Field
            Dial {
                id: speedDial
                from: 0
                to: 260
                stepSize: 1.0
                value: instrumentCluster.speed
                onMoved: instrumentCluster.speed = value

                Label {
                    text: qsTr("Speed:")
                    anchors.bottom: speedDial.verticalCenter
                    anchors.horizontalCenter: speedDial.horizontalCenter
                }

                Label {
                    id: speedLabel
                    text: Math.round(speedDial.value)
                    anchors.top: speedDial.verticalCenter
                    anchors.horizontalCenter: speedDial.horizontalCenter
                }
            }

            // ePower Field
            Dial {
                id: ePowerDial
                from: -25
                to: 100
                stepSize: 1.0
                value: instrumentCluster.ePower
                onMoved: instrumentCluster.ePower = value

                Label {
                    text: qsTr("ePower:")
                    anchors.bottom: ePowerDial.verticalCenter
                    anchors.horizontalCenter: ePowerDial.horizontalCenter
                }

                Label {
                    id: ePowerLabel
                    text: Math.round(ePowerDial.value)
                    anchors.top: ePowerDial.verticalCenter
                    anchors.horizontalCenter: ePowerDial.horizontalCenter
                }
            }
        }

        GridLayout {
            Layout.alignment: Qt.AlignHCenter
            columns: root.width < sc(100) ? 2 : 4

            // speedLimit Field
            Label {
                text: qsTr("Speed limit:")
            }
            Slider {
                id: speedLimitSlider
                value: instrumentCluster.speedLimit
                from: 0.0
                stepSize: 1.0
                to: 120.0
                onValueChanged: if (pressed) { instrumentCluster.speedLimit = value }
            }

            // speedCruise Field
            Label {
                text: qsTr("Cruise speed:")
            }
            Slider {
                id: speedCruiseSlider
                value: instrumentCluster.speedCruise
                from: 0.0
                stepSize: 1.0
                to: 120.0
                onValueChanged: if (pressed) { instrumentCluster.speedCruise = value }
            }

            // driveTrainState field
            Label {
                text: qsTr("Gear:")
            }

            ComboBox {
                id: driveTrainStateComboBox
                model: [qsTr("P"), qsTr("N"), qsTr("D"), qsTr("R")]
                currentIndex: instrumentCluster.driveTrainState
                onActivated: instrumentCluster.driveTrainState = currentIndex
            }
            Label {
                text: qsTr("Navigation Mode:")
            }
            CheckBox {
                checked: instrumentCluster.navigationMode
                onClicked: instrumentCluster.navigationMode = checked
            }

            Label {
                text: qsTr("Simulation Mode:")
            }
            CheckBox {
                checked: root.simulationEnabled
                onClicked: root.simulationEnabled = !root.simulationEnabled
            }

            Label {
                text: qsTr("Hide Gauges:")
            }
            CheckBox {
                checked: instrumentCluster.hideGauges
                onClicked: instrumentCluster.hideGauges = checked
            }

            /*!
                Outside Temperature
            */
            Label {
                text: qsTr("Outside temperature: " +  outsideTemperature.value.toFixed(1).padStart(6) + " °C")
            }
            Slider {
                id: outsideTemperature
                value: instrumentCluster.outsideTempCelsius
                from: -100
                stepSize: 0.5
                to: 100.0
                onValueChanged: if (pressed) { instrumentCluster.outsideTempCelsius = value }
            }

            /*!
                Mileage in km
            */
            Label {
                text: qsTr("Mileage km")
            }
            Slider {
                id: mileageKm
                value: instrumentCluster.mileageKm
                from: 0
                stepSize: 0.5
                to: 9E6
                onValueChanged: if (pressed) { instrumentCluster.mileageKm = value }
            }

            /*!
                DrivingMode field
            */
            Label {
                text: qsTr("Driving mode:")
            }

            ComboBox {
                id: driveingModeComboBox
                model: [qsTr("Normal"), qsTr("ECO"), qsTr("Sport")]
                currentIndex: instrumentCluster.drivingMode
                onActivated: instrumentCluster.drivingMode = currentIndex
            }

            /*!
                Driving mode range Field
            */
            Label {
                text: qsTr("Driving mode range:")
            }
            Dial {
                id: drivingModeRangeDial
                from: 0
                to: 1000
                stepSize: 1.0
                value: instrumentCluster.drivingModeRangeKm
                onMoved: instrumentCluster.drivingModeRangeKm = value



                Label {
                    text: Math.round(parent.value)
                    anchors.top: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            /*!
                ECO mode range Field
            */
            Label {
                text: qsTr("ECO mode range:")
            }
            Dial {
                id: ecoModeRangeDial
                from: 0
                to: 500
                stepSize: 1.0
                value: instrumentCluster.drivingModeECORangeKm
                onMoved: instrumentCluster.drivingModeECORangeKm = value



                Label {
                    text: Math.round(parent.value)
                    anchors.top: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            /*!
               Route progress
            */
            Label {
                text: qsTr("Route progress, %:")
            }

            Dial {
                id: routeProgressDial
                from: 0
                to: 1.0
                stepSize: 0.01
                value: instrumentCluster.navigationProgressPercents
                onMoved: instrumentCluster.navigationProgressPercents = value



                Label {
                    text: Math.round(parent.value * 100.0)
                    anchors.top: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            /*!
                Route distance
            */
            Label {
                text: qsTr("Route distance, km")
            }
            Slider {
                id: routeDistance
                value: instrumentCluster.navigationRouteDistanceKm
                from: 0
                stepSize: 0.5
                to: 25000
                onValueChanged: if (pressed) { instrumentCluster.navigationRouteDistanceKm = value }
            }

            Timer {
                interval: 1000
                running: root.simulationEnabled
                repeat: true
                onTriggered: {
                    if (instrumentCluster.speed < 140) {
                        instrumentCluster.speed = instrumentCluster.speed + 10;
                    } else {
                        instrumentCluster.speed = 0.0;
                    }

                    if (instrumentCluster.ePower < 80) {
                        instrumentCluster.ePower = instrumentCluster.ePower + 2;
                    } else {
                        instrumentCluster.ePower = 0.0;
                    }

                    if (instrumentCluster.speedCruise < 100) {
                        instrumentCluster.speedCruise = instrumentCluster.speedCruise + 10;
                    } else {
                        instrumentCluster.speedCruise = 0;
                    }

                    if (instrumentCluster.mileageKm < 100000) {
                        instrumentCluster.mileageKm = instrumentCluster.mileageKm + Math.random(100)
                    } else {
                        instrumentCluster.mileageKm = 0
                    }

                    if (instrumentCluster.drivingModeRangeKm < 1000) {
                        instrumentCluster.drivingModeRangeKm = instrumentCluster.mileageKm + Math.random(20)
                    } else {
                        instrumentCluster.drivingModeRangeKm = 0
                    }

                    if (instrumentCluster.navigationProgressPercents < 1.0) {
                        instrumentCluster.navigationProgressPercents = instrumentCluster.navigationProgressPercents
                                + 0.01
                    } else {
                        instrumentCluster.navigationProgressPercents = 0.0
                    }

                    if (instrumentCluster.navigationRouteDistanceKm < 130.0) {
                        instrumentCluster.navigationRouteDistanceKm = instrumentCluster.navigationRouteDistanceKm
                                + Math.random(10)
                    } else {
                        instrumentCluster.navigationRouteDistanceKm = 0.0
                    }
                }
            }
        }

        GridLayout {
            Layout.alignment: Qt.AlignHCenter
            columns: root.width < sc(100) ? 2 : 4

            // lowBeamHeadlight Field
            Label {
                text: qsTr("Low beam headlight:")
            }
            CheckBox {
                id: lowBeamHeadlightCheckbox
                checked: instrumentCluster.lowBeamHeadlight
                onClicked: instrumentCluster.lowBeamHeadlight = checked
            }

            // highBeamHeadlight Field
            Label {
                text: qsTr("High beam headlight:")
            }
            CheckBox {
                id: highBeamHeadlightCheckbox
                checked: instrumentCluster.highBeamHeadlight
                onClicked: instrumentCluster.highBeamHeadlight = checked
            }

            // fogLight Field
            Label {
                text: qsTr("Fog light:")
            }
            CheckBox {
                id: fogLightCheckbox
                checked: instrumentCluster.fogLight
                onClicked: instrumentCluster.fogLight = checked
            }

            // stabilityControl Field
            Label {
                text: qsTr("Stability control:")
            }
            CheckBox {
                id: stabilityControlCheckbox
                checked: instrumentCluster.stabilityControl
                onClicked: instrumentCluster.stabilityControl = checked
            }

            // leftTurn Field
            Label {
                text: qsTr("Left turn:")
            }
            CheckBox {
                id: leftTurnCheckbox
                checked: instrumentCluster.leftTurn
                onClicked: instrumentCluster.leftTurn = checked
            }

            // rightTurn Field
            Label {
                text: qsTr("Right turn:")
            }
            CheckBox {
                id: rightTurnCheckbox
                checked: instrumentCluster.rightTurn
                onClicked: instrumentCluster.rightTurn = checked
            }

            // seatBeltNotFastened Field
            Label {
                text: qsTr("Seat belt not fastened:")
            }
            CheckBox {
                id: seatBeltNotFastenedCheckbox
                checked: instrumentCluster.seatBeltNotFastened
                onClicked: instrumentCluster.seatBeltNotFastened = checked
            }

            // ABSFailure Field
            Label {
                text: qsTr("ABS failure:")
            }
            CheckBox {
                id: absFailureCheckbox
                checked: instrumentCluster.ABSFailure
                onClicked: instrumentCluster.ABSFailure = checked
            }

            // parkBrake Field
            Label {
                text: qsTr("Park brake:")
            }
            CheckBox {
                id: parkBrakeCheckbox
                checked: instrumentCluster.parkBrake
                onClicked: instrumentCluster.parkBrake = checked
            }

            // tyrePressureLow Field
            Label {
                text: qsTr("Tyre pressure low:")
            }
            CheckBox {
                id: tyrePressureLowCheckbox
                checked: instrumentCluster.tyrePressureLow
                onClicked: instrumentCluster.tyrePressureLow = checked
            }

            // brakeFailure Field
            Label {
                text: qsTr("Brake failure:")
            }
            CheckBox {
                id: brakeFailureCheckBox
                checked: instrumentCluster.brakeFailure
                onClicked: instrumentCluster.brakeFailure = checked
            }

            // airbagFailure Field
            Label {
                text: qsTr("Airbag failure:")
            }
            CheckBox {
                id: airbagFailureCheckBox
                checked: instrumentCluster.airbagFailure
                onClicked: instrumentCluster.airbagFailure = checked
            }
        }
    }
}
