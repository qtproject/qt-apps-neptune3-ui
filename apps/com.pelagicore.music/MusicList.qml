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

Control {
    id: root

    property bool showPath: true
    property bool showBg: false
    property bool showList: false
    property string contentType: "track"
    property string albumPath: ""
    property string artistPath: ""
    property alias listView: listView

    // Since contentType might have some unique id's when we browse a music by going
    // from one level to another level, a content type slicing is needed to get the
    // intended content type. This property helper will return the actual content type.
    readonly property string actualContentType: root.contentType.slice(-5)

    clip: true

    signal itemClicked(var index, var item, var title)
    signal libraryGoBack(var goToArtist)
    signal headerClicked()

    background: Image {
        id: bgDummy
        anchors.fill: parent
        source: Style.gfx2("bg-home")
        visible: root.showBg
    }

    contentItem: ListView {
        id: listView

        width: root.showBg ? Style.hspan(15) : root.width
        height: root.height

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: root.showBg ? Style.hspan(6) : 0
        clip: true
        boundsBehavior: listView.interactive ? Flickable.DragAndOvershootBounds : Flickable.StopAtBounds

        Component {
            id: nextHeader
            Tool {
                width: Style.hspan(2.5)
                height: Style.vspan(0.8)
                anchors.left: parent !== null ? parent.left : undefined
                anchors.leftMargin: Style.hspan(8)
                baselineOffset: 0
                text: qsTr("Next")
                font.pixelSize: Style.fontSizeS
                symbol: root.showList ? "" : Style.symbol("ic-expand")
                onClicked: root.headerClicked()
            }
        }

        Component {
            id: browseHeader
            Tool {
                width: Style.hspan(3)
                height: Style.vspan(0.8)
                anchors.left: parent !== null ? parent.left : undefined
                anchors.leftMargin: Style.hspan(4.5)
                baselineOffset: 0
                text: qsTr("Browse")
                font.pixelSize: Style.fontSizeS
                symbol: Style.symbol("ic-expand")
                onClicked: root.headerClicked()
            }
        }

        Component {
            id: mediaPath
            Item {
                width: listView.width
                implicitHeight: Style.vspan(1.5)
                anchors.left: parent !== null ? parent.left : undefined
                anchors.leftMargin: Style.hspan(1)

                RowLayout {
                    anchors.verticalCenter: parent.verticalCenter
                    Tool {
                        id: category
                        implicitHeight: Style.vspan(1.5)
                        anchors.top: parent.top
                        text: {
                            if (root.contentType.substring(0, 5) === "album") {
                                return qsTr("Album");
                            } else if (root.contentType.substring(0, 6) === "artist") {
                                return qsTr("Artist");
                            } else {
                                return ""
                            }
                        }
                        contentItem: Label {
                            text: category.text
                            font.underline: true
                            font.pixelSize: Style.fontSizeS
                            horizontalAlignment: Text.AlignLeft
                        }
                        visible: text !== ""
                        onClicked: {
                            if (category.text === qsTr("Artist")) {
                                root.libraryGoBack(true)
                            } else {
                                root.libraryGoBack(false)
                            }
                        }
                    }

                    Label {
                        text: category.text !== "" ? "/" : ""
                        font.pixelSize: Style.fontSizeS
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignLeft
                        visible: text !== ""
                    }

                    Tool {
                        id: artistPathLabel
                        implicitHeight: Style.vspan(1.5)
                        anchors.top: parent.top
                        text: root.artistPath
                        contentItem: Label {
                            text: artistPathLabel.text
                            font.underline: true
                            font.pixelSize: Style.fontSizeS
                            horizontalAlignment: Text.AlignLeft
                        }
                        visible: text !== ""
                        onClicked: root.libraryGoBack(false)
                    }

                    Label {
                        text: artistPathLabel.text !== "" ? "/ " : ""
                        font.pixelSize: Style.fontSizeS
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignLeft
                        visible: text !== ""
                    }

                    Label {
                        text: root.albumPath
                        font.pixelSize: Style.fontSizeS
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignLeft
                        visible: text !== ""
                    }
                }

                Image {
                    width: Style.hspan(17)
                    height: 5
                    anchors.bottom: parent.bottom
                    source: Style.gfx2("divider")
                }
            }
        }

        Component {
            id: delegatedItem
            SongListItem {
                id: delegatedSong
                width: Style.hspan(17)
                height: Style.vspan(1)
                visible: root.showList
                opacity: visible ? 1.0 : 0.0
                Behavior on opacity { DefaultNumberAnimation { } }

                highlighted: false
                titleLabel: model.item.title && (root.actualContentType === "track" || root.showPath) ? model.item.title :
                            (model.name ? model.name : "")
                subtitleLabel: model.item.artist && (root.actualContentType === "track" || root.showPath) ? model.item.artist :
                               (model.item.data.artist && root.actualContentType === "album" ? model.item.data.artist : "")
                onClicked: root.itemClicked(model.index, model.item, delegatedSong.titleLabel)
            }
        }

        header: {
            if (root.showBg && root.showList) {
                return mediaPath;
            } else if (root.showBg && !root.showList) {
                return browseHeader;
            } else {
                return nextHeader;
            }
        }

        delegate: delegatedItem
    }
}


