/****************************************************************************
**
** Copyright (C) 2018 Luxoft GmbH
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

import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import com.pelagicore.styles.neptune 3.0

import utils 1.0

import "../helpers/pathsProvider.js" as Paths
import "../controls"

Item {
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
        anchors.topMargin: NeptuneStyle.dp(40)
        readonly property string sourceSuffix: NeptuneStyle.theme === NeptuneStyle.Dark ? "-dark.png" : ".png"
        width: parent.width
        height: NeptuneStyle.dp(sourceSize.height)
        source: Paths.getImagePath("energy-graph" + sourceSuffix)
    }

    Label {
        id: energyGraphTitle

        anchors.top: energyGraph.bottom
        anchors.topMargin: NeptuneStyle.dp(46)
        anchors.left: energyGraph.left
        anchors.leftMargin: NeptuneStyle.dp(22)

        font.weight: Font.Light
        text: qsTr("Projected distance to empty")
    }

    Item {
        id: chargingInfoItem

        anchors.top: energyGraphTitle.bottom
        anchors.topMargin: NeptuneStyle.dp(24)
        width: parent.width
        height: NeptuneStyle.dp(340)

        Image {
            height: NeptuneStyle.dp(2)
            width: parent.width
            source: Style.gfx("list-divider", NeptuneStyle.theme)
        }

        Label {
            anchors.top: parent.top
            anchors.topMargin: NeptuneStyle.dp(16)
            anchors.left: parent.left
            anchors.leftMargin: NeptuneStyle.dp(40)
            text: qsTr("184")
            font {
                pixelSize: NeptuneStyle.fontSizeL
            }

            Label {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: NeptuneStyle.dp(4)
                anchors.left: parent.right
                anchors.leftMargin: NeptuneStyle.dp(12)

                text: qsTr("km")
                font {
                    pixelSize: NeptuneStyle.fontSizeXS
                    weight: Font.Light
                }
                opacity: NeptuneStyle.opacityLow
            }
        }

        Label {
            anchors.top: parent.top
            anchors.topMargin: NeptuneStyle.dp(114)
            anchors.left: parent.left
            anchors.leftMargin: NeptuneStyle.dp(22)

            font.weight: Font.Light
            text: qsTr("Charging stations")
        }

        VehicleButton {
            anchors.top: parent.top
            anchors.topMargin: NeptuneStyle.dp(102)
            anchors.right: parent.right
            anchors.rightMargin: NeptuneStyle.dp(22)
            state: "SMALL"
            text: qsTr("Show on map")
        }

        Image {
            height: NeptuneStyle.dp(2)
            width: NeptuneStyle.dp(750)
            anchors.top: parent.top
            anchors.topMargin: NeptuneStyle.dp(168)
            source: Style.gfx("list-divider", NeptuneStyle.theme)
        }

        //ToDo: this probably should be in a model later
        Item {
            anchors.top: parent.top
            anchors.topMargin: NeptuneStyle.dp(180)
            anchors.left: parent.left
            width: parent.width
            height: NeptuneStyle.dp(60)

            Label {
                anchors.left: parent.left
                anchors.leftMargin: NeptuneStyle.dp(40)
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("21")
                font {
                    pixelSize: NeptuneStyle.fontSizeL
                }

                Label {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: NeptuneStyle.dp(4)
                    anchors.left: parent.right
                    anchors.leftMargin: NeptuneStyle.dp(10)

                    text: qsTr("km")
                    font {
                        pixelSize: NeptuneStyle.fontSizeXS
                        weight: Font.Light
                    }
                    opacity: NeptuneStyle.opacityLow
                }
            }

            Label {
                id: firstStationAddressLabel
                anchors.left: parent.left
                anchors.leftMargin: NeptuneStyle.dp(140)
                anchors.verticalCenter: parent.verticalCenter

                font.weight: Font.Light
                text: qsTr("Donald Weese Ct, Las Vegas")
            }

            VehicleButton {
                anchors.right: parent.right
                anchors.rightMargin: NeptuneStyle.dp(22)
                state: "SMALL"
                text: qsTr("Route")
                onClicked: {
                    var pathToRoute = "x-map://getMeTo/" + firstStationAddressLabel.text;
                    Qt.openUrlExternally(pathToRoute);
                }
            }
        }

        //ToDo: this probably should be in a model later
        Item {
            anchors.top: parent.top
            anchors.topMargin: NeptuneStyle.dp(245)
            anchors.left: parent.left
            width: parent.width
            height: NeptuneStyle.dp(60)

            Label {
                text: qsTr("27")

                anchors.left: parent.left
                anchors.leftMargin: NeptuneStyle.dp(40)
                anchors.verticalCenter: parent.verticalCenter
                font {
                    pixelSize: NeptuneStyle.fontSizeL
                }

                Label {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: NeptuneStyle.dp(4)
                    anchors.left: parent.right
                    anchors.leftMargin: NeptuneStyle.dp(10)

                    text: qsTr("km")
                    font {
                        pixelSize: NeptuneStyle.fontSizeXS
                        weight: Font.Light
                    }
                    opacity: NeptuneStyle.opacityLow
                }
            }

            Label {
                id: secondStationAddressLabel
                anchors.left: parent.left
                anchors.leftMargin: NeptuneStyle.dp(140)
                anchors.verticalCenter: parent.verticalCenter

                font.weight: Font.Light
                text: qsTr("Faiss Dr, Las Vegas")
            }

            VehicleButton {
                anchors.right: parent.right
                anchors.rightMargin: NeptuneStyle.dp(22)
                state: "SMALL"
                text: qsTr("Route")
                onClicked: {
                    var pathToRoute = "x-map://getMeTo/" + secondStationAddressLabel.text;
                    Qt.openUrlExternally(pathToRoute);
                }
            }
        }
    }
}

