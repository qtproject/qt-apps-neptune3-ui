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
import QtQuick.Controls 2.1
import utils 1.0
import service.notification 1.0
import service.popup 1.0

Item {
    id: root

    NotificationInterface {
        id: notificationHighPrio
        summary: "Notification Prio 2"
        body: "Notification sample"
        priority: 2
        icon: Style.symbolM("loop")
    }

    NotificationInterface {
        id: notificationHighPrio2
        summary: "Notification Prio 3"
        body: "Notification sample"
        priority: 3
        icon: Style.symbolM("mail")
    }

    NotificationInterface {
        id: notificationLowPrio
        summary: "Notification Prio 9"
        body: "Notification sample"
        priority: 9
        icon: Style.symbolM("maps")
    }

    NotificationInterface {
        id: notificationLowPrio2
        summary: "Notification Prio 10"
        body: "Notification sample"
        priority: 10
        icon: Style.symbolM("my_cloud")
    }

    PopupInterface {
        id: popupInterfaceHighPrio
        actions: [ { text: "Cancel" } ]
        title: "Popup Prio 2"
        summary: "Popup Sample"
        priority: 2
    }

    PopupInterface {
        id: popupInterfaceHighPrio2
        actions: [ { text: "Cancel" } ]
        title: "Popup Prio 3"
        subtitle: "The Subtitle"
        summary: "Popup Sample"
        priority: 3
    }

    PopupInterface {
        id: popupInterfaceLowPrio
        actions: [ { text: "Cancel" } ]
        title: "Popup Prio 9"
        summary: "Popup Sample"
        priority: 9
    }

    PopupInterface {
        id: popupInterfaceLowPrio2
        actions: [ { text: "Cancel" } ]
        title: "Popup Prio 10"
        summary: "Popup Sample"
        priority: 10
    }

    Text {
        anchors.top: parent.top
        anchors.topMargin: 50
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Template Application"
        color: "white"
    }

    Column {
        anchors.top: parent.top
        anchors.topMargin: 150
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 2

        Row {
            spacing: 2

            Button {
                id: buttonControl
                text: "Notification 2"
                width: root.width/2 - parent.spacing

                onClicked: notificationHighPrio.show();
            }

            Button {
                id: buttonControl2
                text: "Notification 3"
                width: root.width/2 - parent.spacing

                onClicked: notificationHighPrio2.show();
            }

            Button {
                id: buttonControl3
                text: "Notification 9"
                width: root.width/2 - parent.spacing

                onClicked: notificationLowPrio.show();
            }

            Button {
                id: buttonControl4
                text: "Notification 10"
                width: root.width/2 - parent.spacing

                onClicked: notificationLowPrio2.show();
            }
        }

        Row {
            spacing: 2

            Button {
                id: buttonControl5
                text: "Popup 2"
                width: root.width/2 - parent.spacing

                onClicked: popupInterfaceHighPrio.show();
            }

            Button {
                id: buttonControl6
                text: "Popup 3"
                width: root.width/2 - parent.spacing

                onClicked: popupInterfaceHighPrio2.show();
            }

            Button {
                id: buttonControl7
                text: "Popup 9"
                width: root.width/2 - parent.spacing

                onClicked: popupInterfaceLowPrio.show();
            }

            Button {
                id: buttonControl8
                text: "Popup 10"
                width: root.width/2 - parent.spacing

                onClicked: popupInterfaceLowPrio2.show();
            }
        }
    }
}
