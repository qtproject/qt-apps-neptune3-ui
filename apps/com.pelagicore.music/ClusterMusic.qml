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
import utils 1.0
import controls 1.0
import "stores"
import com.pelagicore.styles.triton 1.0

Item {
    id: root

    property MusicStore store

    Image {
        anchors.fill: parent
        source: Style.gfx2("instrument-cluster-bg", TritonStyle.theme)
        fillMode: Image.Stretch
    }

    AlbumArtRow {
        id: albumArt
        width: Style.hspan(14)
        height: Style.vspan(5.8)

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Style.vspan(0.7)

        showInCluster: true
        showPrevNextAlbum: true
        musicPlaying: root.store.playing
        musicPosition: root.store.currentTrackPosition
        mediaReady: root.store.searchAndBrowseModel.count > 0
        songModel: root.store.musicPlaylist
        currentIndex: root.store.musicPlaylist.currentIndex
        currentSongTitle: root.store.currentEntry ? root.store.currentEntry.title : qsTr("Track unavailable")
        currentArtisName: root.store.currentEntry ? root.store.currentEntry.artist : ""
        currentProgressLabel: root.store.elapsedTime + " / " + root.store.totalTime

        onPlayClicked: root.store.playSong()
        onPreviousClicked: root.store.previousSong()
        onNextClicked: root.store.nextSong()
        onShuffleClicked: root.store.shuffleSong()
        onRepeatClicked: root.store.repeatSong()
        onUpdatePosition: root.store.updatePosition(value)

        Connections {
            target: root.store
            onSongModelPopulated: albumArt.populateModel()
        }
    }
}


