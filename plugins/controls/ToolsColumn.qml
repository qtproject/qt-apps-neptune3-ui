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
import QtQuick.Layouts 1.2

import shared.Sizes 1.0
import shared.utils 1.0

/*!
    \qmltype ToolsColumn
    \inqmlmodule controls
    \inherits ListView
    \since 5.11
    \brief The tools column component for Neptune 3 UI applications.

    The ToolsColumn provides a custom column of tool buttons for Neptune 3 UI Applications
    to follow the specification where only one of them can be selected at any given time.

    \image tools-column.png

    See \l{Neptune 3 UI Components and Interfaces} to see more available components in
    Neptune 3 UI.

    The ToolsColumn inherits its API from \l{AbstractButton::icon}{AbstractButton} to display icons
    for the items. To use icons from theme (\c {icon.name} property of a button) add \c icon
    role to the model items. To define icon by source URL (\c {icon.source} property of a
    button) add \c sourceOn and \c sourceOff roles to the model items for the selected and
    deselected states. Please refer to \l{Icons in Qt Quick Controls 2} for how to use icon
    themes and icon URLs.

    \section2 Example Usage

    The following example uses \l{ToolsColumn} with icons defined by theme:

    \qml
    import QtQuick 2.10
    import shared.controls 1.0

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

    The following example uses \l{ToolsColumn} with icons defined by source URL:

    \qml
    import QtQuick 2.10
    import shared.controls 1.0

    Item {
        id: root
        ToolsColumn {
            translationContext: "MyToolsColumn"
            model: ListModel {
                ListElement {
                    sourceOn: "ic-logo_ON.png"; sourceOff: "ic-logo_OFF.png";
                    text: QT_TRANSLATE_NOOP("MyToolsColumn", "foo")
                }
            }
        }
    }
    \endqml
*/

ListView {
    id: root

    implicitWidth: Sizes.dp(135)
    implicitHeight: root.contentHeight
    spacing: Sizes.dp(24)
    interactive: false

    /*!
        \qmlproperty enumeration ToolsColumn::iconFillMode

        Set this property to define what happens when the item's icon image has a different size
        than the item. Please refer to \l{Image::fillMode} for possible values.
        For values other than Image.Pad \l{ToolsColumn::iconRectWidth} and
        \l {ToolsColumn::iconRectHeight} should be defined.
    */
    property int iconFillMode: Image.Pad

    /*!
        \qmlpropery real ToolsColumn::iconRectWidth

        Set this property to define width of rectangle area for icon when
        \l{ToolsColumn::iconfillMode} has other value than Image.Pad.
    */
    property real iconRectWidth: 0

    /*!
        \qmlpropery real ToolsColumn::iconRectHeight

        Set this property to define height of rectangle area for icon when
        \l{ToolsColumn::iconfillMode} has other value than Image.Pad.
    */
    property real iconRectHeight: 0

    /*!
        \qmlproperty string ToolsColumn::currentText
        \readonly

        This property holds the current selected text of the tools column.
    */
    readonly property string currentText: model && currentIndex > -1 && model.count > currentIndex
                                          ?  model.get(currentIndex).text
                                          : ""

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

    delegate: ToolButton {
            height: Sizes.dp(140); width: root.width
            objectName: model.objectName ? model.objectName : ""
            baselineOffset: 0
            iconFillMode: root.iconFillMode
            iconRectWidth: root.iconRectWidth
            iconRectHeight: root.iconRectHeight
            checkable: true
            checked: root.currentIndex === index
            icon.name: model.icon ? (checked ? model.icon + "_ON" : model.icon + "_OFF") : ""
            icon.source: (model.sourceOn && model.sourceOff)
                           ? checked ? model.sourceOn : model.sourceOff
                           : ""
            text: qsTranslate(root.translationContext, model.text)
            font.pixelSize: Sizes.fontSizeS
            enabled: !model.greyedOut
            display: AbstractButton.TextUnderIcon
            onClicked: {
                root.currentIndex = index;
                root.clicked();
            }
            ButtonGroup.group: buttonGroup
        }

    Connections {
        target: root.model
        function onCountChanged() {
            if (currentIndex > 0 && model.count <= currentIndex) {
                currentIndex = 0;
            }
        }
    }
}
