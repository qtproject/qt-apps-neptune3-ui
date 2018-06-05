/****************************************************************************
**
** Copyright (C) 2017-2018 Pelagicore AB
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
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import utils 1.0
import animations 1.0
import controls 1.0
import com.pelagicore.styles.neptune 3.0

import "../controls"

Item {
    id: root
    property var store
    property real exposedRectHeight: 0

    states: [
        State {
            name: "Widget1Row"
            PropertyChanges { target: root; height: NeptuneStyle.dp(260) }
        },
        State {
            name: "Widget2Rows"
            PropertyChanges { target: root; height: NeptuneStyle.dp(550) }
            PropertyChanges { target: favorites1Row; opacity: 0 }
            PropertyChanges { target: favoritesMoreRows; opacity: 1 }
        },
        State {
            name: "Widget3Rows"
            extend: "Widget2Rows"
            PropertyChanges { target: root; height: NeptuneStyle.dp(840) }
        },
        State {
            name: "Maximized"
            PropertyChanges { target: root; height: NeptuneStyle.dp(436) }
        }

    ]

    transitions: [
        Transition {
            from: "Widget1Row, Maximized"
            to: "Widget2Rows, Widget3Rows"
            DefaultNumberAnimation { target: root; property: "height" }
            DefaultNumberAnimation { target: favorites1Row; property: "opacity" }
            SequentialAnimation {
                PauseAnimation { duration: 200 }
                DefaultNumberAnimation { target: favoritesMoreRows; property: "opacity" }
            }
        },
        Transition {
            from: "Widget2Rows, Widget3Rows"
            to: "Widget1Row, Maximized"
            DefaultNumberAnimation { target: root; property: "height" }
            DefaultNumberAnimation { target: favoritesMoreRows; property: "opacity" }
            SequentialAnimation {
                PauseAnimation { duration: 200 }
                DefaultNumberAnimation { target: favorites1Row; property: "opacity" }
            }
        },
        Transition {
            DefaultNumberAnimation { target: root; property: "height" }
            DefaultNumberAnimation { target: favorites1Row; property: "opacity" }
            DefaultNumberAnimation { target: favoritesMoreRows; property: "opacity" }
        }
    ]

    // 1 ROW
    ListView {
        id: favorites1Row
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            leftMargin: NeptuneStyle.dp(50)
            rightMargin: NeptuneStyle.dp(50)
        }

        height: Math.min(NeptuneStyle.dp(436), root.exposedRectHeight)

        opacity: 1.0
        visible: opacity > 0

        orientation: ListView.Horizontal
        interactive: false
        clip: true
        spacing: NeptuneStyle.dp(50)
        model: root.store.favoritesModel
        delegate: RoundImage {
            width: NeptuneStyle.dp(130)
            height: width
            anchors.verticalCenter: parent.verticalCenter
            source: "../assets/profile_photos/%1.png".arg(model.handle)
            onClicked: root.store.startCall(model.handle)
        }
    }

    // MORE ROWS
    Column {
        id: favoritesMoreRows
        opacity: 0.0
        visible: opacity > 0

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            leftMargin: NeptuneStyle.dp(40)
            rightMargin: NeptuneStyle.dp(40)
            topMargin: NeptuneStyle.dp(48)
        }

        height: root.exposedRectHeight - anchors.topMargin - NeptuneStyle.dp(25)

        ListView {
            id: listviewMoreRows

            readonly property real delegateHeight: currentItem ? currentItem.height : 0
            readonly property bool allItemsFit: contentHeight <= favoritesMoreRows.height

            interactive: false
            height: allItemsFit ? favoritesMoreRows.height : Math.floor(favoritesMoreRows.height / delegateHeight)*delegateHeight - delegateHeight
            width: parent.width
            clip: true
            model: root.store.favoritesModel

            delegate: ItemDelegate { // FIXME replace with ListItem when it supports components (for RoundImage and 2 tools on the right)
                id: itemDelegate
                padding: 0
                width: ListView.view.width
                height: NeptuneStyle.dp(70)
                contentItem: Item {
                    RowLayout {
                        anchors.fill: parent
                        spacing: 0
                        RoundImage {
                            Layout.preferredHeight: NeptuneStyle.dp(64)
                            Layout.preferredWidth: NeptuneStyle.dp(64)
                            Layout.alignment: Qt.AlignVCenter
                            source: "../assets/profile_photos/%1.png".arg(model.handle)
                        }
                        Label {
                            Layout.leftMargin: NeptuneStyle.dp(22)
                            Layout.fillWidth: true
                            text: model.firstName + " " + model.surname
                            color: enabled ? NeptuneStyle.contrastColor : NeptuneStyle.disabledTextColor
                        }
                        ToolButton {
                            Layout.preferredWidth: NeptuneStyle.dp(100)
                            Layout.alignment: Qt.AlignVCenter
                            height: parent.height
                            icon.name: "ic-message-contrast"
                        }
                        ToolButton {
                            Layout.preferredWidth: NeptuneStyle.dp(100)
                            Layout.alignment: Qt.AlignVCenter
                            height: parent.height
                            icon.name: "ic-call-contrast"
                            onClicked: root.store.startCall(model.handle)
                        }
                    }
                    Image {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        source: Style.gfx("list-divider", NeptuneStyle.theme)
                        visible: index !== listviewMoreRows.count - 1
                    }
                }
            }
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: listviewMoreRows.allItemsFit ? 0.0 : 1.0
            Behavior on opacity { DefaultNumberAnimation {} }
            visible: opacity > 0
            text: qsTr("more", "more contacts")
            font.pixelSize: NeptuneStyle.fontSizeS
            //TODO make it a button that takes the user to fullscreen with the favorites page.
        }
    }
}
