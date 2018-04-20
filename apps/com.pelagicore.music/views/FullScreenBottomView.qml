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
import controls 1.0
import animations 1.0
import QtQuick.Controls 2.2

import com.pelagicore.styles.neptune 3.0

import "../stores"
import "../panels"
import "../controls"

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


    clip: true

    ToolsColumn {
        id: toolsColumn
        width: NeptuneStyle.dp(264)
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: NeptuneStyle.dp(53)
        translationContext: "MusicToolsColumn"
        model: store.toolsColumnModel
        onClicked: {
            if (currentText === "radio") {
                Qt.openUrlExternally("x-radio://");
                currentIndex = 0;
            } else if (currentText === "web radio") {
                Qt.openUrlExternally("x-webradio://");
                currentIndex = 0;
            } else if (currentText === "spotify") {
                Qt.openUrlExternally("x-spotify://");
                currentIndex = 0;
            }
        }

        onCurrentTextChanged: {
            musicLibrary.toolsColumnText = currentText;
            if (currentText === "artists") {
                fullscreenBottom.headerTextInAlbums = musicLibrary.headerText;
                //store text in albums view
                musicLibrary.headerText = fullscreenBottom.headerTextInArtists;
                //store content type in albums view
                fullscreenBottom.albumsContentState = root.store.searchAndBrowseModel.contentType;
            } else if (currentText === "albums") {
                //TODO sort albums list alphabetically
                //store text in artists view
                fullscreenBottom.headerTextInArtists = musicLibrary.headerText;
                musicLibrary.headerText = fullscreenBottom.headerTextInAlbums;
                //store content type in artists view
                fullscreenBottom.artistsContentState = root.store.searchAndBrowseModel.contentType;
            }
        }
    }

    Binding {
        target: root.store; property: "contentType";
        value: {
            switch (toolsColumn.currentText) {
            case "artists":
                if (fullscreenBottom.contentTypeContainsArtistUniqueID) {
                    return fullscreenBottom.artistsContentState;
                } else {
                    return "artist";
                }
            case "albums":
                if (fullscreenBottom.contentTypeContainsAlbumUniqueID) {
                    return fullscreenBottom.albumsContentState;
                } else {
                    return "album";
                }
            case "folders":
                return "album";
            case "radio":
            case "spotify":
            case "web radio":
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
        //helper property for the header text
        property string artistName: ""
        onPlayAllClicked: {
            //instert all tracks of current album or artist into play queue
            for (var i = (store.searchAndBrowseModel.count-1); i >= 0; i--) {
                root.store.musicPlaylist.insert(root.store.musicCount, store.searchAndBrowseModel.get(i));
                root.store.player.play();
            }
        }

        onBackClicked: {
            root.store.searchAndBrowseModel.goBack();
            if ((toolsColumn.currentText === "artists") && (actualContentType === "album")) {
                headerText = artistName;
            } else if (toolsColumn.currentText.indexOf(contentType) !== -1) {
                headerText = "";
                artistName = "";
            }
        }

        onItemClicked: {
            if (root.store.searchAndBrowseModel.canGoForward(index) && musicLibrary.contentType.slice(-6) === "artist") {
                //set header text props
                artistName = title;
                headerText = title;
                root.store.searchAndBrowseModel.goForward(index, root.store.searchAndBrowseModel.InModelNavigation);
            } else if (root.store.searchAndBrowseModel.canGoForward(index) && musicLibrary.contentType.slice(-5) === "album") {
                var albumArtist = artist !== "" ? artist : qsTr("Unknown Artist");
                headerText = qsTr("%1 (%2)").arg(title).arg(albumArtist);
                root.store.searchAndBrowseModel.goForward(index, root.store.searchAndBrowseModel.InModelNavigation);
            } else {
                root.store.musicPlaylist.insert(root.store.musicCount, root.store.searchAndBrowseModel.get(index));
                root.store.musicPlaylist.currentIndex = index;
                root.store.player.play();
            }
        }
    }
}
