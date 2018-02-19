/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AB
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

import QtQuick 2.9
import QtQuick.Controls 2.2

import com.pelagicore.styles.triton 1.0

Item {
    id: root

    Image {
        anchors.top: parent.top
        anchors.topMargin: 44
        anchors.left: parent.left
        anchors.leftMargin: 100

        source: "assets/images/car-tires.png"

        Image {
            anchors.top: parent.top
            anchors.topMargin: 80
            anchors.left: parent.left
            anchors.leftMargin: 26
            source: "assets/images/tire.png"

            Label {
                anchors.right: parent.left
                anchors.rightMargin: 26
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("240")

                Label {
                    anchors.top: parent.bottom
                    anchors.topMargin: -6
                    anchors.right: parent.right

                    text: qsTr("kPa")
                    font {
                        weight: Font.Light
                        pixelSize: TritonStyle.fontSizeXS
                    }
                    opacity: TritonStyle.fontOpacityLow
                }
            }
        }

        Image {
            anchors.top: parent.top
            anchors.topMargin: 80
            anchors.right: parent.right
            anchors.rightMargin: 26
            source: "assets/images/tire.png"

            Label {
                anchors.left: parent.right
                anchors.leftMargin: 26
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("240")

                Label {
                    anchors.top: parent.bottom
                    anchors.topMargin: -6
                    anchors.right: parent.right
                    text: qsTr("kPa")
                    font {
                        pixelSize: TritonStyle.fontSizeXS
                        weight: Font.Light
                    }
                    opacity: TritonStyle.fontOpacityLow
                }
            }
        }

        Image {
            anchors.top: parent.top
            anchors.topMargin: 350
            anchors.left: parent.left
            anchors.leftMargin: 26
            source: "assets/images/tire.png"

            Label {
                anchors.right: parent.left
                anchors.rightMargin: 26
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("240")

                Label {
                    anchors.top: parent.bottom
                    anchors.topMargin: -6
                    anchors.right: parent.right

                    text: qsTr("kPa")
                    font {
                        pixelSize: TritonStyle.fontSizeXS
                        weight: Font.Light
                    }
                    opacity: TritonStyle.fontOpacityLow
                }
            }
        }

        Image {
            anchors.top: parent.top
            anchors.topMargin: 350
            anchors.right: parent.right
            anchors.rightMargin: 26
            source: "assets/images/tire.png"

            Label {
                anchors.left: parent.right
                anchors.leftMargin: 26
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("240")
                font {
                    pixelSize: 32
                    family: "Open Sans"
                }

                Label {
                    anchors.top: parent.bottom
                    anchors.topMargin: -6
                    anchors.right: parent.right
                    text: qsTr("kPa")
                    font {
                        pixelSize: TritonStyle.fontSizeXS
                        weight: Font.Light
                    }
                    opacity: TritonStyle.fontOpacityLow
                }
            }
        }
    }

    Label {
        anchors.right: parent.right
        anchors.rightMargin: 22
        anchors.top: parent.top
        anchors.topMargin: 132

        font.weight: Font.Light
        text: qsTr("Normal load")

        Label {
            anchors.top: parent.bottom
            anchors.topMargin: 10
            anchors.right: parent.right

            text: qsTr("Target: 240 kPa")
            font {
                pixelSize: TritonStyle.fontSizeS
                weight: Font.Light
            }
        }
    }


    Label {
        anchors.right: parent.right
        anchors.rightMargin: 22
        anchors.top: parent.top
        anchors.topMargin: 270

        font.weight: Font.Light
        text: qsTr("Max load")
        enabled: false

        Label {
            anchors.top: parent.bottom
            anchors.topMargin: 10
            anchors.right: parent.right

            text: qsTr("Target: 270 kPa")
            font {
                pixelSize: TritonStyle.fontSizeS
                weight: Font.Light
            }
        }
    }

    VehicleButton {
        id: calibrateButton

        anchors.top: parent.top
        anchors.topMargin: 470
        anchors.right: parent.right
        anchors.rightMargin: 22
        text: qsTr("Calibrate")
        readonly property string sourceSuffix: TritonStyle.theme === TritonStyle.Dark ? "-dark.png" : ".png"
        iconSource: "assets/images/ic-calibrate" + sourceSuffix
    }
}
