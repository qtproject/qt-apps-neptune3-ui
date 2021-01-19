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

import QtQuick 2.8
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import shared.utils 1.0

import shared.controls 1.0
import shared.Style 1.0
import shared.Sizes 1.0

Item {
    id: root

    readonly property int largeButtonHeight: Sizes.dp(100)
    readonly property int smallButtonHeight: Sizes.dp(52)
    readonly property int largeButtonPadding: Sizes.dp(58)
    readonly property int smallButtonPadding: Sizes.dp(26)

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(80)
        spacing: Sizes.dp(40)
        RowLayout {
            spacing: Sizes.dp(13)

            Button {
                implicitWidth: Sizes.dp(315)
                implicitHeight: Sizes.dp(64)
                font.pixelSize: Sizes.fontSizeS
                text: qsTr("This is a button")
            }

            Button {
                implicitWidth: Sizes.dp(315)
                implicitHeight: Sizes.dp(64)
                font.pixelSize: Sizes.fontSizeS
                text: qsTr("Disabled Button")
                enabled: false
            }

            Button {
                implicitWidth: Sizes.dp(315)
                implicitHeight: Sizes.dp(64)
                font.pixelSize: Sizes.fontSizeS
                text: qsTr("Button Checkable")
                checkable: true
            }
        }
        RowLayout {
            spacing: Sizes.dp(13)

            Button {
                implicitHeight: smallButtonHeight
                implicitWidth: Sizes.dp(315)
                leftPadding: smallButtonPadding
                rightPadding: smallButtonPadding
                font.pixelSize: Sizes.fontSizeS
                text: qsTr("Small button")
            }
            Button {
                implicitHeight: smallButtonHeight
                implicitWidth: Sizes.dp(315)
                leftPadding: smallButtonPadding
                rightPadding: smallButtonPadding
                font.pixelSize: Sizes.fontSizeS
                text: qsTr("Small button")
                icon.name: "ic-steering-wheel-heat_OFF"
            }
            Button {
                implicitHeight: smallButtonHeight
                implicitWidth: Sizes.dp(315)
                leftPadding: smallButtonPadding
                rightPadding: smallButtonPadding
                font.pixelSize: Sizes.fontSizeS
                text: qsTr("Checkable")
                icon.name: checked ? "ic-steering-wheel-heat_ON" : "ic-steering-wheel-heat_OFF"
                checkable: true
            }
        }
        RowLayout {
            spacing: Sizes.dp(13)
            Button {
                text: qsTr("Large button")
                implicitHeight: largeButtonHeight
                implicitWidth: Sizes.dp(315)
                leftPadding: largeButtonPadding
                rightPadding: largeButtonPadding
                font.pixelSize: Sizes.fontSizeS

            }
            Button {
                implicitHeight: largeButtonHeight
                implicitWidth: Sizes.dp(315)
                leftPadding: largeButtonPadding
                rightPadding: largeButtonPadding
                font.pixelSize: Sizes.fontSizeS
                text: qsTr("Large button")
                icon.name: "ic-steering-wheel-heat_OFF"
            }
            Button {
                implicitHeight: largeButtonHeight
                implicitWidth: Sizes.dp(315)
                leftPadding: largeButtonPadding
                rightPadding: largeButtonPadding
                font.pixelSize: Sizes.fontSizeS
                text: qsTr("Checkable")
                icon.name: checked ? "ic-seat-heat-passenger_ON" : "ic-seat-heat-passenger_OFF"
                checkable: true
            }
        }
        RowLayout {
            spacing: Sizes.dp(13)

            Label {
                text: qsTr("Custom background:")
            }

            Button {
                implicitHeight: largeButtonHeight
                implicitWidth: Sizes.dp(160)
                icon.width: Sizes.dp(40)
                icon.height: Sizes.dp(40)
                background: ButtonBackground {
                    color: parent.pressed ? Qt.darker(Style.clusterMarksColor, (1 / Style.opacityHigh))
                                          : Style.clusterMarksColor
                    opacity: 1
                }
                icon.name: "ic-seat-heat-passenger_OFF"
                icon.color: "white"
            }
            Button {
                implicitHeight: largeButtonHeight
                implicitWidth: Sizes.dp(160)
                icon.width: Sizes.dp(35)
                icon.height: Sizes.dp(35)
                background: ButtonBackground {
                    color: parent.pressed ? Qt.darker(Style.accentDetailColor, (1 / Style.opacityHigh))
                                          : Style.accentDetailColor
                    opacity: 1
                }
                icon.name: "ic-seat-heat-passenger_OFF"
                text: qsTr("text")
                font.pixelSize: Sizes.fontSizeS
                display: AbstractButton.TextUnderIcon
                spacing: 0
            }
        }
        RowLayout {
            spacing: Sizes.dp(13)
            Button {
                implicitHeight: largeButtonHeight
                implicitWidth: Sizes.dp(500)
                leftPadding: largeButtonPadding
                rightPadding: largeButtonPadding
                text: qsTr("Wide button")
                font.pixelSize: Sizes.fontSizeS
                icon.name: "ic-steering-wheel-heat_OFF"
            }
            Button {
                implicitHeight: largeButtonHeight
                implicitWidth: Sizes.dp(315)
                leftPadding: largeButtonPadding
                rightPadding: largeButtonPadding
                font.pixelSize: Sizes.fontSizeS
                text: qsTr("Elide too long text")
                icon.name: "ic-steering-wheel-heat_OFF"
            }
        }
    }
}

