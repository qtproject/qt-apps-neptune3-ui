/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AB
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

import "paths"

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
        anchors.topMargin: 40
        readonly property string sourceSuffix: NeptuneStyle.theme === NeptuneStyle.Dark ? "-dark.png" : ".png"
        width: parent.width
        source: Paths.image("energy-graph" + sourceSuffix)
    }

    Label {
        id: energyGraphTitle

        anchors.top: energyGraph.bottom
        anchors.topMargin: 46
        anchors.left: energyGraph.left
        anchors.leftMargin: 22

        font.weight: Font.Light
        text: qsTr("Projected distance to empty")
    }

    Item {
        id: chargingInfoItem

        anchors.top: energyGraphTitle.bottom
        anchors.topMargin: 24
        width: parent.width
        height: 340

        Image {
            height: 2
            width: parent.width
            source: Style.gfx2("list-divider", NeptuneStyle.theme)
        }

        Label {
            anchors.top: parent.top
            anchors.topMargin: 16
            anchors.left: parent.left
            anchors.leftMargin: 40
            text: qsTr("184")
            font {
                pixelSize: NeptuneStyle.fontSizeL
            }

            Label {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 4
                anchors.left: parent.right
                anchors.leftMargin: 12

                text: qsTr("km")
                font {
                    pixelSize: NeptuneStyle.fontSizeXS
                    weight: Font.Light
                }
                opacity: NeptuneStyle.fontOpacityLow
            }
        }

        Label {
            anchors.top: parent.top
            anchors.topMargin: 114
            anchors.left: parent.left
            anchors.leftMargin: 22

            font.weight: Font.Light
            text: qsTr("Charging stations")
        }

        VehicleButton {
            anchors.top: parent.top
            anchors.topMargin: 102
            anchors.right: parent.right
            anchors.rightMargin: 22
            state: "SMALL"
            text: qsTr("Show on map")
        }

        Image {
            height: 2
            width: 750
            anchors.top: parent.top
            anchors.topMargin: 168
            source: Style.gfx2("list-divider", NeptuneStyle.theme)
        }

        //ToDo: this probably should be in a model later
        Item {
            anchors.top: parent.top
            anchors.topMargin: 180
            anchors.left: parent.left
            width: parent.width
            height: 60

            Label {
                anchors.left: parent.left
                anchors.leftMargin: 40
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("21")
                font {
                    pixelSize: NeptuneStyle.fontSizeL
                }

                Label {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 4
                    anchors.left: parent.right
                    anchors.leftMargin: 10

                    text: qsTr("km")
                    font {
                        pixelSize: NeptuneStyle.fontSizeXS
                        weight: Font.Light
                    }
                    opacity: NeptuneStyle.fontOpacityLow
                }
            }

            Label {
                anchors.left: parent.left
                anchors.leftMargin: 140
                anchors.verticalCenter: parent.verticalCenter

                font.weight: Font.Light
                text: qsTr("Donald Weese Ct, Las Vegas")
            }

            VehicleButton {
                anchors.right: parent.right
                anchors.rightMargin: 22
                state: "SMALL"
                text: qsTr("Route")
            }
        }

        //ToDo: this probably should be in a model later
        Item {
            anchors.top: parent.top
            anchors.topMargin: 245
            anchors.left: parent.left
            width: parent.width
            height: 60

            Label {
                text: qsTr("27")

                anchors.left: parent.left
                anchors.leftMargin: 40
                anchors.verticalCenter: parent.verticalCenter
                font {
                    pixelSize: NeptuneStyle.fontSizeL
                }

                Label {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 4
                    anchors.left: parent.right
                    anchors.leftMargin: 10

                    text: qsTr("km")
                    font {
                        pixelSize: NeptuneStyle.fontSizeXS
                        weight: Font.Light
                    }
                    opacity: NeptuneStyle.fontOpacityLow
                }
            }

            Label {
                anchors.left: parent.left
                anchors.leftMargin: 140
                anchors.verticalCenter: parent.verticalCenter

                font.weight: Font.Light
                text: qsTr("Faiss Dr, Las Vegas")
            }

            VehicleButton {
                anchors.right: parent.right
                anchors.rightMargin: 22
                state: "SMALL"
                text: qsTr("Route")
            }
        }
    }
}

