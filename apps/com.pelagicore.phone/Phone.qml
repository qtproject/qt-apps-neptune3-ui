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

    Rectangle {
        anchors.left: parent.left
        anchors.top: root.ongoingCall ? callWidget.bottom : favoritesWidget.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        // FIXME Use named colors from TritonStyle
        color: TritonStyle.theme === TritonStyle.Light ? "#ece7e4" : TritonStyle.backgroundColor
        visible: root.state == "Maximized"
    }

    FavoritesWidget {
        id: favoritesWidget
        anchors.fill: root.state !== "Maximized" ? parent : undefined
        anchors.top: root.state == "Maximized" ? parent.top : undefined
        anchors.left: root.state == "Maximized" ? parent.left : undefined
        anchors.right: root.state == "Maximized" ? parent.right : undefined
        anchors.leftMargin: Style.hspan(1)
        anchors.rightMargin: Style.hspan(1)
        anchors.topMargin: root.state !== "Maximized" ? Style.vspan(.5) : 0
        anchors.bottomMargin: Style.vspan(.5)
        height: root.state == "Maximized" ? Style.vspan(7) : implicitHeight
        state: root.state
        ongoingCall: root.ongoingCall
        model: favoritesModel
        onCallRequested: startCall(handle)

        opacity: !ongoingCall ? 1.0 : 0.0
        visible: opacity > 0
        Behavior on opacity { DefaultNumberAnimation { } }
    }

    CallWidget {
        id: callWidget
        anchors.fill: root.state !== "Maximized" ? parent : undefined
        anchors.top: root.state == "Maximized" ? parent.top : undefined
        anchors.horizontalCenter: root.state == "Maximized" ? parent.horizontalCenter : undefined
        anchors.rightMargin: Style.hspan(0.9)
        height: root.state == "Maximized" ? Style.vspan(7) : implicitHeight

        state: root.state
        ongoingCall: root.ongoingCall

        onCallEndRequested: endCall(handle)
        onKeypadRequested: {
            toolsColumn.currentTool = "keypad";
            root.activateApp();
        }

        opacity: ongoingCall ? 1.0 : 0.0
        visible: opacity > 0
        Behavior on opacity { DefaultNumberAnimation {} }
    }

    Item {
        id: app

        anchors.left: parent.left
        anchors.leftMargin: Style.hspan(1)
        anchors.top: root.ongoingCall ? callWidget.bottom : favoritesWidget.bottom
        anchors.topMargin: Style.vspan(1)
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Style.vspan(1)

        opacity: root.state === "Maximized" ? 1.0 : 0.0
        visible: opacity > 0
        Behavior on opacity { DefaultNumberAnimation { } }

        ToolsColumn {
            id: toolsColumn
            anchors.left: parent.left
            anchors.top: parent.top
        }

        Loader {
            id: viewLoader
            anchors.left: toolsColumn.right
            anchors.leftMargin: Style.hspan(1)
            anchors.right: parent.right
            anchors.rightMargin: Style.hspan(1)
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            Binding {
                target: viewLoader.item; property: "model";
                value: ContactsModel; when: toolsColumn.currentTool == "contacts"
            }

            Binding {
                target: viewLoader.item; property: "model";
                value: favoritesModel; when: toolsColumn.currentTool == "favorites"
            }

            Connections {
                target: viewLoader.item
                onCallRequested: startCall(handle)
                ignoreUnknownSignals: true
            }

            source: {
                switch (toolsColumn.currentTool) {
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
