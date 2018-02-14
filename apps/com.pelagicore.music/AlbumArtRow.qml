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
    property bool parentStateMaximized: false

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
            height: Style.vspan(2.6)
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

                readonly property double iconx: PathView.iconx !== undefined ? PathView.iconx : 0.0
                readonly property double icony: PathView.icony !== undefined ? PathView.icony : 0.0
            }
            Image {
                id: albumArt
                anchors.fill: parent
                visible: opacity > 0
                opacity: (mediaReady && model.item.coverArtUrl) ? 1.0 : 0.0
                Behavior on opacity {DefaultNumberAnimation {}}
                source: model.item.coverArtUrl
                fillMode: Image.PreserveAspectFit

                readonly property double iconx: PathView.iconx !== undefined ? PathView.iconx : 0.0
                readonly property double icony: PathView.icony !== undefined ? PathView.icony : 0.0
            }
        }
    }

    Item {
        id: coverArtTitleAndControlsWrapperItem
        anchors.fill: parent

        PathView {
            id: coverslide
            width: parent.height
            height: width
            anchors.left: parent.left
            anchors.leftMargin: parentStateMaximized ? 100 : 40
            Behavior on anchors.leftMargin { DefaultNumberAnimation { } }
            preferredHighlightBegin: 0.5
            preferredHighlightEnd: 0.5
            snapMode: PathView.SnapOneItem
            highlightRangeMode: PathView.StrictlyEnforceRange
            highlightMoveDuration: 400
            clip: true
            model: 0
            delegate: albumArtDelegate
            pathItemCount: 1
            interactive: false

            onCurrentIndexChanged: {
                if (currentItem) {
                    root.currentAlbumArt = currentItem.albumArtSource;
                } else {
                    root.currentAlbumArt = "";
                }
            }

            path: Path {
                startX: 0; startY: coverslide.height/2

                PathAttribute { name: "iconx"; value: 0 }
                PathAttribute { name: "iconOpacity"; value: 0.02 }
                PathAttribute { name: "icony"; value: 1 }

                PathLine { x: coverslide.width/2; y: coverslide.height/2 }

                PathAttribute { name: "icony"; value: 0.5 }
                PathAttribute { name: "iconx"; value: 0.5 }
                PathAttribute { name: "iconOpacity"; value: 1 }

                PathLine { x: coverslide.width; y: coverslide.height/2 }
                PathAttribute { name: "iconx"; value: 0 }
                PathAttribute { name: "icony"; value: 1 }
                PathAttribute { name: "iconOpacity"; value: 0.02 }

            }
        }

        TitleColumn {
            id: titleColumn
            anchors.left: coverslide.right
            anchors.leftMargin: 60
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -30
            preferredWidth: Style.vspan(6)
        }

        MusicControls {
            id: controlsRow
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 40
            spacing: Style.hspan(3)
            play: root.musicPlaying
            onPreviousClicked: {
                root.previousClicked();
            }
            onNextClicked: {
                root.nextClicked();
            }

            onPlayClicked: {
                root.playClicked();
            }
        }
    }
}
