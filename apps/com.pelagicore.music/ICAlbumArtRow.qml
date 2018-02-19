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
import QtGraphicalEffects 1.0
import utils 1.0
import animations 1.0

Item {
    id: root

    property bool musicPlaying: false
    property real musicPosition: 0.0
    property bool mediaReady: false
    property alias coverSlide: coverslide
    property string currentAlbumArt
    property var songModel
    property alias currentIndex: coverslide.currentIndex
    property alias currentSongTitle: titleColumn.currentSongTitle
    property alias currentArtisName: titleColumn.currentArtisName
    property alias currentProgressLabel: musicProgress.progressText

    signal previousClicked()
    signal nextClicked()
    signal playClicked()

    signal favoriteClicked()
    signal shuffleClicked()
    signal repeatClicked()

    function populateModel() {
        coverSlide.model = root.songModel;
    }

    Component {
        id: albumArtDelegate

        Item {
            id: itemDelegated
            height: 180
            width: height
            opacity: PathView.iconOpacity !== undefined ? PathView.iconOpacity : 0.0

            property alias albumArtSource: albumArt.source

            Image {
                id: albumArtUndefined
                anchors.fill: parent
                visible: opacity > 0
                opacity: !(mediaReady && model.item.coverArtUrl) ? 1.0 : 0.0
                Behavior on opacity {DefaultNumberAnimation {}}
                source: Style.gfx2("album-art-placeholder")
                fillMode: Image.PreserveAspectFit
            }
            Image {
                id: albumArt
                anchors.fill: parent
                visible: opacity > 0
                opacity: (mediaReady && model.item.coverArtUrl) ? 1.0 : 0.0
                Behavior on opacity {DefaultNumberAnimation {}}
                source: model.item.coverArtUrl
                fillMode: Image.PreserveAspectFit
            }
        }
    }

    Item {
        id: pathView

        width: root.width
        height: 180
        anchors.top: parent.top

        PathView {
            id: coverslide

            anchors.fill: parent
            anchors.centerIn: parent
            preferredHighlightBegin: 0.5
            preferredHighlightEnd: 0.5
            snapMode: PathView.SnapOneItem
            highlightRangeMode: PathView.StrictlyEnforceRange
            highlightMoveDuration: 400
            clip: true
            model: 3
            delegate: albumArtDelegate
            pathItemCount: 3
            interactive: false

            onCurrentIndexChanged: {
                if (currentItem) {
                    root.currentAlbumArt = currentItem.albumArtSource
                } else {
                    root.currentAlbumArt = ""
                }
            }

            path: Path {
                startX: 0; startY: coverslide.height/2

                PathAttribute { name: "iconOpacity"; value: 0.02 }

                PathLine { x: coverslide.width/2; y: coverslide.height/2 }
                PathAttribute { name: "iconOpacity"; value: 1 }

                PathLine { x: coverslide.width; y: coverslide.height/2 }
                PathAttribute { name: "iconOpacity"; value: 0.02 }

            }
        }
    }

    MusicProgress {
        id: musicProgress
        width: root.width
        height: Style.vspan(3)
        anchors.top: pathView.bottom
        value: root.musicPosition
        onUpdatePosition: root.updatePosition(value)
    }

    TitleColumn {
        id: titleColumn
        anchors.left: parent.left
        anchors.leftMargin: Style.hspan(0.6)
        anchors.top: musicProgress.bottom
        anchors.topMargin: -Style.vspan(0.5)
        preferredWidth: Style.vspan(6)
    }
}
