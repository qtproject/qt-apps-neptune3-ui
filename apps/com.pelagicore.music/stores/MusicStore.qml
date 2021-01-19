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
import QtApplicationManager.Application 2.0
import QtApplicationManager 2.0
import QtIvi 1.0
import QtIvi.Media 1.0
import shared.utils 1.0

Store {
    id: root

    property alias musicPlaylist: player.playQueue
    property int musicCount: player.playQueue.count
    property alias contentType: searchBrowseModel.contentType

    property ListModel toolsColumnModel: ListModel {
        id: toolsColumnModel
        ListElement { icon: "ic-favorites"; text: QT_TRANSLATE_NOOP("MusicToolsColumn", "favorites"); objectName: "musicView_favorites"; greyedOut: false}
        ListElement { icon: "ic-artists"; text: QT_TRANSLATE_NOOP("MusicToolsColumn", "artists"); objectName: "musicView_artists"; greyedOut: false }
        ListElement { icon: "ic-albums"; text: QT_TRANSLATE_NOOP("MusicToolsColumn", "albums"); objectName: "musicView_albums"; greyedOut: false }
        ListElement { icon: "ic-sources-bt"; text: QT_TRANSLATE_NOOP("MusicToolsColumn", "sources"); objectName: "musicView_sources"; greyedOut: false }

        // Neptune 3 doesn't support playlists yet. Temporarily commented until we have the final implementation.
        //ListElement { icon: "ic-playlists"; text: QT_TRANSLATE_NOOP("MusicToolsColumn", "playlists"); greyedOut: true }

        // Neptune 3 doesn't support folder browser yet. Temporarily commented until we have the final implementation.
        //ListElement { icon: "ic-folder-browse"; text: QT_TRANSLATE_NOOP("MusicToolsColumn", "folders"); greyedOut: true }
    }

    property ListModel luceeToolsColumnModel: ListModel {
        id: luceeToolsColumnModel
        ListElement { icon: "ic-favorites"; text: "favorites"; greyedOut: false}
        ListElement { icon: "ic-ipod"; text: "ipod"; greyedOut: true }
        ListElement { icon: "ic-usb"; text: "usb"; greyedOut: true }
        ListElement { icon: "ic-spotify"; text: "spotify"; greyedOut: true  }
        ListElement { icon: "ic-radio"; text: "radio"; greyedOut: false }
    }

    property bool isSpotifyInstalled: false
    onIsSpotifyInstalledChanged: {
        luceeToolsColumnModel.setProperty(3, "greyedOut", !isSpotifyInstalled)
    }

    property string headerText: (contentType.indexOf("artist") === -1) ? headerTextInAlbumsView :
                                                                         headerTextInArtistsView
    property string headerTextInArtistsView: ""
    property string headerTextInAlbumsView: ""

    property SearchAndBrowseModel searchAndBrowseModel: SearchAndBrowseModel {
        id: searchBrowseModel
        contentType: ""
        onContentTypeChanged: console.log(Logging.apps, "Music App::Content Type Change: ", contentType)
        serviceObject: root.player.serviceObject

        onCountChanged: {
            if (count > 0) {
                insertInitialTracks()
            }

            var artist = (get(0) && get(0).artist !== "") ? get(0).artist : qsTr("Unknown Artist");
            var album = (get(0) && get(0).album !== "") ? get(0).album : qsTr("Unknown Album");
            if (get(0) && get(0).type === "album") {
                //inside artists menu, having selected one artist
                var artistFromAlbum = get(0).data.artist !== "" ? get(0).data.artist : qsTr("Unknown Artist");
                headerTextInArtistsView = artistFromAlbum;
            } else if (get(0) && get(0).type === "audiotrack" && contentType.indexOf("artist") !== -1) {
                //inside artists menu, having selected one artist and one album
                headerTextInArtistsView = album + " (" + artist +")";
            } else if (get(0) && get(0).type === "audiotrack" && contentType.indexOf("artist") === -1) {
                //inside albums menu, having selected one album
                headerTextInAlbumsView = album + " (" + artist + ")";
            }
        }
    }

    readonly property MediaIndexerControl indexerControl: MediaIndexerControl {
        property bool databaseReloaded: false
        property bool modelPopulated: false
        onProgressChanged: {
            // SearchAndBrowseModel need to be reloaded when indexing process reach 20 %
            // to get the music data and after indexing process is done.
            // Without reloading the model, Neptune 3 won't see any music during the first
            // run.
            if (progress > 0.2 && progress < 0.3 && !databaseReloaded) {
                root.searchAndBrowseModel.reload();
            } else if (progress === 1.0 && !databaseReloaded) {
                root.searchAndBrowseModel.reload();
                databaseReloaded = true;
                root.contentType = "track";
            }
        }
    }

    property MediaPlayer player: MediaPlayer { id: player }
    property var currentEntry: player.currentTrack;
    property bool playing: player.playState === MediaPlayer.Playing
    property bool shuffleOn: player.playMode === MediaPlayer.Shuffle
    property bool repeatOn: player.playMode === MediaPlayer.RepeatTrack
    property string elapsedTime: (player.position > -1) ? Qt.formatTime(new Date(player.position), 'mm:ss') : "00:00"
    property string totalTime: (player.duration > -1) ? Qt.formatTime(new Date(player.duration), 'mm:ss') : "00:00"
    property real currentTrackPosition : player.position / player.duration
    property ListModel musicSourcesModel: ListModel {
        id: musicSourcesModel
        ListElement {
            text: qsTr("Music")
            appId: "com.pelagicore.music"
        }
        ListElement {
            text: qsTr("AM/FM Radio")
            appId: "com.pelagicore.tuner"
        }
    }

    property Connections con: Connections {
        target: player.playQueue

        function onRowsInserted(parentIndex, first, last) {
            console.log(Logging.apps, "Music Queue / Playlist Row Inserted: ", first);
            player.playQueue.currentIndex = first;
        }
    }

    readonly property IntentHandler intentHandler: IntentHandler {
        intentIds: "activate-app"
        onRequestReceived: {
            root.requestToRise()
            request.sendReply({ "done": true })
        }
    }

    property IntentHandler intentHandler2: IntentHandler {
            intentIds: "music-command"
            onRequestReceived: {
                var receivedCommand = request.parameters["musiccommand"];
                request.sendReply({ "done": true })

                if (receivedCommand === "next") {
                    root.nextSong();
                } else if (receivedCommand === "prev") {
                    root.previousSong();
                }
            }
        }

    signal requestToRise()
    signal songModelPopulated()

    function insertInitialTracks() {
        if (root.musicCount === 0) {
            if (root.searchAndBrowseModel.count > 3) {
                for (var x = 0; x < 3; ++x) {
                    if (root.searchAndBrowseModel.get(x)) {
                       root.musicPlaylist.insert(0, searchAndBrowseModel.get(x));
                    }
                }
            } else {
                root.musicPlaylist.insert(0, searchAndBrowseModel.get(0));
            }
            root.songModelPopulated();
            root.indexerControl.modelPopulated = true;
        }
    }


    function playSong() {
        if (root.playing) {
            player.pause();
        } else {
            player.play();
        }
    }

    function previousSong() {
        console.log(Logging.apps, 'NeptuneUI::Music - previous track');
        if (player.playQueue.currentIndex === 0) {
            player.playQueue.currentIndex = root.musicCount - 1;
        } else {
            player.previous();
        }
    }

    function nextSong() {
        console.log(Logging.apps, 'NeptuneUI::Music - next track');
        if (player.playQueue.currentIndex === root.musicCount - 1) {
            player.playQueue.currentIndex = 0;
        } else {
            player.next();
        }
    }

    function updatePosition(value) {
        var newPosition = value * player.duration
        player.setPosition(newPosition)
    }

    function shuffleSong() {
        if (shuffleOn) {
            player.playMode = MediaPlayer.Normal;
        } else {
            player.playMode = MediaPlayer.Shuffle;
        }
    }

    function repeatSong() {
        if (repeatOn) {
            player.playMode = MediaPlayer.Normal;
        } else {
            player.playMode = MediaPlayer.RepeatTrack;
        }
    }

    function switchSource(source) {
        player.pause()
        if (source === "com.pelagicore.tuner") {
            var request = IntentClient.sendIntentRequest("activate-app", source, {})

            request.onReplyReceived.connect(function() {
                if (request.succeeded) {
                    var result = request.result
                    console.log(Logging.apps, "Intent result: " + result.done)
                } else {
                    console.log(Logging.apps, "Intent request failed: " + request.errorMessage)
                }
            })
        }
    }
}
