/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AG
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

import QtQuick 2.8
import Qt.labs.folderlistmodel 2.2
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import controls 1.0
import utils 1.0

import com.pelagicore.styles.triton 1.0

Item {
    id: root

    Row {
        width: parent.width
        height: parent.height * 0.1
        anchors.bottom: stack.top
        anchors.left: parent.left
        anchors.leftMargin: Style.hspan(0.8)
        visible: stack.depth >= 2
        spacing: Style.hspan(0.2)

        Image {
            id: icon
            source: Style.symbol("ic-update")
            anchors.verticalCenter: parent.verticalCenter
        }

        Tool {
            anchors.verticalCenter: parent.verticalCenter
            baselineOffset: 0
            text: qsTr("Back")
            font.pixelSize: Style.fontSizeS
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

            delegate: Item {
                width: componentListView.width
                height: Style.vspan(0.8)

                Label {
                    anchors.fill: parent
                    anchors.margins: Style.hspan(1)
                    text: fileName.substring(0, fileName.length - 9);
                }

                Image {
                    width: parent.width
                    height: 5
                    anchors.bottom: parent.bottom
                    source: Style.gfx2("divider", TritonStyle.theme)
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: stack.push(Qt.resolvedUrl("./components/" + fileName), StackView.PushTransition)
                }
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
    }
}

