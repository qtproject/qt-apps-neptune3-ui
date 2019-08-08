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

import shared.Style 1.0
import shared.Sizes 1.0

import "../helpers" 1.0
import "../controls" 1.0

Item {
    id: root

    LayoutMirroring.enabled: false
    LayoutMirroring.childrenInherit: true

    Image {
        anchors.top: parent.top
        anchors.left: parent.left
        width: Sizes.dp(sourceSize.width)
        height: Sizes.dp(sourceSize.height)

        source: Paths.getImagePath("car-tires.png")

        Image {
            anchors.top: parent.top
            anchors.topMargin: Sizes.dp(120)
            anchors.left: parent.left
            anchors.leftMargin: Sizes.dp(110)
            source: Paths.getImagePath("tire.png")
            width: Sizes.dp(sourceSize.width)
            height: Sizes.dp(sourceSize.height)

            Label {
                anchors.right: parent.left
                anchors.rightMargin: Sizes.dp(26)
                anchors.verticalCenter: parent.verticalCenter

                text: qsTr("240")
                Label {
                    anchors.top: parent.bottom
                    anchors.topMargin: Sizes.dp(-6)
                    anchors.right: parent.right

                    text: qsTr("kPa")
                    font {
                        weight: Font.Light
                        pixelSize: Sizes.fontSizeXS
                    }
                    opacity: Style.opacityLow
                }
            }
        }

        Image {
            anchors.top: parent.top
            anchors.topMargin: Sizes.dp(120)
            anchors.right: parent.right
            anchors.rightMargin: Sizes.dp(146)
            source: Paths.getImagePath("tire.png")
            width: Sizes.dp(sourceSize.width)
            height: Sizes.dp(sourceSize.height)

            Label {
                anchors.left: parent.right
                anchors.leftMargin: Sizes.dp(26)
                anchors.verticalCenter: parent.verticalCenter

                text: qsTr("240")
                Label {
                    anchors.top: parent.bottom
                    anchors.topMargin: Sizes.dp(-6)
                    anchors.right: parent.right

                    text: qsTr("kPa")
                    font {
                        pixelSize: Sizes.fontSizeXS
                        weight: Font.Light
                    }
                    opacity: Style.opacityLow
                }
            }
        }

        Image {
            anchors.top: parent.top
            anchors.topMargin: Sizes.dp(480)
            anchors.left: parent.left
            anchors.leftMargin: Sizes.dp(110)
            source: Paths.getImagePath("tire.png")
            width: Sizes.dp(sourceSize.width)
            height: Sizes.dp(sourceSize.height)

            Label {
                anchors.right: parent.left
                anchors.rightMargin: Sizes.dp(26)
                anchors.verticalCenter: parent.verticalCenter

                text: qsTr("240")
                Label {
                    anchors.top: parent.bottom
                    anchors.topMargin: Sizes.dp(-6)
                    anchors.right: parent.right

                    text: qsTr("kPa")
                    font {
                        pixelSize: Sizes.fontSizeXS
                        weight: Font.Light
                    }
                    opacity: Style.opacityLow
                }
            }
        }

        Image {
            anchors.top: parent.top
            anchors.topMargin: Sizes.dp(480)
            anchors.right: parent.right
            anchors.rightMargin: Sizes.dp(146)
            source: Paths.getImagePath("tire.png")
            width: Sizes.dp(sourceSize.width)
            height: Sizes.dp(sourceSize.height)

            Label {
                anchors.left: parent.right
                anchors.leftMargin: Sizes.dp(26)
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("240")

                Label {
                    anchors.top: parent.bottom
                    anchors.topMargin: Sizes.dp(-6)
                    anchors.right: parent.right

                    text: qsTr("kPa")
                    font {
                        pixelSize: Sizes.fontSizeXS
                        weight: Font.Light
                    }
                    opacity: Style.opacityLow
                }
            }
        }
    }

    Label {
        anchors.right: parent.right
        anchors.rightMargin: Sizes.dp(22)
        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(132)

        font.weight: Font.Light
        text: qsTr("Normal load")

        Label {
            anchors.top: parent.bottom
            anchors.topMargin: Sizes.dp(10)
            anchors.right: parent.right

            text: qsTr("Target: 240 kPa")
            font {
                pixelSize: Sizes.fontSizeS
                weight: Font.Light
            }
        }
    }


    Label {
        anchors.right: parent.right
        anchors.rightMargin: Sizes.dp(22)
        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(270)

        font.weight: Font.Light
        text: qsTr("Max load")
        enabled: false

        Label {
            anchors.top: parent.bottom
            anchors.topMargin: Sizes.dp(10)
            anchors.right: parent.right

            text: qsTr("Target: 270 kPa")
            font {
                pixelSize: Sizes.fontSizeS
                weight: Font.Light
            }
        }
    }

    VehicleButton {
        id: calibrateButton

        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(470)
        anchors.right: parent.right
        anchors.rightMargin: Sizes.dp(22)
        text: qsTr("Calibrate")
        readonly property string sourceSuffix: Style.theme === Style.Dark ? "-dark.png" : ".png"
        icon.source: Paths.getImagePath("ic-calibrate" + sourceSuffix)
    }
}
