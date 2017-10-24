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
import QtApplicationManager 1.0
import controls 1.0
import utils 1.0

import models.application 1.0

RowLayout {
    id: root

    width: Style.launcherWidth
    height: gridButton.checked ? expandedHeight : Style.launcherHeight

    readonly property real expandedHeight: Style.vspan(10)
    readonly property bool open: gridButton.checked

    function goHome() {
        homeButton.checked = true;
        homeButton.clicked();
    }

    Behavior on height {
        SmoothedAnimation {
            easing.type: Easing.InOutQuad
            duration: 270
        }
    }

    ButtonGroup {
        id: buttonGroup
        buttons: [homeButton]
    }

    ToolButton {
        id: homeButton

        implicitWidth: Style.hspan(2.3)
        implicitHeight: Style.vspan(1.6)
        Layout.alignment: Qt.AlignTop

        // TODO: replace this with the correct asset when available
        //icon.source: ""

        contentItem: Label {
            text: "Home"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        checked: true
        onClicked: {
            gridButton.checked = false;
            ApplicationManagerModel.goHome()
        }

        // TODO: Replace this with the correct visualization
        Rectangle {
            id: homeDummyChecked

            width: Style.hspan(2.3)
            height: Style.vspan(1.6)
            color: "transparent"
            border.color: homeButton.checked ? "red" : "transparent"
            border.width: 2
        }
    }

    EditableGridView {
        id: editableLauncher

        anchors.top: parent.top
        gridOpen: root.open
        model: ApplicationManager

        onButtonCreated: buttonGroup.addButton(button)
        onButtonRemoved: buttonGroup.removeButton(button)
        onAppButtonClicked: {
            homeButton.checked = false;
            gridButton.checked = false;
            ApplicationManager.startApplication(applicationId);
        }
    }

    Tool {
        id: gridButton

        implicitWidth: Style.hspan(2.3)
        implicitHeight: Style.vspan(1.6)
        Layout.alignment: Qt.AlignTop

        // TODO: replace this with the correct asset when available
        //icon.source: ""

        contentItem: Label {
            text: editableLauncher.gridEditMode ? "" : "Apps"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        symbol: editableLauncher.gridEditMode ? Style.symbol("close", 0, false) : ""

        checkable: true

        onCheckedChanged: {
            if (checked) {
                homeButton.checked = false
            }
        }

        // TODO: Replace this with the correct visualization
        Rectangle {
            id: gridDummyChecked

            width: Style.hspan(2.3)
            height: Style.vspan(1.6)
            color: "transparent"
            border.color: gridButton.checked ? "red" : "transparent"
            border.width: 2
        }
    }
}
