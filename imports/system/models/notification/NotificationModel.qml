/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AG
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
import QtApplicationManager 1.0

QtObject {
    id: root

    property ListModel model: ListModel { }
    readonly property int count: root.model.count
    property QtObject currentNotification: QtObject {
        property int id: -1
        property string title: ""
        property string description: ""
        property int priority: 15
        property string icon: ""
        property string image: ""
    }

    property bool notificationCenterVisible: false
    property bool notificationToastVisible: false
    property var notificationQueue:[]
    property var buttonModel: []

    property var loggingCategory: LoggingCategory {
        id: logCategory
        name: "neptune.notificationmodel"
    }

    property Timer notificationTimer: Timer {
        interval: 2000
        onTriggered: {
            root.closeNotification();
            root.showNotificationOnQueue();
        }
    }

    property Connections notificationManagerConnection: Connections {
        target: NotificationManager

        onNotificationAdded: {
            var receivedContent = NotificationManager.notification(id);

            if (receivedContent.category === "notification") {
                console.log(logCategory, "::: Notification received :::", id);

                if (!root.notificationToastVisible && root.notificationQueue.length === 0) {
                    root.addNotification(id);
                }
                else {
                    if (root.currentNotification.priority < receivedContent.priority || root.currentNotification.priority === receivedContent.priority) {
                        root.notificationQueue.push(id);
                    } else {
                        root.closeNotification();
                        root.addNotification(id);
                    }
                }
            }
        }

        onNotificationChanged: {
            var receivedContent = NotificationManager.notification(id);

            if (receivedContent.category === "notification") {
                console.log(logCategory, "::: Notification changed :::", id);
                var notificationExisted = false;

                for (var x = 0; x < root.model.count; ++x) {
                    if (id === root.model.get(x).id) {
                        notificationExisted = true;
                    }
                }

                if (notificationExisted) {
                    if (!root.notificationToastVisible && root.notificationQueue.length === 0) {
                        updateNotification(id);
                    } else {
                        if (receivedContent.priority < 5 && root.currentNotification.priority < receivedContent.priority) {
                            root.notificationQueue.unshift(id);
                        } else if (root.currentNotification.priority < receivedContent.priority || root.currentNotification.priority === receivedContent.priority) {
                            root.notificationQueue.push(id);
                        } else {
                            root.updateNotification(id);
                        }
                    }
                }
            }
        }

        onNotificationAboutToBeRemoved: {
            var receivedContent = NotificationManager.notification(id);

            if (receivedContent.category === "notification") {
                root.closeNotification();
            }
        }
    }

    function addNotification(id) {
        var contentToShow = NotificationManager.notification(id);
        //don't save if timeout larger than 2000
        //TODO implementation to be refactored
        if (contentToShow.timeout <= 2000) {
            root.model.append(parseNotification(contentToShow))
        } else {
            parseNotification(contentToShow);
        }
        root.showNotification();
    }

    function updateNotification(id) {
        var contentToUpdate = NotificationManager.notification(id);
        for (var x = 0; x < root.model.count; ++x) {
            if (id === root.model.get(x).id) {
                root.model.set(x, parseNotification(contentToUpdate))
            }
        }
        root.showNotification();
    }

    function parseNotification(contentToShow) {
        root.currentNotification.title = contentToShow.summary;
        root.currentNotification.description = contentToShow.body;
        root.currentNotification.priority = contentToShow.priority;
        root.currentNotification.icon = contentToShow.icon;
        if (contentToShow.actions.length > 0) {
        // TODO improve actions assignment to support more than 1,
        // for now there is only one specified
            root.currentNotification.image = contentToShow.actions[0].actionText;
        }
        if (contentToShow.timeout !== 2000) {
            root.notificationTimer.interval = contentToShow.timeout;
        }
        root.currentNotification.id = contentToShow.id;
        return root.currentNotification;
    }

    function showNotification() {
        root.notificationToastVisible = true;
        root.notificationTimer.restart();
    }

    function showNotificationOnQueue() {
        if (root.notificationQueue.length > 0) {
            for (var x = 0; x < root.model.count; ++x) {
                if (root.notificationQueue[0] === root.model.get(x).id) {
                    var contentOnQueue = NotificationManager.notification(root.notificationQueue[0]);
                    root.model.set(x, parseNotification(contentOnQueue))
                    root.notificationQueue.splice(0,1);
                    root.showNotification();
                    return
                }
            }

            root.addNotification(root.notificationQueue[0]);
            root.notificationQueue.splice(0,1);
        }
    }

    function closeNotification() {
        root.notificationToastVisible = false;
        root.currentNotification.title = ""
        root.currentNotification.description = ""
        root.currentNotification.priority = 15
        root.currentNotification.icon = ""
        root.currentNotification.image = ""
        root.currentNotification.id = -1
        root.notificationTimer.interval = 2000;
    }

    function buttonClicked() {
        NotificationManager.triggerNotificationAction(root.currentNotification.id, "");
        root.closeNotification();
    }

    function removeNotification(id) {
        NotificationManager.dismissNotification(id);
        for (var j = 0; j < root.model.count; j++) {
            if (root.model.get(j).id === id) {
                root.model.remove(j);
            }
        }
    }

    function clearNotification() {
        root.model.clear();
        for (var x = 0; x < root.model.count; ++x) {
            NotificationManager.dismissNotification(root.model.get(x).id);
        }
    }
}

