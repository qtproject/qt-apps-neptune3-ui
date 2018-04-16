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

import com.pelagicore.styles.neptune 3.0

import "paths"

Item {
    id: root

    Image {
        anchors.top: parent.top
        anchors.left: parent.left
        width: NeptuneStyle.dp(sourceSize.width)
        height: NeptuneStyle.dp(sourceSize.height)

        source: Paths.image("car-tires.png")

        Image {
            anchors.top: parent.top
            anchors.topMargin: NeptuneStyle.dp(120)
            anchors.left: parent.left
            anchors.leftMargin: NeptuneStyle.dp(110)
            source: Paths.image("tire.png")
            width: NeptuneStyle.dp(sourceSize.width)
            height: NeptuneStyle.dp(sourceSize.height)

            Label {
                anchors.right: parent.left
                anchors.rightMargin: NeptuneStyle.dp(26)
                anchors.verticalCenter: parent.verticalCenter

                text: qsTr("240")
                Label {
                    anchors.top: parent.bottom
                    anchors.topMargin: NeptuneStyle.dp(-6)
                    anchors.right: parent.right

                    text: qsTr("kPa")
                    font {
                        weight: Font.Light
                        pixelSize: NeptuneStyle.fontSizeXS
                    }
                    opacity: NeptuneStyle.fontOpacityLow
                }
            }
        }

        Image {
            anchors.top: parent.top
            anchors.topMargin: NeptuneStyle.dp(120)
            anchors.right: parent.right
            anchors.rightMargin: NeptuneStyle.dp(146)
            source: Paths.image("tire.png")
            width: NeptuneStyle.dp(sourceSize.width)
            height: NeptuneStyle.dp(sourceSize.height)

            Label {
                anchors.left: parent.right
                anchors.leftMargin: NeptuneStyle.dp(26)
                anchors.verticalCenter: parent.verticalCenter

                text: qsTr("240")
                Label {
                    anchors.top: parent.bottom
                    anchors.topMargin: NeptuneStyle.dp(-6)
                    anchors.right: parent.right

                    text: qsTr("kPa")
                    font {
                        pixelSize: NeptuneStyle.fontSizeXS
                        weight: Font.Light
                    }
                    opacity: NeptuneStyle.fontOpacityLow
                }
            }
        }

        Image {
            anchors.top: parent.top
            anchors.topMargin: NeptuneStyle.dp(480)
            anchors.left: parent.left
            anchors.leftMargin: NeptuneStyle.dp(110)
            source: Paths.image("tire.png")
            width: NeptuneStyle.dp(sourceSize.width)
            height: NeptuneStyle.dp(sourceSize.height)

            Label {
                anchors.right: parent.left
                anchors.rightMargin: NeptuneStyle.dp(26)
                anchors.verticalCenter: parent.verticalCenter

                text: qsTr("240")
                Label {
                    anchors.top: parent.bottom
                    anchors.topMargin: NeptuneStyle.dp(-6)
                    anchors.right: parent.right

                    text: qsTr("kPa")
                    font {
                        pixelSize: NeptuneStyle.fontSizeXS
                        weight: Font.Light
                    }
                    opacity: NeptuneStyle.fontOpacityLow
                }
            }
        }

        Image {
            anchors.top: parent.top
            anchors.topMargin: NeptuneStyle.dp(480)
            anchors.right: parent.right
            anchors.rightMargin: NeptuneStyle.dp(146)
            source: Paths.image("tire.png")
            width: NeptuneStyle.dp(sourceSize.width)
            height: NeptuneStyle.dp(sourceSize.height)

            Label {
                anchors.left: parent.right
                anchors.leftMargin: NeptuneStyle.dp(26)
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("240")

                Label {
                    anchors.top: parent.bottom
                    anchors.topMargin: NeptuneStyle.dp(-6)
                    anchors.right: parent.right

                    text: qsTr("kPa")
                    font {
                        pixelSize: NeptuneStyle.fontSizeXS
                        weight: Font.Light
                    }
                    opacity: NeptuneStyle.fontOpacityLow
                }
            }
        }
    }

    Label {
        anchors.right: parent.right
        anchors.rightMargin: NeptuneStyle.dp(22)
        anchors.top: parent.top
        anchors.topMargin: NeptuneStyle.dp(132)

        font.weight: Font.Light
        text: qsTr("Normal load")

        Label {
            anchors.top: parent.bottom
            anchors.topMargin: NeptuneStyle.dp(10)
            anchors.right: parent.right

            text: qsTr("Target: 240 kPa")
            font {
                pixelSize: NeptuneStyle.fontSizeS
                weight: Font.Light
            }
        }
    }


    Label {
        anchors.right: parent.right
        anchors.rightMargin: NeptuneStyle.dp(22)
        anchors.top: parent.top
        anchors.topMargin: NeptuneStyle.dp(270)

        font.weight: Font.Light
        text: qsTr("Max load")
        enabled: false

        Label {
            anchors.top: parent.bottom
            anchors.topMargin: NeptuneStyle.dp(10)
            anchors.right: parent.right

            text: qsTr("Target: 270 kPa")
            font {
                pixelSize: NeptuneStyle.fontSizeS
                weight: Font.Light
            }
        }
    }

    VehicleButton {
        id: calibrateButton

        anchors.top: parent.top
        anchors.topMargin: NeptuneStyle.dp(470)
        anchors.right: parent.right
        anchors.rightMargin: NeptuneStyle.dp(22)
        text: qsTr("Calibrate")
        readonly property string sourceSuffix: NeptuneStyle.theme === NeptuneStyle.Dark ? "-dark.png" : ".png"
        iconSource: Paths.image("ic-calibrate" + sourceSuffix)
    }
}
