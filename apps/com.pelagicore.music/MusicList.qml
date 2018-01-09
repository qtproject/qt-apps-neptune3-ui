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

    contentItem: Item {

        Component {
            id: nextHeader
            Tool {
                width: Style.hspan(3)
                height: Style.vspan(0.8)
                anchors.horizontalCenter: parent !== null ? parent.horizontalCenter : undefined
                baselineOffset: 0
                text: qsTr("Next")
                font.pixelSize: Style.fontSizeS
                symbol: root.showList ? "" : Style.symbol("ic-expand", TritonStyle.theme)
                onClicked: root.headerClicked()
            }
        }

        Component {
            id: browseHeader
            Tool {
                width: Style.hspan(3.7)
                height: Style.vspan(0.8)
                anchors.left: parent !== null ? parent.left : undefined
                anchors.leftMargin: Style.hspan(4.5)
                baselineOffset: 0
                text: qsTr("Browse")
                font.pixelSize: Style.fontSizeS
                symbol: Style.symbol("ic-expand-up", TritonStyle.theme)
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
                    source: Style.gfx2("divider", TritonStyle.theme)
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

        ListView {
            id: listView

            implicitWidth: root.showBg ? Style.hspan(15) : root.width
            implicitHeight: root.height - Style.vspan(1)

            anchors.top: parent.top
            anchors.topMargin: root.showBg ? Style.vspan(0.5) : 0
            anchors.right: parent.right
            anchors.rightMargin: root.showBg ? Style.hspan(3) : 0
            clip: true
            boundsBehavior: listView.interactive ? Flickable.DragAndOvershootBounds : Flickable.StopAtBounds

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
            ScrollIndicator.vertical: ScrollIndicator {
                id: scrollIndicator
                parent: listView.parent
                anchors.top: listView.top
                anchors.left: listView.right
                anchors.leftMargin: root.showBg ? Style.hspan(2) : 0
                anchors.bottom: listView.bottom

                background: Item {
                    Rectangle {
                        implicitWidth: Style.hspan(0.05)
                        height: parent.height
                        anchors.horizontalCenter: parent.horizontalCenter
                        radius: height
                        opacity: scrollIndicator.active ? 1.0 : 0.0
                        Behavior on opacity { DefaultNumberAnimation { } }

                        color: "#969494"
                    }
                }

                contentItem: Rectangle {
                    implicitWidth: Style.hspan(0.1)
                    radius: height
                    opacity: scrollIndicator.active ? 1.0 : 0.0
                    Behavior on opacity { DefaultNumberAnimation { } }

                    color: "#FA9E54"
                }
            }
        }
    }
}


