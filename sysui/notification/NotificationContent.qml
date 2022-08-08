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

import QtQuick
import centerconsole
import shared.animations
import system.models.notification
import shared.Sizes

ModalOverlay {
    id: root

    showModalOverlay: notificationCenter.state === "allNotifications"
    onOverlayClicked: {
        notificationCenter.closeNotificationCenter();
    }

    NotificationModel {
        id: notificationModel
        onNotificationsCleared: {
            notificationHandle.forceActiveFocus();
        }
        onNotificationClosed: {
            notificationHandle.forceActiveFocus();
        }
    }

    NotificationCenter {
        id: notificationCenter
        anchors.left: parent.left
        anchors.right: parent.right
        notificationModel: notificationModel
    }

    NotificationHandle {
        id: notificationHandle
        anchors.horizontalCenter: root.horizontalCenter
        anchors.top: notificationCenter.bottom
        notificationCount: notificationModel.count
        notificationCounterVisible: notificationCount > 0
                                    &&  notificationCenter.state !== "allNotifications"
        dragTarget: notificationCenter
        parentRotation: root.rotation

        onReleased: {
            if (notificationCenter.state === "intermediate_from_closed"
                    || notificationCenter.state === "intermediate_from_all")
            {
                if (-notificationCenter.y < notificationCenter.allNotificationsHeight / 2) {
                    notificationCenter.state = "allNotifications";
                } else {
                    notificationCenter.state = "closed";
                }
            } else if (notificationCenter.state === "allNotifications") {
                notificationCenter.state = "closed";
            } else {
                notificationCenter.state = "allNotifications";
            }
        }
    }
}
