/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AG
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

import utils 1.0
import com.pelagicore.styles.neptune 3.0

/*
 * ListItem provides a type of a list item with one button or text at the right side
 *
 * Properties:
 *  - secondaryText - This property holds a textual component that is aligned to the right side of ListItem.
 *  - rightToolSymbol - This property holds the tool icon source that is aligned to the right side of ListItem.
 *
 *  Usage example:
 *
 *   ListItem {
 *       Layout.fillWidth: true
 *       icon.name: "ic-update"
 *       rightToolSymbol: "ic-close"
 *       text: "ListItem with Secondary Text"
 *       secondaryText: "68% of 14 MB"
 *   }
 */

ListItemBasic {
    id: root

    property string secondaryText: ""
    property string rightToolSymbol: ""
    property string rightToolButtonText: ""

    signal rightToolClicked()

    accessoryDelegateComponent1: Label {
        font.pixelSize: NeptuneStyle.fontSizeS
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        visible: root.secondaryText
        color: NeptuneStyle.contrastColor
        text: root.secondaryText
    }

    rightSpacerUsed: (root.secondaryText !== "")&&(root.rightToolSymbol === "")
    middleSpacerUsed: root.secondaryText !== ""
    dividerVisible: true

    accessoryDelegateComponent2: ToolButton {
        implicitWidth: rightToolSymbol ? NeptuneStyle.dp(100) : 0
        implicitHeight: rightToolSymbol ? root.height : 0
        baselineOffset: 0
        icon.name: root.rightToolSymbol
        visible: root.rightToolSymbol !== ""
        onClicked: root.rightToolClicked()
    }

    accessoryButton: Button {
        text: root.rightToolButtonText
        font.pixelSize: NeptuneStyle.fontSizeS
        implicitHeight: root.rightToolButtonText ? contentItem.implicitHeight + topPadding + bottomPadding : 0
        implicitWidth: root.rightToolButtonText ? contentItem.implicitWidth + leftPadding + rightPadding : 0
        leftPadding: NeptuneStyle.dp(30)
        rightPadding: NeptuneStyle.dp(30)
        topPadding: NeptuneStyle.dp(8)
        bottomPadding: NeptuneStyle.dp(8)
        visible: root.rightToolButtonText !== ""
    }
}
