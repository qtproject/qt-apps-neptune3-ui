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

import QtQuick 2.6
import QtQuick.Controls 2.2
import QtQml.Models 2.1
import QtQuick.Layouts 1.0

import shared.animations 1.0
import shared.controls 1.0
import shared.utils 1.0

import shared.Style 1.0
import shared.Sizes 1.0

Item {
    id: root

    readonly property real expandedHeight: Sizes.dp(800)
    readonly property bool open: gridButton.gridOpen
    property bool showDevApps: false
    property bool showSystemApps: false
    property var applicationModel
    property alias backgroundWidth: backgroundArea.width
    property alias backgroundHeight: backgroundArea.height

    readonly property bool _isThereActiveApp: applicationModel && applicationModel.activeAppInfo

    MouseArea {
        id: backgroundArea
        width: root.parentWidth
        height: root.parentHeight
        onClicked: gridButton.gridOpen = false;
        enabled: root.open
    }

    ButtonGroup {
        id: buttonGroup
    }

    ToolButton {
        id: homeButton

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: Sizes.dp(134) - width/2
        width: Sizes.dp(90)
        height: Sizes.dp(90)
        icon.color: Style.contrastColor
        icon.name: "ic-menu-home"
        display: NeptuneIconLabel.IconOnly
        ButtonGroup.group: buttonGroup
        checkable: true
        checked: !_isThereActiveApp
        visible: opacity > 0

        background: Image {
            anchors.centerIn: parent
            width: Sizes.dp(sourceSize.width)
            height: Sizes.dp(sourceSize.height)
            fillMode: Image.PreserveAspectFit
            visible: homeButton.checked
            source: Style.image("ic-app-active-bg")
        }
        onClicked: root.applicationModel.goHome()
        Component.onCompleted: { forceActiveFocus(); }
    }

    ToolButton {
        id: gridButton
        objectName: "gridButton"
        width: Sizes.dp(90)
        height: Sizes.dp(90)
        //holds the state of apps grid (opened/closed)
        property bool gridOpen: false
        readonly property bool useCloseIcon: editableLauncher.editMode || root.open

        anchors.top: parent.top
        anchors.right: parent.right
        anchors.rightMargin: Sizes.dp(134) - width/2

        opacity: useCloseIcon ? Style.opacityMedium : Style.opacityHigh
        icon.name: useCloseIcon ? "ic-close" : "ic-menu-allapps"
        icon.color: "white"
        checkable: true
        onClicked: gridButton.gridOpen = !gridButton.gridOpen
    }

    EditableGridView {
        id: editableLauncher
        objectName: "editableLauncher"
        anchors.top: parent.top
        anchors.right: parent.right

        gridOpen: root.open
        model: root.applicationModel
        showDevApps: root.showDevApps
        showSystemApps: root.showSystemApps
        exclusiveButtonGroup: buttonGroup
        onAppButtonClicked: {
            gridButton.gridOpen = false;
        }
    }
    state: _isThereActiveApp ? (root.open ? "open_active_app" : "closed_active_app") : (root.open ? "open_no_app" : "closed_no_app")
    states: [
        State {
            name: "open"
            PropertyChanges {
                target: editableLauncher
                anchors.rightMargin: Sizes.dp(168)
                width: Sizes.dp(744)
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
                anchors.topMargin: Sizes.dp(150) - root.Sizes.dp(Config.statusBarHeight)
            }
            PropertyChanges {
                target: homeButton
                anchors.topMargin: Sizes.dp(152) - root.Sizes.dp(Config.statusBarHeight) - homeButton.height/2
            }
            PropertyChanges {
                target: gridButton
                anchors.topMargin: Sizes.dp(152) - root.Sizes.dp(Config.statusBarHeight) - gridButton.width/2
            }
        },

        State {
            name: "open_active_app"
            extend: "open"
            PropertyChanges {
                target: editableLauncher
                anchors.topMargin: Sizes.dp(134) - root.Sizes.dp(Config.statusBarHeight)
            }
            PropertyChanges {
                target: homeButton
                anchors.topMargin: Sizes.dp(120) - root.Sizes.dp(Config.statusBarHeight) - homeButton.height/2
            }
            PropertyChanges {
                target: gridButton
                anchors.topMargin: Sizes.dp(120) - root.Sizes.dp(Config.statusBarHeight) - gridButton.width/2
            }
        },

        State {
            name: "closed"
            PropertyChanges {
                target: editableLauncher
                anchors.rightMargin: Sizes.dp(134) + cellWidth/2
                width: Sizes.dp(480)
            }
            PropertyChanges {
                target: homeButton
                opacity: 1
            }
            PropertyChanges {
                target: root
                height: Sizes.dp(Config.launcherHeight)
            }
        },

        State {
            name: "closed_no_app"
            extend: "closed"
            PropertyChanges {
                target: editableLauncher
                anchors.topMargin: Sizes.dp(32)
            }
            PropertyChanges {
                target: homeButton
                anchors.topMargin: Sizes.dp(152) - root.Sizes.dp(Config.statusBarHeight) - homeButton.height/2
            }
            PropertyChanges {
                target: gridButton
                anchors.topMargin: Sizes.dp(152) - root.Sizes.dp(Config.statusBarHeight) - gridButton.width/2
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
                anchors.topMargin: Sizes.dp(120) - root.Sizes.dp(Config.statusBarHeight) - homeButton.height/2
            }
            PropertyChanges {
                target: gridButton
                anchors.topMargin: Sizes.dp(120) - root.Sizes.dp(Config.statusBarHeight) - gridButton.width/2
            }
        }
    ]

    transitions: Transition {
        DefaultNumberAnimation { properties: "anchors.topMargin, anchors.rightMargin, width, opacity, height" }
    }
}
