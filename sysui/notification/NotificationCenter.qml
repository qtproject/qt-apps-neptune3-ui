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
import shared.Sizes 1.0
import shared.utils 1.0
import shared.controls 1.0
import shared.animations 1.0
import system.models.notification 1.0
import shared.BasicStyle 1.0

Item {
    id: root

    y: root.notificationModel.notificationCenterVisible ? 0 : -root.height

    height: {
        var totalHeight = notificationList.height + root.notificationBottomMargin + root.notificationTopMargin;
        if (totalHeight > Sizes.dp(1720)) {
            return Sizes.dp(1720);
        }
        return totalHeight;
    }

    property NotificationModel notificationModel
    readonly property int notificationCenterMaxHeight: notificationList.height + root.notificationTopMargin + root.notificationBottomMargin
    readonly property int listviewMaxHeight: Sizes.dp(1720) - root.notificationTopMargin - root.notificationBottomMargin
    readonly property int notificationTopMargin: Sizes.dp(80)
    readonly property int notificationBottomMargin: Sizes.dp(144)

    Behavior on y {
        enabled: !root.notificationModel.notificationToastVisible
        DefaultNumberAnimation { }
    }
    Behavior on height {
        enabled: !root.notificationModel.notificationToastVisible
        DefaultNumberAnimation { }
    }

    Rectangle {
        id: notificationCenterBg
        anchors.fill: parent
        Behavior on opacity { DefaultNumberAnimation { } }
        color: BasicStyle.offMainColor
    }

    Column {
        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(80)
        anchors.left: parent.left
        anchors.leftMargin: Sizes.dp(40)
        anchors.right: parent.right
        anchors.rightMargin: Sizes.dp(40)

        opacity: notificationCenterBg.opacity
        spacing: Sizes.dp(72)

        ListView {
            id: notificationList
            width: parent.width
            height: Math.min(contentHeight, root.listviewMaxHeight)
            interactive: contentHeight > root.listviewMaxHeight
            opacity: notificationCenterBg.opacity
            model: root.notificationModel.model
            clip: true
            ScrollIndicator.vertical: ScrollIndicator {}
            delegate: NotificationItem {
                id: delegatedItem
                width: notificationList.width
                notificationIcon: model.icon
                notificationText: model.summary
                notificationSubtext: model.body
                notificationImage: model.image
                notificationActionText: model.actions.length > 0 ? model.actions[0].actionText : ""
                onCloseClicked: root.notificationModel.removeNotification(model.id)
                onButtonClicked: root.notificationModel.buttonClicked(model.id)
            }
        }

        Item {
            implicitHeight: Sizes.dp(40)
            implicitWidth: Sizes.dp(140)
            anchors.horizontalCenter: parent.horizontalCenter

            Label {
                anchors.centerIn: parent
                opacity: root.notificationModel.count < 1
                visible: opacity > 0
                Behavior on opacity { DefaultNumberAnimation { } }
                text: qsTr("No Notifications")
            }

            Button {
                anchors.fill: parent
                anchors.centerIn: parent
                opacity: root.notificationModel.count > 0
                visible: opacity > 0
                Behavior on opacity { DefaultNumberAnimation { } }
                font.pixelSize: Sizes.fontSizeS
                text: qsTr("Clear list")

                onClicked: root.notificationModel.clearNotifications();
            }
        }
    }
}
