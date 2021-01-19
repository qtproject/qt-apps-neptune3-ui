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
import shared.utils 1.0
import QtApplicationManager.Application 2.0

Store {
    id: root

    property date currentTime: new Date()
    property Timer timer: Timer {
        running: true
        interval: 1000
        repeat: true
        onTriggered: root.currentTime = new Date()
    }

    property ListModel eventModel: ListModel {

        ListElement {
            timeStart: "07:00"
            timeEnd: "08:00"
            event: "Breakfast with family"
        }

        ListElement {
            timeStart: "08:00"
            timeEnd: "09:00"
            event: "Drive to the office"
        }

        ListElement {
            timeStart: "09:00"
            timeEnd: "10:00"
            event: "Meeting with partners"
        }

        ListElement {
            timeStart: "10:30"
            timeEnd: "11:00"
            event: "Daily meeting"
        }

        ListElement {
            timeStart: "12:00"
            timeEnd: "13:00"
            event: "Lunch time"
        }

        ListElement {
            timeStart: "12:00"
            timeEnd: "13:00"
            event: "Annual project meeting"
        }

        ListElement {
            timeStart: "17:00"
            timeEnd: "18:00"
            event: "Pick up daughter from school"
        }

        ListElement {
            timeStart: "19:00"
            timeEnd: "22:00"
            event: "Dinner with friends"
        }
    }

    readonly property IntentHandler intentHandler: IntentHandler {
        intentIds: "activate-app"
        onRequestReceived: {
            root.requestRaiseAppReceived()
            request.sendReply({ "done": true })
        }
    }
    signal requestRaiseAppReceived()
}
