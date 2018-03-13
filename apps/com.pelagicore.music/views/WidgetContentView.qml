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
import QtQuick.Controls 1.4

import "../panels"
import "../controls"

import com.pelagicore.styles.neptune 3.0

Item {
    id: root
    property var store

    signal flickableAreaClicked()

    onStateChanged: {
        //reset scroll view
        nextListFlickable.flickableItem.contentY = 0;
    }

    ScrollView {
        id: nextListFlickable
        anchors.fill: parent
        opacity: 0
        visible: opacity > 0
        clip: true
        property real contentY: 0.0

        flickableItem.onContentYChanged: {
            contentY = flickableItem.contentY;
        }

        Column {
            id: nextListContent

            Item { //spacer
                width: nextListFlickable.width
                height: 430
            }

            MusicPlayQueuePanel { //playing queue
                id: nextList
                width: nextListFlickable.width
                height: (listView.count * Style.vspan(1.3))
                listView.model: store.musicPlaylist
                listView.interactive: false
                onItemClicked: {
                    store.musicPlaylist.currentIndex = index;
                    store.player.play();
                }
            }

            Item { //spacer
                width: nextListFlickable.width
                height: 20
            }
        }
    }

    Rectangle {
        id: artAndTitleBackground
        height: 260
        width: parent.width
        color: NeptuneStyle.offMainColor
        MouseArea {
            //prevent clicking on list items when the list
            //is scrolled under the header component
            //should go to maximized state instead
            anchors.fill: parent
            enabled: (nextListFlickable.contentY > 0)
            onClicked: {
                root.flickableAreaClicked();
            }
        }
    }

    Image {
        id: nextListShadow
        opacity: 0
        width: parent.width
        height: sourceSize.height
        anchors.top: artAndTitleBackground.bottom
        source: Style.gfx2("panel-inner-shadow", NeptuneStyle.theme)
    }

    AlbumArtPanel {
        id: artAndTitlesBlock
        height: 180
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 0
        songModel: store.musicPlaylist
        currentIndex: store.musicPlaylist.currentIndex
        currentSongTitle: store.currentEntry ? root.store.currentEntry.title : ""
        currentArtisName: store.currentEntry ? root.store.currentEntry.artist : ""
        parentStateMaximized: state === "Maximized"
        mediaReady: store.searchAndBrowseModel.count > 0
        musicPlaying: store.playing
        onPlayClicked: store.playSong()
        onPreviousClicked: store.previousSong()
        onNextClicked: store.nextSong()
        Connections {
            target: store
            onSongModelPopulated: { artAndTitlesBlock.populateModel(); }
        }
    }

    MusicProgress {
        id: progressBarBlock
        //TODO use Style.hspan and Style.vspan instead
        width: 880
        height: 220

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 200

        opacity: 0
        visible: opacity > 0
        value: store.currentTrackPosition
        progressText: store.elapsedTime + " / " + store.totalTime
        onUpdatePosition: store.updatePosition(value)
    }

    MusicTools {
        id: musicTools
        anchors.top: progressBarBlock.bottom
        anchors.topMargin: -progressBarBlock.height/2
        anchors.right: progressBarBlock.right
        onShuffleClicked: store.shuffleSong()
        onRepeatClicked: store.repeatSong()
    }

    states: [
        State {
            name: "Widget1Row"
        },
        State {
            name: "Widget2Rows"
            PropertyChanges { target: root; height: 550 }
            PropertyChanges { target: artAndTitlesBlock; anchors.verticalCenterOffset: - 62 }
            PropertyChanges { target: progressBarBlock; anchors.verticalCenterOffset: 138 }
            PropertyChanges { target: progressBarBlock; opacity: 1 }
            PropertyChanges { target: musicTools; opacity: 1 }
        },
        State {
            name: "Widget3Rows"
            PropertyChanges { target: root; height: 840 }
            PropertyChanges { target: nextListFlickable; opacity: 1 }
            PropertyChanges { target: artAndTitlesBlock; anchors.verticalCenterOffset: - 271 - Math.min(20, nextListFlickable.contentY / 6) }
            PropertyChanges { target: progressBarBlock; anchors.verticalCenterOffset: -71 - Math.min(60, nextListFlickable.contentY / 2) }
            PropertyChanges { target: progressBarBlock; opacity: 1 - Math.max(0, Math.min(1, nextListFlickable.contentY / 140)) }
            PropertyChanges { target: musicTools; opacity: 1 - Math.max(0, Math.min(1, nextListFlickable.contentY / 140))}
            PropertyChanges { target: nextListShadow; opacity: 0 + Math.max(0, Math.min(1, nextListFlickable.contentY / 140))}
        },
        State {
            name: "Maximized"
            PropertyChanges { target: root; height: 660 - 224 }
            PropertyChanges { target: artAndTitleBackground; opacity: 0 }   //todo: do something else here because it is blocking the gray background.
            PropertyChanges { target: artAndTitlesBlock; anchors.verticalCenterOffset: -110 }
            PropertyChanges { target: progressBarBlock; anchors.verticalCenterOffset: 90 }
            PropertyChanges { target: progressBarBlock; opacity: 1 }
            PropertyChanges { target: musicTools; opacity: 1 }
        }
    ]

    transitions: [
        Transition {
            from: "Maximized"
            DefaultNumberAnimation { targets: [progressBarBlock, musicTools, nextListFlickable, artAndTitlesBlock, root]; properties: "width, height, opacity, anchors.verticalCenterOffset" }
            SequentialAnimation {
                PauseAnimation { duration: 200 }
                DefaultNumberAnimation { target: artAndTitleBackground ; property: "opacity" }
            }
        },
        Transition {
            DefaultNumberAnimation { targets: [progressBarBlock, musicTools, nextListFlickable, artAndTitlesBlock, root]; properties: "width, height, opacity, anchors.verticalCenterOffset" }
        }
    ]
}
