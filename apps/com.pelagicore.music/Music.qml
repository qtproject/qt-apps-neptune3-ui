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
import QtGraphicalEffects 1.0
import "stores"

import com.pelagicore.styles.triton 1.0

Item {
    id: root

    property MusicStore store
    readonly property int topMaximizedMargin: Style.vspan(1)
    property alias albumArtRow: albumArtRow
    property alias controlsRow: controlsRow
    property bool showList: false

    signal dragAreaClicked()

    state: "Widget1Row"

    Binding {
        target: root.store; property: "contentType";
        value: {
            switch (toolsColumn.currentText) {
                case "artists":
                    return "artist";
                case "albums":
                case "folders":
                    return "album";
                case "favorites":
                    // TODO: check if IVI already support favorites list.
                default:
                    // TODO: specify all possible content type. currently use "track" as default
                    return "track";
            }
        }
    }

    // States and transitions are still WIP. it still need to wait for the feedback from designer and later be updated according to the final spec.
    states: [
        State {
            name: "Widget1Row"
            PropertyChanges { target: nowPlayingList; state: "WidgetList1Row" }
        },
        State {
            name: "Widget2Rows"
            PropertyChanges { target: nowPlayingList; state: "WidgetHideList" }
        },
        State {
            name: "Widget3Rows"
            PropertyChanges { target: nowPlayingList; width: parent.width - Style.hspan(4); y: nowPlayingList.initialY;
                              listView.contentY: - Style.vspan(0.8); anchors.horizontalCenterOffset: 0; state: "WidgetHideList" }
        },
        State {
            name: "Maximized"
            PropertyChanges { target: nowPlayingList; width: parent.width - Style.hspan(4); y: Style.vspan(4.5);
                              listView.contentY: - Style.vspan(0.8); state: "WidgetListMaximized" }
        }
    ]

    transitions: [
        Transition {
            DefaultNumberAnimation { target: nowPlayingList; properties: "width, y, contentY, anchors.horizontalCenterOffset"; }
        }
    ]

    MouseArea {
        id: nowPlayingDragArea
        width: root.width
        height: enabled ? Style.vspan(5.5) : 0
        anchors.horizontalCenter: nowPlayingList.horizontalCenter
        anchors.bottom: nowPlayingList.top
        anchors.bottomMargin: - nowPlayingList.listView.headerItem.height
        drag.target: nowPlayingList
        drag.axis: Drag.YAxis
        drag.minimumY: Style.vspan(4.2)
        drag.maximumY: nowPlayingList.initialY
        enabled: root.state === "Widget3Rows"

        onClicked: root.dragAreaClicked()
        onReleased: {
            if (nowPlayingList.y < Style.vspan(7.8) && nowPlayingList.y > Style.vspan(4.2)) {
                nowPlayingList.y = Style.vspan(4.2);
            } else if (nowPlayingList.y > Style.vspan(7.8)) {
                nowPlayingList.y = nowPlayingList.initialY;
            }
        }
    }

    MusicList {
        id: nowPlayingList

        width: parent.width - Style.hspan(4)
        height: root.state === "Maximized" ? Style.vspan(9.5) : Style.vspan(6.8)
        Behavior on height { DefaultNumberAnimation { } }

        anchors.left: parent.left
        anchors.leftMargin: Style.hspan(2.6)

        property int initialY: Style.vspan(10.4)
        y: nowPlayingList.initialY
        onYChanged: {
            if (root.state === "Widget3Rows") {
                if (y < Style.vspan(7.8) && nowPlayingList.state === "WidgetHideList") {
                    nowPlayingList.state = "WidgetShowList";
                } else if (y > Style.vspan(7.8) && nowPlayingList.state === "WidgetShowList") {
                    nowPlayingList.state = "WidgetHideList";
                }
            }
        }
        Behavior on y { DefaultNumberAnimation { } }

        showPath: false
        showBg: false
        showList: !musicLibrary.showList
        listView.interactive: showList && ((root.state === "Widget3Rows" && nowPlayingList.state !== "WidgetHideList")
                                           || root.state === "Maximized")
        state: "WidgetHideList"
        states: [
            State {
                name: "WidgetHideList"
                AnchorChanges {
                    target: albumArtRow
                    anchors.left: undefined
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                PropertyChanges { target: albumArtRow; scale: 1.0; width: Style.hspan(19); height: Style.vspan(6);
                                  anchors.verticalCenterOffset: - Style.vspan(0.5) }
                PropertyChanges { target: nowPlayingList; width: parent.width - Style.hspan(4); y: nowPlayingList.initialY;
                                  listView.contentY: - Style.vspan(0.8); anchors.horizontalCenterOffset: 0; }
            },
            State {
                name: "WidgetShowList"
                AnchorChanges {
                    target: albumArtRow
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                }
                PropertyChanges { target: albumArtRow; scale: 0.7; width: Style.hspan(6.2); height: Style.vspan(3.5);
                                  anchors.verticalCenterOffset: - Style.vspan(3.5); anchors.leftMargin: Style.hspan(0.8) }
                PropertyChanges { target: nowPlayingList; width: parent.width - Style.hspan(4); y: Style.vspan(4.2);
                                  listView.contentY: - Style.vspan(0.8); anchors.horizontalCenterOffset: 0; showList: true }
            },

            State {
                name: "WidgetList1Row"
                AnchorChanges {
                    target: albumArtRow
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                }
                PropertyChanges { target: albumArtRow; width: Style.hspan(6.2); height: Style.vspan(3.5); scale: 1.0;
                                  anchors.verticalCenterOffset: 0; anchors.leftMargin: 0 }
            },

            State {
                name: "WidgetListMaximized"
                AnchorChanges {
                    target: albumArtRow
                    anchors.verticalCenter: undefined
                    anchors.top: parent.top
                }
                PropertyChanges { target: albumArtRow; scale: 1; width: Style.hspan(6.2); height: Style.vspan(3.5);
                                  anchors.leftMargin: Style.hspan(1.8) }
                PropertyChanges { target: nowPlayingList; width: parent.width - Style.hspan(4); y: Style.vspan(4.5);
                                  listView.contentY: - Style.vspan(0.8); }
            }

        ]

        transitions: [
            Transition {
                from: "WidgetHideList"; to: "WidgetList1Row"
                DefaultNumberAnimation { target: albumArtRow; properties: "width, height, scale, anchors.leftMargin, anchors.verticalCenterOffset";
                    duration: 50 }
            },
            Transition {
                from: "WidgetList1Row"; to: "WidgetHideList"
                ParallelAnimation {
                    AnchorAnimation { easing.type: Easing.InOutQuad; duration: 100 }
                    DefaultNumberAnimation { target: albumArtRow; properties: "width, height, scale, anchors.verticalCenterOffset"; }
                }
            },
            Transition {
                from: "WidgetShowList"; to: "WidgetHideList"
                ParallelAnimation {
                    AnchorAnimation { easing.type: Easing.InOutQuad; duration: 100 }
                    DefaultNumberAnimation { target: albumArtRow; properties: "width, height, scale, anchors.verticalCenterOffset" }
                }
            },
            Transition {
                from: "WidgetListMaximized";
                ParallelAnimation {
                    AnchorAnimation { easing.type: Easing.InOutQuad; duration: 100 }
                    DefaultNumberAnimation { target: albumArtRow; properties: "width, height, scale, anchors.leftMargin, anchors.verticalCenterOffset" }
                }
            },
            Transition {
                ParallelAnimation {
                    AnchorAnimation { easing.type: Easing.InOutQuad; duration: 270 }
                    DefaultNumberAnimation { target: albumArtRow; properties: "width, height, scale, anchors.verticalCenterOffset"; }
                    DefaultNumberAnimation { target: nowPlayingList; properties: "width, listView.contentY"; }
                }
            }
        ]

        contentType: root.store.searchAndBrowseModel.contentType
        visible: (root.state === "Widget3Rows" || nowPlayingList.state === "WidgetShowList" || root.state === "Maximized") && root.height > 850
        opacity: visible ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation { } }

        listView.model: root.store.musicPlaylist

        onItemClicked: {
            root.store.musicPlaylist.currentIndex = index;
            root.store.player.play();
        }

        onHeaderClicked: {
            if (root.state === "Maximized") {
                musicLibrary.showList = false;
                musicLibrary.listView.contentY = - Style.vspan(0.8);
            } else if (root.state === "Widget3Rows" && nowPlayingList.state === "WidgetHideList") {
                nowPlayingList.y = Style.vspan(4.2);
            } else if (root.state === "Widget3Rows" && nowPlayingList.state === "WidgetShowList") {
                nowPlayingList.y = nowPlayingList.initialY;
            }
        }
    }

    MusicList {
        id: musicLibrary

        anchors.left: parent.left
        anchors.right: parent.right

        anchors.bottom: parent.bottom

        showPath: {
            switch (toolsColumn.currentText) {
                case "artists":
                case "albums":
                case "folders":
                    return false;
                case "favorites":
                default:
                    return true;
            }
        }

        states: [
            State {
                name: "expanded"
                when: musicLibrary.showList
                AnchorChanges {
                    target: musicLibrary
                    anchors.top: nowPlayingList.top
                }
                PropertyChanges {
                    target: musicLibrary
                    anchors.topMargin: nowPlayingList.listView.headerItem.height
                }
            },
            State {
                name: "colapsed"
                when: !musicLibrary.showList
                AnchorChanges {
                    target: musicLibrary
                    anchors.top: nowPlayingList.bottom
                }
                PropertyChanges {
                    target: musicLibrary
                    anchors.topMargin: 0
                }
            }
        ]
        transitions: Transition {
            AnchorAnimation { easing.type: Easing.InOutQuad; duration: 270 }
        }

        visible: root.state === "Maximized"
        onVisibleChanged: {
            if (visible) {
                musicLibrary.showList = visible;
                root.store.searchAndBrowseModel.contentType = "track";
            }
        }

        opacity: visible ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation { } }

        showBg: true
        listView.interactive: showList
        listView.model: root.store.searchAndBrowseModel
        contentType: root.store.searchAndBrowseModel.contentType

        onShowListChanged: {
            if (musicLibrary.showList) {
                nowPlayingList.y = Style.vspan(4.5);
            } else {
                nowPlayingList.y = Style.vspan(5.5);
            }
        }

        onHeaderClicked: {
            musicLibrary.showList = !musicLibrary.showList;
            nowPlayingList.listView.contentY = - Style.vspan(0.8);
        }

        onLibraryGoBack: {
            musicLibrary.albumPath = "";
            if (musicLibrary.contentType.slice(-5) === "album") {
                musicLibrary.artistPath = "";
            }

            // if root content "artist" is specified, then go to the root, otherwise it will go one step back.
            if (goToArtist) {
                root.store.searchAndBrowseModel.contentType = "artist";
                musicLibrary.artistPath = "";
                musicLibrary.albumPath = "";
            } else {
                root.store.searchAndBrowseModel.goBack();
            }
        }

        onItemClicked: {

            if (root.store.searchAndBrowseModel.canGoForward(index) && musicLibrary.contentType.slice(-6) === "artist") {
                musicLibrary.artistPath = title;
                root.store.searchAndBrowseModel.goForward(index, root.store.searchAndBrowseModel.InModelNavigation);
            } else if (root.store.searchAndBrowseModel.canGoForward(index) && musicLibrary.contentType.slice(-5) === "album") {
                musicLibrary.albumPath = title;
                root.store.searchAndBrowseModel.goForward(index, root.store.searchAndBrowseModel.InModelNavigation);
            } else {
                root.store.musicPlaylist.insert(root.store.musicCount, root.store.searchAndBrowseModel.get(index));
                root.store.player.play();
            }

            if (root.state !== "Maximized") {
                root.store.musicPlaylist.currentIndex = index;
                root.store.player.play();
            }
        }
    }

    ToolsColumn {
        id: toolsColumn
        anchors.left: parent.left
        anchors.leftMargin: Style.hspan(1.0)
        anchors.top: musicLibrary.top
        anchors.topMargin: Style.vspan(1.1)
        visible: root.state === "Maximized" && musicLibrary.showList
        opacity: visible ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation { } }

        translationContext: "MusicToolsColumn"
        model: ListModel {
            ListElement { icon: "ic-favorites"; text: QT_TRANSLATE_NOOP("MusicToolsColumn", "favorites") }
            ListElement { icon: "ic-artists"; text: QT_TRANSLATE_NOOP("MusicToolsColumn", "artists") }
            ListElement { icon: "ic-playlists"; text: QT_TRANSLATE_NOOP("MusicToolsColumn", "playlists") }
            ListElement { icon: "ic-albums"; text: QT_TRANSLATE_NOOP("MusicToolsColumn", "albums") }
            ListElement { icon: "ic-folder-browse"; text: QT_TRANSLATE_NOOP("MusicToolsColumn", "folders") }
        }

        onCurrentIndexChanged: {
            // Reset media library path
            musicLibrary.artistPath = "";
            musicLibrary.albumPath = "";
        }
    }

    AlbumArtRow {
        id: albumArtRow

        width: Style.hspan(6.2)
        height: Style.vspan(3.5)

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left

        showPrevNextAlbum: root.state === "Widget2Rows" || (root.state === "Widget3Rows" && nowPlayingList.state === "WidgetHideList")
        showMusicTools: albumArtRow.showPrevNextAlbum
        musicPlaying: root.store.playing
        musicPosition: root.store.currentTrackPosition
        showShadow: root.store.musicCount > 0 && root.state === "Maximized"
        mediaReady: root.store.searchAndBrowseModel.count > 0
        songModel: root.store.musicPlaylist
        currentIndex: root.store.musicPlaylist.currentIndex
        currentSongTitle: root.store.currentEntry ? root.store.currentEntry.title : "Track unavailable"
        currentArtisName: root.store.currentEntry ? root.store.currentEntry.artist : ""
        currentProgressLabel: root.store.elapsedTime + " / " + root.store.totalTime

        onPlayClicked: root.store.playSong()
        onPreviousClicked: root.store.previousSong()
        onNextClicked: root.store.nextSong()
        onShuffleClicked: root.store.shuffleSong()
        onRepeatClicked: root.store.repeatSong()
        onUpdatePosition: root.store.updatePosition(value)
    }

    MusicProgress {
        id: musicProgress
        width: labelOnTop ? Style.hspan(14.5) : Style.hspan(18.5)
        height: Style.hspan(0.6)

        // Show progress label on top when maximized state.
        labelOnTop: root.state === "Maximized"

        anchors.top: labelOnTop ? controlsRow.bottom : albumArtRow.bottom
        anchors.topMargin: - Style.hspan(0.6)
        anchors.left: labelOnTop ? titleColumn.left : parent.left
        anchors.leftMargin: labelOnTop ? - Style.hspan(1) : Style.hspan(2.2)
        Behavior on anchors.leftMargin { DefaultNumberAnimation { } }
        progressBarLabelLeftMargin: labelOnTop ? Style.hspan(1) : Style.hspan(0.6)
        progressText: root.store.elapsedTime + " / " + root.store.totalTime

        progressBarWidth: {
            if (musicProgress.labelOnTop) {
                return musicProgress.width - Style.hspan(2);
            } else {
                return musicProgress.width - Style.hspan(5);
            }
        }
        Behavior on progressBarWidth { DefaultNumberAnimation { } }

        value: root.store.currentTrackPosition
        visible: nowPlayingList.state === "WidgetShowList" || root.state === "Maximized"
        opacity: (visible && nowPlayingList.listView.contentY < 0) || root.state === "Maximized"? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation { duration: 100 } }

        onUpdatePosition: root.store.updatePosition(value)
    }

    TitleColumn {
        id: titleColumn
        Layout.preferredWidth: Style.vspan(3)
        anchors.verticalCenter: albumArtRow.verticalCenter
        anchors.verticalCenterOffset: root.state === "Maximized" ? - Style.vspan(0.5) : 0
        anchors.right: controlsRow.left
        anchors.leftMargin: Style.hspan(0.8)
        opacity: controlsRow.opacity
        currentSongTitle: root.store.currentEntry ? root.store.currentEntry.title : "Track unavailable"
        currentArtisName: root.store.currentEntry ? root.store.currentEntry.artist : ""
    }

    MusicControls {
        id: controlsRow
        anchors.verticalCenter: albumArtRow.verticalCenter
        anchors.verticalCenterOffset: root.state === "Maximized" ? - Style.vspan(0.5) : 0
        anchors.right: parent.right
        anchors.rightMargin: root.state === "Maximized" ? Style.hspan(2.6) : Style.hspan(2)
        visible: root.state === "Widget1Row" ||
                 (root.state === "Widget3Rows" && nowPlayingList.state === "WidgetShowList") ||
                 root.state === "Maximized"
        opacity: visible ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation { duration: 100 } }

        play: root.store.playing

        onPlayClicked: root.store.playSong()
        onPreviousClicked: root.store.previousSong()
        onNextClicked: root.store.nextSong()
    }

    MusicTools {
        anchors.top: musicProgress.bottom
        anchors.topMargin: Style.vspan(2)
        anchors.right: parent.right
        anchors.rightMargin: Style.hspan(2)
        visible: root.state === "Maximized"
        opacity: visible ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation { duration: 100 } }

        onShuffleClicked: root.store.shuffleSong()
        onRepeatClicked: root.store.repeatSong()
    }

    Image {
        width: nowPlayingList.width
        height: Style.vspan(0.2)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: albumArtRow.bottom
        anchors.topMargin: root.state === "Maximized" ? Style.vspan(1.5) : Style.vspan(0.2)
        source: Style.gfx2("divider", TritonStyle.theme)
        opacity: (nowPlayingList.state === "WidgetShowList" || root.state === "Maximized")
                 && nowPlayingList.listView.contentY > 0 ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation { duration: 100 } }
    }
}
