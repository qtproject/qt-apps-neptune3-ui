/****************************************************************************
**
** Copyright (C) 2017, 2018 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Triton IVI UI.
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
        enabled: instrumentCluster.connected
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
                text: qsTr("Next IVI-Mode:")
            }
            CheckBox {
                checked: instrumentCluster.navigationMode
                onClicked: instrumentCluster.navigationMode = checked
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
