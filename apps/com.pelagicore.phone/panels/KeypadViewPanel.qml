/****************************************************************************
**
** Copyright (C) 2017-2018 Pelagicore AB
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

import QtQuick 2.8
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import shared.Style 1.0
import shared.Sizes 1.0
import shared.utils 1.0
import shared.animations 1.0
import shared.controls 1.0
import "../controls" 1.0

Item {

    Component.onCompleted: textedit.forceActiveFocus()

    opacity: visible ? 1 : 0
    Behavior on opacity { DefaultNumberAnimation { } }

    Rectangle {
        id: cursor
        visible: textedit.text !== ""
        anchors.right: textedit.right
        anchors.rightMargin: Sizes.dp(18)
        anchors.verticalCenter: textedit.verticalCenter
        width: Sizes.dp(2)
        height: Sizes.dp(60)
        color: Style.contrastColor
        opacity: 0
        SequentialAnimation {
            running: true
            loops: Animation.Infinite
            NumberAnimation { target: cursor; property: "opacity"; to: 0.2; duration: 500 }
            NumberAnimation { target: cursor; property: "opacity"; to: 0; duration: 500 }
        }
    }

    // TODO: Use a TextField instead so that it follows the current style automatically
    TextEdit {
        id: textedit
        anchors.left: gridlayout.left
        anchors.right: gridlayout.right
        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(40)
        leftPadding: Sizes.dp(45 * 0.5)
        rightPadding: Sizes.dp(45 * 0.5)
        readOnly: true
        color: Style.contrastColor
        inputMethodHints: Qt.ImhDialableCharactersOnly
        font.pixelSize: Sizes.fontSizeXL
        font.weight: Font.Light
        wrapMode: TextEdit.Wrap
        horizontalAlignment: TextEdit.AlignRight
        Keys.onEscapePressed: clear()
    }

    ToolButton {
        anchors.right: parent.right
        anchors.verticalCenter: textedit.verticalCenter
        width: Sizes.dp(90)
        icon.name: "ic-erase"
        opacity: textedit.text ? 1.0 : 0.0
        visible: opacity > 0
        Behavior on opacity { DefaultNumberAnimation {} }
        onClicked: textedit.remove(textedit.length - 1, textedit.length);
    }

    GridLayout {
        id: gridlayout

        width: Sizes.dp(500)
        height: Sizes.dp(540)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: textedit.bottom
        anchors.topMargin: Sizes.dp(80)
        columns: 3
        columnSpacing: Sizes.dp(10)
        rowSpacing: Sizes.dp(10)
        KeypadButton {
            primaryText: "1"
            secondaryText: " " // to keep the "1" above
            onClicked: textedit.text += primaryText
        }
        KeypadButton {
            primaryText: "2"
            secondaryText: "ABC"
            onClicked: textedit.text += primaryText
        }
        KeypadButton {
            primaryText: "3"
            secondaryText: "DEF"
            onClicked: textedit.text += primaryText
        }
        KeypadButton {
            primaryText: "4"
            secondaryText: "GHI"
            onClicked: textedit.text += primaryText
        }
        KeypadButton {
            primaryText: "5"
            secondaryText: "JKL"
            onClicked: textedit.text += primaryText
        }
        KeypadButton {
            primaryText: "6"
            secondaryText: "MNO"
            onClicked: textedit.text += primaryText
        }
        KeypadButton {
            primaryText: "7"
            secondaryText: "PQRS"
            onClicked: textedit.text += primaryText
        }
        KeypadButton {
            primaryText: "8"
            secondaryText: "TUV"
            onClicked: textedit.text += primaryText
        }
        KeypadButton {
            primaryText: "9"
            secondaryText: "WXYZ"
            onClicked: textedit.text += primaryText
        }
        KeypadButton {
            primaryText: "*"
            onClicked: textedit.text += primaryText
        }
        KeypadButton {
            primaryText: "0"
            secondaryText: "+"
            onClicked: textedit.text += primaryText
        }
        KeypadButton {
            primaryText: "#"
            onClicked: textedit.text += primaryText
        }
        KeypadButton {
            Layout.row: 4
            Layout.column: 1
            enabled: textedit.text
            backgroundColor: "#68C97D" // app specific color
            backgroundOpacity: 1.0
            iconSource: Config.symbol("ic-call")
        }
    }
}
