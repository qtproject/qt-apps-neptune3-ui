/****************************************************************************
**
** Copyright (C) 2019-2020 Luxoft Sweden AB
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
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3


Flickable {
    id: root
    flickableDirection: Flickable.VerticalFlick
    contentHeight: baseLayout.height
    ScrollIndicator.vertical: ScrollIndicator {
        active: true
        // we want always see it if the content doesnt fit view
        onActiveChanged: active = true
    }

    ColumnLayout {
        id: baseLayout

        anchors.centerIn: parent
        spacing: 20

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

            Button {
                Layout.alignment: Qt.AlignHCenter
                text: instrumentCluster.enableSimulation
                      ? qsTr("Disable simulation")
                      : qsTr("Enable simulation")
                onClicked: {
                    instrumentCluster.enableSimulation = !instrumentCluster.enableSimulation;
                }
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


        Label {
            text: "Vehicle state"
            Layout.alignment: Qt.AlignHCenter
            font.bold: true
        }

        GridLayout {
            enabled: instrumentCluster.isConnected && !instrumentCluster.enableSimulation
            Layout.alignment: Qt.AlignHCenter
            columns: root.width > 2 * (outsideTemperatureLabel.width + outsideTemperature.width + columnSpacing)
                     ? 4 : 2

            columnSpacing: 15
            rowSpacing: 20

            //Outside Temperature
            Label {
                id: outsideTemperatureLabel
                text: qsTr("Outside \n temperature, °C")
            }
            Slider {
                id: outsideTemperature
                value: instrumentCluster.outsideTemperatureCelsius
                from: -60.0
                stepSize: 0.5
                to: 60.0
                onValueChanged: {
                    if (pressed) {
                        instrumentCluster.outsideTemperatureCelsius = value
                    }
                }

                Label {
                    anchors.centerIn: parent.handle
                    anchors.verticalCenterOffset: - parent.handle.height * 2
                    text: parent.value.toFixed(1).padStart(6)
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
                to: 1E6
                onValueChanged: if (pressed) { instrumentCluster.mileageKm = value }

                Label {
                    anchors.centerIn: parent.handle
                    anchors.verticalCenterOffset: - parent.handle.height * 2
                    text: parent.value.toFixed(2)
                }
            }

            // Route progress
            Label {
                text: qsTr("Route \n progress, % ")
            }
            Label {
                text: (100.0 * instrumentCluster.navigationProgressPercents).toFixed(0)
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

                Label {
                    anchors.centerIn: parent.handle
                    anchors.verticalCenterOffset: - parent.handle.height * 2
                    text: parent.value
                }
            }
        }//grid


        RowLayout {
            enabled: instrumentCluster.isConnected && !instrumentCluster.enableSimulation
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

        // readonly state
        GridLayout {
            Layout.alignment: Qt.AlignHCenter
            columns: 2
            columnSpacing: 50
            rowSpacing: 25

            // speedLimit Field
            Label {
                text: qsTr("Speed limit: ") + instrumentCluster.speedLimit
            }

            Label {
                text: qsTr("Cruise speed: ") + instrumentCluster.speedCruise
            }

            Label {
                text: qsTr("Speed: ") + instrumentCluster.speed
            }

            Label {
                text: qsTr("ePower: ") + instrumentCluster.ePower
            }
        }

        RowLayout {
            enabled: instrumentCluster.isConnected
            Layout.alignment: Qt.AlignHCenter
            spacing: 50

            Label {
                text: qsTr("Range: ") + instrumentCluster.drivingModeRangeKm
            }

            Label {
                text: qsTr("ECO Range: ") + instrumentCluster.drivingModeECORangeKm
            }
        }

        Label {
            text: "Telltales"
            Layout.alignment: Qt.AlignHCenter
            font.bold: true
        }

        GridLayout {
            enabled: instrumentCluster.isConnected && !instrumentCluster.enableSimulation
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
                text: qsTr("Neptune Revision: ") + neptuneGitRevision
                Layout.alignment: Qt.AlignHCenter
            }

            Label {
                text: qsTr("Qt IVI Version: ") + qtiviVersion
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
