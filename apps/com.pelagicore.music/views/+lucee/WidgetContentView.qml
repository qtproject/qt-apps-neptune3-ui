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
import QtGraphicalEffects 1.12
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

import shared.utils 1.0
import shared.animations 1.0

import "../panels" 1.0
import "../controls" 1.0

import shared.Style 1.0
import shared.Sizes 1.0

Item {
    id: root

    property var store

    AlbumArtPanel {
        id: artAndTitlesBlock
        height: Sizes.dp(180)
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 0
        songModel: store.musicPlaylist
        elapsedTime: store.elapsedTime
        currentIndex: store.musicPlaylist.currentIndex
        currentSongTitle: store.currentEntry ? root.store.currentEntry.title : ""
        currentArtisName: store.currentEntry ? root.store.currentEntry.artist : ""
        currentAlbumName: store.currentEntry ? root.store.currentEntry.album : ""
        visible: root.state !== "Maximized"
        mediaReady: store.searchAndBrowseModel.count > 0
        musicPlaying: store.playing
        musicPosition: store.currentTrackPosition
        state: root.state
        onPlayClicked: store.playSong()
        onPreviousClicked: store.previousSong()
        onNextClicked: store.nextSong()
        Connections {
            target: store
            function onSongModelPopulated() { artAndTitlesBlock.populateModel(); }
        }
    }

    Rectangle {
        anchors.bottom: otherTracksLabel.top
        width: Sizes.dp(887)
        height: Sizes.dp(1)
        anchors.horizontalCenter: parent.horizontalCenter
        color: "black"
        visible: root.state === "Widget3Rows"
        opacity: visible ? 0.3 : 0.0
        Behavior on opacity { DefaultNumberAnimation {} }
    }


    Label {
        id: otherTracksLabel
        anchors.bottom: otherTracks.top
        anchors.bottomMargin: Sizes.dp(15)
        anchors.left: otherTracks.left
        text: qsTr("Discover similar music")
        font.pixelSize: Sizes.dp(26)
        font.weight: Font.Normal
        visible: root.state === "Widget3Rows"
        opacity: visible ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation {} }
    }

    Row {
        id: otherTracks
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Sizes.dp(45)
        anchors.left: parent.left
        anchors.leftMargin: Sizes.dp(95)
        spacing: Sizes.dp(52)
        visible: root.state === "Widget3Rows"
        opacity: visible ? 1.0 : 0.0

        Behavior on opacity { DefaultNumberAnimation {} }
        Repeater {
            model: 5
            Item {
                id: delegatedAlbumArt
                width: Sizes.dp(135)
                height: Sizes.dp(180)
                property int randomIndex: Math.floor((Math.random() * (root.store.searchAndBrowseModel.count)) + 0)

                Image {
                    id: albumArt
                    width: parent.width
                    height: width
                    visible: false
                    anchors.top: parent.top
                    source: root.store && root.store.searchAndBrowseModel.get(delegatedAlbumArt.randomIndex) ?
                                root.store.searchAndBrowseModel.get(delegatedAlbumArt.randomIndex).coverArtUrl : ""
                    fillMode: Image.PreserveAspectCrop
                }

                Image {
                    id: mask
                    width: parent.width
                    height: width
                    source: Style.image("album-art-mask")
                    smooth: true
                    visible: false
                    fillMode: Image.PreserveAspectCrop
                }

                OpacityMask {
                    id: opacityMask
                    anchors.fill: albumArt
                    source: albumArt
                    maskSource: mask
                }

                Label {
                    id: title
                    width: Sizes.dp(135)
                    text: root.store && root.store.searchAndBrowseModel.get(delegatedAlbumArt.randomIndex) ?
                              root.store.searchAndBrowseModel.get(delegatedAlbumArt.randomIndex).title : ""
                    anchors.top: opacityMask.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: Sizes.dp(20)
                    font.weight: Font.Normal
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.store.musicPlaylist.insert(root.store.musicCount,
                                                        root.store.searchAndBrowseModel.get(delegatedAlbumArt.randomIndex));
                        root.store.musicPlaylist.currentIndex = delegatedAlbumArt.randomIndex;
                        root.store.player.play();
                    }
                }
            }
        }
    }

    states: [
        State {
            name: "Widget1Row"
            PropertyChanges { target: artAndTitlesBlock; height: Sizes.dp(180) }
        },
        State {
            name: "Widget2Rows"
            PropertyChanges { target: root; height: Sizes.dp(550) }
            PropertyChanges { target: artAndTitlesBlock; height: Sizes.dp(500) }
        },
        State {
            name: "Widget3Rows"
            PropertyChanges { target: root; height: Sizes.dp(840) }
            PropertyChanges { target: artAndTitlesBlock; height: Sizes.dp(750) }
        },
        State {
            name: "Maximized"
            PropertyChanges { target: root; height: Sizes.dp(660) }
            PropertyChanges { target: artAndTitlesBlock; anchors.verticalCenterOffset: Sizes.dp(-110); height: Sizes.dp(580) }
        }
    ]

    transitions: [
        Transition {
            from: "Maximized"
            DefaultNumberAnimation { targets: [artAndTitlesBlock, root]; properties: "width, height, opacity, anchors.verticalCenterOffset" }
        },
        Transition {
            DefaultNumberAnimation { targets: [artAndTitlesBlock, root]; properties: "width, height, opacity, anchors.verticalCenterOffset" }
        }
    ]
}
