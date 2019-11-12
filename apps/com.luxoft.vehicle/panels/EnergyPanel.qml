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

import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import shared.Style 1.0
import shared.Sizes 1.0

import shared.utils 1.0

import "../helpers" 1.0
import "../controls" 1.0

Item {
    id: root
    signal intentToMapRequested(var intentId, var params)

    TabBar {
        id: energyControls
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        TabButton { text: qsTr("Present") }
        TabButton { text: qsTr("1 day") }
        TabButton { text: qsTr("1 week") }
        TabButton { text: qsTr("1 month") }
    }

    Image {
        id: energyGraph

        anchors.top: energyControls.bottom
        anchors.left: energyControls.left
        anchors.topMargin: Sizes.dp(40)
        readonly property string sourceSuffix: Style.theme === Style.Dark ? "-dark.png" : ".png"
        width: parent.width
        height: Sizes.dp(sourceSize.height)
        source: Paths.getImagePath("energy-graph" + sourceSuffix)
    }

    Label {
        id: energyGraphTitle

        anchors.top: energyGraph.bottom
        anchors.topMargin: Sizes.dp(46)
        anchors.left: energyGraph.left
        anchors.leftMargin: Sizes.dp(22)

        font.weight: Font.Light
        text: qsTr("Projected distance to empty")
    }

    Item {
        id: chargingInfoItem

        anchors.top: energyGraphTitle.bottom
        anchors.topMargin: Sizes.dp(24)
        width: parent.width
        height: Sizes.dp(340)

        Image {
            height: Sizes.dp(2)
            width: parent.width
            source: Style.image("list-divider")
        }

        Label {
            anchors.top: parent.top
            anchors.topMargin: Sizes.dp(16)
            anchors.left: parent.left
            anchors.leftMargin: Sizes.dp(40)
            text: qsTr("184")
            font {
                pixelSize: Sizes.fontSizeL
            }

            Label {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: Sizes.dp(4)
                anchors.left: parent.right
                anchors.leftMargin: Sizes.dp(12)

                text: qsTr("km")
                font {
                    pixelSize: Sizes.fontSizeXS
                    weight: Font.Light
                }
                opacity: Style.opacityLow
            }
        }

        Label {
            anchors.top: parent.top
            anchors.topMargin: Sizes.dp(114)
            anchors.left: parent.left
            anchors.leftMargin: Sizes.dp(22)

            font.weight: Font.Light
            text: qsTr("Charging stations")
        }

        VehicleButton {
            anchors.top: parent.top
            anchors.topMargin: Sizes.dp(102)
            anchors.right: parent.right
            anchors.rightMargin: Sizes.dp(22)
            state: "SMALL"
            text: qsTr("Open map")
            onClicked:  root.intentToMapRequested("activate-app", {});
        }

        Image {
            height: Sizes.dp(2)
            width: Sizes.dp(750)
            anchors.top: parent.top
            anchors.topMargin: Sizes.dp(168)
            source: Style.image("list-divider")
        }

        //ToDo: this probably should be in a model later
        Item {
            anchors.top: parent.top
            anchors.topMargin: Sizes.dp(180)
            anchors.left: parent.left
            width: parent.width
            height: Sizes.dp(60)

            Label {
                anchors.left: parent.left
                anchors.leftMargin: Sizes.dp(40)
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("21")
                font {
                    pixelSize: Sizes.fontSizeL
                }

                Label {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: Sizes.dp(4)
                    anchors.left: parent.right
                    anchors.leftMargin: Sizes.dp(10)

                    text: qsTr("km")
                    font {
                        pixelSize: Sizes.fontSizeXS
                        weight: Font.Light
                    }
                    opacity: Style.opacityLow
                }
            }

            Label {
                id: firstStationAddressLabel
                anchors.left: parent.left
                anchors.leftMargin: Sizes.dp(140)
                anchors.verticalCenter: parent.verticalCenter

                font.weight: Font.Light
                text: qsTr("Donald Weese Ct, Las Vegas")
            }

            VehicleButton {
                anchors.right: parent.right
                anchors.rightMargin: Sizes.dp(22)
                state: "SMALL"
                text: qsTr("Route")
                onClicked: {
                    root.intentToMapRequested("show-destination",
                            {"destination": firstStationAddressLabel.text});
                }
            }
        }

        //ToDo: this probably should be in a model later
        Item {
            anchors.top: parent.top
            anchors.topMargin: Sizes.dp(245)
            anchors.left: parent.left
            width: parent.width
            height: Sizes.dp(60)

            Label {
                text: qsTr("27")

                anchors.left: parent.left
                anchors.leftMargin: Sizes.dp(40)
                anchors.verticalCenter: parent.verticalCenter
                font {
                    pixelSize: Sizes.fontSizeL
                }

                Label {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: Sizes.dp(4)
                    anchors.left: parent.right
                    anchors.leftMargin: Sizes.dp(10)

                    text: qsTr("km")
                    font {
                        pixelSize: Sizes.fontSizeXS
                        weight: Font.Light
                    }
                    opacity: Style.opacityLow
                }
            }

            Label {
                id: secondStationAddressLabel
                anchors.left: parent.left
                anchors.leftMargin: Sizes.dp(140)
                anchors.verticalCenter: parent.verticalCenter

                font.weight: Font.Light
                text: qsTr("Faiss Dr, Las Vegas")
            }

            VehicleButton {
                anchors.right: parent.right
                anchors.rightMargin: Sizes.dp(22)
                state: "SMALL"
                text: qsTr("Route")
                onClicked: {
                    root.intentToMapRequested("show-destination",
                            {"destination": secondStationAddressLabel.text});
                }
            }
        }
    }
}

