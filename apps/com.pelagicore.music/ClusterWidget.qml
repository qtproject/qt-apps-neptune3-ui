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

import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import utils 1.0
import controls 1.0
import "models"
import "."

Item {
    width: Style.clusterWidth * 0.677
    height: parent.height
    anchors.horizontalCenter: parent.horizontalCenter

    ListView {
        id: playListView
        width: parent.width * 0.3
        height: parent.height
        anchors.centerIn: parent
        clip: true
        model: MusicModel.nowPlaying
        currentIndex: MusicModel.currentIndex
        highlight: Rectangle {
            color: Style.colorWhite; opacity: 0.25
            border.color: Qt.lighter(color, 1.2)
        }
        highlightMoveDuration: 75
        preferredHighlightBegin: parent.height / 2
        preferredHighlightEnd: parent.height / 2
        highlightRangeMode: ListView.StrictlyEnforceRange
        // TODO: Extract the delegate as own component
        delegate: Control {
            width: Style.hspan(4)
            height: Style.vspan(2)
            RowLayout {
                anchors.fill: parent
                spacing: 0
                Item {
                    Layout.fillHeight: true
                    width: Style.hspan(1)
                    Item {
                        anchors.fill: parent
                        anchors.margins: Style.padding
                        Rectangle {
                            anchors.fill: parent
                            anchors.leftMargin: -6
                            anchors.rightMargin: -6
                            anchors.topMargin: -2
                            anchors.bottomMargin: -2
                            color: Style.colorWhite
                        }

                        Image {
                            anchors.centerIn: parent
                            height: parent.height
                            width: parent.height
                            source: model.item.coverArtUrl
                            fillMode: Image.PreserveAspectCrop
                            asynchronous: true
                        }
                    }
                }
                ColumnLayout {
                    spacing: 0
                    Label {
                        text: model.item.title
                        font.pixelSize: Style.fontSizeXS
                        opacity: 0.5
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                    Label {
                        text: model.item.artist
                        font.pixelSize: Style.fontSizeS
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    MusicModel.currentIndex = index
                }
            }
        }
    }
}

