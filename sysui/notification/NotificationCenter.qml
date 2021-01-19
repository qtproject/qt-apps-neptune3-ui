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

import QtQuick 2.10
import QtQuick.Controls 2.0
import shared.Sizes 1.0
import shared.utils 1.0
import shared.controls 1.0
import shared.animations 1.0
import system.models.notification 1.0
import shared.Style 1.0

Item {
    id: root

    state: "closed"
    states: [
        State {
            name: "closed"
            PropertyChanges {
                target: root
                y: -allNotificationsHeight
                height: allNotificationsHeight
            }
            PropertyChanges {
                target: notificationToast
                opacity: 0.0
                visible: false
            }
            PropertyChanges {
                target: notificationCenterBG
                opacity: 0.0
            }
            PropertyChanges {
                target: notificationLabelOnBG
                opacity: 0.0
            }
            PropertyChanges {
                target: notificationListItem
                opacity: 0.0
                visible: false
            }
            PropertyChanges {
                target: clearListButton
                opacity: 0.0
            }
        },
        State {
            name: "intermediate_from_closed"
            PropertyChanges {
                target: notificationCenterBG
                opacity: 1.0
            }
            PropertyChanges {
                target: root
                y: -allNotificationsHeight
                height: allNotificationsHeight
            }
            PropertyChanges {
                target: notificationToast
                opacity: 0.0
                visible: false
            }
            PropertyChanges {
                target: notificationListItem
                opacity: 1.0
                visible: true
            }
        },
        State {
            name: "incomingNotification"
            PropertyChanges {
                target: notificationCenterBG
                opacity: 1.0
            }
            PropertyChanges {
                target: root
                height: oneIncomingNotificationHeight
                y: 0
            }
            PropertyChanges {
                target: notificationToast
                opacity: 1.0
                visible: true
            }
            PropertyChanges {
                target: notificationListItem
                opacity: 0.0
                visible: false
            }
            PropertyChanges {
                target: clearListButton
                opacity: 0.0
            }
        },
        State {
            name: "intermediate_from_all"
            extend: "allNotifications"
        },
        State {
            name: "allNotifications"
            PropertyChanges {
                target: root
                y: 0
                height: allNotificationsHeight
            }
            PropertyChanges {
                target: notificationCenterBG
                opacity: 1.0
            }
            PropertyChanges {
                target: notificationToast
                opacity: 0.0
                visible: false
            }
            PropertyChanges {
                target: notificationListItem
                opacity: 1.0
                visible: true
            }
        }
    ]

    transitions: [
        Transition {from: "*"; to: "intermediate_from_closed"}
        , Transition {from: "*"; to: "intermediate_from_all"}
        , Transition {
            PropertyAnimation {
                properties: "y, height";
                easing.type: Easing.InOutQuad;
            }
            PropertyAnimation { properties: "opacity"; duration: 400 }
        }
    ]

    readonly property int oneIncomingNotificationHeight: Sizes.dp(100) + notificationToast.height
    readonly property int allNotificationsHeight: root.totalContentHeight
                                                  + root.notificationDefaultMargin
                                                  + root.notificationBottomMargin

    readonly property int totalMaxContentHeight: parent.height
                                                 - Config.statusBarHeight
                                                 - root.notificationDefaultMargin
                                                 - root.notificationBottomMargin
    readonly property int totalContentHeight:
            notificationList.contentHeight > root.totalMaxContentHeight
            ? root.totalMaxContentHeight
            : notificationList.contentHeight
    readonly property int listviewHeight:
        Math.min((root.notificationModel.count * Sizes.dp(120)), root.totalContentHeight)

    readonly property int notificationDefaultMargin: Sizes.dp(40)
    readonly property int notificationBottomMargin: Sizes.dp(110)
    readonly property int defaultTimeout: 2000

    property NotificationModel notificationModel

    function closeNotificationCenter() {
        // reset helper properties&timer
        notificationShowTimer.stop();
        notificationShowTimer.interval = root.defaultTimeout;
        state = "closed"
    }

    Rectangle {
        id: notificationCenterBG
        anchors.fill: parent
        color: Style.offMainColor
        visible: opacity > 0.0
        Behavior on opacity { DefaultNumberAnimation { } }
    }

    Timer {
        id: notificationShowTimer
        onTriggered: {
            if (root.state == "incomingNotification")
                root.state = "closed";
        }
    }

    Connections {
        target: root.notificationModel
        function onCountChanged() {
            if (root.notificationModel.count === 0) {
                root.state = "closed";
            }
        }

        function onNotificationAdded() {
            state = "incomingNotification";
            notificationShowTimer.stop();
            var notification = root.notificationModel.model.get(root.notificationModel.count - 1);
            notificationShowTimer.interval = (notification.timeout > root.defaultTimeout)
                ? notification.timeout
                : root.defaultTimeout;

            notificationShowTimer.start();
        }

        function onNotificationClosed() {
            root.state = "closed";
        }
    }

    Item {
        id: notificationListItem
        anchors.top: parent.top
        anchors.topMargin: root.notificationDefaultMargin
        anchors.bottom: parent.bottom
        anchors.bottomMargin: root.notificationBottomMargin
        anchors.left: parent.left
        anchors.leftMargin: root.notificationDefaultMargin
        anchors.right: parent.right
        anchors.rightMargin: root.notificationDefaultMargin
        clip: true
        ListView {
            id: notificationList
            anchors.fill: parent
            interactive: (contentHeight > root.listviewHeight)
            model: root.notificationModel.model
            ScrollIndicator.vertical: ScrollIndicator { }
            onCountChanged: {
                positionViewAtEnd();
            }
            delegate: NotificationItem {
                width: notificationList.width
                notificationIcon: model.icon
                notificationText: model.summary
                notificationSubtext: model.body
                notificationImage: model.image
                notificationActionText: model.actions.length > 0 ? model.actions[0].actionText : ""
                Behavior on height { DefaultNumberAnimation { duration: 300 } }
                Behavior on opacity { DefaultNumberAnimation { duration: 200 } }
                onHeightChanged: {
                    if (height == 0)
                        root.notificationModel.removeNotification(model.id);
                }
                onCloseClicked: {
                    opacity = 0;
                    height = 0;
                }
                onButtonClicked: {
                    root.notificationModel.buttonClicked(model.id);
                    root.state = "closed";
                }
            }
        }
    }

    Label {
        id: notificationLabelOnBG
        anchors.centerIn: parent
        visible: opacity > 0.0
        opacity: (root.notificationModel.count === 0) ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation { } }
        text: qsTr("No Notifications")
    }

    NotificationToast {
        id: notificationToast
        anchors.top: parent.top
        anchors.topMargin: root.notificationDefaultMargin
        anchors.left: parent.left
        anchors.leftMargin: root.notificationDefaultMargin
        anchors.right: parent.right
        anchors.rightMargin: root.notificationDefaultMargin
        notificationModel: root.notificationModel
    }

    Button {
        id: clearListButton
        implicitWidth: Sizes.dp(140)
        implicitHeight: Sizes.dp(40)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Sizes.dp(40)
        visible: (opacity > 0.50)
        opacity: (root.notificationModel.count > 0) ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation { } }
        font.pixelSize: Sizes.fontSizeS
        text: qsTr("Clear list")
        onClicked: { root.notificationModel.clearNotifications(); }
    }
}
