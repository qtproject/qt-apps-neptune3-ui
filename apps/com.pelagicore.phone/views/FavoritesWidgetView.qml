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

import QtQuick 2.8
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import shared.utils 1.0
import shared.animations 1.0
import shared.controls 1.0
import shared.Style 1.0
import shared.Sizes 1.0

import "../controls" 1.0

Item {
    id: root
    property var store
    property real exposedRectHeight: 0

    states: [
        State {
            name: "Widget1Row"
            PropertyChanges { target: root; height: Sizes.dp(260) }
            PropertyChanges { target: favorites1Row; opacity: 1 }
            PropertyChanges { target: favoritesMoreRows; opacity: 0 }
        },
        State {
            name: "Widget2Rows"
            PropertyChanges { target: root; height: Sizes.dp(550) }
            PropertyChanges { target: favorites1Row; opacity: 0 }
            PropertyChanges { target: favoritesMoreRows; opacity: 1 }
        },
        State {
            name: "Widget3Rows"
            extend: "Widget2Rows"
            PropertyChanges { target: root; height: Sizes.dp(840) }
        },
        State {
            name: "Maximized"
            PropertyChanges { target: root; height: Sizes.dp(660) } // - Config.statusBarHeight
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
        }

        height: Math.min(Sizes.dp(660), root.exposedRectHeight) //436
        width: Sizes.dp(890)

        opacity: 1.0
        visible: opacity > 0
        orientation: ListView.Horizontal
        displayMarginEnd: 100
        displayMarginBeginning: 100
        snapMode: ListView.SnapOneItem
        model: root.store.favoritesModel
        highlightRangeMode: ListView.StrictlyEnforceRange
        delegate: WidgetContact {
            width: Sizes.dp(890)
            height: parent.height
            source: "../assets/profile_photos/%1.png".arg(model.handle)
            lastItem: (index === (favorites1Row.model.count - 1))
            maximized: (root.state === "Maximized")
            onCallWidgetClicked: { root.store.startCall(handle); }
            enableOpacityMasks: store.allowOpenGLContent
        }
        PageIndicator {
            anchors.verticalCenter: parent.bottom
            anchors.verticalCenterOffset: root.state === "Maximized" ? Sizes.dp(-80) : Sizes.dp(-38)
            Behavior on anchors.verticalCenterOffset { DefaultNumberAnimation{} }
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: Sizes.dp(20)
            spacing: Sizes.dp(8)
            count: favorites1Row.count
            delegate: Rectangle {
                width: Sizes.dp(10)
                height: width
                radius: width/2
                color: Style.contrastColor
                opacity: (index === favorites1Row.currentIndex) ? 0.6 : 0.1
            }
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
            leftMargin: Sizes.dp(40)
            rightMargin: Sizes.dp(40)
            topMargin: Sizes.dp(48)
        }

        height: root.exposedRectHeight - anchors.topMargin - Sizes.dp(25)

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
                objectName: "favoritesShortCall_" + index
                padding: 0
                width: ListView.view.width
                height: Sizes.dp(96)
                contentItem: Item {
                    anchors.fill: parent
                    RowLayout {
                        anchors.fill: parent
                        spacing: 0
                        RoundImage {
                            Layout.preferredHeight: Sizes.dp(64)
                            Layout.preferredWidth: Sizes.dp(64)
                            Layout.alignment: Qt.AlignVCenter
                            source: "../assets/profile_photos/%1.png".arg(model.handle)
                            enableOpacityMasks: store.allowOpenGLContent
                        }
                        Label {
                            objectName: "shortCallName"
                            Layout.leftMargin: Sizes.dp(22)
                            Layout.fillWidth: true
                            text: model.firstName + " " + model.surname
                            color: Style.contrastColor
                        }
                        ToolButton {
                            Layout.preferredWidth: Sizes.dp(100)
                            Layout.alignment: Qt.AlignVCenter
                            height: parent.height
                            icon.name: "ic-message-contrast"
                            opacity: 0.6
                        }
                        ToolButton {
                            objectName: "shortCallButton"
                            Layout.preferredWidth: Sizes.dp(100)
                            Layout.alignment: Qt.AlignVCenter
                            height: parent.height
                            icon.name: "ic-call-contrast"
                            onClicked: root.store.startCall(model.handle)
                            opacity: 0.6
                        }
                    }
                    Image {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        source: Style.image("list-divider")
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
            font.pixelSize: Sizes.fontSizeS
            //TODO make it a button that takes the user to fullscreen with the favorites page.
        }
    }
}
