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
    property bool showPrevNextAlbum: false
    property bool showShadow: false
    property bool showMusicTools: false
    property bool showInCluster: false
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

    signal updatePosition(var value)

    function populateModel() {
        coverSlide.model = root.songModel;
    }

    Component {
        id: albumArtDelegate

        Item {
            id: itemDelegated
            height: root.showInCluster ? Style.vspan(2.5) : Style.vspan(3.5)
            Behavior on height { DefaultNumberAnimation { } }

            width: height
            opacity: PathView.iconOpacity !== undefined ? PathView.iconOpacity : 0.0

            property alias albumArtSource: albumArt.source

            Image {
                anchors.fill: parent
                visible: mediaReady && model.item.coverArtUrl

                opacity: visible ? 1.0 : 0.0
                Behavior on opacity { DefaultNumberAnimation { } }

                source: Style.gfx2("album-art-placeholder")
                fillMode: Image.PreserveAspectFit

                property double iconx: PathView.iconx !== undefined ? PathView.iconx : 0.0
                property double icony: PathView.icony !== undefined ? PathView.icony : 0.0
            }

            Image {
                id: albumArt
                anchors.fill: parent
                source: mediaReady && model.item.coverArtUrl ? model.item.coverArtUrl : Style.gfx2("album-art-placeholder")
                fillMode: Image.PreserveAspectFit

                property double iconx: PathView.iconx !== undefined ? PathView.iconx : 0.0
                property double icony: PathView.icony !== undefined ? PathView.icony : 0.0
            }
        }
    }

    Rectangle {
        id: albumArtShadow

        width: root.width - Style.hspan(0.9)
        height: Style.vspan(0.05)
        anchors.bottom: root.bottom
        anchors.horizontalCenter: root.horizontalCenter
        visible: root.showShadow && coverSlide.currentItem.opacity === 1.0
        opacity: visible ? 0.7 : 0.0
        Behavior on opacity { DefaultNumberAnimation { } }

        color: "grey"
        layer.enabled: true
        layer.effect: DropShadow {
            anchors.fill: albumArtShadow
            source: albumArtShadow
            horizontalOffset: 0
            verticalOffset: Style.vspan(0.7)
            radius: 30
            samples: 50
            spread: 0.0
            color: "#aa000000"
        }
    }

    Item {
        id: pathView

        width: root.width
        height: root.showInCluster ? Style.vspan(2.5) : Style.vspan(3.5)
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
            pathItemCount: root.showPrevNextAlbum ? 3 : 1
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

        MusicControls {
            id: controlsRow
            anchors.centerIn: parent
            spacing: Style.hspan(9)
            visible: !root.showInCluster && root.showPrevNextAlbum
            play: root.musicPlaying
            opacity: root.showPrevNextAlbum ? 1.0 : 0.0
            Behavior on opacity {
                SequentialAnimation {
                    PauseAnimation {
                        duration: 200
                    }
                    DefaultNumberAnimation { duration: 100 }
                }
            }

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

    MusicProgress {
        id: musicProgress
        width: root.width
        height: root.showInCluster ? Style.vspan(0.2) : Style.vspan(1)
        anchors.top: pathView.bottom
        value: root.musicPosition
        visible: root.showPrevNextAlbum
        opacity: root.showPrevNextAlbum ? 1.0 : 0.0
        Behavior on opacity {
            SequentialAnimation {
                PauseAnimation {
                    duration: 200
                }
                DefaultNumberAnimation { duration: 100 }
            }
        }

        onUpdatePosition: root.updatePosition(value)
    }

    TitleColumn {
        id: titleColumn

        anchors.left: parent.left
        anchors.leftMargin: Style.hspan(0.6)
        anchors.top: musicProgress.bottom
        anchors.topMargin: root.showInCluster ? Style.vspan(1.6) : Style.vspan(0.8)
        preferredWidth: Style.vspan(6)

        // the animation will only applied when it goes from invisible to visible.
        visible: root.showPrevNextAlbum
        opacity: visible ? 1.0 : 0.0
        Behavior on opacity {
            SequentialAnimation {
                PauseAnimation {
                    duration: 200
                }
                DefaultNumberAnimation { duration: 100 }
            }
        }
    }

    MusicTools {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Style.vspan(0.2)
        anchors.right: parent.right
        anchors.rightMargin: Style.hspan(0.3)
        visible: root.showMusicTools
        opacity: visible ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation { } }

        onShuffleClicked: root.shuffleClicked()
        onRepeatClicked: root.repeatClicked()
    }
}
