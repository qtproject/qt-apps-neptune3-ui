/****************************************************************************
**
** Copyright (C) 2018 Luxoft Sweden AB
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

import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

import shared.com.pelagicore.styles.neptune 3.0

GridLayout {
    anchors.leftMargin: NeptuneStyle.dp(100)
    anchors.rightMargin: NeptuneStyle.dp(100)
    columns: 2

    ToolButton {
        Layout.alignment: Qt.AlignCenter
        icon.name: "ic-close"
    }
    Label {
        text: "Icon only"
        font.pixelSize: NeptuneStyle.fontSizeS
    }

    ToolButton {
        Layout.alignment: Qt.AlignCenter
        icon.name: "ic_back"
        text: "Back"
    }
    Label {
        text: "Icon with text"
        font.pixelSize: NeptuneStyle.fontSizeS
    }

    ToolButton {
        Layout.alignment: Qt.AlignCenter
        icon.name: "ic-update"
        text: "Update"
        display: AbstractButton.TextUnderIcon
    }
    Label {
        text: "Icon with text below"
        font.pixelSize: NeptuneStyle.fontSizeS
    }

    ToolButton {
        Layout.alignment: Qt.AlignCenter
        checkable: true
        checked: true
        icon.name: checked ? "ic-color_ON" : "ic-color_OFF"
        text: "Color"
        display: AbstractButton.TextUnderIcon
    }
    Label {
        text: "Checkable tool button, icon + text below"
        font.pixelSize: NeptuneStyle.fontSizeS
    }

    ToolButton {
        Layout.alignment: Qt.AlignCenter
        checkable: true
        checked: true
        icon.name: checked ? "ic-themes_ON" : "ic-themes_OFF"
        icon.color: "green"
        text: "Green"
        display: AbstractButton.TextUnderIcon
    }
    Label {
        text: "Checkable tool button, custom colored icon"
        font.pixelSize: NeptuneStyle.fontSizeS
    }

    ToolButton {
        Layout.alignment: Qt.AlignCenter
        icon.name: "ic_back"
        icon.width: NeptuneStyle.dp(16)
        icon.height: NeptuneStyle.dp(16)
    }
    Label {
        text: "Custom icon size"
        font.pixelSize: NeptuneStyle.fontSizeS
    }

    Item {
        Layout.fillHeight: true
    }
}

