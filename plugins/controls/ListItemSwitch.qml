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

import shared.Style 1.0

/*!
    \qmltype ListItemSwitch
    \inqmlmodule controls
    \inherits ListItemBasic
    \since 5.11
    \brief The list item with progress bar component of Neptune 3.

    The ListItemSwitch provides a type of a list item with a Switch at the right side.

    See \l{Neptune 3 UI Components and Interfaces} to see more available components in
    Neptune 3 UI.

    \section2 Example Usage

    The following example uses \l{ListItemSwitch}:

    \qml
    import QtQuick 2.10
    import shared.controls 1.0

    Item {
        id: root
        ListView {
            model: 3
            delegate: ListItemSwitch {
               Layout.fillWidth: true
               icon.name: "ic-update"
               text: "Downloading the application"
               onSwitchClicked {
                   console.log("switch clicked");
               }
            }
        }
    }
    \endqml
*/

ListItemBasic {
    id: root

    /*!
        \qmlproperty bool ListItemSwitch::switchOn

        This property holds whether the switch is on or off.

        This property's default is false.
    */
    property bool switchOn: false

    /*!
        \qmlproperty real ListItemSwitch::position

        This property holds the logical position of the thumb indicator.

        This property's default is 0.0.
    */
    property real position: 0.0

    /*!
        \qmlsignal ListItemSwitch::switchToggled

        This signal is emitted when the switch is toogled by the user.
    */
    signal switchToggled()

    /*!
        \qmlsignal ListItemSwitch::switchClicked

        This signal is emitted when the switch is clicked by the user.
    */
    signal switchClicked()

    rightSpacerUsed: true

    accessoryDelegateComponent1: Switch {
        id: switchDelegate
        objectName: "listItemSwitch"
        checked: root.switchOn
        onPositionChanged: root.position = position
        onToggled: {
            root.switchToggled()
            root.switchOn = checked
        }
        onClicked: root.switchClicked()

        Connections {
            target: root
            function onClicked() { switchDelegate.toggle() }
        }
    }
}
