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

import shared.controls 1.0
import shared.utils 1.0

import shared.Style 1.0
import shared.Sizes 1.0

import "../controls"

Control {
    id: root

    property bool hotspotEnabled: false
    property alias ssid: ssidTextField.text
    property alias password: passwTextField.text

    signal backButtonClicked()
    signal toggleEnableHotspot()

    contentItem: Flickable {
        id: flickable
        width: parent.width
        height: parent.height
        clip: true
        flickableDirection: Flickable.VerticalFlick
        interactive: contentHeight > height
        contentHeight: column1.height
        ScrollBar.vertical: ScrollBar { }

        Column {
            id: column1

            Item {
                id: listHeader
                width: Sizes.dp(720)
                height: Sizes.dp(94)

                ToolButton {
                    id: backButton
                    objectName: "backButton"
                    anchors.left: parent.left
                    anchors.leftMargin: Sizes.dp(13.5)
                    anchors.verticalCenter: parent.verticalCenter
                    icon.name: LayoutMirroring.enabled ? "ic_forward" : "ic_back"
                    onClicked: root.backButtonClicked()
                }
                Label {
                    id: headerLabel
                    width: Sizes.dp(600)
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: Sizes.fontSizeS
                    elide: Text.ElideRight
                    text: qsTr("Hotspot")
                }
                Rectangle {
                    id: headerDivider
                    width: parent.width
                    height: Sizes.dp(1)
                    anchors.bottom: parent.bottom
                    color: "grey"   //todo: change to #contrast 60%
                }
            }

            Item {
                id: spacing0
                width: parent.width
                height: Sizes.dp(53)
            }

            SwitchDelegate {
                text: qsTr("Hotspot Enabled")
                width: root.width
                checked: root.hotspotEnabled
                onToggled: root.hotspotEnabled = checked
                enabled: root.ssid !== "" && root.password !== ""
            }

            Item {
                id: spacing1
                width: parent.width
                height: Sizes.dp(80)
            }

            Label {
                id: ssidTitle
                width: root.width
                text: qsTr("SSID")
                font.pixelSize: Sizes.fontSizeS
                elide: Text.ElideRight
                color: Style.contrastColor
                enabled: !root.hotspotEnabled
            }

            Item {
                id: spacing2
                width: parent.width
                height: Sizes.dp(20)
            }

            TextField {
                id: ssidTextField
                width: root.width
                height: Sizes.dp (100)
                font.family: Style.fontFamily
                font.pixelSize: Sizes.fontSizeM
                color: Style.contrastColor
                selectedTextColor: Style.contrastColor
                leftPadding: Sizes.dp(18)
                rightPadding: Sizes.dp(63)
                horizontalAlignment: TextInput.AlignLeft
                enabled: !root.hotspotEnabled
                background: Rectangle {
                    border.color: Style.buttonColor
                    border.width: Sizes.dp(1)
                    color: "transparent"
                    radius: height/2
                }
            }

            Item {
                id: spacing3
                width: parent.width
                height: Sizes.dp(80)
            }

            Label {
                id: passwTitle
                width: root.width
                text: qsTr("Password")
                font.pixelSize: Sizes.fontSizeS
                elide: Text.ElideRight
                color: Style.contrastColor
                enabled: !root.hotspotEnabled
            }

            Item {
                id: spacing4
                width: parent.width
                height: Sizes.dp(20)
            }

            TextField {
                id: passwTextField
                width: root.width
                height: Sizes.dp (100)
                font.family: Style.fontFamily
                font.pixelSize: Sizes.fontSizeM
                color: Style.contrastColor
                selectedTextColor: Style.contrastColor
                leftPadding: Sizes.dp(18)
                rightPadding: Sizes.dp(63)
                horizontalAlignment: TextInput.AlignLeft
                enabled: !root.hotspotEnabled
                background: Rectangle {
                    border.color: Style.buttonColor
                    border.width: Sizes.dp(1)
                    color: "transparent"
                    radius: height/2
                }
            }

        }
    }

}
