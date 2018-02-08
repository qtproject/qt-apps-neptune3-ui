/****************************************************************************
**
** Copyright (C) 2017-2018 Pelagicore AG
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
import com.pelagicore.styles.triton 1.0

Item {
    id: root

    property bool ongoingCall

    signal activateApp()

    function startCall(handle) {
        if (root.ongoingCall) { // end the current one first
            endCall(callWidget.callerHandle);
        }

        callWidget.callerHandle = handle;
        root.ongoingCall = true;
    }

    function endCall(handle) {
        // insert an entry into the CallsModel
        CallsModel.insert(0, {"peerHandle": handle, "type": "outgoing", "duration": callWidget.duration});

        root.ongoingCall = false;
        callWidget.callerHandle = "";
    }

    ListModel {
        id: favoritesModel // faking a "filtered" model ;)

        Component.onCompleted: {
            for (var i = 0; i < ContactsModel.count; i++) {
                var person = ContactsModel.get(i);
                if (person.favorite) {
                    favoritesModel.append(person);
                }
            }
        }
    }

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


    FavoritesWidget {
        id: favoritesWidget
        anchors.horizontalCenter: parent.horizontalCenter
        width: Style.hspan(960/45)
        anchors.top: parent.top
        state: root.state

        exposedRectHeight: root.height
        ongoingCall: root.ongoingCall
        model: favoritesModel
        onCallRequested: startCall(handle)

        opacity: !ongoingCall ? 1.0 : 0.0
        visible: opacity > 0
        Behavior on opacity { DefaultNumberAnimation {} }
    }

    CallWidget {
        id: callWidget
        anchors.fill: root.state === "Widget1Row" ? parent : undefined
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.rightMargin: Style.hspan(0.9)
        state: root.state
        ongoingCall: root.ongoingCall

        onCallEndRequested: endCall(handle)
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

        width: Style.hspan(1080/45)
        anchors.left: parent.left
        // ############### Johan's comment:
        // I think it looks better if it does not move horizontally. That's why I added -80 and the Behaviour on...
        // It keeps the width of lists etc.
        // Would prefer to get this value passed down to every app, like we did it with exposedRect.
        // ###############
        anchors.leftMargin: root.state === "Maximized" ? 0 : -80
        Behavior on anchors.leftMargin { DefaultSmoothedAnimation {} }
        anchors.top: parent.top
        anchors.topMargin: 660 - 224
        anchors.bottom: parent.bottom


        opacity: root.state === "Maximized" ? 1.0 : 0.0
        visible: opacity > 0
        Behavior on opacity { DefaultNumberAnimation {} }

        // ############### Johan's comment:
        // In the future I would like to see the toolBar code in AppUIScreen.qml
        // and just assigning a model to each app
        // ###############
        Item {
            id: toolsColumn
            property alias currentText: toolsColumnComponent.currentText
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: Style.hspan(264/45)

            ToolsColumn {
                id: toolsColumnComponent
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: Style.vspan(53/80)

                translationContext: "PhoneToolsColumn"
                model: ListModel {
                    ListElement { icon: "ic-recents"; text: QT_TRANSLATE_NOOP("PhoneToolsColumn", "recents") }
                    ListElement { icon: "ic-favorites"; text: QT_TRANSLATE_NOOP("PhoneToolsColumn", "favorites") }
                    ListElement { icon: "ic-voicemail"; text: QT_TRANSLATE_NOOP("PhoneToolsColumn", "voicemail") }
                    ListElement { icon: "ic-keypad"; text: QT_TRANSLATE_NOOP("PhoneToolsColumn", "keypad") }
                    ListElement { icon: "ic-contacts"; text: QT_TRANSLATE_NOOP("PhoneToolsColumn", "contacts") }
                    ListElement { icon: "ic-messages"; text: QT_TRANSLATE_NOOP("PhoneToolsColumn", "messages") }
                }
            }
        }

        // ############### Johan's comment:
        // In the future I would like the "main content of bottom part of fullscreen app"
        // to be loaded by a loader in AppUIScreen.qml.
        // ###############
        Loader {
            id: viewLoader
            anchors.left: toolsColumn.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: Style.vspan(53/80)
            anchors.bottom: parent.bottom

            width: Style.hspan(720/45)

            Binding {
                target: viewLoader.item; property: "model";
                value: ContactsModel; when: toolsColumn.currentText === "contacts"
            }

            Binding {
                target: viewLoader.item; property: "model";
                value: favoritesModel; when: toolsColumn.currentText === "favorites"
            }

            Connections {
                target: viewLoader.item
                onCallRequested: startCall(handle)
                ignoreUnknownSignals: true
            }

            source: {
                switch (toolsColumn.currentText) {
                    case "recents":
                        return "RecentCallsView.qml";
                    case "favorites":
                    case "contacts":
                        return "ContactsView.qml";
                    case "keypad":
                        return "KeypadView.qml";
                    default: return "";
                }
            }
        }
    }
}
