/****************************************************************************
**
** Copyright (C) 2017, 2018 Pelagicore AG
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
import QtQuick.Layouts 1.2

import com.pelagicore.styles.neptune 3.0
import utils 1.0

/*
    A column of tool buttons where only one of them can be selected at any given time.

    Usage example:

    ToolsColumn {
        translationContext: "MyToolsColumn"
        model: ListModel {
            ListElement { icon: "ic-foo"; text: QT_TRANSLATE_NOOP("MyToolsColumn", "foo") }
            ListElement { icon: "ic-bar"; text: QT_TRANSLATE_NOOP("MyToolsColumn", "bar") }
        }
    }

*/
ColumnLayout {
    id: root

    width: NeptuneStyle.dp(135)

    property int currentIndex: 0
    readonly property string currentText: model ? model.get(currentIndex).text : ""

    property alias model: repeater.model

    ButtonGroup { id: buttonGroup }

    spacing: NeptuneStyle.dp(24)

    property string translationContext
    signal clicked()

    Repeater {
        id: repeater

        ToolButton {
            Layout.preferredWidth: NeptuneStyle.dp(135)
            Layout.preferredHeight: NeptuneStyle.dp(96)
            Layout.alignment: Qt.AlignHCenter
            baselineOffset: 0
            checkable: true
            checked: root.currentIndex === index
            icon.name: model.icon ? (checked ? model.icon + "_ON" : model.icon + "_OFF") : ""
            text: qsTranslate(root.translationContext, model.text)
            font.pixelSize: NeptuneStyle.fontSizeS
            enabled: !model.greyedOut
            display: AbstractButton.TextUnderIcon
            onClicked: {
                root.currentIndex = index;
                root.clicked();
            }
            ButtonGroup.group: buttonGroup
        }
    }
}
