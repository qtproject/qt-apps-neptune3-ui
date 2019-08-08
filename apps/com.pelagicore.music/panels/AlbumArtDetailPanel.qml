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

import QtQuick 2.11
import QtGraphicalEffects 1.12
import QtQuick.Controls 2.2
import shared.utils 1.0
import shared.animations 1.0
import shared.Style 1.0
import shared.Sizes 1.0
import shared.effects 1.0

import "../controls" 1.0

Item {
    id: root

    property bool musicPlaying: false
    property real musicPosition: 0.0
    property bool mediaReady: false
    property alias coverSlide: coverSlide
    property alias elapsedTimeLabel: elapsedTimeLabel
    property alias coverSize: coverSlide.coverSize
    property alias playToolButton: playToolButton
    property alias titleColumn: titleColumn
    property alias currentIndex: coverSlide.currentIndex
    property int defaultWidthCoverSlide: 275
    property int defaultWidthDelegatedAlbum: 290
    property int defaultLeftMargin: 400
    property string currentAlbumArt
    property string elapsedTime

    signal previousClicked()
    signal nextClicked()
    signal playClicked()

    Component {
        id: albumArtDelegate

        Item {
            id: itemDelegated

            property int delegatedSize: {
                if (root.state === "Widget1Row") {
                    return 185;
                } else {
                    return root.defaultWidthDelegatedAlbum;
                }
            }
            Behavior on delegatedSize { DefaultNumberAnimation {} }

            property alias albumArtSource: albumArt.source
            property bool isCurrentItem: PathView.iconCurrentItem === 1
            property bool isOnPath: PathView.onPath
            property real albumOpacity: PathView.iconOpacity

            height: Sizes.dp(itemDelegated.delegatedSize)
            width: height
            z: PathView.iconZ
            layer.enabled: true
            visible: itemDelegated.isOnPath
            scale: PathView.iconScale !== undefined ? PathView.iconScale : 1.0

            Image {
                id: mask
                source: Style.image("album-art-mask")
                width: Sizes.dp(itemDelegated.delegatedSize)
                height: Sizes.dp(itemDelegated.delegatedSize)
                smooth: true
                visible: false
            }

            Image {
                id: albumArtUndefined
                visible: false
                anchors.centerIn: parent
                width: Sizes.dp(itemDelegated.delegatedSize)
                height: width
                source: Style.image("album-art-placeholder")
                fillMode: Image.PreserveAspectCrop
            }

            GaussianBlur {
                id: undefinedBlur
                anchors.fill: albumArtUndefined
                source: albumArtUndefined
                radius: 8
                samples: 16
                visible: false
            }

            OpacityMask {
                id: albumArtUndefinedMask
                anchors.fill: undefinedBlur
                source: itemDelegated.isCurrentItem ? albumArtUndefined : undefinedBlur
                maskSource: mask
                smooth: true
                visible: opacity > 0
                opacity: (mediaReady && model.item.coverArtUrl) ? itemDelegated.albumOpacity : 0.0
                Behavior on opacity {DefaultNumberAnimation {}}
            }

            Image {
                id: albumArt
                anchors.centerIn: parent
                sourceSize: Qt.size(Sizes.dp(itemDelegated.delegatedSize), Sizes.dp(itemDelegated.delegatedSize))
                source: model.item && model.item.coverArtUrl !== undefined ? model.item.coverArtUrl : ""
                visible: false
                smooth: true
                fillMode: Image.PreserveAspectCrop
            }

            GaussianBlur {
                id: albumArtBlur
                anchors.fill: albumArt
                source: albumArt
                radius: 8
                samples: 16
                visible: false
            }

            OpacityMask {
                id: opacityMask
                anchors.fill: albumArtBlur
                source: itemDelegated.isCurrentItem ? albumArt : albumArtBlur
                maskSource: mask
                smooth: true
                visible: opacity > 0
                opacity: (mediaReady && model.item.coverArtUrl) ? itemDelegated.albumOpacity : 0.0
                Behavior on opacity { DefaultNumberAnimation {} }
            }

            RadialBar {
                anchors.centerIn: albumArt
                width: root.state === "Widget1Row" ? Sizes.dp(itemDelegated.delegatedSize - itemDelegated.delegatedSize * 0.05)
                                                   : Sizes.dp(itemDelegated.delegatedSize - itemDelegated.delegatedSize * 0.09)
                height: width
                colorCircle: Style.accentColor
                showBackground: true
                opacity: itemDelegated.isCurrentItem ? itemDelegated.albumOpacity : 0.0
                Behavior on opacity { DefaultNumberAnimation {} }
                arcBegin: 0
                arcEnd: root.musicPosition * 360
            }
        }
    }

    PathView {
        id: coverSlide

        property int coverSize: {
            if (root.state === "Widget1Row") {
                return 200;
            } else {
                return root.defaultWidthCoverSlide;
            }
        }

        width: Sizes.dp(coverSize)
        height: parent.height

        anchors.left: root.left
        anchors.leftMargin: Sizes.dp(root.defaultLeftMargin)
        anchors.verticalCenter: parent.verticalCenter
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        snapMode: PathView.SnapOneItem
        highlightRangeMode: PathView.StrictlyEnforceRange
        highlightMoveDuration: 200
        model: root.state !== "Widget1Row" ? 5 : 1
        pathItemCount: root.state !== "Widget1Row" ? 5 : 1
        cacheItemCount:10
        delegate: albumArtDelegate
        //interactive: true

        onCurrentIndexChanged: {
            if (currentItem) {
                root.currentAlbumArt = currentItem.albumArtSource;
            } else {
                root.currentAlbumArt = "";
            }
        }

        path: Path {
            startX: -coverSlide.width-4; startY: coverSlide.height/2
            PathAttribute { name: "iconOpacity"; value: 0.2 }
            PathAttribute { name: "iconScale"; value: 0.7 }
            PathAttribute { name: "iconZ"; value: 0 }
            PathAttribute { name: "iconCurrentItem"; value: 0 }
            PathLine { x: -coverSlide.width/4-2; y: coverSlide.height/2 }
            PathAttribute { name: "iconOpacity"; value: 0.7 }
            PathAttribute { name: "iconScale"; value: 0.8 }
            PathAttribute { name: "iconZ"; value: 1 }
            PathAttribute { name: "iconCurrentItem"; value: 0 }
            PathLine { x: coverSlide.width/2; y: coverSlide.height/2 }
            PathAttribute { name: "iconOpacity"; value: 1.0 }
            PathAttribute { name: "iconScale"; value: 1.0 }
            PathAttribute { name: "iconZ"; value: 2 }
            PathAttribute { name: "iconCurrentItem"; value: 1 }
            PathLine { x: coverSlide.width*5/4+2; y: coverSlide.height/2 }
            PathAttribute { name: "iconOpacity"; value: 0.7 }
            PathAttribute { name: "iconScale"; value: 0.8 }
            PathAttribute { name: "iconZ"; value: 1 }
            PathAttribute { name: "iconCurrentItem"; value: 0 }
            PathLine { x: coverSlide.width*2+4; y: coverSlide.height/2 }
            PathAttribute { name: "iconOpacity"; value: 0.2 }
            PathAttribute { name: "iconScale"; value: 0.7 }
            PathAttribute { name: "iconZ"; value: 0 }
            PathAttribute { name: "iconCurrentItem"; value: 0 }
        }
    }

    Item {
        id: searchingMedia
        width: Sizes.dp(180)
        height: width
        opacity: root.mediaReady ? 0.0 : 1.0
        Behavior on opacity { DefaultNumberAnimation {} }
        visible: opacity > 0
        anchors.centerIn: coverSlide

        BusyIndicator {
            anchors.centerIn: parent
            visible: parent.visible
            running: visible
            width: Sizes.dp(60)
            height: Sizes.dp(60)
        }
    }

    TitleColumn {
        id: titleColumn
        anchors.centerIn: coverSlide
        anchors.horizontalCenterOffset: Sizes.dp(150)
        preferredWidth: Sizes.dp(480)
        opacity: root.state === "Widget1Row" ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation {} }
    }

    TitleColumn {
        id: horizontalTitleColumn
        anchors.centerIn: coverSlide
        anchors.verticalCenterOffset: root.state !== "Maximized" ? Sizes.dp(225) : Sizes.dp(300)
        preferredWidth: Sizes.dp(480)
        alignHorizontal: true
        currentSongTitle: titleColumn.currentSongTitle
        currentArtisName: titleColumn.currentArtisName
        currentAlbumName: titleColumn.currentAlbumName
        opacity: root.state !== "Widget1Row" ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation {} }
    }

    Label {
        id: elapsedTimeLabel
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: Sizes.dp(300)
        text: root.elapsedTime
        font.pixelSize: Sizes.dp(26)
        font.weight: Font.Normal
    }

    ToolButton {
        width: Sizes.dp(100)
        height: width
        visible: root.state !== "Widget1Row"
        anchors.left: parent.left
        anchors.leftMargin: root.state !== "Maximized" ? Sizes.dp(5) : Sizes.dp(250)
        anchors.verticalCenter: coverSlide.verticalCenter
        icon.name: LayoutMirroring.enabled ? "ic_skipnext" : "ic_skipprevious"
        onClicked: root.previousClicked()
    }

    ToolButton {
        id: playToolButton
        width: Sizes.dp(100)
        height: width

        anchors.centerIn: coverSlide

        icon.name: root.musicPlaying ? "ic-pause" : "ic_play"
        icon.color: "white"
        onClicked: root.playClicked();

        background: Image {
            id: playButtonBackground
            anchors.centerIn: parent
            width: Sizes.dp(sourceSize.width)
            height: Sizes.dp(sourceSize.height)
            source: Style.image("ic_button-bg")
            fillMode: Image.PreserveAspectFit

            ScalableColorOverlay {
                anchors.fill: parent
                source: playButtonBackground
                color: Style.accentColor
            }
        }
    }

    ToolButton {
        width: Sizes.dp(100)
        height: width
        visible: root.state !== "Widget1Row"
        anchors.right: parent.right
        anchors.rightMargin: root.state !== "Maximized" ? Sizes.dp(5) : Sizes.dp(250)
        anchors.verticalCenter: coverSlide.verticalCenter
        icon.name: LayoutMirroring.enabled ? "ic_skipprevious" : "ic_skipnext"
        onClicked: root.nextClicked()
    }

    states: [
        State {
            name: "Widget1Row"
            PropertyChanges { target: coverSlide;
                anchors.leftMargin: Sizes.dp(70);
                anchors.verticalCenterOffset: 0 }
                PropertyChanges { target: elapsedTimeLabel; anchors.horizontalCenterOffset: Sizes.dp(300);
                    anchors.verticalCenterOffset: 0 }
                PropertyChanges { target: playToolButton; anchors.horizontalCenterOffset: Sizes.dp(760) }
        },
        State {
            name: "Widget2Rows"
            PropertyChanges { target: coverSlide;
                anchors.leftMargin: Sizes.dp(370);
                anchors.verticalCenterOffset: -Sizes.dp(75) }
                PropertyChanges { target: elapsedTimeLabel;
                    anchors.horizontalCenterOffset: Sizes.dp(170);
                    anchors.verticalCenterOffset: Sizes.dp(50) }
                PropertyChanges { target: playToolButton;
                    anchors.horizontalCenterOffset: 0 }
        },
        State {
            name: "Widget3Rows"
            PropertyChanges { target: coverSlide;
                anchors.leftMargin: Sizes.dp(370);
                anchors.verticalCenterOffset: -Sizes.dp(180) }
                PropertyChanges { target: elapsedTimeLabel;
                    anchors.horizontalCenterOffset: Sizes.dp(170);
                    anchors.verticalCenterOffset: -Sizes.dp(50) }
                PropertyChanges { target: playToolButton;
                    anchors.horizontalCenterOffset: 0 }
        },
        State {
            name: "Maximized"
            PropertyChanges { target: elapsedTimeLabel;
                anchors.horizontalCenterOffset: Sizes.dp(200);
                anchors.verticalCenterOffset: Sizes.dp(190) }
        }
    ]


    transitions: [
        Transition {
            from: "Maximized"
            DefaultNumberAnimation { targets: horizontalTitleColumn; properties: "opacity"; from: 0.0; to: 1.0; }
        },
        Transition {
            DefaultNumberAnimation { targets: [coverSlide,
                    playToolButton,
                    elapsedTimeLabel];
                properties: "anchors.leftMargin, anchors.verticalCenterOffset, anchors.horizontalCenterOffset" }
        }
    ]
}
