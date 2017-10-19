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

pragma Singleton
import QtQuick 2.6
import QtApplicationManager 1.0
import QtIvi 1.0
import QtIvi.Media 1.0
import utils 1.0

QtObject {
    id: root

    property alias nowPlaying: player.playQueue

    property MediaPlayer player: MediaPlayer {
        id: player
    }

    property int currentIndex: player.playQueue.currentIndex
    onCurrentIndexChanged: {
        player.playQueue.currentIndex = currentIndex
    }

    property Connections con: Connections {
        target: player.playQueue
        onCurrentIndexChanged: {
            root.currentIndex = currentIndex
        }

        onRowsInserted: {
            console.log(Logging.apps, "ROW INSERTED: NEW INDEX: ", first)
            player.playQueue.currentIndex = first;
        }
    }

    property int count: player.playQueue.count
    property var currentEntry: player.currentTrack;
    property alias position: player.position
    property alias duration: player.duration
    property string currentTime: Qt.formatTime(new Date(player.position), 'mm:ss')
    property string durationTime: Qt.formatTime(new Date(player.duration), 'mm:ss')

    property bool shuffleOn: player.playMode === MediaPlayer.Shuffle
    property bool repeatOn: player.playMode === MediaPlayer.RepeatTrack

    function next() {
        console.log(Logging.apps, 'MusicModel.nextTrack()')
        player.next()
    }

    function previous() {
        console.log(Logging.apps, 'MusicModel.previousTrack()')
        player.previous()
    }

    property bool playing: player.playState === MediaPlayer.Playing

    function togglePlay() {
        if (root.playing)
            player.pause()
        else
            player.play();
    }

    function toggleShuffle() {
        if (shuffleOn)
            player.playMode = MediaPlayer.Normal
        else
            player.playMode = MediaPlayer.Shuffle
    }

    function toggleRepeat() {
        if (repeatOn)
            player.playMode = MediaPlayer.Normal
        else
            player.playMode = MediaPlayer.RepeatTrack
    }

    property Item ipc: Item {
        ApplicationInterfaceExtension {
            id: musicRemoteControl

            name: "com.pelagicore.music.control"
        }

        Binding { target: musicRemoteControl.object; property: "currentTrack"; value: player.currentTrack }
        Binding { target: musicRemoteControl.object; property: "currentTime"; value: root.currentTime }
        Binding { target: musicRemoteControl.object; property: "durationTime"; value: root.durationTime }
        Binding { target: musicRemoteControl.object; property: "playing"; value: root.playing }

        Connections {
            target: musicRemoteControl.object

            onPlay: {
                player.play()
            }

            onPause: {
                player.pause()
            }

            onPrevious: {
                root.previous()
            }

            onNext: {
                root.next()
            }
        }
    }
}
