/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
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

import QtQuick 2.6
import QtQuick.Controls 2.0
import utils 1.0

Control {
    id: root

    property alias text: textInput.text
    property alias hintText: hintLabel.text
    property alias length: textInput.length
    property alias inputMethodHints: textInput.inputMethodHints
    property bool forceFocusOnClick: false

    signal accepted

    Rectangle {
        id: background

        anchors.fill: parent
        color: Style.colorBlack
    }

    TextInput {
        id: textInput

        anchors.fill: parent
        anchors.leftMargin: Style.paddingXL
        anchors.rightMargin: Style.paddingXL
        verticalAlignment: Qt.AlignVCenter

        font.family: Style.fontFamily
        font.pixelSize: Style.fontSizeM
        color: Style.colorWhite
        clip: true

        onAccepted: root.accepted()
    }

    Label {
        id: hintLabel

        anchors.fill: textInput
        font.italic: true
        opacity: !textInput.activeFocus && textInput.length === 0

        Behavior on opacity { NumberAnimation {} }
    }

    MouseArea {
        id: focusMouseArea

        enabled: root.forceFocusOnClick && !textInput.activeFocus
        anchors.fill: textInput

        onClicked: textInput.forceActiveFocus()
    }
}
