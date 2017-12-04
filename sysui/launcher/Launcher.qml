/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Triton IVI UI.
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

import QtQuick 2.6
import QtQuick.Controls 2.2
import QtQml.Models 2.1
import QtQuick.Layouts 1.0
import animations 1.0
import controls 1.0
import utils 1.0

Item {
    id: root

    width: Style.launcherWidth
    height: open ? expandedHeight : Style.launcherHeight

    readonly property real expandedHeight: Style.vspan(10)
    readonly property bool open: gridButton.checked

    property var applicationModel

    Behavior on height { DefaultSmoothedAnimation {} }

    ButtonGroup {
        id: buttonGroup
        buttons: [homeButton]
    }

    Tool {
        id: homeButton

        width: Style.hspan(1.5)
        height: Style.vspan(0.9)
        Layout.alignment: Qt.AlignTop
        anchors.left: parent.left

        opacity: root.open ? 0.0 : 1.0
        Behavior on opacity {
            NumberAnimation {
                duration: 200
            }
        }

        symbol: Style.symbol("ic-menu-home", false)

        checked: true
        onClicked: {
            gridButton.checked = false;
            root.applicationModel.goHome();
        }

//        // TODO: Replace this with the correct visualization
        Rectangle {
            id: homeDummyChecked

            anchors.fill: parent
            color: "transparent"
            border.color: homeButton.checked ? "red" : "transparent"
            border.width: 2
        }
    }

    RowLayout {
        id: applicationLauncher

        width: root.open ? Style.launcherWidth : Style.hspan(12)
        Behavior on width {
            NumberAnimation {
                duration: 200
            }
        }

        anchors.right: parent.right

        EditableGridView {
            id: editableLauncher

            Layout.fillWidth: true
            Layout.preferredHeight: implicitHeight

            anchors.top: parent.top
            gridOpen: root.open
            model: root.applicationModel

            onButtonCreated: buttonGroup.addButton(button)
            onButtonRemoved: buttonGroup.removeButton(button)
            onAppButtonClicked: {
                homeButton.checked = false;
                gridButton.checked = false;
            }
        }

        Tool {
            id: gridButton

            implicitWidth: Style.hspan(2.3)
            implicitHeight: Style.vspan(0.9)

            Layout.alignment: Qt.AlignTop
            symbol: editableLauncher.gridEditMode || root.open ? Style.symbol("ic-close", false) : Style.symbol("ic-menu-allapps", false)
            checkable: true

            onCheckedChanged: {
                if (checked) {
                    homeButton.checked = false
                }
            }
        }
    }
}
