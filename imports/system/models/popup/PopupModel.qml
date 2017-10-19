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

pragma Singleton
import QtQuick 2.8
import QtApplicationManager 1.0

QtObject {
    id: root

    property bool popupVisible: false
    property int popupIndex: -1
    property int currentVisiblePopupId: 0
    property QtObject currentPopup: QtObject {
        property int id: -1
        property var body
        property var summary
        property real progressValue: 0.0
        property int priority: 15

    }
    property var buttonModel: []

    property var popupQueue: []
    property var popupContentData
    property var popupButtonData

    property var loggingCategory: LoggingCategory {
        id: logCategory
        name: "triton.popupmodel"
    }

    readonly property Connections notificationManagerConnection: Connections {
        target: NotificationManager

        onNotificationAdded: {
            var receivedContent = NotificationManager.notification(id);

            if (receivedContent.category === "popup") {
                console.log(logCategory, "::: Popup received :::", id);
                if (!root.popupVisible && root.popupQueue.length === 0) {
                    root.requestPopup(id);
                }
                else {
                    if (root.currentPopup.priority < receivedContent.priority || root.currentPopup.priority === receivedContent.priority) {
                        root.popupQueue.push(id);
                    } else {
                        root.popupQueue.push(root.currentPopup.id);
                        root.hideCurrentPopup();
                        root.requestPopup(id);
                    }
                }
            }
        }

        onNotificationChanged: {
            var receivedContent = NotificationManager.notification(id);

            if (receivedContent.category === "popup") {
                console.log(logCategory, "::: Popup changed :::", id);
                if (root.currentPopup.id === id) {
                    root.processPopup(receivedContent);
                } else if (root.currentPopup.priority > receivedContent.priority) {
                    root.hideCurrentPopup();
                    root.requestPopup(id);
                } else {
                    root.popupQueue.push(id);
                }
            }
        }

        onNotificationAboutToBeRemoved: {
            var receivedContent = NotificationManager.notification(id);

            if (receivedContent.category === "popup") {
                hideCurrentPopup();
            }
        }
    }

    function requestPopup(id) {
        var contentToShow = NotificationManager.notification(id);
        root.popupIndex = contentToShow.id;
        root.processPopup(contentToShow);
        root.popupVisible = true;
    }

    function processPopup(receivedPopup) {
        var receivedBody = receivedPopup.extended;
        var receivedSummary = receivedPopup.summary;
        var receivedButtons = [];
        var receivedProgress = receivedPopup.progress;

        for (var i in receivedPopup.actions) {
            receivedButtons.push(receivedPopup.actions[i]);
        }

        root.currentPopup.id = receivedPopup.id;
        root.currentPopup.summary = receivedSummary;
        root.currentPopup.body = receivedBody;
        root.currentPopup.priority = receivedPopup.priority;
        root.currentPopup.progressValue = receivedProgress;
        root.buttonModel = receivedButtons;
    }

    function showPopupOnQueue() {
        if (root.popupQueue.length > 0) {
            root.requestPopup(root.popupQueue[0]);
            root.popupQueue.splice(0,1);
        }
    }

    function buttonPressed(buttonIndex) {
        NotificationManager.triggerNotificationAction(root.popupIndex, buttonIndex);
        NotificationManager.dismissNotification(root.popupIndex);
        root.hideCurrentPopup();
        if (root.popupQueue.length > 0) {
            root.showPopupOnQueue();
        }
    }

    function resetContent() {
        root.currentPopup.id = -1;
        root.currentPopup.summary = {};
        root.currentPopup.body = {};
        root.currentPopup.priority = 15;
        root.currentPopup.progressValue = 0.0;
        root.buttonModel = [];
        root.popupIndex = -1;
    }

    function hideCurrentPopup() {
        root.resetContent();
        root.popupVisible = false;
    }
}
