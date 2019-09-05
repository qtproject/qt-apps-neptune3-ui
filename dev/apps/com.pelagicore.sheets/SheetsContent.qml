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
import Qt.labs.folderlistmodel 2.2
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import shared.controls 1.0
import shared.utils 1.0

import shared.Style 1.0
import shared.Sizes 1.0

Item {
    id: root

    Row {
        width: parent.width
        height: parent.height * 0.1
        anchors.bottom: stack.top
        anchors.left: parent.left
        anchors.leftMargin: Sizes.dp(36)
        visible: stack.depth >= 2
        spacing: Sizes.dp(9)

        ToolButton {
            id: backButton
            anchors.verticalCenter: parent.verticalCenter
            baselineOffset: 0
            icon.name: LayoutMirroring.enabled ? "ic_forward" : "ic_back"
            text: qsTr("Back")
            font.pixelSize: Sizes.fontSizeS
            onClicked: stack.pop()
        }
    }

    Component {
        id: componentInitialItem
        ListView {
            id: componentListView

            model: FolderListModel{
                showDirs: false
                showDotAndDotDot: false
                folder: "./components"
                nameFilters: [ "*Panel.qml" ]
            }

            delegate: ItemDelegate {
                width: componentListView.width
                height: Sizes.dp(120)
                contentItem: Item {
                    anchors.fill: parent
                    Label {
                        anchors.left: parent.left
                        anchors.leftMargin: Sizes.dp(90)
                        anchors.verticalCenter: parent.verticalCenter
                        text: fileName.substring(0, fileName.length - 9);
                    }

                    Image {
                        width: parent.width
                        height: 5
                        anchors.bottom: parent.bottom
                        source: Style.image("divider")
                    }
                }
                onClicked: { stack.push(Qt.resolvedUrl("./components/" + fileName), StackView.PushTransition); }
            }
        }
    }

    StackView {
        id: stack
        width: parent.width
        height: parent.height * 0.9
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        initialItem: componentInitialItem
        onCurrentItemChanged: {
            backButton.forceActiveFocus();
        }
    }
}

