/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
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
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

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

        Vehicle2DPanel {
            height: root.height / 3
            width: 300
            leftDoorOpen: uiSettings.door1Open
            rightDoorOpen: uiSettings.door2Open
            trunkOpen: uiSettings.trunkOpen
            roofOpen: uiSettings.roofOpenProgress > 0.5
            Layout.preferredHeight: root.height / 3
            Layout.preferredWidth: neptuneScale(90)

            Item {
                width: parent.width / 2
                height: parent.height / 3
                ColumnLayout {
                    anchors.fill: parent

                    Label {
                        text: instrumentCluster.isConnected ? instrumentCluster.speed : "--"
                        font.pixelSize: root.height / 15
                        Layout.alignment: Qt.AlignHCenter
                        color: "white"
                        style: Text.Outline
                        styleColor: Qt.darker("white")
                    }

                    Label {
                        text: qsTr("km/h")
                        Layout.alignment: Qt.AlignHCenter
                        color: "white"
                        style: Text.Outline
                        styleColor: Qt.darker("white")
                    }
                }
            }

            Item {
                x: width
                width: parent.width / 2
                height: parent.height / 3
                ColumnLayout {
                    anchors.fill: parent

                    Label {
                        text: instrumentCluster.isConnected ? instrumentCluster.ePower : "--"
                        font.pixelSize: root.height / 15
                        Layout.alignment: Qt.AlignHCenter
                        color: "white"
                        style: Text.Outline
                        styleColor: Qt.darker("white")
                    }

                    Label {
                        text: qsTr("% power")
                        Layout.alignment: Qt.AlignHCenter
                        color: "white"
                        style: Text.Outline
                        styleColor: Qt.darker("white")
                    }
                }
            }
        }

        ColumnLayout {
            enabled: instrumentCluster.isConnected
            Layout.alignment: Qt.AlignHCenter

            Label {
                text: qsTr("Climate:")
                Layout.alignment: Qt.AlignHCenter
                font.bold: true
            }

            Label {
                text: instrumentCluster.outsideTemperatureCelsius + " °C" +
                      qsTr(" outside")
            }

            Label {
                text: qsTr("Status:")
                Layout.alignment: Qt.AlignHCenter
                font.bold: true
            }

            Label {
                text: qsTr("Gear: ") + gears[instrumentCluster.driveTrainState]
                readonly property var gears: [qsTr("P"), qsTr("N"), qsTr("D"), qsTr("R")]
            }

            Label {
                text: qsTr("Range: ") + instrumentCluster.drivingModeRangeKm + " km"
            }

            Label {
                text: qsTr("ECO Range: ") + instrumentCluster.drivingModeECORangeKm + " km"
            }

            Label {
                text: qsTr("Mileage: ") + Math.round(instrumentCluster.mileageKm, -2) + " km"
            }

            RowLayout {
                // DrivingMode field
                Label {
                    text: qsTr("Driving mode:")
                }

                ComboBox {
                    id: driveingModeComboBox
                    model: [qsTr("Normal"), qsTr("ECO"), qsTr("Sport")]
                    currentIndex: instrumentCluster.drivingMode
                    onActivated: instrumentCluster.drivingMode = currentIndex
                }
            }
        }

        Label {
            text: qsTr("Doors & Locks:")
            Layout.alignment: Qt.AlignHCenter
            font.bold: true
        }

        GridLayout {
            columns: 4
            enabled: systemUI.isInitialized && client.connected
            Layout.alignment: Qt.AlignHCenter

            // Door 1 Field
            Label {
                text: qsTr("Left Door:")
            }
            CheckBox {
                id: door1OpenCheckbox
                checked: uiSettings.door1Open
                onClicked: uiSettings.door1Open = checked
            }

            // Door 2 Field
            Label {
                text: qsTr("Right Door:")
            }
            CheckBox {
                id: door2OpenCheckbox
                checked: uiSettings.door2Open
                onClicked: uiSettings.door2Open = checked
            }

            Label {
                text: qsTr("Trunk:")
            }
            CheckBox {
                checked: uiSettings.trunkOpen
                onClicked: uiSettings.trunkOpen = checked
            }

            // Door 2 Field
            Label {
                text: qsTr("Roof:")
            }
            CheckBox {
                checked: uiSettings.roofOpenProgress > 0.5
                onClicked: uiSettings.roofOpenProgress = checked ? 1.0 : 0.0
            }
        }
    }
}
