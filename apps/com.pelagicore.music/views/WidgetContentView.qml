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
import QtQuick.Controls 2.3

import shared.utils 1.0
import shared.animations 1.0

import "../panels" 1.0
import "../controls" 1.0

import shared.Style 1.0
import shared.Sizes 1.0

Item {
    id: root
    property var store

    signal flickableAreaClicked()

    onStateChanged: {
        //reset flickable
        nextListFlickable.contentY = 0;
    }
    Item {
        id: nextListFlickableItem
        width: parent.width
        height: (parent.height - Sizes.dp(260) - progressBarBlock.height)
        anchors.bottom: parent.bottom
        opacity: 0
        visible: opacity > 0
        clip: true

        Flickable {
            id: nextListFlickable
            anchors.fill: parent

            contentWidth: parent.width
            contentHeight: (nextList.height + musicTools.height + Sizes.dp(20))

            ScrollIndicator.vertical: ScrollIndicator { }
            Column {
                id: nextListContent

                Item { //spacer
                    width: nextListFlickable.width
                    height: musicTools.height
                }

                MusicPlayQueuePanel { //playing queue
                    id: nextList
                    objectName: "musicPlaySong"
                    width: nextListFlickable.width
                    height: (listView.count * Sizes.dp(104))
                    listView.model: store.musicPlaylist
                    listView.interactive: false
                    musicPlaying: root.store.playing
                    onItemClicked: {
                        store.musicPlaylist.currentIndex = index;
                        store.player.play();
                    }
                }

                Item { //spacer
                    width: nextListFlickable.width
                    height: Sizes.dp(20)
                }
            }
        }
    }

    AlbumArtPanel {
        id: artAndTitlesBlock
        objectName: "musicPlayer"
        height: Sizes.dp(180)
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 0
        songModel: root.store.musicPlaylist
        currentIndex: root.store.musicPlaylist.currentIndex
        currentSongTitle: root.store.currentEntry ? root.store.currentEntry.title : ""
        currentArtisName: root.store.currentEntry ? root.store.currentEntry.artist : ""
        parentStateMaximized: root.state === "Maximized"
        mediaReady: root.store.searchAndBrowseModel.count > 0
        musicPlaying: root.store.playing
        musicPosition: root.store.currentTrackPosition
        onPlayClicked: root.store.playSong()
        onPreviousClicked: root.store.previousSong()
        onNextClicked: root.store.nextSong()
        Connections {
            target: root.store
            function onSongModelPopulated() { artAndTitlesBlock.populateModel(); }
        }
    }

    Image {
        id: nextListShadow
        width: parent.width
        height: sourceSize.height
        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(260)
        opacity: 0
        source: Style.image("panel-inner-shadow")
    }

    MusicProgress {
        id: progressBarBlock
        objectName: "musicProgressBar"
        width: Sizes.dp(880)
        height: Sizes.dp(50)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: artAndTitlesBlock.bottom
        anchors.topMargin: Sizes.dp(50)
        opacity: 0
        visible: opacity > 0
        value: store.currentTrackPosition
        progressText: store.elapsedTime + " / " + store.totalTime
        onUpdatePosition: store.updatePosition(value)
    }

    MusicTools {
        id: musicTools
        anchors.top: progressBarBlock.bottom
        anchors.right: progressBarBlock.right
        onShuffleClicked: store.shuffleSong()
        onRepeatClicked: store.repeatSong()

        shuffleOn: store.shuffleOn
        repeatOn: store.repeatOn
    }

    states: [
        State {
            name: "Widget1Row"
        },
        State {
            name: "Widget2Rows"
            PropertyChanges { target: root; height: Sizes.dp(550) }
            PropertyChanges { target: artAndTitlesBlock; anchors.verticalCenterOffset: Sizes.dp(-62) }
            PropertyChanges { target: progressBarBlock; anchors.verticalCenterOffset: Sizes.dp(138) }
            PropertyChanges { target: progressBarBlock; opacity: 1 }
            PropertyChanges { target: musicTools; opacity: 1 }
        },
        State {
            name: "Widget3Rows"
            PropertyChanges { target: root; height: Sizes.dp(840) }
            PropertyChanges { target: nextListFlickableItem; opacity: 1 }
            PropertyChanges { target: artAndTitlesBlock; anchors.verticalCenterOffset: Sizes.dp(-271) - Math.min(Sizes.dp(20), nextListFlickable.contentY / 6) }
            PropertyChanges { target: progressBarBlock; anchors.verticalCenterOffset: Sizes.dp(-71) - Math.min(Sizes.dp(60), nextListFlickable.contentY / 2) }
            PropertyChanges { target: progressBarBlock; opacity: 1 - Math.max(0, Math.min(1, nextListFlickable.contentY / 140)) }
            PropertyChanges { target: musicTools; opacity: 1 - Math.max(0, Math.min(1, nextListFlickable.contentY / 140))}
            PropertyChanges { target: nextListShadow; opacity: 0 + Math.max(0, Math.min(1, nextListFlickable.contentY / 140))}
        },
        State {
            name: "Maximized"
            PropertyChanges { target: root; height: Sizes.dp(660) - Sizes.dp(224) }
            PropertyChanges { target: artAndTitlesBlock; anchors.verticalCenterOffset: Sizes.dp(-110) }
            PropertyChanges { target: progressBarBlock; anchors.verticalCenterOffset: Sizes.dp(90) }
            PropertyChanges { target: progressBarBlock; opacity: 1 }
            PropertyChanges { target: musicTools; opacity: 1 }
        }
    ]

    transitions: [
        Transition {
            from: "Maximized"
            DefaultNumberAnimation { targets: [progressBarBlock, musicTools, nextListFlickable, nextListFlickableItem, artAndTitlesBlock, root]; properties: "width, height, opacity, anchors.verticalCenterOffset" }
            PauseAnimation { duration: 200 }
        },
        Transition {
            DefaultNumberAnimation { targets: [progressBarBlock, musicTools, nextListFlickable, nextListFlickableItem, artAndTitlesBlock, root]; properties: "width, height, opacity, anchors.verticalCenterOffset" }
        }
    ]
}
