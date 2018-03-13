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

import QtQuick 2.8
import utils 1.0
import animations 1.0
import QtQuick.Controls 2.2

import "../panels"

import com.pelagicore.styles.neptune 3.0

Item {
    id: root

    property var store
    property bool topExpanded: false //expanded => playing queue visible

    ToolButton {
        id: showPlayingQueueButton
        width: contentItem.childrenRect.width + Style.hspan(1)
        height: Style.hspan(0.5)
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: Style.vspan(370/80)
        anchors.horizontalCenter: parent.horizontalCenter

        enabled: !root.topExpanded
        onClicked: { root.topExpanded = true; }

        contentItem: Row {
            spacing: Style.hspan(10/45)
            Label {
                font.pixelSize: Style.fontSizeS
                font.capitalization: Font.AllUppercase
                text: qsTr("Next")
                anchors.verticalCenter: parent.verticalCenter
            }
            Image {
                opacity: root.topExpanded ? 0.0 : 1.0
                Behavior on opacity { DefaultNumberAnimation {} }
                source: root.topExpanded ? "" : Style.symbol("ic-expand", NeptuneStyle.theme)
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    MusicPlayQueuePanel {
        id: playingQueueList    //playing queue
        anchors.top: parent.top
        anchors.topMargin: 660 - 224
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 100
        anchors.right: parent.right
        anchors.rightMargin: 100
        listView.model: store.musicPlaylist
        onItemClicked: {
            store.musicPlaylist.currentIndex = index;
            store.player.play();
        }
    }

    ToolButton {
        id: showNormalBrowseViewButton
        width: contentItem.childrenRect.width + Style.hspan(1)
        height: Style.hspan(0.5)
        anchors.verticalCenter: parent.bottom
        anchors.verticalCenterOffset: Style.vspan(44/80)
        anchors.horizontalCenter: parent.horizontalCenter
        opacity: root.topExpanded ? 1.0 : 0.0
        Behavior on opacity {
            SequentialAnimation {
                PauseAnimation { duration: root.topExpanded ? 0 : 100 }
                DefaultNumberAnimation {}
            }
        }
        visible: opacity > 0

        onClicked: { root.topExpanded = false; }

        contentItem: Row {
            spacing: Style.hspan(10/45)
            Label {
                font.pixelSize: 22 //todo: change to Style.fontSizeS when the value is corrected in style plugin
                font.capitalization: Font.AllUppercase
                text: qsTr("Browse")
                anchors.verticalCenter: parent.verticalCenter
            }
            Image {
                source: Style.symbol("ic-expand-up", NeptuneStyle.theme)
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
