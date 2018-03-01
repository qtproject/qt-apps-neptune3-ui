/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
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
import QtApplicationManager 1.0
import QtIvi 1.0
import QtIvi.Media 1.0
import utils 1.0

Store {
    id: root

    property alias musicPlaylist: player.playQueue
    property int musicCount: player.playQueue.count
    property alias contentType: searchBrowseModel.contentType
    property real indexerProgress: 0.0

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
                    player.playQueue.insert(0, searchAndBrowseModel.get(0));
                }
                root.songModelPopulated();
                modelPopulated = true;
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

    property Connections con: Connections {
        target: player.playQueue

        onRowsInserted: {
            console.log(Logging.apps, "Music Queue / Playlist Row Inserted: ", first);
            player.playQueue.currentIndex = first;
        }
    }

    property Item ipc: Item {
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
        console.log(Logging.apps, 'TritonUI::Music - previous track');
        if (player.playQueue.currentIndex === 0) {
            player.playQueue.currentIndex = root.musicCount - 1;
        } else {
            player.previous();
        }
    }

    function nextSong() {
        console.log(Logging.apps, 'TritonUI::Music - next track');
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
