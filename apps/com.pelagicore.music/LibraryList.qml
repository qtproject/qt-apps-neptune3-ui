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

import QtQuick 2.6
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import QtIvi 1.0

import controls 1.0
import utils 1.0
import "models"
import "."

Control {
    id: root
    width: Style.hspan(10)
    height: Style.vspan(18)

    property string type: ""
    property bool nowPlaying: false
    property SearchAndBrowseModel model: SearchAndBrowseModel {
        contentType: ""
        onContentTypeChanged: console.log(Logging.apps, "CONTENT TYPE CHANGE: ", contentType)
        serviceObject: MusicModel.player.serviceObject
    }

    onTypeChanged: {
        if (type === "songs")
            model.contentType = "track"
        else if (type === "artists")
            model.contentType = "artist"
        else if (type === "albums")
            model.contentType = "album"
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    ListView {
        id: listView
        anchors.fill: parent
        model: root.nowPlaying ? MusicModel.nowPlaying : root.model
        clip: true
        highlightMoveDuration: 300
        highlightFollowsCurrentItem: false
        snapMode: ListView.SnapOneItem
        currentIndex: nowPlaying ? MusicModel.currentIndex : -1

        header: UIElement {
            width: root.width
            height: Style.vspan(root.model.canGoBack ? 3 : 0)
            visible: root.model.canGoBack

            Rectangle {
                width: parent.width
                height: 1
                opacity: 0.2
                color: "white"
            }

            Tool {
                anchors.fill: parent
                symbol: 'back'
                onClicked: root.model.goBack()
            }
        }

        delegate: Control {
            width: root.width
            height: Style.vspan(3)

            Rectangle {
                anchors.fill: parent
                opacity: 0.2
                visible: listView.currentIndex === index
            }

            Rectangle {
                width: parent.width
                height: 1
                opacity: 0.2
                color: "white"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (root.nowPlaying) {
                        MusicModel.currentIndex = index
                        MusicModel.player.play()
                    } else {
                        if (item.type === "audiotrack") {
                            MusicModel.nowPlaying.insert(MusicModel.nowPlaying.count, model.item)
                            MusicModel.player.play()
                        } else {
                            root.model.goForward(model.index, SearchAndBrowseModel.InModelNavigation)
                        }
                    }
                }
            }

            Row {
                anchors.verticalCenter: parent.verticalCenter
                padding: Style.padding
                spacing: 0
                Icon {
                    width: height
                    height: Style.vspan(3)
                    fit: true
                    source: model.item.coverArtUrl ? model.item.coverArtUrl : model.item.data.coverArtUrl
                }

                Column {
                    spacing: 0
                    padding: Style.padding
                    Label {
                        width: Style.hspan(7)
                        height: Style.vspan(2)
                        text: model.name.toUpperCase()
                        font.pixelSize: Style.fontSizeM
                    }

                    Label {
                        width: Style.hspan(7)
                        height: Style.vspan(1)
                        text: model.type === "audiotrack" ? model.item.artist.toUpperCase() : (model.type === "album" ? model.item.data.artist.toUpperCase() : "")
                        font.pixelSize: Style.fontSizeS
                        font.bold: true
                    }
                }

                Tool {
                    width: Style.hspan(1)
                    height: Style.vspan(3)
                    size: Style.symbolSizeS
                    symbol: "close"
                    visible: root.nowPlaying
                    onClicked: MusicModel.nowPlaying.remove(index)
                }
            }
        }
    }
}
