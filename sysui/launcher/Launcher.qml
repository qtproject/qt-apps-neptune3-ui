/****************************************************************************
**
** Copyright (C) 2017-2018 Pelagicore AG
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

import QtQuick 2.6
import QtQuick.Controls 2.2
import QtQml.Models 2.1
import QtQuick.Layouts 1.0
import animations 1.0
import controls 1.0
import utils 1.0

import com.pelagicore.styles.neptune 3.0

Item {
    id: root

    readonly property real expandedHeight: Style.vspan(10)
    readonly property bool open: gridButton.checked
    property bool showDevApps: false
    property var applicationModel

    readonly property bool _isThereActiveApp: applicationModel && applicationModel.activeAppInfo

    ButtonGroup {
        id: buttonGroup
    }

    Tool {
        id: homeButton

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: Style.hspan(134/45) - width/2
        width: NeptuneStyle.dp(29)
        height: NeptuneStyle.dp(32)

        symbol: Style.symbol("ic-menu-home")
        ButtonGroup.group: buttonGroup
        checkable: true
        checked: !_isThereActiveApp
        visible: opacity > 0

        background: Image {
            anchors.centerIn: parent
            width: NeptuneStyle.dp(sourceSize.width)
            height: NeptuneStyle.dp(sourceSize.height)
            fillMode: Image.PreserveAspectFit
            visible: homeButton.checked
            source: Style.symbol("ic-app-active-bg")
        }
        onClicked: root.applicationModel.goHome()
    }

    Tool {
        id: gridButton
        width: NeptuneStyle.dp(23)
        height: NeptuneStyle.dp(23)

        readonly property bool useCloseIcon: editableLauncher.gridEditMode || root.open

        anchors.top: parent.top
        anchors.right: parent.right
        anchors.rightMargin: Style.hspan(134/45) - width/2

        opacity: useCloseIcon ? 0.2 : 1
        symbol: useCloseIcon ? Style.symbol("ic-close") : Style.symbol("ic-menu-allapps")
        checkable: true
    }

    EditableGridView {
        id: editableLauncher

        anchors.top: parent.top
        anchors.right: parent.right

        gridOpen: root.open
        model: root.applicationModel
        showDevApps: root.showDevApps
        exclusiveButtonGroup: buttonGroup

        onAppButtonClicked: {
            gridButton.checked = false;
        }
    }
    state: _isThereActiveApp ? (root.open ? "open_active_app" : "closed_active_app") : (root.open ? "open_no_app" : "closed_no_app")
    states: [
        State {
            name: "open"
            PropertyChanges {
                target: editableLauncher
                anchors.rightMargin: Style.hspan(168/45)
                width: Style.hspan(744/45)
            }
            PropertyChanges {
                target: homeButton
                opacity: 0
            }
            PropertyChanges {
                target: root
                height: expandedHeight
            }
        },

        State {
            name: "open_no_app"
            extend: "open"
            PropertyChanges {
                target: editableLauncher
                anchors.topMargin: Style.vspan(150/80) - root.NeptuneStyle.dp(Style.statusBarHeight)
            }
            PropertyChanges {
                target: homeButton
                anchors.topMargin: Style.vspan(152/80) - root.NeptuneStyle.dp(Style.statusBarHeight) - homeButton.height/2
            }
            PropertyChanges {
                target: gridButton
                anchors.topMargin: Style.vspan(152/80) - root.NeptuneStyle.dp(Style.statusBarHeight) - gridButton.width/2
            }
        },

        State {
            name: "open_active_app"
            extend: "open"
            PropertyChanges {
                target: editableLauncher
                anchors.topMargin: Style.vspan(134/80) - root.NeptuneStyle.dp(Style.statusBarHeight)
            }
            PropertyChanges {
                target: homeButton
                anchors.topMargin: Style.vspan(120/80) - root.NeptuneStyle.dp(Style.statusBarHeight) - homeButton.height/2
            }
            PropertyChanges {
                target: gridButton
                anchors.topMargin: Style.vspan(120/80) - root.NeptuneStyle.dp(Style.statusBarHeight) - gridButton.width/2
            }
        },

        State {
            name: "closed"
            PropertyChanges {
                target: editableLauncher
                anchors.rightMargin: Style.hspan(134/45) + cellWidth/2
                width: Style.hspan(480/45)
            }
            PropertyChanges {
                target: homeButton
                opacity: 1
            }
            PropertyChanges {
                target: root
                height: Style.launcherHeight
            }
        },

        State {
            name: "closed_no_app"
            extend: "closed"
            PropertyChanges {
                target: editableLauncher
                anchors.topMargin: Style.vspan(32/80)
            }
            PropertyChanges {
                target: homeButton
                anchors.topMargin: Style.vspan(152/80) - root.NeptuneStyle.dp(Style.statusBarHeight) - homeButton.height/2
            }
            PropertyChanges {
                target: gridButton
                anchors.topMargin: Style.vspan(152/80) - root.NeptuneStyle.dp(Style.statusBarHeight) - gridButton.width/2
            }
        },

        State {
            name: "closed_active_app"
            extend: "closed"
            PropertyChanges {
                target: editableLauncher
                anchors.topMargin: 0
            }
            PropertyChanges {
                target: homeButton
                anchors.topMargin: Style.vspan(120/80) - root.NeptuneStyle.dp(Style.statusBarHeight) - homeButton.height/2
            }
            PropertyChanges {
                target: gridButton
                anchors.topMargin: Style.vspan(120/80) - root.NeptuneStyle.dp(Style.statusBarHeight) - gridButton.width/2
            }
        }
    ]

    transitions: Transition {
        DefaultNumberAnimation { properties: "anchors.topMargin, anchors.rightMargin, width, opacity, height" }
    }

}
