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
import QtQuick.Controls 2.2
import utils 1.0
import animations 1.0
import com.pelagicore.styles.neptune 3.0

import "../controls"

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
            height: NeptuneStyle.dp(180)
            width: height

            layer.enabled: true
            opacity: PathView.iconOpacity !== undefined ? PathView.iconOpacity : 0.0

            property alias albumArtSource: albumArt.source

            Image {
                id: albumArtShadow
                anchors.centerIn: parent
                source: Style.gfx2("album-art-shadow")
                fillMode: Image.Pad
            }

            Image {
                id: albumArtUndefined
                visible: opacity > 0
                opacity: (mediaReady && model.item.coverArtUrl) ? 1.0 : 0.0
                Behavior on opacity {DefaultNumberAnimation {}}
                anchors.centerIn: parent
                width: NeptuneStyle.dp(180)
                height: width
                source: Style.gfx2("album-art-placeholder")

                fillMode: Image.PreserveAspectCrop
            }


            Image {
                id: albumArt
                visible: opacity > 0
                opacity: (mediaReady && model.item.coverArtUrl) ? 1.0 : 0.0
                Behavior on opacity {DefaultNumberAnimation {}}
                anchors.centerIn: parent
                width: NeptuneStyle.dp(180)
                height: width
                source: model.item.coverArtUrl !== undefined ? model.item.coverArtUrl : ""

                fillMode: Image.PreserveAspectCrop
            }
        }
    }

    Item {
        id: coverArtTitleAndControlsWrapperItem
        anchors.fill: parent

        PathView {
            id: coverslide
            width: height
            height: parent.height
            anchors.left: parent.left
            anchors.leftMargin: parentStateMaximized ? NeptuneStyle.dp(100) : NeptuneStyle.dp(40)
            Behavior on anchors.leftMargin { DefaultNumberAnimation { } }
            preferredHighlightBegin: 0.5
            preferredHighlightEnd: 0.5
            snapMode: PathView.SnapOneItem
            highlightRangeMode: PathView.StrictlyEnforceRange
            highlightMoveDuration: 200
            model: 0
            delegate: albumArtDelegate
            pathItemCount: 1
            cacheItemCount:10

            interactive: false

            onCurrentIndexChanged: {
                if (currentItem) {
                    root.currentAlbumArt = currentItem.albumArtSource;
                } else {
                    root.currentAlbumArt = "";
                }
            }

            path: Path {
                startX: -coverSlide.width-8; startY: coverslide.height/2
                PathAttribute { name: "iconOpacity"; value: 0.0 }
                PathLine { x: -coverSlide.width/4-4; y: coverslide.height/2 }
                PathAttribute { name: "iconOpacity"; value: 0.0 }
                PathLine { x: coverSlide.width/2; y: coverslide.height/2 }
                PathAttribute { name: "iconOpacity"; value: 1.0 }
                PathLine { x: coverslide.width*5/4+4; y: coverslide.height/2 }
                PathAttribute { name: "iconOpacity"; value: 0.0 }
                PathLine { x: coverslide.width*2+8; y: coverslide.height/2 }
                PathAttribute { name: "iconOpacity"; value: 0.0 }
            }
        }

        Item {
            id: searchingMedia
            width: NeptuneStyle.dp(180)
            height: width
            opacity: root.mediaReady ? 0.0 : 1.0
            Behavior on opacity { DefaultNumberAnimation {} }
            visible: opacity > 0
            anchors.centerIn: coverslide

            BusyIndicator {
                anchors.centerIn: parent
                visible: parent.visible
                running: visible
                width: NeptuneStyle.dp(60)
                height: NeptuneStyle.dp(60)
            }
        }

        TitleColumn {
            id: titleColumn
            anchors.left: coverslide.right
            anchors.leftMargin: NeptuneStyle.dp(100)
            anchors.right: controlsRow.left
            anchors.rightMargin: NeptuneStyle.dp(20)
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: NeptuneStyle.dp(-4)
            preferredWidth: NeptuneStyle.dp(480)
        }

        MusicControls {
            id: controlsRow
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: parentStateMaximized ? NeptuneStyle.dp(100) : NeptuneStyle.dp(28)
            Behavior on anchors.rightMargin { DefaultNumberAnimation { } }
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
