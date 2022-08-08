/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
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

import QtQuick
import QtQuick.Controls
import Qt.labs.folderlistmodel

import shared.Sizes

import "../sysui/launcher"

Item {
    id: root

    signal appClicked(var appUrl)

    ButtonGroup {
        id: buttonGroup
    }

    readonly property int buttonWidth: Sizes.dp(100)

    ListView {
        id: appsLauncher
        interactive: false
        LayoutMirroring.enabled: false
        orientation: Qt.Horizontal
        height: buttonWidth
        width: (buttonWidth + spacing) * flModel.count - spacing
        spacing: buttonWidth / 4
        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(30)
        anchors.horizontalCenter: parent.horizontalCenter

        model: FolderListModel {
            id: flModel
            showDirs: true
            showDotAndDotDot: false
            folder: "apps"
            nameFilters: [ "*-ic" ]
        }

        delegate:
            Item {
            id: delegateRoot
            width: buttonWidth
            height: width

            AppButton {
                id: appButton
                z: 40
                ButtonGroup.group: buttonGroup
                anchors.fill: parent
                editModeBgOpacity: 0.0

                icon.name: Qt.resolvedUrl("apps/" + fileName + '/' + 'icon.png')
                gridOpen: false

                onClicked: {
                    root.appClicked(Qt.resolvedUrl("apps/" + fileName + '/' + 'Main.qml'));
                }
            }
        }
    }
}
