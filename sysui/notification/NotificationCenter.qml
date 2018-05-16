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

import QtQuick 2.10
import QtQuick.Controls 2.0
import utils 1.0
import controls 1.0
import animations 1.0
import models.notification 1.0
import com.pelagicore.styles.neptune 3.0

Item {
    id: root

    height: {
        var totalHeight = notificationList.height + root.notificationBottomMargin + root.notificationTopMargin;
        if (totalHeight > NeptuneStyle.dp(1720)) {
            return NeptuneStyle.dp(1720);
        }
        return totalHeight;
    }

    property NotificationModel notificationModel
    readonly property int notificationTopMargin: NeptuneStyle.dp(80)
    readonly property int notificationBottomMargin: NeptuneStyle.dp(144)
    readonly property int dragMaximumY: NeptuneStyle.dp(130)
    readonly property int dragMinimumY: root.height - NeptuneStyle.dp(130)
    readonly property bool notificationCenterVisible: root.notificationModel.notificationCenterVisible
    property Item notificationCenterParent
    property int toastHeight: 0

    y: root.notificationCenterVisible ? root.dragMaximumY : - root.dragMinimumY
    Behavior on y { DefaultNumberAnimation { } }

    onYChanged: {
        if (root.y > - root.dragMinimumY && !root.notificationModel.notificationToastVisible) {
            notificationCenterBg.opacity = 1.0;
        } else if (root.y === - root.dragMinimumY && !root.notificationCenterVisible) {
            notificationCenterBg.opacity = 0.0;
        }
    }

    function closeNotificationCenter() {
        root.notificationModel.notificationCenterVisible = !root.notificationModel.notificationCenterVisible;
        if (!root.notificationModel.notificationCenterVisible) {
            notificationCenterBg.opacity = 0.0;
        }
    }

    Rectangle {
        id: notificationCenterBg
        anchors.fill: parent
        opacity: 0.0
        Behavior on opacity { DefaultNumberAnimation { } }
        color: NeptuneStyle.offMainColor
    }

    Column {
        anchors.top: parent.top
        anchors.topMargin: NeptuneStyle.dp(80)
        anchors.left: parent.left
        anchors.leftMargin: NeptuneStyle.dp(40)
        anchors.right: parent.right
        anchors.rightMargin: NeptuneStyle.dp(40)

        opacity: notificationCenterBg.opacity
        spacing: NeptuneStyle.dp(72)

        ListView {
            id: notificationList
            width: parent.width
            height: {
                var maxHeight = NeptuneStyle.dp(1720) - root.notificationTopMargin - root.notificationBottomMargin
                if (delegatedHeight > maxHeight) {
                    return maxHeight;
                } else {
                    return delegatedHeight;
                }
            }
            opacity: notificationCenterBg.opacity

            readonly property int delegatedHeight: NeptuneStyle.dp(110) * (notificationList.count)

            model: root.notificationModel.model

            clip: true
            ScrollIndicator.vertical: ScrollIndicator {}
            delegate: NotificationItem {
                id: delegatedItem
                implicitWidth: notificationList.width
                implicitHeight: NeptuneStyle.dp(110)
                notificationIcon: icon
                notificationText: title
                notificationSubtext: description
                notificationAccessoryButtonIcon: image
                wrapText: false
                onCloseClicked: root.notificationModel.removeNotification(index);
            }
        }

        Item {
            implicitHeight: NeptuneStyle.dp(40)
            implicitWidth: childrenRect.width
            anchors.horizontalCenter: parent.horizontalCenter

            Label {
                anchors.centerIn: parent
                font.pixelSize: NeptuneStyle.fontSizeM
                opacity: root.notificationModel.model.count < 1
                Behavior on opacity { DefaultNumberAnimation { } }
                text: qsTr("No Notifications")
            }

            Button {
                anchors.fill: parent
                anchors.centerIn: parent
                opacity: root.notificationModel.model.count > 0
                Behavior on opacity { DefaultNumberAnimation { } }
                font.pixelSize: NeptuneStyle.fontSizeS
                text: qsTr("Clear list")

                onClicked: {
                    root.notificationModel.clearNotification();
                }
            }
        }
    }

    NotificationHandle {
        id: notificationHandle
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: root.bottom
        anchors.topMargin: root.notificationModel.notificationToastVisible ? root.toastHeight - root.dragMaximumY : 0
        dragTarget: root.notificationModel.notificationToastVisible ? root.notificationCenterParent : root

        drag.minimumY: root.notificationModel.notificationToastVisible ? - NeptuneStyle.dp(130) : - root.dragMinimumY
        drag.maximumY: root.notificationModel.notificationToastVisible ? 0 : root.dragMaximumY

        drag.onActiveChanged: {
            notificationHandle.prevDragY = notificationHandle.dragTarget.y;
        }

        onPressed: {
            if (!root.notificationModel.notificationToastVisible) {
                // reset values
                notificationHandle.dragDelta = 0;
                notificationHandle.dragOrigin = notificationHandle.dragTarget.y;
                notificationHandle.prevDragY = notificationHandle.dragTarget.y;
                notificationCenterBg.opacity = 1.0;

                // start drag filter timer
                notificationHandle.dragFilterTimer.running = true;
            }
        }

        onReleased: {
            if (root.notificationCenterParent.y === - root.notificationCenterParent.height
                    && !root.notificationModel.notificationToastVisible) {
                if (!notificationHandle.drag.active && notificationHandle.swipe) {
                    if (root.notificationModel.notificationCenterVisible && notificationHandle.dragDelta > 0) {
                        root.notificationModel.notificationCenterVisible = true;
                    } else if (root.notificationModel.notificationCenterVisible && notificationHandle.dragDelta < 0) {
                        root.notificationModel.notificationCenterVisible = false;
                    } else {
                        root.notificationModel.notificationCenterVisible = !root.notificationModel.notificationCenterVisible;
                    }
                } else {
                    root.notificationModel.notificationCenterVisible = !root.notificationModel.notificationCenterVisible;
                }

                // stop drag filter timer
                notificationHandle.dragFilterTimer.running = false;
                notificationHandle.dragDelta = notificationHandle.dragTarget.y - notificationHandle.dragOrigin;

                if (!root.notificationModel.notificationCenterVisible) {
                    notificationCenterBg.opacity = 0.0;
                }
            } else {
                // close notification toast
                root.notificationModel.closeNotification();
            }
        }
    }
}
