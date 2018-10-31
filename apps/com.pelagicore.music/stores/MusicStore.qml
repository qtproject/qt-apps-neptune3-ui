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
import QtApplicationManager.Application 1.0
import QtIvi 1.0
import QtIvi.Media 1.0
import shared.utils 1.0
import shared.com.pelagicore.settings 1.0

Store {
    id: root

    property alias musicPlaylist: player.playQueue
    property int musicCount: player.playQueue.count
    property alias contentType: searchBrowseModel.contentType

    readonly property UISettings uiSettings: UISettings {
        onVolumeChanged: player.volume = volume * 100;
        onMutedChanged: player.muted = muted;
    }

    // N.B. need to use a Timer here to "push" the initial volume to settings server
    // since it uses QMetaObject::invokeMethod(), possibly running in a different thread
    Timer {
        interval: 1
        running: true
        triggeredOnStart: true
        onTriggered: {
            uiSettings.volume = player.volume / 100;
            uiSettings.muted = player.muted;
        }
    }

    property ListModel toolsColumnModel: ListModel {
        id: toolsColumnModel
        ListElement { icon: "ic-favorites"; text: QT_TRANSLATE_NOOP("MusicToolsColumn", "favorites"); greyedOut: false}
        ListElement { icon: "ic-artists"; text: QT_TRANSLATE_NOOP("MusicToolsColumn", "artists"); greyedOut: false }
        ListElement { icon: "ic-albums"; text: QT_TRANSLATE_NOOP("MusicToolsColumn", "albums"); greyedOut: false }
        ListElement { icon: "ic-sources-bt"; text: QT_TRANSLATE_NOOP("MusicToolsColumn", "sources"); greyedOut: false }

        // Neptune 3 doesn't support playlists yet. Temporarily commented until we have the final implementation.
        //ListElement { icon: "ic-playlists"; text: QT_TRANSLATE_NOOP("MusicToolsColumn", "playlists"); greyedOut: true }

        // Neptune 3 doesn't support folder browser yet. Temporarily commented until we have the final implementation.
        //ListElement { icon: "ic-folder-browse"; text: QT_TRANSLATE_NOOP("MusicToolsColumn", "folders"); greyedOut: true }
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

        property bool modelPopulated: false

        onCountChanged: {
            if (count > 0 && !modelPopulated) {
                if (musicCount === 0) {
                    root.searchAndBrowseModel.contentType = "album";
                    if (searchAndBrowseModel.get(0)) {
                        player.playQueue.insert(0, searchAndBrowseModel.get(0));
                    }
                }
                root.songModelPopulated();
                modelPopulated = true;
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
        onProgressChanged: {
            // SearchAndBrowseModel need to be reloaded when indexing process reach 20 %
            // to get the music data and after indexing process is done.
            // Without reloading the model, Neptune 3 won't see any music during the first
            // run.
            if (progress > 0.2 && progress < 0.3 && !databaseReloaded) {
                searchAndBrowseModel.reload();
            } else if (progress === 1.0 && !databaseReloaded) {
                searchAndBrowseModel.reload();
                databaseReloaded = true;
            }
        }
    }

    property MediaPlayer player: MediaPlayer { id: player }
    property var currentEntry: player.currentTrack;
    property bool playing: player.playState === MediaPlayer.Playing
    property bool shuffleOn: player.playMode === MediaPlayer.Shuffle
    property bool repeatOn: player.playMode === MediaPlayer.RepeatTrack
    property string elapsedTime: Qt.formatTime(new Date(player.position), 'mm:ss')
    property string totalTime: Qt.formatTime(new Date(player.duration), 'mm:ss')
    property real currentTrackPosition : player.position / player.duration
    property ListModel musicSourcesModel: ListModel {
        id: musicSourcesModel
        ListElement { text: "AM/FM Radio"}
    }

    property Connections con: Connections {
        target: player.playQueue

        onRowsInserted: {
            console.log(Logging.apps, "Music Queue / Playlist Row Inserted: ", first);
            player.playQueue.currentIndex = first;
        }
    }

    property Item ipc: Item {
        ApplicationInterfaceExtension {
            id: musicApplicationRequestIPC
            name: "neptune.musicapprequests.interface"
            Component.onCompleted: {
                if (object.webradioInstalled) {
                    musicSourcesModel.append({"text" : "Web radio"});
                }
                if (object.spotifyInstalled) {
                    musicSourcesModel.append({"text" : "Spotify"});
                }
            }
        }

        Connections {
            target: musicApplicationRequestIPC.object

            onSpotifyInstalledChanged: {
                if (musicApplicationRequestIPC.object.spotifyInstalled) {
                    musicSourcesModel.append({"text" : "Spotify"});
                } else {
                    for (var i = 0; i < musicSourcesModel.count; i++) {
                        if (musicSourcesModel.get(i).text === "Spotify") {
                            musicSourcesModel.remove(i, 1);
                        }
                    }
                }
            }
            onWebradioInstalledChanged: {
                if (musicApplicationRequestIPC.object.webradioInstalled) {
                    musicSourcesModel.append({"text" : "Web radio"});
                } else {
                    for (var i = 0; i < musicSourcesModel.count; i++) {
                        if (musicSourcesModel.get(i).text === "Web radio") {
                            musicSourcesModel.remove(i, 1);
                        }
                    }
                }
            }
        }

        ApplicationInterfaceExtension {
            id: musicRemoteControl

            name: "com.pelagicore.music.control"
        }

        Binding { target: musicRemoteControl.object; property: "currentTime"; value: root.elapsedTime }
        Binding { target: musicRemoteControl.object; property: "durationTime"; value: root.totalTime }
        Binding { target: musicRemoteControl.object; property: "playing"; value: root.playing }

        Connections {
            target: musicRemoteControl.object

            onPlay: {
                player.play();
            }

            onPause: {
                player.pause();
            }

            onPrevious: {
                if (player.playQueue.currentIndex === 0) {
                    player.playQueue.currentIndex = root.musicCount - 1;
                } else {
                    player.previous();
                }

            }

            onNext: {
                if (player.playQueue.currentIndex === root.musicCount - 1) {
                    player.playQueue.currentIndex = 0;
                } else {
                    player.next();
                }
            }
        }
    }

    signal songModelPopulated()

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
}
