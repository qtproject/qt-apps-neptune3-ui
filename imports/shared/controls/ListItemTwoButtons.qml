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

import controls 1.0
import utils 1.0
import com.pelagicore.styles.neptune 3.0

/*
 * ListItemTwoButtons provides a type of a list item with two tool buttons at the right side.
 *
 * Properties:
 *  - symbolAccessoryButton1 - This property holds an icon name to be displayed on the first accessory button.
 *  - accessoryButton1Checkable - This property holds whether the first accessory button is checkable.
 *  - accessoryButton1Checked - This property holds whether the first accessory button is checked.
 *  - symbolAccessoryButton2 - This property an icon name to be displayed on the second accessory button.
 *  - accessoryButton2Checkable - This property holds whether the second accessory button is checkable.
 *  - accessoryButton2Checked - This property holds whether the second accessory button is checked.
 *
 * Signals:
 *  - accessoryButton1Clicked() - This signal is emitted when the first accessory button is clicked by the user.
 *  - accessoryButton2Clicked() - This signal is emitted when the second accessory button is clicked by the user.
 *
 *  Usage example:
 *
 *   ListItemTwoButtons {
 *       Layout.fillWidth: true
 *       symbol: Style.symbol("ic-update")
 *       symbolAccessoryButton1: "ic-call-contrast"
 *       symbolAccessoryButton2: "ic-message-contrast"
 *       text: "..."
 *       onClicked: { ... }
 *       onAccessoryButton1Clicked: { ... }
 *       onAccessoryButton2Clicked: { ... }
 *   }
 */

ListItemBasic {
    id: root

    property string symbolAccessoryButton1: ""
    property bool accessoryButton1Checkable: false
    property bool accessoryButton1Checked: false

    property string symbolAccessoryButton2: ""
    property bool accessoryButton2Checkable: false
    property bool accessoryButton2Checked: false

    signal accessoryButton1Clicked()
    signal accessoryButton2Clicked()

    accessoryDelegateComponent1: ToolButton {
        implicitWidth: NeptuneStyle.dp(100)
        implicitHeight: root.height
        checkable: root.accessoryButton1Checkable
        checked: root.accessoryButton1Checked
        icon.name: root.symbolAccessoryButton1
        onClicked: root.accessoryButton1Clicked()
        onCheckedChanged: root.accessoryButton1Checked = checked
    }
    accessoryDelegateComponent2: ToolButton {
        implicitWidth: NeptuneStyle.dp(100)
        implicitHeight: root.height
        checkable: root.accessoryButton2Checkable
        checked: root.accessoryButton2Checked
        icon.name: root.symbolAccessoryButton2
        onClicked: root.accessoryButton2Clicked()
        onCheckedChanged: root.accessoryButton2Checked = checked
    }
}
