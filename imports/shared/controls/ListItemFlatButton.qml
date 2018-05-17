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

import utils 1.0
import com.pelagicore.styles.neptune 3.0


/*!
    \qmltype
    \inqmlmodule controls
    \inherits ListItemBasic
    \brief Flat button for list items and lists and notifications

    ListItemFlatButton provides a type of a list item with a flat button and close button
    on the right side. The flat button supports text on one line and its width is aligned with
    text width. The visibility of close button can be defined with closeButtonVisible property.

    \section2 Example Usage

    \qml

    ListItemFlatButton {
        implicitWidth: NeptuneStyle.dp(765)
        implicitHeight: NeptuneStyle.dp(104)
        icon.name: "ic-update"
        symbolFlatButton: Style.symbol("ic-favorite")
        subText: "subtitle"
        text: "ListItem with button text"
        textFlatButton: "Text"
        closeButtonVisible: true
    }

    \endqml

 */

ListItemBasic {
    id: root

    /*!
        \qmlproperty string ListItemBasic::textFlatButton

        This property holds a flat button text.
    */
    property string textFlatButton: ""

    /*!
        \qmlproperty string ListItemBasic::symbolFlatButton

        This property holds a flat button icon path.
    */
    property string symbolFlatButton: ""

    /*!
        \qmlproperty string ListItemBasic::closeButtonVisible

        This property holds a visibility of close button. The default value is false.
    */
    property bool closeButtonVisible: false

    /*!
        \fn ListItemBasic::flatButtonClicked()

        The signal is emitted when flat button is clicked
    */
    signal flatButtonClicked()

    /*!
        \fn ListItemBasic::closeButtonClicked()

        The signal is emitted when close button is clicked
    */
    signal closeButtonClicked()


    accessoryDelegateComponent1: Button {
        implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding
        implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
        leftPadding: NeptuneStyle.dp(30)
        rightPadding: NeptuneStyle.dp(30)
        topPadding: NeptuneStyle.dp(8)
        bottomPadding: NeptuneStyle.dp(8)
        text: root.textFlatButton
        font.pixelSize: NeptuneStyle.fontSizeS
        icon.source: root.symbolFlatButton
        onClicked: root.flatButtonClicked()
    }

    accessoryDelegateComponent2: ToolButton {
        implicitWidth: visible ? NeptuneStyle.dp(100) : 0
        implicitHeight: visible ? root.height : 0
        icon.name: "ic-close"
        visible: root.closeButtonVisible
        onClicked: root.closeButtonClicked()
    }
}
