/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Copyright (C) 2018 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune IVI UI.
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
import QtApplicationManager.Application 2.0
import shared.utils 1.0
import shared.com.pelagicore.systeminfo 1.0

Store {
    id: root

    property bool ongoingCall: false
    property string callerHandle: ""
    property alias callDuration: callTimer.duration
    readonly property SystemInfo systemInfo: SystemInfo {}
    readonly property bool allowOpenGLContent: systemInfo.allowOpenGLContent

//! [parking intent handler]
    readonly property IntentHandler intentHandler: IntentHandler {
        intentIds: ["call-support", "activate-app"]
        onRequestReceived: {
            switch (request.intentId) {
            case "call-support":
                root.startCall("neptunesupport");
                request.sendReply({ "done": true });
                break;
            case "activate-app":
                root.requestRaiseAppReceived()
                request.sendReply({ "done": true })
                break;
            }
        }
    }
//! [parking intent handler]

    signal requestRaiseAppReceived()

    function findPerson(handle) {
        for (var i = 0; i < contactsModel.count; i++) {
            var item = contactsModel.get(i);
            if (item.handle === handle) {
                return item;
            }
        }
    }

    function startCall(handle) {
        if (root.ongoingCall) { // end the current one first
            endCall(callerHandle);
        }

        callerHandle = handle;
        root.ongoingCall = true;
    }

    function endCall(handle) {
        // insert an entry into the CallsModel
        callsModel.insert(0, {"peerHandle": handle, "type": "outgoing", "duration": callTimer.duration});

        root.ongoingCall = false;
        callerHandle = "";
    }

    Timer {
        id: callTimer
        interval: 1000
        repeat: true
        running: root.ongoingCall
        property int duration: 0
        onTriggered: {
            duration += 1;
        }
        onRunningChanged: {
            if (!running) {
                duration = 0; // reset when hidden
            }
        }
    }

    property ListModel callsModel: ListModel {
        id: callsModel
    //    template
    //    ListElement { peerHandle: ""; type: ""; duration: 0 }
        ListElement { peerHandle: "aharvester"; type: "missed"; duration: 0 }
        ListElement { peerHandle: "jsmith"; type: "incoming"; duration: 140 }
        ListElement { peerHandle: "hcarter"; type: "incoming"; duration: 35 }
        ListElement { peerHandle: "dalleson"; type: "outgoing"; duration: 345 }
        ListElement { peerHandle: "cmcgilbert"; type: "incoming"; duration: 20 }
        ListElement { peerHandle: "jbrown"; type: "missed"; duration: 0 }
        ListElement { peerHandle: "ejackson"; type: "outgoing"; duration: 605 }
    }


    property ListModel contactsModel: ListModel {
        id: contactsModel
    // template
    //    ListElement { handle: ""; firstName: ""; surname: ""; favorite: false; phoneNumbers: [
    //            ListElement { name: ""; number: "" }
    //        ]
    //    }

        ListElement { handle: "aharvester"; firstName: "Adam"; surname: "Harvester"; favorite: true; phoneNumbers: [
                ListElement { name: "mobile"; number: "(251) 546-9442" }
            ]
        }
        ListElement { handle: "jsmith"; firstName: "Jody"; surname: "Smith"; favorite: true; phoneNumbers: [
                ListElement { name: "mobile"; number: "(972) 848-4399" }
            ]
        }
        ListElement { handle: "hcarter"; firstName: "Howard"; surname: "Carter"; favorite: false; phoneNumbers: [
                ListElement { name: "home"; number: "(833) 568-4381" }
            ]
        }
        ListElement { handle: "dalleson"; firstName: "David"; surname: "Alleson"; favorite: true; phoneNumbers: [
                ListElement { name: "company"; number: "(438) 648-9964" }
            ]
        }
        ListElement { handle: "cmcgilbert"; firstName: "Christine"; surname: "McGilbert"; favorite: true; phoneNumbers: [
                ListElement { name: "home"; number: "(326) 800-8911" }
            ]
        }
        ListElement { handle: "jbrown"; firstName: "Jacob"; surname: "Brown"; favorite: false; phoneNumbers: [
                ListElement { name: "mobile"; number: "(141) 801-7764" }
            ]
        }
        ListElement { handle: "ejackson"; firstName: "Edward"; surname: "Jackson"; favorite: true; phoneNumbers: [
                ListElement { name: "mobile"; number: "(221) 780-7704" }
            ]
        }
        ListElement { handle: "bhummels"; firstName: "Berndt"; surname: "Hummels"; favorite: false; phoneNumbers: [
                ListElement { name: "company"; number: "(669) 189-3693" }
            ]
        }
        ListElement { handle: "neptunesupport"; firstName: "Neptune"; surname: "Support"; favorite: false; phoneNumbers: [
                ListElement { name: "company"; number: "(0809) 898989" }
            ]
        }
    }

    property ListModel favoritesModel: ListModel { // faking a "filtered" model ;)
        Component.onCompleted: {
            for (var i = 0; i < contactsModel.count; i++) {
                var person = contactsModel.get(i);
                if (person.favorite) {
                    this.append(person);
                }
            }
        }
    }
}
