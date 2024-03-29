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

import QtQuick
import QtQuick.Controls
import shared.utils
import shared.animations
import shared.Style
import shared.Sizes

import "../controls"
import "../panels"

Item {
    id: root

    property bool musicPlaying: false
    property real musicPosition: 0.0
    property bool mediaReady: false
    property string elapsedTime
    property alias coverSlide: detailAlbumArtRow.coverSlide
    property string currentAlbumArt
    property var songModel
    property alias currentIndex: detailAlbumArtRow.currentIndex
    property string currentSongTitle
    property string currentArtisName
    property string currentAlbumName
    property bool parentStateMaximized: false
    property alias detailAlbumArtRow: detailAlbumArtRow

    signal previousClicked()
    signal nextClicked()
    signal playClicked()

    signal favoriteClicked()
    signal shuffleClicked()
    signal repeatClicked()

    function populateModel() {
        detailAlbumArtRow.coverSlide.model = root.songModel;
    }

    AlbumArtDetailPanel {
        id: detailAlbumArtRow
        anchors.fill: parent

        titleColumn.currentSongTitle: root.currentSongTitle
        titleColumn.currentArtisName: root.currentArtisName
        titleColumn.currentAlbumName: root.currentAlbumName
        musicPosition: root.musicPosition
        musicPlaying: root.musicPlaying
        currentAlbumArt: root.currentAlbumArt
        elapsedTime: root.elapsedTime
        state: root.state
        mediaReady: root.mediaReady

        onPreviousClicked: {
            root.previousClicked()
        }

        onNextClicked: {
            root.nextClicked()
        }

        onPlayClicked: {
            root.playClicked()
        }
    }
}
