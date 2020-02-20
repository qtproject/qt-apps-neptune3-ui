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
import QtQml 2.14
import shared.utils 1.0
import shared.controls 1.0
import shared.animations 1.0
import QtQuick.Controls 2.2

import shared.Sizes 1.0

import "../stores" 1.0
import "../panels" 1.0
import "../controls" 1.0
import "../popups" 1.0

Item {
    id: root

    property string artistsContentState: ""
    property string albumsContentState: ""
    property string headerTextInArtists: ""
    property string headerTextInAlbums: ""
    //if the content type is longer than 6 then it contains a unique id
    readonly property bool contentTypeContainsArtistUniqueID: (artistsContentState.length > 6)
    //if the content type is longer than 5 then it contains a unique id
    readonly property bool contentTypeContainsAlbumUniqueID: (albumsContentState.length > 5)
    property var store
    property Item rootItem

    clip: true

    ToolsColumn {
        id: toolsColumn
        objectName: "musicToolsColumn"
        width: Sizes.dp(264)
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(53)
        translationContext: "MusicToolsColumn"
        model: store.toolsColumnModel

        onCurrentTextChanged: {
            musicLibrary.toolsColumnText = currentText;
            if (currentText === "artists") {
                //store content type in albums view
                root.albumsContentState = root.store.searchAndBrowseModel.contentType;
            } else if (currentText === "albums") {
                //store content type in artists view
                root.artistsContentState = root.store.searchAndBrowseModel.contentType;
            }
        }
        onClicked: {
            if (currentText === "sources") {
                //set model each time to ensure data accuracy
                musicSourcesPopup.model = root.store.musicSourcesModel

                //FIXME in multiprocess store.musicSourcesModel.length returns 1
                //even though is more. When spotify and/or web radio are uninstalled
                //and installed again, then it updates fine.
                let pos = currentItem.mapToItem(root.rootItem,
                                                currentItem.width / 2,
                                                currentItem.height / 2);
                let posX = pos.x / root.Sizes.scale;
                let posY = pos.y / root.Sizes.scale;

                // caclulate popup height based on musicSources list items
                // + 200 for header & margins
                musicSourcesPopup.height = Qt.binding(() => {
                    return musicSourcesPopup.model
                        ? root.Sizes.dp(200 + (musicSourcesPopup.model.count * 96))
                        : root.Sizes.dp(296);
                });
                musicSourcesPopup.width = Qt.binding(() => root.Sizes.dp(910))
                musicSourcesPopup.originItemX = Qt.binding(() => root.Sizes.dp(posX));
                musicSourcesPopup.originItemY = Qt.binding(() => root.Sizes.dp(posY));
                musicSourcesPopup.popupY = Qt.binding(() => {
                    return root.Sizes.dp(Config.centerConsoleHeight / 4);
                });

                musicSourcesPopup.visible = true;
            }
        }
    }

    MusicSourcesPopup {
        id: musicSourcesPopup

        onSwitchSourceClicked: {
            store.switchSource(source)
        }
    }

    Binding {
        restoreMode: Binding.RestoreBinding;
        target: root.store; property: "contentType";
        value: {
            switch (toolsColumn.currentText) {
            case "artists":
                if (root.contentTypeContainsArtistUniqueID) {
                    return root.artistsContentState;
                } else {
                    return "artist";
                }
            case "albums":
                if (root.contentTypeContainsAlbumUniqueID) {
                    return root.albumsContentState;
                } else {
                    return "album";
                }
            case "folders":
                return "album";
            case "favorites":
                // TODO: check if IVI already support favorites list.
            default:
                // TODO: specify all possible content type. currently use "track" as default
                return "track";
            }
        }
    }

    MusicBrowseListPanel {
        id: musicLibrary
        anchors.left: toolsColumn.right
        anchors.right: parent.right
        anchors.top: parent.top
        height: parent.height
        listView.model: root.store.searchAndBrowseModel
        contentType: root.store.contentType
        headerText: root.store.headerText
        onPlayAllClicked: {
            //instert all tracks of current album or artist into play queue
            for (var i = (store.searchAndBrowseModel.count-1); i >= 0; i--) {
                root.store.musicPlaylist.insert(root.store.musicCount, store.searchAndBrowseModel.get(i));
                root.store.player.play();
            }
        }

        onBackClicked: { root.store.searchAndBrowseModel.goBack(); }

        onItemClicked: {
            if (root.store.searchAndBrowseModel.canGoForward(index) && musicLibrary.contentType.slice(-6) === "artist") {
                root.store.searchAndBrowseModel.goForward(index, root.store.searchAndBrowseModel.InModelNavigation);
            } else if (root.store.searchAndBrowseModel.canGoForward(index) && musicLibrary.contentType.slice(-5) === "album") {
                root.store.searchAndBrowseModel.goForward(index, root.store.searchAndBrowseModel.InModelNavigation);
            } else {
                root.store.musicPlaylist.insert(root.store.musicCount, root.store.searchAndBrowseModel.get(index));
                root.store.musicPlaylist.currentIndex = index;
                root.store.player.play();
            }
        }
    }
}
