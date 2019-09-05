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
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import shared.Style 1.0
import shared.Sizes 1.0
import shared.utils 1.0
import shared.animations 1.0
import shared.controls 1.0
import "../controls" 1.0

Item {
    opacity: visible ? 1 : 0
    Behavior on opacity { DefaultNumberAnimation { } }

    Flickable {
        id: flick

        width: Sizes.dp(500)
        height: Sizes.dp(45)
        contentWidth: textedit.paintedWidth
        contentHeight: textedit.paintedHeight
        clip: true
        interactive: false

        anchors.left: gridlayout.left
        anchors.right: gridlayout.right
        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(40)

        function ensureVisible(cw) {
            var printableWidth = width - Sizes.dp(45);
            if (cw > printableWidth) {
                textedit.x = printableWidth - cw;
            } else {
                textedit.x = 0;
            }
        }

        // TODO: Use a TextField instead so that it follows the current style automatically
        TextEdit {
            id: textedit
            objectName: "callNumber"
            width: flick.width
            height: flick.height

            leftPadding: Sizes.dp(45 * 0.5)
            rightPadding: Sizes.dp(45 * 0.5)

            readOnly: true
            color: Style.contrastColor
            inputMethodHints: Qt.ImhDialableCharactersOnly
            font.pixelSize: Sizes.fontSizeXL
            font.weight: Font.Light
            horizontalAlignment: TextEdit.AlignHCenter
            Keys.onEscapePressed: clear()

            onCursorRectangleChanged: flick.ensureVisible(contentWidth)
        }
    }



    ToolButton {
        objectName: "delLastCallDigitButton"
        anchors.right: parent.right
        anchors.verticalCenter: flick.verticalCenter
        width: Sizes.dp(90)
        icon.name: "ic-erase"
        opacity: textedit.text ? 1.0 : 0.0
        visible: opacity > 0
        Behavior on opacity { DefaultNumberAnimation {} }
        onClicked: {
            textedit.remove(textedit.length - 1, textedit.length);
            flick.ensureVisible(textedit.contentWidth)
        }
    }

    GridLayout {
        id: gridlayout

        width: Sizes.dp(500)
        height: Sizes.dp(540)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: flick.bottom
        anchors.topMargin: Sizes.dp(80)
        columns: 3
        columnSpacing: Sizes.dp(10)
        rowSpacing: Sizes.dp(10)
        KeypadButton {
            objectName: "padButton_1"
            text: "1"
            secondaryText: " " // to keep the "1" above
            onClicked: { textedit.text += text; }
        }
        KeypadButton {
            objectName: "padButton_2"
            text: "2"
            secondaryText: "ABC"
            onClicked: { textedit.text += text; }
        }
        KeypadButton {
            objectName: "padButton_3"
            text: "3"
            secondaryText: "DEF"
            onClicked: { textedit.text += text; }
        }
        KeypadButton {
            objectName: "padButton_4"
            text: "4"
            secondaryText: "GHI"
            onClicked: { textedit.text += text; }
        }
        KeypadButton {
            objectName: "padButton_5"
            text: "5"
            secondaryText: "JKL"
            onClicked: { textedit.text += text; }
        }
        KeypadButton {
            objectName: "padButton_6"
            text: "6"
            secondaryText: "MNO"
            onClicked: { textedit.text += text; }
        }
        KeypadButton {
            objectName: "padButton_7"
            text: "7"
            secondaryText: "PQRS"
            onClicked: { textedit.text += text; }
        }
        KeypadButton {
            objectName: "padButton_8"
            text: "8"
            secondaryText: "TUV"
            onClicked: { textedit.text += text; }
        }
        KeypadButton {
            objectName: "padButton_9"
            text: "9"
            secondaryText: "WXYZ"
            onClicked: { textedit.text += text; }
        }
        KeypadButton {
            objectName: "padButton_asterisk"
            text: "*"
            onClicked: { textedit.text += text; }
        }
        KeypadButton {
            objectName: "padButton_0"
            text: "0"
            secondaryText: "+"
            onClicked: { textedit.text += text; }
        }
        KeypadButton {
            objectName: "padButton_hash"
            text: "#"
            onClicked: { textedit.text += text; }
        }
        KeypadButton {
            Layout.row: 4
            Layout.column: 1
            enabled: textedit.text.length > 0
            backgroundColor: "#68C97D" // app specific color
            backgroundOpacity: 1.0
            icon.name: Style.image("ic-call")
        }
    }
}
