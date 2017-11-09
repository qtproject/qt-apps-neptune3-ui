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
import animations 1.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import "stores"

Item {
    id: root

    property MusicStore store
    readonly property int topMaximizedMargin: Style.vspan(1)
    property alias albumArtRow: albumArtRow
    property alias controlsRow: controlsRow
    property bool showList: false
    readonly property int widgetMaxHeight: 874

    // TODO: REMOVE THIS WHEN ITS FINAL. Temporary to show Johan how it looks since he is working with single process.
    clip: true
    state: "minimized"

    // Probably need to be changed. Get widget state instead of taking its updated height if needed.
    onHeightChanged: {
        if (root.height < 550) {
            root.state = "minimized";
        } else if (root.height > 550 && root.height <= 580) {
            root.state = "opened";
        } else if (root.height > 580 && !showList) {
            root.state = "maximized";
        }
    }

    // States and transitions are still WIP. it still need to wait for the feedback from designer and later be updated according to the final spec.
    states: [
        State {
            name: "minimized"
            PropertyChanges { target: albumArtRow; width: 270; height: 270; anchors.verticalCenterOffset: 0; anchors.horizontalCenterOffset: - Style.hspan(7.1) }
            PropertyChanges { target: controlsRow; anchors.topMargin: Style.vspan(0.55); anchors.rightMargin: Style.hspan(2.5); spacing: 15 }
        },
        State {
            name: "opened"
            PropertyChanges { target: albumArtRow; width: root.width - 150; height: 450; anchors.verticalCenterOffset: - Style.vspan(0.5);
                              anchors.horizontalCenterOffset: 0 }
            PropertyChanges { target: controlsRow; opacity: 0.0 }
        },
        State {
            name: "maximized"
            PropertyChanges { target: albumArtRow; width: root.width - 150; height: 450; anchors.verticalCenterOffset: - Style.vspan(0.5);
                              anchors.horizontalCenterOffset: 0 }
            PropertyChanges { target: controlsRow; opacity: 0.0 }
        },
        State {
            name: "lists"
            PropertyChanges { target: albumArtRow; scale: 0.7; width: 270; height: 270; anchors.verticalCenterOffset: - Style.vspan(3.5);
                              anchors.horizontalCenterOffset: - Style.hspan(6.5) }
            PropertyChanges { target: controlsRow; anchors.topMargin: Style.vspan(0.55); anchors.rightMargin: Style.hspan(2.5); spacing: 15 }
        }
    ]

    transitions: [
        Transition {
            from: "opened"; to: "minimized"
            DefaultNumberAnimation { target: albumArtRow; properties: "width, height, scale, anchors.horizontalCenterOffset, anchors.verticalCenterOffset";
                                     duration: 50 }
            DefaultNumberAnimation { target: controlsRow; properties: "anchors.topMargin, anchors.rightMargin, spacing, opacity"; }
        },
        Transition {
            DefaultNumberAnimation { target: albumArtRow; properties: "width, height, scale, anchors.horizontalCenterOffset, anchors.verticalCenterOffset"; }
            DefaultNumberAnimation { target: controlsRow; properties: "anchors.topMargin, anchors.rightMargin, spacing, opacity"; }
        }
    ]

    AlbumArtRow {
        id: albumArtRow

        width: 270
        height: 270
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: - Style.hspan(7.1)

        showPrevNextAlbum: root.state === "opened" || root.state === "maximized"
        songModel: root.store.musicModel
        currentIndex: root.store.currentIndex
        currentSongTitle: root.store.getCurrentTitle(albumArtRow.coverSlide.currentIndex)
        currentArtisName: root.store.getCurrentArtist(albumArtRow.coverSlide.currentIndex)

        onShowPrevNextAlbumChanged:{

            //HACK!! TODO: FIND A BETTER WAY TO RESET LIST DEFAULT POSITION
            if (root.state === "maximized" && showPrevNextAlbum && songList.headerItem) {
                songList.y = root.widgetMaxHeight - songList.headerItem.height
                songList.contentY = - songList.headerItem.height
            }
        }

        onPreviousClicked: {
            root.store.previousSong();
        }

        onNextClicked: {
            root.store.nextSong();
        }
    }

    MusicProgress {
        id: musicProgress
        width: 840
        height: 25
        anchors.top: albumArtRow.bottom
        anchors.left: parent.left
        anchors.leftMargin: Style.hspan(2.2)
        labelOnTop: false
        visible: root.state === "lists"
        opacity: visible && songList.contentY < 0 ? 1.0 : 0.0
        Behavior on opacity {
            DefaultNumberAnimation { duration: 100 }
        }
    }

    TitleColumn {
        id: titleColumn
        anchors.verticalCenter: albumArtRow.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: - Style.hspan(1)
        opacity: controlsRow.opacity
        currentSongTitle: root.store.getCurrentTitle(albumArtRow.coverSlide.currentIndex)
        currentArtisName: root.store.getCurrentArtist(albumArtRow.coverSlide.currentIndex)
    }

    MusicControls {
        id: controlsRow
        anchors.verticalCenter: albumArtRow.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: Style.hspan(2.5)

        onPreviousClicked: {
            root.store.previousSong();
        }

        onNextClicked: {
            root.store.nextSong();
        }
    }

    Image {
        id: divider
        width: songList.width
        height: Style.vspan(0.2)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: albumArtRow.bottom
        anchors.topMargin: Style.vspan(0.2)
        source: Style.gfx2("divider")
        opacity: root.state === "lists" && songList.contentY > 0 ? 1.0 : 0.0
        Behavior on opacity {
            DefaultNumberAnimation { }
        }
    }

    MusicList {
        id: songList

        width: parent.width - Style.hspan(4)
        height: Style.vspan(6.8)
        anchors.horizontalCenter: parent.horizontalCenter

        y: root.widgetMaxHeight - headerItem.height
        onYChanged: {
            if (y < 620 && y > 320 && root.state === "maximized") {
                root.state = "lists";
            } else if (y > 620 && root.state === "lists") {
                root.state = "maximized";
            }
        }

        visible: (root.state === "maximized" || root.state === "lists") && root.height > 850
        opacity: visible ? 1.0 : 0.0
        Behavior on opacity {
            DefaultNumberAnimation { }
        }

        model: store.musicModel
        currentIndex: root.state === "lists" ? root.store.currentIndex : 0

        onItemClicked: root.store.currentIndex = index

        MouseArea {
            id: dragArea
            width: root.width
            height: Style.vspan(0.8)
            anchors.horizontalCenter: parent.horizontalCenter
            drag.target: songList
            drag.axis: Drag.YAxis
            drag.minimumY: 320
            drag.maximumY: root.height - Style.vspan(0.8)

            onReleased: {
                if (songList.y < 620 && songList.y > 320) {
                    songList.y = 320;
                } else if (songList.y > 620) {
                    songList.y = root.height - songList.headerItem.height;
                }
            }
        }
    }
}
