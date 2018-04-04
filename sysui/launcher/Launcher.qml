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

    readonly property real expandedHeight: NeptuneStyle.dp(800)
    readonly property bool open: gridButton.checked
    property bool showDevApps: false
    property var applicationModel

    readonly property bool _isThereActiveApp: applicationModel && applicationModel.activeAppInfo

    ButtonGroup {
        id: buttonGroup
    }

    ToolButton {
        id: homeButton

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: NeptuneStyle.dp(134) - width/2
        width: NeptuneStyle.dp(90)
        height: NeptuneStyle.dp(90)

        icon.name: "ic-menu-home"
        icon.color: "white"
        icon.width: NeptuneStyle.dp(35)
        icon.height: NeptuneStyle.dp(35)
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

    ToolButton {
        id: gridButton
        width: NeptuneStyle.dp(90)
        height: NeptuneStyle.dp(90)

        readonly property bool useCloseIcon: editableLauncher.gridEditMode || root.open

        anchors.top: parent.top
        anchors.right: parent.right
        anchors.rightMargin: NeptuneStyle.dp(134) - width/2

        opacity: useCloseIcon ? NeptuneStyle.fontOpacityMedium : NeptuneStyle.fontOpacityHigh
        icon.name: useCloseIcon ? "ic-close" : "ic-menu-allapps"
        icon.color: "white"
        icon.width: NeptuneStyle.dp(35)
        icon.height: NeptuneStyle.dp(35)
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
                anchors.rightMargin: NeptuneStyle.dp(168)
                width: NeptuneStyle.dp(744)
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
                anchors.topMargin: NeptuneStyle.dp(150) - root.NeptuneStyle.dp(Style.statusBarHeight)
            }
            PropertyChanges {
                target: homeButton
                anchors.topMargin: NeptuneStyle.dp(152) - root.NeptuneStyle.dp(Style.statusBarHeight) - homeButton.height/2
            }
            PropertyChanges {
                target: gridButton
                anchors.topMargin: NeptuneStyle.dp(152) - root.NeptuneStyle.dp(Style.statusBarHeight) - gridButton.width/2
            }
        },

        State {
            name: "open_active_app"
            extend: "open"
            PropertyChanges {
                target: editableLauncher
                anchors.topMargin: NeptuneStyle.dp(134) - root.NeptuneStyle.dp(Style.statusBarHeight)
            }
            PropertyChanges {
                target: homeButton
                anchors.topMargin: NeptuneStyle.dp(120) - root.NeptuneStyle.dp(Style.statusBarHeight) - homeButton.height/2
            }
            PropertyChanges {
                target: gridButton
                anchors.topMargin: NeptuneStyle.dp(120) - root.NeptuneStyle.dp(Style.statusBarHeight) - gridButton.width/2
            }
        },

        State {
            name: "closed"
            PropertyChanges {
                target: editableLauncher
                anchors.rightMargin: NeptuneStyle.dp(134) + cellWidth/2
                width: NeptuneStyle.dp(480)
            }
            PropertyChanges {
                target: homeButton
                opacity: 1
            }
            PropertyChanges {
                target: root
                height: NeptuneStyle.dp(Style.launcherHeight)
            }
        },

        State {
            name: "closed_no_app"
            extend: "closed"
            PropertyChanges {
                target: editableLauncher
                anchors.topMargin: NeptuneStyle.dp(32)
            }
            PropertyChanges {
                target: homeButton
                anchors.topMargin: NeptuneStyle.dp(152) - root.NeptuneStyle.dp(Style.statusBarHeight) - homeButton.height/2
            }
            PropertyChanges {
                target: gridButton
                anchors.topMargin: NeptuneStyle.dp(152) - root.NeptuneStyle.dp(Style.statusBarHeight) - gridButton.width/2
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
                anchors.topMargin: NeptuneStyle.dp(120) - root.NeptuneStyle.dp(Style.statusBarHeight) - homeButton.height/2
            }
            PropertyChanges {
                target: gridButton
                anchors.topMargin: NeptuneStyle.dp(120) - root.NeptuneStyle.dp(Style.statusBarHeight) - gridButton.width/2
            }
        }
    ]

    transitions: Transition {
        DefaultNumberAnimation { properties: "anchors.topMargin, anchors.rightMargin, width, opacity, height" }
    }

}
