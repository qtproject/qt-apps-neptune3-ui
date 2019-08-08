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

import QtQuick 2.8
import shared.utils 1.0
import shared.controls 1.0
import QtQuick.Controls 2.2
import "../helpers" 1.0

import shared.Style 1.0
import shared.Sizes 1.0

Control {
    id: root
    property string contentType: "track"
    property alias listView: listView
    property alias headerText: headerLabel.text
    // Since contentType might have some unique id's when we browse a music by going
    // from one level to another level, a content type slicing is needed to get the
    // intended content type. This property helper will return the actual content type.
    readonly property string actualContentType: root.contentType.slice(-5)
    property string toolsColumnText: ""

    clip: true

    signal itemClicked(var index)
    signal libraryGoBack(var goToArtist)
    signal nextClicked()
    signal backClicked()
    signal playAllClicked()

    contentItem: Item {

        Component {
            id: delegatedItem
            ListItem {
                id: delegatedSong
                objectName: "browseList_clickableItem_" + index
                width: listView.width
                height: Sizes.dp(104)
                text: MetaData.getTitleName(model.item.title, model.name, root.actualContentType)
                subText: MetaData.getArtistName(model.item.artist, root.actualContentType)
                onClicked: { root.itemClicked(model.index); }
            }
        }

        Item {
            id: listHeader
            anchors.top:parent.top
            anchors.topMargin:Sizes.dp(53)
            anchors.left: parent.left
            opacity: visible ? 1.0 : 0.0
            width: visible ? Sizes.dp(720) : 0
            height: visible ? Sizes.dp(94) : 0
            //no header when one of below views is selected
            property var labels: ["favorites", "sources"]
            visible: ((toolsColumnText.indexOf(actualContentType) === -1) && (labels.indexOf(toolsColumnText) === -1))

            ToolButton {
                id: backButton
                objectName: "musicListBackButton"
                anchors.left: parent.left
                anchors.leftMargin: Sizes.dp(13.5)
                anchors.verticalCenter: parent.verticalCenter
                icon.name: LayoutMirroring.enabled ? "ic_forward" : "ic_back"
                onClicked: root.backClicked()
            }
            Label {
                id: headerLabel
                font.pixelSize: Sizes.fontSizeS
                anchors.left: backButton.right
                anchors.leftMargin: Sizes.dp(13)
                anchors.right: buttonPlayAll.left
                anchors.rightMargin: Sizes.dp(13)
                anchors.verticalCenter: parent.verticalCenter
                elide: Text.ElideRight
            }
            ToolButton {
                id: buttonPlayAll
                objectName: "musicListPlayAllButton"
                width: Sizes.dp(121.5)
                height: Sizes.dp(48)
                anchors.right: parent.right
                anchors.rightMargin: Sizes.dp(13.5)
                anchors.verticalCenter: parent.verticalCenter
                // Check if contentType has unique id (so is > 5) when in albums view.
                // This means that the albums of a specific artist are displayed
                // and the play all button should be visible as per specification
                visible: (actualContentType === "track" ||
                         (contentType.length > 5 && actualContentType === "album"))
                background: Rectangle {
                    radius: height/2
                    color: Style.contrastColor
                    opacity: 0.06
                }
                text: qsTr("Play All")
                font.pixelSize: Sizes.fontSizeS
                onClicked: { root.playAllClicked(); }
            }

            Rectangle {
                width: parent.width
                height: Sizes.dp(1)
                anchors.bottom: parent.bottom
                color: "grey"   //todo: change to #contrast 60%
            }
        }

        ListView {
            id: listView
            objectName: "musicPlayListList"
            anchors.top:parent.top
            anchors.topMargin: Sizes.dp(53) + listHeader.height
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            width: Sizes.dp(720)
            interactive: contentHeight > height
            delegate: delegatedItem
            clip: true
            ScrollIndicator.vertical: ScrollIndicator {
                parent: listView.parent
                anchors.top: listView.top
                anchors.left: listView.right
                anchors.leftMargin: Sizes.dp(45)
                anchors.bottom: listView.bottom
            }
        }
    }
}
