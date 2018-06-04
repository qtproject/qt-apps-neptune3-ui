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

/*!
    \qmltype ToolsColumn
    \inqmlmodule controls
    \inherits ColumnLayout
    \since 5.11
    \brief The tools column component for Neptune 3 applications

    The ToolsColumn provides a custom column of tool buttons for Neptune 3 Applications
    to follow the specification where only one of them can be selected at any given time.

    See \l{Neptune 3 UI Components and Interfaces} to see more available components in
    Neptune 3 UI.

    \section2 Example Usage

    The following example uses \l{ToolsColumn}:

    \qml
    import QtQuick 2.10
    import controls 1.0

    Item {
        id: root

        ToolsColumn {
            translationContext: "MyToolsColumn"
            model: ListModel {
                ListElement { icon: "ic-foo"; text: QT_TRANSLATE_NOOP("MyToolsColumn", "foo") }
                ListElement { icon: "ic-bar"; text: QT_TRANSLATE_NOOP("MyToolsColumn", "bar") }
            }
        }
    }
    \endqml
*/

ColumnLayout {
    id: root

    width: NeptuneStyle.dp(135)
    spacing: NeptuneStyle.dp(24)

    /*!
        \qmlproperty int ToolsColumn::currentIndex

        This property holds the current selected index of the tools column.

        This property's default is 0.
    */
    property int currentIndex: 0

    /*!
        \qmlproperty string ToolsColumn::currentText
        \readonly

        This property holds the current selected text of the tools column.
    */
    readonly property string currentText: model ? model.get(currentIndex).text : ""

    /*!
        \qmlproperty string ToolsColumn::currentItem

        This property holds the current selected item of the tools column.
    */
    property Item currentItem: repeater.itemAt(currentIndex)

    /*!
        \qmlproperty var ToolsColumn::model

        This property holds the model to be delegated in the tools column.
    */
    property alias model: repeater.model

    /*!
        \qmlproperty string ToolsColumn::translationContext
        \readonly

        This property holds the translation context of the tools column.

        This property's default is 0.
    */
    property string translationContext

    /*!
        \qmlsignal ToolsColumn::clicked

        This signal is emitted when one of the tool is clicked by the user.
    */
    signal clicked()

    ButtonGroup { id: buttonGroup }

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
