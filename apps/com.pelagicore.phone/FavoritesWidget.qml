/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AB
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
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import utils 1.0
import animations 1.0
import controls 1.0
import "models"

Item {
    id: root
    property bool ongoingCall
    property var model

    signal callRequested(string handle)

    Label {
        id: favoritesLabel
        anchors.left: parent.left
        anchors.top: parent.top
        text: qsTr("Favorites")
        color: "#999999" // FIXME color?
        font.pixelSize: Style.fontSizeXXS
    }

    // 1 ROW
    RowLayout {
        id: favorites1Row
        opacity: root.state === "Widget1Row" || root.state === "Maximized" ? 1.0 : 0.0
        visible: opacity > 0
        Behavior on opacity { DefaultNumberAnimation { } }

        anchors {
            left: parent.left
            right: parent.right
            top: favoritesLabel.bottom
            bottom: parent.bottom
            leftMargin: Style.hspan(.5)
        }

        spacing: Style.hspan(1)
        ListView {
            id: listview1Row
            orientation: ListView.Horizontal
            snapMode: ListView.SnapToItem
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.maximumHeight: 150 // FIXME check the specs when available
            clip: true
            spacing: Style.hspan(1)
            model: root.model
            delegate: RoundImage {
                height: ListView.view.height
                width: height
                source: "assets/profile_photos/%1.jpg".arg(model.handle)
                onClicked: root.callRequested(model.handle)
            }
        }
        Rectangle { // FIXME bug! it's correctly sized and placed only if you go maximized and back
            id: moreBtn
            Layout.fillHeight: true
            width: height
            radius: height/2
            visible: listview1Row.visibleArea.widthRatio < 1.0
            color: "gray" // FIXME not in TritonStyle
            Label {
                anchors.centerIn: parent
                text: qsTr("more", "more contacts")
                font.pixelSize: Style.fontSizeXS
            }
        }
    }

    // MORE ROWS
    ColumnLayout {
        id: favoritesMoreRows
        opacity: root.state === "Widget2Rows" || root.state === "Widget3Rows" ? 1.0 : 0.0
        visible: opacity > 0
        Behavior on opacity { DefaultNumberAnimation { } }

        anchors {
            left: parent.left
            right: parent.right
            top: favoritesLabel.bottom
            bottom: parent.bottom
            topMargin: Style.vspan(.5)
            leftMargin: Style.hspan(.5)
        }

        ListView {
            id: listviewMoreRows
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: root.model
            delegate: ItemDelegate { // FIXME right component?
                width: ListView.view.width
                contentItem: Column {
                    spacing: Style.vspan(.2)
                    RowLayout {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        spacing: Style.hspan(.5)
                        RoundImage {
                            height: parent.height
                            width: height
                            source: "assets/profile_photos/%1.jpg".arg(model.handle)
                        }
                        Label {
                            text: model.firstName + " " + model.surname
                            font.pixelSize: Style.fontSizeXS
                        }
                        Item { // spacer
                            Layout.fillWidth: true
                        }
                        Tool {
                            symbol: Style.symbol("ic-message-contrast")
                        }
                        Tool {
                            symbol: Style.symbol("ic-call-contrast")
                            onClicked: root.callRequested(model.handle)
                        }
                    }
                    Rectangle { // separator
                        width: parent.width
                        height: 1
                        color: "lightgray" // FIXME correct color
                    }
                }
            }
        }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            visible: listviewMoreRows.visibleArea.heightRatio < 1.0
            text: qsTr("more", "more contacts")
            font.pixelSize: Style.fontSizeXS
        }
    }
}
