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

import shared.utils 1.0
import shared.Style 1.0
import shared.Sizes 1.0

/*!
    \qmltype ListItem
    \inqmlmodule controls
    \inherits ListItemBasic
    \since 5.11
    \brief The list item component in Neptune 3 UI.

    The \c ListItem provides a type of list item with one button or text on the right side.

    The code snippet below shows how to use \c ListItem:

    \qml
    import QtQuick 2.10
    import shared.controls 1.0

    Item {
        id: root
        ListView {
            model: 3
            delegate:  ListItem {
                icon.name: "ic-update"
                rightToolSymbol: "ic-close"
                text: "Title ListItem"
                secondaryText: "Secondary Text List Item"
            }
        }
    }
    \endqml

    For a list of components available in Neptune 3 UI, see
    \l{Neptune 3 UI Components and Interfaces}.

*/

ListItemBasic {
    id: root

    /*!
        \qmlproperty string ListItem::secondaryText

        This property holds a textual component that is aligned to the right of ListItem.
    */
    property string secondaryText: ""

    /*!
        \qmlproperty string ListItem::rightToolSymbol

        This property holds the tool icon source that is aligned to the right of ListItem.
    */
    property string rightToolSymbol: ""

    /*!
        \qmlsignal ListItem::rightToolClicked()

        This signal is emitted when right tool symbol is clicked.
    */
    signal rightToolClicked()

    Cursor {
        acceptsCursor: (root.rightToolSymbol === "")
        onActivated: {
            root.clicked();
        }
    }

    accessoryDelegateComponent1: Label {
        font.pixelSize: Sizes.fontSizeS
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        visible: root.secondaryText
        color: Style.contrastColor
        text: root.secondaryText
    }

    rightSpacerUsed: (root.secondaryText !== "")&&(root.rightToolSymbol === "")
    middleSpacerUsed: root.secondaryText !== ""
    dividerVisible: true

    accessoryDelegateComponent2: ToolButton {
        implicitWidth: Sizes.dp(40)
        implicitHeight: Sizes.dp(40)
        baselineOffset: 0
        icon.name: root.rightToolSymbol
        visible: root.rightToolSymbol !== ""
        onClicked: { root.rightToolClicked(); }
    }
}
