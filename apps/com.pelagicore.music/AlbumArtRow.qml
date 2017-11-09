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
import animations 1.0

Item {
    id: root

    property bool showPrevNextAlbum: false
    property alias coverSlide: coverslide
    property alias songModel: coverslide.model
    property alias currentIndex: coverslide.currentIndex
    property alias currentSongTitle: titleColumn.currentSongTitle
    property alias currentArtisName: titleColumn.currentArtisName

    signal previousClicked()
    signal nextClicked()
    signal playClicked()

    Component {
        id: albumArtDelegate

        Image {
            id: itemDelegated
            height: 270
            Behavior on height {
                DefaultNumberAnimation { }
            }

            width: height
            opacity: PathView.iconOpacity !== undefined ? PathView.iconOpacity : 0.0
            source: model.albumArt
            fillMode: Image.Pad

            property double iconx: PathView.iconx !== undefined ? PathView.iconx : 0.0
            property double icony: PathView.icony !== undefined ? PathView.icony : 0.0
        }
    }

    Item {
        id: pathView

        width: root.width
        height: 270
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
            delegate: albumArtDelegate
            pathItemCount: root.showPrevNextAlbum ? 3 : 1
            interactive: false

            path: Path {
                startX: 0; startY: coverslide.height/2

                PathAttribute { name: "iconx"; value: 0 }
                PathAttribute { name: "iconOpacity"; value: 0.3 }
                PathAttribute { name: "icony"; value: 1 }

                PathLine { x: coverslide.width/2; y: coverslide.height/2 }

                PathAttribute { name: "icony"; value: 0.5 }
                PathAttribute { name: "iconx"; value: 0.5 }
                PathAttribute { name: "iconOpacity"; value: 1 }

                PathLine { x: coverslide.width; y: coverslide.height/2 }
                PathAttribute { name: "iconx"; value: 0 }
                PathAttribute { name: "icony"; value: 1 }
                PathAttribute { name: "iconOpacity"; value: 0.3 }

            }
        }

        MusicControls {
            id: controlsRow
            anchors.centerIn: parent
            spacing: 150
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
        width: 840
        height: 80
        anchors.top: pathView.bottom
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
    }

    TitleColumn {
        id: titleColumn
        anchors.left: parent.left
        anchors.leftMargin: Style.hspan(0.6)
        anchors.top: musicProgress.bottom
        anchors.topMargin: Style.vspan(0.2)

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
        id: musicTools
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Style.vspan(0.2)
        anchors.right: parent.right
        anchors.rightMargin: Style.hspan(1)
        visible: root.showPrevNextAlbum
        opacity: visible ? 1.0 : 0.0
        Behavior on opacity {
            DefaultNumberAnimation { }
        }
    }
}
