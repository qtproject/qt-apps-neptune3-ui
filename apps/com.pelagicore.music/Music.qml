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
    property bool topExpanded: false //expanded => playing queue visible
    signal flickableAreaClicked()

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

    Item {
        id: fullscreenTop   //but not items shared with widget

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: root.topExpanded ? (root.height - 100) : (660 - 224)
        Behavior on height { DefaultNumberAnimation { duration: 270 } }

        opacity: root.state === "Maximized" ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation {} }
        visible: opacity > 0

        Image {
            id: fullscreenTopPartBackground //todo: add the blurred album art as well
            anchors.fill: parent
            source: Style.gfx2("app-fullscreen-top-bg", TritonStyle.theme)
        }

        Tool {
            id: showPlayingQueueButton

            anchors.verticalCenter: parent.top
            anchors.verticalCenterOffset: Style.vspan(360/80)
            anchors.horizontalCenter: parent.horizontalCenter
            width: Style.hspan(10)
            height: Style.vspan(1.4)
            text: qsTr("Next")
            font.pixelSize: 22 //todo: change to Style.fontSizeS when the value is corrected in style plugin
            symbol: root.topExpanded ? "" : Style.symbol("ic-expand", TritonStyle.theme)
            onClicked: {
                root.topExpanded = true;
            }
        }

        MusicList {
            id: playingQueueList    //playing queue
            anchors.top: parent.top
            anchors.topMargin: 660 - 224
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.leftMargin: 100
            anchors.right: parent.right
            anchors.rightMargin: 100
            clip: true
            listView.model: root.store.musicPlaylist
            onItemClicked: {
                root.store.musicPlaylist.currentIndex = index;
                root.store.player.play();
            }
        }

        Tool {
            id: showNormalBrowseViewButton

            anchors.verticalCenter: parent.bottom
            anchors.verticalCenterOffset: Style.vspan(80/80)
            anchors.horizontalCenter: parent.horizontalCenter
            width: Style.hspan(10)
            height: Style.vspan(1.4)

            opacity: root.topExpanded ? 1.0 : 0.0
            Behavior on opacity {
                SequentialAnimation {
                    PauseAnimation { duration: root.topExpanded ? 0 : 100 }
                    DefaultNumberAnimation {}
                }
            }
            visible: opacity > 0
            text: qsTr("Browse")
            font.pixelSize: 22 //todo: change to Style.fontSizeS when the value is corrected in style plugin
            symbol: Style.symbol("ic-expand-up", TritonStyle.theme)
            onClicked: {
                root.topExpanded = false;
            }
        }
    }

    Item {
        id: fullscreenBottom

        width: Style.hspan(1080/45)
        anchors.left: parent.left
        // ############### Johan's comment:
        // I think it looks better if it does not move horizontally. That's why I added -80 and the Behavior on...
        // It keeps the width of lists etc.
        // Would prefer to get this value passed down to every app, like we did it with exposedRect.
        // ###############
        anchors.leftMargin: root.state === "Maximized" ? 0 : -80
        Behavior on anchors.leftMargin { DefaultNumberAnimation {} }
        anchors.top: fullscreenTop.bottom
        anchors.bottom: parent.bottom

        opacity: root.state === "Maximized" && !root.topExpanded ? 1.0 : 0.0
        Behavior on opacity {
            SequentialAnimation {
                //delay fadeIn when playing queue is closing
                PauseAnimation { duration: root.state === "Maximized" && !root.topExpanded ? 0 : 100 }
                DefaultNumberAnimation {}
            }
        }
        visible: opacity > 0
        clip: true

        // ############### Johan's comment:
        // In the future I would like to see the toolBar code in AppUIScreen.qml
        // and just assigning a model to each app
        // ###############
        AppToolBar {
            id: toolsColumn
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            translationContext: "MusicToolsColumn"
            model: ListModel {
                ListElement { icon: "ic-favorites"; text: QT_TRANSLATE_NOOP("MusicToolsColumn", "favorites"); greyedOut: false}
                ListElement { icon: "ic-artists"; text: QT_TRANSLATE_NOOP("MusicToolsColumn", "artists"); greyedOut: false }
                ListElement { icon: "ic-playlists"; text: QT_TRANSLATE_NOOP("MusicToolsColumn", "playlists"); greyedOut: true }
                ListElement { icon: "ic-albums"; text: QT_TRANSLATE_NOOP("MusicToolsColumn", "albums"); greyedOut: false }
                ListElement { icon: "ic-folder-browse"; text: QT_TRANSLATE_NOOP("MusicToolsColumn", "folders"); greyedOut: true }
            }
            onCurrentTextChanged: {
                musicLibrary.showHeader = false;
            }
        }

        // ############### Johan's comment:
        // In the future I would like the "main content of bottom part of fullscreen app"
        // to be loaded by a loader in AppUIScreen.qml.
        // ###############
        MusicBrowseList {
            id: musicLibrary
            anchors.left: toolsColumn.right
            anchors.right: parent.right
            anchors.top: parent.top
            height: parent.height
            listView.model: root.store.searchAndBrowseModel
            contentType: root.store.searchAndBrowseModel.contentType

            onBackClicked: {
                root.store.searchAndBrowseModel.goBack();
                headerText = "";
                if (toolsColumn.currentText.indexOf(contentType) !== -1) {
                    showHeader = false;
                }
            }

            onItemClicked: {
                if (root.store.searchAndBrowseModel.canGoForward(index) && musicLibrary.contentType.slice(-6) === "artist") {
                    root.store.searchAndBrowseModel.goForward(index, root.store.searchAndBrowseModel.InModelNavigation);
                    headerText = "";
                    showHeader = true;
                } else if (root.store.searchAndBrowseModel.canGoForward(index) && musicLibrary.contentType.slice(-5) === "album") {
                    root.store.searchAndBrowseModel.goForward(index, root.store.searchAndBrowseModel.InModelNavigation);
                    var albumArtist = artist !== "" ? artist : qsTr("Unknown Artist");
                    headerText = qsTr("Songs of %1 (%2)").arg(title).arg(albumArtist);
                    showHeader = true;
                } else {
                    root.store.musicPlaylist.insert(root.store.musicCount, root.store.searchAndBrowseModel.get(index));
                    root.store.musicPlaylist.currentIndex = index;
                    root.store.player.play();
                }
            }
        }
    }

    Item {
        id: widgetAndFullscreen //widget content (and items shared with fullscreen)
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 260
        state: root.state
        property alias widget3QueueContentY: nextListFlickable.contentY

        Item {
            id: nextListFlickableItemWrapper
            width: parent.width
            height: (parent.height - Style.vspan(2))
            anchors.top: artAndTitlesBlock.bottom
            anchors.topMargin: Style.vspan(0.3)
            opacity: 0
            Behavior on opacity { DefaultNumberAnimation { duration: 300 } }
            visible: opacity > 0
            clip: true
            Flickable {
                id: nextListFlickable
                anchors.fill: parent
                contentWidth: parent.width
                contentHeight: Math.max((nextList.height + nextList.anchors.topMargin + Style.vspan(1.3)), height)

                MouseArea {
                    //when clicking anywhere else, go to Maximized state
                    anchors.fill: parent
                    onClicked: {
                        root.flickableAreaClicked();
                    }
                }
                MusicList { //playing queue
                    id: nextList
                    width: parent.width
                    height: (listView.count * Style.vspan(1.3))
                    anchors.top: parent.top
                    anchors.topMargin: ((progressBarBlock.height / 2) + musicTools.height)
                    listView.model: root.store.musicPlaylist
                    listView.interactive: false
                    onItemClicked: {
                        root.store.musicPlaylist.currentIndex = index;
                        root.store.player.play();
                    }
                }
            }
        }
        AlbumArtRow {
            id: artAndTitlesBlock
            height: 180
            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 0
            songModel: root.store.musicPlaylist
            currentIndex: root.store.musicPlaylist.currentIndex
            currentSongTitle: root.store.currentEntry ? root.store.currentEntry.title : qsTr("Unknown Track")
            currentArtisName: root.store.currentEntry ? root.store.currentEntry.artist : ""
            parentStateMaximized: root.state === "Maximized"
            mediaReady: root.store.searchAndBrowseModel.count > 0
            musicPlaying: root.store.playing
            onPlayClicked: root.store.playSong()
            onPreviousClicked: root.store.previousSong()
            onNextClicked: root.store.nextSong()
            Connections {
                target: root.store
                onSongModelPopulated: { artAndTitlesBlock.populateModel(); }
            }
        }

        MusicProgress {
            id: progressBarBlock
            width: parent.width
            height: 220
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 200
            opacity: 0
            visible: opacity > 0
            Behavior on opacity { DefaultNumberAnimation { } }
            value: root.store.currentTrackPosition
            progressText: root.store.elapsedTime + " / " + root.store.totalTime
            onUpdatePosition: root.store.updatePosition(value)
        }

        MusicTools {
            id: musicTools
            anchors.top: progressBarBlock.bottom
            anchors.topMargin: -progressBarBlock.height/2
            anchors.right: progressBarBlock.right
            anchors.rightMargin: Style.hspan(0.3)
            onShuffleClicked: root.store.shuffleSong()
            onRepeatClicked: root.store.repeatSong()
        }

        states: [
            State {
                name: "Widget1Row"
                PropertyChanges { target: nextListFlickable; contentY: 0 }
            },
            State {
                name: "Widget2Rows"
                PropertyChanges { target: widgetAndFullscreen; height: 550 }
                PropertyChanges { target: artAndTitlesBlock; anchors.verticalCenterOffset: - 62 }
                PropertyChanges { target: nextListFlickable; contentY: 0 }
                PropertyChanges { target: progressBarBlock; anchors.verticalCenterOffset: 138 }
                PropertyChanges { target: progressBarBlock; opacity: 1 }
                PropertyChanges { target: musicTools; opacity: 1 }
            },
            State {
                name: "Widget3Rows"
                PropertyChanges { target: widgetAndFullscreen; height: 840 }
                PropertyChanges { target: nextListFlickable; contentY: 0 }
                PropertyChanges { target: nextListFlickableItemWrapper; opacity: 1 }
                PropertyChanges { target: artAndTitlesBlock; anchors.verticalCenterOffset: - 271 - Math.min(20, widgetAndFullscreen.widget3QueueContentY/6) }
                PropertyChanges { target: progressBarBlock; anchors.verticalCenterOffset: -71 - Math.min(60, widgetAndFullscreen.widget3QueueContentY/2) }
                PropertyChanges { target: progressBarBlock; opacity: 1 - Math.max(0, Math.min(1, widgetAndFullscreen.widget3QueueContentY / 140)) }
                PropertyChanges { target: musicTools; opacity: 1 - Math.max(0, Math.min(1, widgetAndFullscreen.widget3QueueContentY / 140))}
            },
            State {
                name: "Maximized"
                PropertyChanges { target: widgetAndFullscreen; height: 660 - 224 }
                PropertyChanges { target: nextListFlickable; contentY: 0 }
                PropertyChanges { target: artAndTitlesBlock; anchors.verticalCenterOffset: -110 }
                PropertyChanges { target: progressBarBlock; anchors.verticalCenterOffset: 90 }
                PropertyChanges { target: progressBarBlock; opacity: 1 }
                PropertyChanges { target: musicTools; opacity: 1 }
            }
        ]

        transitions: [
            Transition {
                DefaultNumberAnimation { targets: [progressBarBlock, musicTools, nextListFlickable, artAndTitlesBlock, widgetAndFullscreen]; properties: "width, height, opacity, anchors.verticalCenterOffset" }
            }
        ]
    }
}
