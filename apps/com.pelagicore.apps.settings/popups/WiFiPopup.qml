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

import QtQuick 2.6
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import application.windows 1.0
import shared.utils 1.0

import shared.Style 1.0
import shared.Sizes 1.0

PopupWindow {
    id: root

    property alias ssid: ssidTextField.text
    property alias password: passwTextField.text
    property bool manual: false

    signal connectClicked(string ssid, string password)
    signal cancelClicked()

    QtObject {
        id: p
        property bool okClicked: false
    }

    Item {
        width: root.width
        height: root.height

        Label {
            anchors.baseline: parent.top
            anchors.baselineOffset: Sizes.dp(78)
            font.pixelSize: Sizes.fontSizeM
            width: parent.width
            text: !root.manual ? qsTr("Input password") : qsTr("Manual connection")
            horizontalAlignment: Text.AlignHCenter
        }
        Image {
            anchors.top: parent.top
            anchors.topMargin: Sizes.dp(120)
            width: parent.width
            height: Sizes.dp(sourceSize.height)
            source: Style.image("popup-title-shadow")
        }

        ColumnLayout {
            id: columnFields
            spacing: Sizes.dp(50)
            anchors.top: parent.top
            anchors.topMargin: Sizes.dp(170)
            anchors.left: parent.left
            anchors.leftMargin: Sizes.dp(100)
            anchors.right: parent.right
            anchors.rightMargin: Sizes.dp(100)

            Label {
                Layout.preferredHeight: Sizes.dp(50)
                Layout.alignment: Qt.AlignBottom | Qt.AlignLeft
                verticalAlignment: Text.AlignBottom
                Layout.bottomMargin: -Sizes.dp(25)
                text: qsTr("SSID")
                font.pixelSize: Sizes.fontSizeS
                elide: Text.ElideRight
                color: Style.contrastColor
            }

            TextField {
                id: ssidTextField
                Layout.fillWidth: true
                Layout.preferredHeight: Sizes.dp(100)
                font.family: Style.fontFamily
                font.pixelSize: Sizes.fontSizeM
                color: Style.contrastColor
                selectedTextColor: Style.contrastColor
                leftPadding: Sizes.dp(18)
                rightPadding: Sizes.dp(63)
                horizontalAlignment: TextInput.AlignLeft
                readOnly: !root.manual

                background: Rectangle {
                    border.color: Style.buttonColor
                    border.width: 1
                    color: "transparent"
                    radius: height/2
                }
            }

            Label {
                Layout.preferredHeight: Sizes.dp(50)
                Layout.alignment: Qt.AlignBottom | Qt.AlignLeft
                verticalAlignment: Text.AlignBottom
                Layout.bottomMargin: -Sizes.dp(25)
                text: qsTr("Password")
                font.pixelSize: Sizes.fontSizeS
                elide: Text.ElideRight
                color: Style.contrastColor
            }

            TextField {
                id: passwTextField
                Layout.fillWidth: true
                Layout.preferredHeight: Sizes.dp(100)
                font.family: Style.fontFamily
                font.pixelSize: Sizes.fontSizeM
                color: Style.contrastColor
                selectedTextColor: Style.contrastColor
                leftPadding: Sizes.dp(18)
                rightPadding: Sizes.dp(63)
                horizontalAlignment: TextInput.AlignLeft

                background: Rectangle {
                    border.color: Style.buttonColor
                    border.width: 1
                    color: "transparent"
                    radius: height/2

                }
            }

        }
        Button {
            anchors.top: columnFields.bottom
            anchors.topMargin: Sizes.dp(100)
            anchors.right: parent.right
            anchors.rightMargin: Sizes.dp(100)
            width: Sizes.dp(315)
            height: Sizes.dp(64)
            font.pixelSize: Sizes.fontSizeS
            text: qsTr("Connect")
            onClicked: {
                p.okClicked = true;
                root.connectClicked(ssidTextField.text, passwTextField.text);
                root.close();
            }
        }
    }

    onVisibleChanged: {
        if ((!root.visible) && (!p.okClicked)) {
            root.cancelClicked();
            p.okClicked = false;
        }
    }
}
