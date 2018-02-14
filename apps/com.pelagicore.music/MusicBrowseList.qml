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

import com.pelagicore.styles.triton 1.0

Control {
    id: root

    property string contentType: "track"
    property alias listView: listView
    property alias headerText: headerLabel.text
    property alias showHeader: listHeader.visible
    // Since contentType might have some unique id's when we browse a music by going
    // from one level to another level, a content type slicing is needed to get the
    // intended content type. This property helper will return the actual content type.
    readonly property string actualContentType: root.contentType.slice(-5)

    clip: true

    signal itemClicked(var index, var item, var title, var artist)
    signal libraryGoBack(var goToArtist)
    signal nextClicked()
    signal backClicked()
    signal playAllClicked()

    contentItem: Item {

        Component {
            id: delegatedItem
            ListItem {
                id: delegatedSong
                width: listView.width
                height: Style.vspan(1.3)
                imageSource: ((toolsColumn.currentText !== "favorites") && (toolsColumn.currentText.indexOf(contentType) === -1) && model.item) ?
                              model.item.data.coverArtUrl !==  "" ? model.item.data.coverArtUrl
                              : Style.gfx2("album-art-placeholder") : ""
                text: {
                    if (model.item.title && (root.actualContentType === "track")) {
                        return model.item.title;
                    } else if (model.name) {
                        return model.name;
                    } else {
                        return qsTr("Unknown Track");
                    }
                }
                subText: {
                    if (model.item.artist && (root.actualContentType === "track")) {
                        return model.item.artist;
                    } else if (model.item.data.artist && root.actualContentType === "album") {
                        return model.item.data.artist;
                    } else {
                        return "";
                    }
                }
                onClicked: { root.itemClicked(model.index, model.item, delegatedSong.text, delegatedSong.subText); }
            }
        }

        Item {
            id: listHeader

            anchors.top:parent.top
            anchors.topMargin: Style.vspan(53/80)
            anchors.left: parent.left
            opacity: visible ? 1.0 : 0.0
            width: visible ? Style.hspan(720/45) : 0
            height: visible ? Style.vspan(94/80) : 0
            //TODO check with Johan for animation here
            Behavior on height { DefaultNumberAnimation {}}

            Tool {
                id: backButton
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                symbol: Style.symbol("ic_back")
                onClicked: root.backClicked()
            }
            Label {
                id: headerLabel
                font.pixelSize: Style.fontSizeS
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
            }
            Tool {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                background: Rectangle {
                    radius: height/2
                    color: TritonStyle.contrastColor
                    opacity: 0.06
                }
                text: qsTr("Play All")
                font.pixelSize: Style.fontSizeS
                onClicked: { root.playAllClicked(); }
            }

            Rectangle {
                width: parent.width
                height: 1
                anchors.bottom: parent.bottom
                color: "grey"   //todo: change to #contrast 60%
            }
        }

        ListView {
            id: listView
            anchors.top:parent.top
            anchors.topMargin: Style.vspan(53/80) + listHeader.height
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            width: Style.hspan(720/45)
            interactive: contentHeight > height
            delegate: delegatedItem
            clip: true
        }

        MusicScrollBar {
            attachTo: listView
        }
    }
}


