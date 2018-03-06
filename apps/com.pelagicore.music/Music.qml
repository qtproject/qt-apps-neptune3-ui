/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
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
import utils 1.0
import controls 1.0
import animations 1.0
import QtQuick.Controls 1.4 as QQC
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import "stores"

import com.pelagicore.styles.neptune 3.0

Item {
    id: root

    property MusicStore store
    property bool topExpanded: false //expanded => playing queue visible
    signal flickableAreaClicked()
    property alias fullscreenTopHeight: fullscreenTop.height

    state: "Widget1Row"

    onStateChanged: {
        if (root.topExpanded) { root.topExpanded = false; }
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

        ToolButton {
            id: showPlayingQueueButton
            width: contentItem.childrenRect.width + Style.hspan(1)
            height: Style.hspan(0.5)
            anchors.verticalCenter: parent.top
            anchors.verticalCenterOffset: Style.vspan(370/80)
            anchors.horizontalCenter: parent.horizontalCenter

            enabled: ! root.topExpanded
            onClicked: { root.topExpanded = true; }

            contentItem: Row {
                spacing: Style.hspan(10/45)
                Label {
                    font.pixelSize: Style.fontSizeS
                    font.capitalization: Font.AllUppercase
                    text: qsTr("Next")
                    anchors.verticalCenter: parent.verticalCenter
                }
                Image {
                    opacity: root.topExpanded ? 0.0 : 1.0
                    Behavior on opacity { DefaultNumberAnimation {} }
                    source: root.topExpanded ? "" : Style.symbol("ic-expand", NeptuneStyle.theme)
                    anchors.verticalCenter: parent.verticalCenter
                }
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
            listView.model: root.store.musicPlaylist
            onItemClicked: {
                root.store.musicPlaylist.currentIndex = index;
                root.store.player.play();
            }
        }

        ToolButton {
            id: showNormalBrowseViewButton
            width: contentItem.childrenRect.width + Style.hspan(1)
            height: Style.hspan(0.5)
            anchors.verticalCenter: parent.bottom
            anchors.verticalCenterOffset: Style.vspan(44/80)
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: root.topExpanded ? 1.0 : 0.0
            Behavior on opacity {
                SequentialAnimation {
                    PauseAnimation { duration: root.topExpanded ? 0 : 100 }
                    DefaultNumberAnimation {}
                }
            }
            visible: opacity > 0

            onClicked: { root.topExpanded = false; }

            contentItem: Row {
                spacing: Style.hspan(10/45)
                Label {
                    font.pixelSize: 22 //todo: change to Style.fontSizeS when the value is corrected in style plugin
                    font.capitalization: Font.AllUppercase
                    text: qsTr("Browse")
                    anchors.verticalCenter: parent.verticalCenter
                }
                Image {
                    source: Style.symbol("ic-expand-up", NeptuneStyle.theme)
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    Item {
        id: fullscreenBottom

        property string artistsContentState: ""
        property string albumsContentState: ""
        property string headerTextInArtists: ""
        property string headerTextInAlbums: ""
        //if the content type is longer than 6 then it contains a unique id
        readonly property bool contentTypeContainsArtistUniqueID: (artistsContentState.length > 6)
        //if the content type is longer than 5 then it contains a unique id
        readonly property bool contentTypeContainsAlbumUniqueID: (albumsContentState.length > 5)

        width: Style.hspan(1080/45)
        anchors.left: parent.left
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
                if (currentText === "artists") {
                    fullscreenBottom.headerTextInAlbums = musicLibrary.headerText;
                    //store text in albums view
                    musicLibrary.headerText = fullscreenBottom.headerTextInArtists;
                    //store content type in albums view
                    fullscreenBottom.albumsContentState = root.store.searchAndBrowseModel.contentType;
                } else if (currentText === "albums") {
                    //TODO sort albums list alphabetically
                    //store text in artists view
                    fullscreenBottom.headerTextInArtists = musicLibrary.headerText;
                    musicLibrary.headerText = fullscreenBottom.headerTextInAlbums;
                    //store content type in artists view
                    fullscreenBottom.artistsContentState = root.store.searchAndBrowseModel.contentType;
                }
            }
        }

        Binding {
            target: root.store; property: "contentType";
            value: {
                switch (toolsColumn.currentText) {
                case "artists":
                    if (fullscreenBottom.contentTypeContainsArtistUniqueID) {
                        return fullscreenBottom.artistsContentState;
                    } else {
                        return "artist";
                    }
                case "albums":
                    if (fullscreenBottom.contentTypeContainsAlbumUniqueID) {
                        return fullscreenBottom.albumsContentState;
                    } else {
                        return "album";
                    }
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

        MusicBrowseList {
            id: musicLibrary
            anchors.left: toolsColumn.right
            anchors.right: parent.right
            anchors.top: parent.top
            height: parent.height
            listView.model: root.store.searchAndBrowseModel
            contentType: root.store.contentType
            //helper property for the header text
            property string artistName: ""
            onPlayAllClicked: {
                //instert all tracks of current album or artist into play queue
                for (var i = (store.searchAndBrowseModel.count-1); i >= 0; i--) {
                    root.store.musicPlaylist.insert(root.store.musicCount, store.searchAndBrowseModel.get(i));
                    root.store.player.play();
                }
            }

            onBackClicked: {
                root.store.searchAndBrowseModel.goBack();
                if ((toolsColumn.currentText === "artists") && (actualContentType === "album")) {
                    headerText = artistName;
                } else if (toolsColumn.currentText.indexOf(contentType) !== -1) {
                    headerText = "";
                    artistName = "";
                }
            }

            onItemClicked: {
                if (root.store.searchAndBrowseModel.canGoForward(index) && musicLibrary.contentType.slice(-6) === "artist") {
                    //set header text props
                    artistName = title;
                    headerText = title;
                    root.store.searchAndBrowseModel.goForward(index, root.store.searchAndBrowseModel.InModelNavigation);
                } else if (root.store.searchAndBrowseModel.canGoForward(index) && musicLibrary.contentType.slice(-5) === "album") {
                    var albumArtist = artist !== "" ? artist : qsTr("Unknown Artist");
                    headerText = qsTr("%1 (%2)").arg(title).arg(albumArtist);
                    root.store.searchAndBrowseModel.goForward(index, root.store.searchAndBrowseModel.InModelNavigation);
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
        onStateChanged: {
            //reset scroll view
            nextListFlickable.flickableItem.contentY = 0;
        }
        QQC.ScrollView {
            id: nextListFlickable
            anchors.fill: parent
            opacity: 0
            visible: opacity > 0
            clip: true
            property real contentY: 0.0

            flickableItem.onContentYChanged: {
                contentY = flickableItem.contentY;
            }

            Column {
                id: nextListContent

                Item { //spacer
                    width: nextListFlickable.width
                    height: 430
                }

                MusicList { //playing queue
                    id: nextList
                    width: nextListFlickable.width
                    height: (listView.count * Style.vspan(1.3))
                    listView.model: root.store.musicPlaylist
                    listView.interactive: false
                    onItemClicked: {
                        root.store.musicPlaylist.currentIndex = index;
                        root.store.player.play();
                    }
                }

                Item { //spacer
                    width: nextListFlickable.width
                    height: 20
                }
            }
        }

        Rectangle {
            id: artAndTitleBackground
            height: 260
            width: parent.width
            color: NeptuneStyle.offMainColor
            MouseArea {
                //prevent clicking on list items when the list
                //is scrolled under the header component
                //should go to maximized state instead
                anchors.fill: parent
                enabled: (nextListFlickable.contentY > 0)
                onClicked: {
                    root.flickableAreaClicked();
                }
            }
        }

        Image {
            id: nextListShadow
            opacity: 0
            width: parent.width
            height: sourceSize.height
            anchors.top: artAndTitleBackground.bottom
            source: Style.gfx2("panel-inner-shadow", NeptuneStyle.theme)
        }

        AlbumArtRow {
            id: artAndTitlesBlock
            height: 180
            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 0
            songModel: root.store.musicPlaylist
            currentIndex: root.store.musicPlaylist.currentIndex
            currentSongTitle: root.store.currentEntry ? root.store.currentEntry.title : ""
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
                onIndexerProgressChanged: { artAndTitlesBlock.mediaIndexerProgress = root.store.indexerProgress; }
            }
        }

        MusicProgress {
            id: progressBarBlock
            height: 220

            anchors.left: parent.left
            anchors.leftMargin: 40
            anchors.right: parent.right
            anchors.rightMargin: 40
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 200

            opacity: 0
            visible: opacity > 0
            value: root.store.currentTrackPosition
            progressText: root.store.elapsedTime + " / " + root.store.totalTime
            onUpdatePosition: root.store.updatePosition(value)
        }

        MusicTools {
            id: musicTools
            anchors.top: progressBarBlock.bottom
            anchors.topMargin: -progressBarBlock.height/2
            anchors.right: parent.right
            anchors.rightMargin: Style.hspan(28/45)
            onShuffleClicked: root.store.shuffleSong()
            onRepeatClicked: root.store.repeatSong()
        }

        states: [
            State {
                name: "Widget1Row"
            },
            State {
                name: "Widget2Rows"
                PropertyChanges { target: widgetAndFullscreen; height: 550 }
                PropertyChanges { target: artAndTitlesBlock; anchors.verticalCenterOffset: - 62 }
                PropertyChanges { target: progressBarBlock; anchors.verticalCenterOffset: 138 }
                PropertyChanges { target: progressBarBlock; opacity: 1 }
                PropertyChanges { target: musicTools; opacity: 1 }
            },
            State {
                name: "Widget3Rows"
                PropertyChanges { target: widgetAndFullscreen; height: 840 }
                PropertyChanges { target: nextListFlickable; opacity: 1 }
                PropertyChanges { target: artAndTitlesBlock; anchors.verticalCenterOffset: - 271 - Math.min(20, nextListFlickable.contentY / 6) }
                PropertyChanges { target: progressBarBlock; anchors.verticalCenterOffset: -71 - Math.min(60, nextListFlickable.contentY / 2) }
                PropertyChanges { target: progressBarBlock; opacity: 1 - Math.max(0, Math.min(1, nextListFlickable.contentY / 140)) }
                PropertyChanges { target: musicTools; opacity: 1 - Math.max(0, Math.min(1, nextListFlickable.contentY / 140))}
                PropertyChanges { target: nextListShadow; opacity: 0 + Math.max(0, Math.min(1, nextListFlickable.contentY / 140))}
            },
            State {
                name: "Maximized"
                PropertyChanges { target: widgetAndFullscreen; height: 660 - 224 }
                PropertyChanges { target: artAndTitleBackground; opacity: 0 }   //todo: do something else here because it is blocking the gray background.
                PropertyChanges { target: artAndTitlesBlock; anchors.verticalCenterOffset: -110 }
                PropertyChanges { target: progressBarBlock; anchors.verticalCenterOffset: 90 }
                PropertyChanges { target: progressBarBlock; opacity: 1 }
                PropertyChanges { target: musicTools; opacity: 1 }
                PropertyChanges { target: musicTools; anchors.rightMargin: Style.hspan(100/45) }
                PropertyChanges { target: progressBarBlock; anchors.leftMargin: 100 }
                PropertyChanges { target: progressBarBlock; anchors.rightMargin: 100 }
            }
        ]

        transitions: [
            Transition {
                from: "Maximized"
                DefaultNumberAnimation { targets: [progressBarBlock, musicTools, nextListFlickable, artAndTitlesBlock, widgetAndFullscreen]; properties: "width, height, opacity, anchors.verticalCenterOffset" }
                SequentialAnimation {
                    PauseAnimation { duration: 200 }
                    DefaultNumberAnimation { target: artAndTitleBackground ; property: "opacity" }
                }
            },
            Transition {
                DefaultNumberAnimation { targets: [progressBarBlock, musicTools, nextListFlickable, artAndTitlesBlock, widgetAndFullscreen]; properties: "width, height, opacity, anchors.verticalCenterOffset" }
            }
        ]
    }
}
