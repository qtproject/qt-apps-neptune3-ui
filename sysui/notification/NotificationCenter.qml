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

    readonly property int notificationTopMargin: NeptuneStyle.dp(80)
    readonly property int notificationBottomMargin: NeptuneStyle.dp(144)
    readonly property int dragMaximumY: NeptuneStyle.dp(130)
    readonly property int dragMinimumY: root.height - NeptuneStyle.dp(130)

    y: NotificationModel.notificationCenterVisible ? root.dragMaximumY
                                                   : - root.dragMinimumY
    Behavior on y { DefaultNumberAnimation { } }

    function closeNotificationCenter() {
        NotificationModel.notificationCenterVisible = !NotificationModel.notificationCenterVisible;
    }

    Rectangle {
        id: notificationCenterBg
        anchors.fill: parent
        opacity: NotificationModel.notificationCenterVisible ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation { } }
        color: NeptuneStyle.offMainColor
    }

    //TODO: Use real notification model
    Column {
        anchors.top: parent.top
        anchors.topMargin: NeptuneStyle.dp(80)
        anchors.left: parent.left
        anchors.leftMargin: NeptuneStyle.dp(120)
        anchors.right: parent.right
        anchors.rightMargin: NeptuneStyle.dp(120)

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

            readonly property int delegatedHeight: NeptuneStyle.dp(110) * (notificationList.count - 1)

            model: 8

            clip: true
            ScrollIndicator.vertical: ScrollIndicator {}
            delegate: ListItemTwoButtons {
                id: delegatedItem
                implicitWidth: notificationList.width
                implicitHeight: NeptuneStyle.dp(110)

                // TODO: Update this text mockup with real notification model data.
                icon.name: ""
                text: "Notification Title"
                subText: "Notification Description"
                symbolAccessoryButton2: "ic-close"
                onAccessoryButton2Clicked: NotificationModel.removeNotification(index);
            }
        }

        Button {
            implicitHeight: NeptuneStyle.dp(40)
            implicitWidth: NeptuneStyle.dp(150)
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: NeptuneStyle.fontSizeS
            text: qsTr("Clear list")

            // HACK!! TODO: Clear real notification model
            // and adapt notification center height accordingly.
            onClicked: {
                notificationList.height = 0;
                root.height = root.notificationBottomMargin + root.notificationTopMargin;
                notificationList.model = 0;
            }
        }
    }

    NotificationHandle {
        width: NeptuneStyle.dp(300)
        height: NeptuneStyle.dp(30)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: root.bottom

        onClicked: {
            NotificationModel.notificationToastVisible = false;
            NotificationModel.notificationCenterVisible = !NotificationModel.notificationCenterVisible;
        }
    }
}
