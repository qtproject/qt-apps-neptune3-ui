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

import "../stores" 1.0
import "../views" 1.0

import shared.Sizes 1.0

Item {
    id: root

    property bool ongoingCall
    signal activateApp()
    property PhoneStore store
    property string callerHandle: root.store.callerHandle

    states: [
        State {
            name: "Widget1Row"
            AnchorChanges { target: callWidget; anchors.top: undefined; anchors.verticalCenter: parent.verticalCenter}
            PropertyChanges { target: callWidget; height: parent.height }
        },
        State {
            name: "Widget2Rows"
            extend: "Widget1Row"
        },
        State {
            name: "Widget3Rows"
            extend: "Widget1Row"
        },
        State {
            name: "Maximized"
            extend: "Widget3Rows"
            AnchorChanges { target: callWidget; anchors.top: parent.top }
        }
    ]


    FavoritesWidgetView {
        id: favoritesWidget
        objectName: "phonefavoritesView"
        width: Sizes.dp(960)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        state: root.state
        exposedRectHeight: root.height
        store: root.store

        opacity: !root.store.ongoingCall ? 1.0 : 0.0
        visible: opacity > 0
        Behavior on opacity { DefaultNumberAnimation {} }
    }

    CallWidgetView {
        id: callWidget
        objectName: "phoneCallView"
        width: Sizes.dp(960)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        state: root.state
        store: root.store
        ongoingCall: root.store.ongoingCall
        onCallEndRequested: root.store.endCall(handle)
        onKeypadRequested: {
            toolsColumn.currentIndex = 3; // keypad
            root.activateApp();
        }

        opacity: ongoingCall ? 1.0 : 0.0
        visible: opacity > 0
        Behavior on opacity { DefaultNumberAnimation {} }
    }

    Item {
        id: fullscreenBottom

        width: Sizes.dp(1080)
        anchors.left: parent.left
        anchors.leftMargin: root.state === "Maximized" ? 0 : Sizes.dp(-80)
        Behavior on anchors.leftMargin { DefaultSmoothedAnimation {} }
        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(660)
        anchors.bottom: parent.bottom


        opacity: root.state === "Maximized" ? 1.0 : 0.0
        visible: opacity > 0
        Behavior on opacity { DefaultNumberAnimation {} }

        Item {
            id: toolsColumn
            property alias currentText: toolsColumnComponent.currentText
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: Sizes.dp(264)

            ToolsColumn {
                id: toolsColumnComponent
                objectName: "phoneViewChangeButtons"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: Sizes.dp(53)

                translationContext: "PhoneToolsColumn"
                model: ListModel {
                    ListElement { icon: "ic-recents"; text: QT_TRANSLATE_NOOP("PhoneToolsColumn", "recents"); objectName: "viewPhoneButton_recents"; greyedOut: false }
                    ListElement { icon: "ic-favorites"; text: QT_TRANSLATE_NOOP("PhoneToolsColumn", "favorites"); objectName: "viewPhoneButton_favorites"; greyedOut: false }
                    ListElement { icon: "ic-keypad"; text: QT_TRANSLATE_NOOP("PhoneToolsColumn", "keypad"); objectName: "viewPhoneButton_keypad"; greyedOut: false }
                    ListElement { icon: "ic-contacts"; text: QT_TRANSLATE_NOOP("PhoneToolsColumn", "contacts"); objectName: "viewPhoneButton_contacts"; greyedOut: false }
                }
                onCurrentTextChanged: {
                    switch (currentText) {
                    case "recents":
                        stackView.replace(Qt.resolvedUrl("RecentCallsView.qml"), {"store" : root.store, "objectName" : "recents_phoneView"});
                        break;
                    case "favorites":
                        stackView.replace(Qt.resolvedUrl("ContactsView.qml"), {"store" : root.store, "model": root.store.favoritesModel, "objectName" : "favorites_phoneView"});
                        break;
                    case "contacts":
                        stackView.replace(Qt.resolvedUrl("ContactsView.qml"), {"store" : root.store, "model" : root.store.contactsModel, "objectName" : "contacts_phoneView"});
                        break;
                    case "keypad":
                        stackView.replace(Qt.resolvedUrl("../panels/KeypadViewPanel.qml"), {"objectName" : "keypad_phoneView"});
                        break;
                    default:
                        stackView.replace(Qt.resolvedUrl("RecentCallsView.qml"), {"store" : root.store, "objectName" : "recents_phoneView"});
                        break;
                    }
                }
            }

        }

        StackView {
            id: stackView
            objectName: "phoneMainStackView"
            anchors.left: toolsColumn.right
            anchors.top: parent.top
            anchors.topMargin: Sizes.dp(53)
            anchors.bottom: parent.bottom
            width: Sizes.dp(720)
            pushEnter: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to:1
                    duration: 100
                }
            }
            pushExit: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to:0
                    duration: 100
                }
            }
            popEnter: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to:1
                    duration: 100
                }
            }
            popExit: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to:0
                    duration: 100
                }
            }
            replaceEnter: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to:1
                    duration: 100
                }
            }
            replaceExit: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to:0
                    duration: 100
                }
            }
        }
    }
}
