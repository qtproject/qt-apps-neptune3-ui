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

import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

import shared.Sizes 1.0

GridLayout {
    anchors.leftMargin: Sizes.dp(100)
    anchors.rightMargin: Sizes.dp(100)
    columns: 2

    ToolButton {
        Layout.alignment: Qt.AlignCenter
        icon.name: "ic-close"
    }
    Label {
        text: qsTr("Icon only")
        font.pixelSize: Sizes.fontSizeS
    }

    ToolButton {
        Layout.alignment: Qt.AlignCenter
        icon.name: "ic_back"
        text: qsTr("Back")
    }
    Label {
        text: qsTr("Icon with text")
        font.pixelSize: Sizes.fontSizeS
    }

    ToolButton {
        Layout.alignment: Qt.AlignCenter
        icon.name: "ic-update"
        text: qsTr("Update")
        display: AbstractButton.TextUnderIcon
    }
    Label {
        text: qsTr("Icon with text below")
        font.pixelSize: Sizes.fontSizeS
    }

    ToolButton {
        Layout.alignment: Qt.AlignCenter
        checkable: true
        checked: true
        icon.name: checked ? "ic-color_ON" : "ic-color_OFF"
        text: qsTr("Color")
        display: AbstractButton.TextUnderIcon
    }
    Label {
        text: qsTr("Checkable tool button, icon + text below")
        font.pixelSize: Sizes.fontSizeS
    }

    ToolButton {
        Layout.alignment: Qt.AlignCenter
        checkable: true
        checked: true
        icon.name: checked ? "ic-themes_ON" : "ic-themes_OFF"
        icon.color: "green"
        text: qsTr("Green")
        display: AbstractButton.TextUnderIcon
    }
    Label {
        text: qsTr("Checkable tool button, custom colored icon")
        font.pixelSize: Sizes.fontSizeS
    }

    ToolButton {
        Layout.alignment: Qt.AlignCenter
        icon.name: "ic_back"
        icon.width: Sizes.dp(16)
        icon.height: Sizes.dp(16)
    }
    Label {
        text: qsTr("Custom icon size")
        font.pixelSize: Sizes.fontSizeS
    }

    Item {
        Layout.fillHeight: true
    }
}

