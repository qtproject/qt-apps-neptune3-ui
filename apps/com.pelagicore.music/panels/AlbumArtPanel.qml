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
import QtQuick.Controls 2.2
import shared.utils 1.0
import shared.animations 1.0
import shared.Style 1.0
import shared.Sizes 1.0

import "../controls" 1.0

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
            height: Sizes.dp(180)
            width: height

            layer.enabled: true
            opacity: PathView.iconOpacity !== undefined ? PathView.iconOpacity : 0.0

            property alias albumArtSource: albumArt.source

            Image {
                id: albumArtUndefined
                visible: opacity > 0
                opacity: (mediaReady && model.item.coverArtUrl) ? 1.0 : 0.0
                Behavior on opacity {DefaultNumberAnimation {}}
                anchors.centerIn: parent
                width: Sizes.dp(180)
                height: width
                source: Style.image("album-art-placeholder")
                fillMode: Image.PreserveAspectCrop
            }


            Image {
                id: albumArt
                visible: opacity > 0
                opacity: (mediaReady && model.item.coverArtUrl) ? 1.0 : 0.0
                Behavior on opacity {DefaultNumberAnimation {}}
                anchors.centerIn: parent
                width: Sizes.dp(180)
                height: width
                source: model.item.coverArtUrl !== undefined ? model.item.coverArtUrl : ""
                fillMode: Image.PreserveAspectCrop
            }
        }
    }

    Item {
        anchors.fill: parent

        PathView {
            id: coverslide
            width: height
            height: parent.height
            anchors.left: parent.left
            anchors.leftMargin: parentStateMaximized ? Sizes.dp(100) : Sizes.dp(40)
            Behavior on anchors.leftMargin { DefaultNumberAnimation { } }
            preferredHighlightBegin: 0.5
            preferredHighlightEnd: 0.5
            snapMode: PathView.SnapOneItem
            highlightRangeMode: PathView.StrictlyEnforceRange
            highlightMoveDuration: 200
            model: root.songModel
            delegate: albumArtDelegate
            pathItemCount: 1
            cacheItemCount: Math.max(Math.min(model.count - 1, 10), 0)

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

                PathAttribute { name: "iconOpacity"; value: 0.02 }
                PathLine { x: coverslide.width/2; y: coverslide.height/2 }
                PathAttribute { name: "iconOpacity"; value: 1 }
                PathLine { x: coverslide.width; y: coverslide.height/2 }
                PathAttribute { name: "iconOpacity"; value: 0.02 }
            }
        }

        Loader {
            id: searchingMedia
            width: Sizes.dp(180)
            height: width
            anchors.centerIn: coverslide
            active: !root.mediaReady
            sourceComponent: Item {
                BusyIndicator {
                    id: busyIndicator
                    anchors.centerIn: parent
                    Behavior on opacity { DefaultNumberAnimation {} }
                    visible: opacity > 0.0
                    running: visible
                    width: Sizes.dp(60)
                    height: Sizes.dp(60)
                }

                Label {
                    id: warningLabel
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: root.parentStateMaximized === "Maximized"? Sizes.dp(300) : 0
                    Behavior on anchors.leftMargin { DefaultNumberAnimation {} }
                    opacity: 0.0
                    text: qsTr("There is no music available")
                    Behavior on opacity { DefaultNumberAnimation {} }
                }

                Timer {
                    running: busyIndicator.running
                    interval: 5000
                    onTriggered: {
                        if (!root.mediaReady) {
                            busyIndicator.opacity = 0.0;
                            warningLabel.opacity = 1.0;
                        }
                    }
                }
            }
        }

        TitleColumn {
            id: titleColumn
            anchors.left: coverslide.right
            anchors.leftMargin: Sizes.dp(100)
            anchors.right: controlsRow.left
            anchors.rightMargin: Sizes.dp(20)
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: Sizes.dp(-4)
            preferredWidth: Sizes.dp(480)
        }

        MusicControls {
            id: controlsRow
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: parentStateMaximized ? Sizes.dp(100) : Sizes.dp(28)
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
