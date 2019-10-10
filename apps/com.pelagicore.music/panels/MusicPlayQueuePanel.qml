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
import QtGraphicalEffects 1.13
import shared.utils 1.0
import shared.controls 1.0
import shared.Sizes 1.0
import shared.Style 1.0
import QtQuick.Controls 2.2
import "../helpers" 1.0

Control {
    id: root

    property string contentType: "track"
    property string albumName: ""
    property string artistName: ""
    property alias listView: listView
    property bool musicPlaying: false

    // Since contentType might have some unique id's when we browse a music by going
    // from one level to another level, a content type slicing is needed to get the
    // intended content type. This property helper will return the actual content type.
    readonly property string actualContentType: root.contentType.slice(-5)

    clip: true

    signal itemClicked(var index, var item, var title)
    signal libraryGoBack(var goToArtist)
    signal nextClicked()
    signal backClicked()

    contentItem: Item {

        Component {
            id: delegatedItem
            ListItem {
                id: delegatedSong
                objectName: "playList_clickableItem_" + index
                icon.name: model.index === listView.model.currentIndex ? "ic-play_ON" : "ic-play_OFF"
                width: listView.width
                height: Sizes.dp(104)
                highlighted: false
                text: MetaData.getTitleName(model.item.title, model.name, root.actualContentType)
                subText: MetaData.getArtistName(model.item.artist, root.actualContentType)
                onClicked: root.itemClicked(model.index, model.item, delegatedSong.text)
                dividerVisible: (index < (listView.count - 1))
                //TODO use a Lottie object instead
                accessoryDelegateComponent2: AnimatedImage {
                    width: Sizes.dp(sourceSize.width)
                    height: Sizes.dp(sourceSize.height)
                    //FIXME it doesn't pause even though set to true
                    //paused: !root.musicPlaying
                    source: {
                        var path = Style.image("playing");
                        path = path.substring(0, path.length - 4);
                        path = path + ((Style.theme === Style.Dark) ? "-dark.gif" : ".gif");
                        return (model.index === listView.model.currentIndex) ? path : "";
                    }
                }
            }
        }

        ListView {
            id: listView
            implicitWidth: Sizes.dp(880)
            implicitHeight: root.height
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: Sizes.dp(40)
            anchors.rightMargin: Sizes.dp(40)
            boundsBehavior: listView.interactive ? Flickable.DragAndOvershootBounds : Flickable.StopAtBounds
            delegate: delegatedItem
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
