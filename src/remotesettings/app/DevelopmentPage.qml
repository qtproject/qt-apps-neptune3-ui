/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
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
    ScrollIndicator.vertical: ScrollIndicator { }

    ColumnLayout {
        id: baseLayout

        anchors.centerIn: parent

        ColumnLayout {
            enabled: systemUI.isInitialized && client.connected
            Layout.alignment: Qt.AlignHCenter

            Label {
                text: "System UI"
                Layout.alignment: Qt.AlignHCenter
                font.bold: true
            }

            Button {
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("Show Next Application IC Window");
                onClicked: {
                    systemUI.applicationICWindowSwitchCount =
                                                    systemUI.applicationICWindowSwitchCount + 1
                }
            }

            Label {
                text: "Cluster"
                Layout.alignment: Qt.AlignHCenter
                font.bold: true
            }

            GridLayout {
                Layout.alignment: Qt.AlignHCenter
                columns: root.width < neptuneScale(100) ? 2 : 4

                CheckBox {
                    text: qsTr("Hide Gauges")
                    checked: uiSettings.hideGauges
                    onClicked: uiSettings.hideGauges = checked
                }

                CheckBox {
                    text: qsTr("Navigation Mode")
                    checked: uiSettings.navigationMode
                    onClicked: uiSettings.navigationMode = checked
                }
            }
        }


        GridLayout {
            enabled: instrumentCluster.isConnected
            Layout.alignment: Qt.AlignHCenter
            columns: root.width < neptuneScale(100) ? 2 : 4

            //Outside Temperature
            Label {
                text: qsTr("Outside \n temperature: "
                           + outsideTemperature.value.toFixed(1).padStart(6) + " °C")
            }
            Slider {
                id: outsideTemperature
                value: instrumentCluster.outsideTemperatureCelsius
                from: -100
                stepSize: 0.5
                to: 100.0
                onValueChanged: {
                    if (pressed) {
                        instrumentCluster.outsideTemperatureCelsius = value
                    }
                }
            }

            // Mileage in km
            Label {
                text: qsTr("Mileage, km")
            }
            Slider {
                id: mileageKm
                value: instrumentCluster.mileageKm
                from: 0
                stepSize: 0.5
                to: 9E6
                onValueChanged: if (pressed) { instrumentCluster.mileageKm = value }
            }

            // Route progress
            Label {
                text: qsTr("Route \n progress, %:")
            }

            Slider {
                id: routeProgressSlider
                from: 0
                to: 1.0
                stepSize: 0.01
                value: instrumentCluster.navigationProgressPercents
                onValueChanged: {
                    if (pressed) {
                        instrumentCluster.navigationProgressPercents = value
                    }
                }

            }

            // Route distance
            Label {
                text: qsTr("Route \n distance, km")
            }
            Slider {
                id: routeDistance
                value: instrumentCluster.navigationRouteDistanceKm
                from: 0
                stepSize: 0.5
                to: 25000
                onValueChanged: {
                    if (pressed) {
                        instrumentCluster.navigationRouteDistanceKm = value
                    }
                }
            }
        }//grid

        RowLayout {
            enabled: instrumentCluster.isConnected
            Layout.alignment: Qt.AlignHCenter
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
        }

        GridLayout {
            Layout.alignment: Qt.AlignHCenter
            columns: root.width < neptuneScale(100) ? 2 : 4
            enabled: false

            // speedLimit Field
            Dial {
                id: speedLimitDial
                from: 0
                to: 260
                stepSize: 1.0
                value: instrumentCluster.speedLimit


                Label {
                    text: qsTr("Speed limit:")
                    anchors.bottom: speedLimitDial.verticalCenter
                    anchors.horizontalCenter: speedLimitDial.horizontalCenter
                }

                Label {
                    id: speedLimitLabel
                    text: Math.round(speedLimitDial.value)
                    anchors.top: speedLimitDial.verticalCenter
                    anchors.horizontalCenter: speedLimitDial.horizontalCenter
                }
            }

            // speedCruise Field
            Dial {
                id: speedCruiseDial
                from: 0
                to: 260
                stepSize: 1.0
                value: instrumentCluster.speedCruise

                Label {
                    text: qsTr("Cruise speed:")
                    anchors.bottom: speedCruiseDial.verticalCenter
                    anchors.horizontalCenter: speedCruiseDial.horizontalCenter
                }

                Label {
                    id: speedCruiseLabel
                    text: Math.round(speedCruiseDial.value)
                    anchors.top: speedCruiseDial.verticalCenter
                    anchors.horizontalCenter: speedCruiseDial.horizontalCenter
                }
            }

            // speed Field
            Dial {
                id: speedDial
                from: 0
                to: 260
                stepSize: 1.0
                value: instrumentCluster.speed

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

        RowLayout {
            enabled: instrumentCluster.isConnected
            Layout.alignment: Qt.AlignHCenter

            //Driving mode range Field
            Dial {
                id: drivingModeRangeDial
                from: 0
                to: 1000
                stepSize: 1.0
                value: instrumentCluster.drivingModeRangeKm
                onMoved: instrumentCluster.drivingModeRangeKm = value

                Label {
                    text: qsTr("Range:")
                    anchors.bottom: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Label {
                    text: Math.round(parent.value)
                    anchors.top: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            // ECO mode range Field
            Dial {
                id: ecoModeRangeDial
                from: 0
                to: 500
                stepSize: 1.0
                value: instrumentCluster.drivingModeECORangeKm
                onMoved: instrumentCluster.drivingModeECORangeKm = value

                Label {
                    text: qsTr("ECO Range:")
                    anchors.bottom: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }


                Label {
                    text: Math.round(parent.value)
                    anchors.top: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        Label {
            text: "Telltales"
            Layout.alignment: Qt.AlignHCenter
            font.bold: true
        }

        GridLayout {
            enabled: instrumentCluster.isConnected
            Layout.alignment: Qt.AlignHCenter
            columns: root.width < neptuneScale(100) ? 2 : 4

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

        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter

            Label {
                text: qsTr("Application Info")
                Layout.alignment: Qt.AlignHCenter
                font.bold: true
            }

            Label {
                text: qsTr("Neptune Companion App Version: ") + Qt.application.version
                Layout.alignment: Qt.AlignHCenter
            }

            Label {
                text: qsTr("Neptune Revision: ") + neptuneInfo
                Layout.alignment: Qt.AlignHCenter
            }

            Label {
                text: qsTr("Qt IVI Version: ") + qtiviVersion
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
