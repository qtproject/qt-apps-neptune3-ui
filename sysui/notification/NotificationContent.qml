/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
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
import centerconsole 1.0
import shared.animations 1.0
import system.models.notification 1.0
import shared.Sizes 1.0

ModalOverlay {
    id: root

    showModalOverlay: notificationModel.notificationCenterVisible
    onOverlayClicked: notificationModel.notificationCenterVisible = false

    NotificationModel {
        id: notificationModel
    }

    NotificationCenter {
        id: notificationCenter
        anchors.left: parent.left
        anchors.right: parent.right
        notificationModel: notificationModel
    }

    NotificationToast {
        id: notificationToast
        leftPadding: Sizes.dp(40)
        rightPadding: Sizes.dp(40)
        anchors.left: parent.left
        anchors.right: parent.right
        notificationModel: notificationModel
    }

    NotificationHandle {
        id: notificationHandle
        anchors.horizontalCenter: root.horizontalCenter
        anchors.top: notificationToast.y !== -notificationToast.height ? notificationToast.bottom : notificationCenter.bottom
        notificationCount: notificationModel.count
        notificationCounterVisible: notificationCount > 0 &&
                                    !notificationModel.notificationCenterVisible && !notificationModel.notificationToastVisible
        dragTarget: notificationToast.y !== -notificationToast.height ? notificationToast : notificationCenter
        drag.minimumY: notificationModel.notificationToastVisible ? - Sizes.dp(130) : -notificationCenter.height
        drag.maximumY: 0
        drag.onActiveChanged: {
            notificationHandle.prevDragY = notificationHandle.dragTarget.y;
        }

        onPressed: {
            if (!notificationModel.notificationToastVisible) {
                // reset values
                notificationHandle.dragDelta = 0;
                notificationHandle.dragOrigin = notificationHandle.dragTarget.y;
                notificationHandle.prevDragY = notificationHandle.dragTarget.y;

                // start drag filter timer
                notificationHandle.dragFilterTimer.running = true;
            }
        }

        onReleased: {
            if (!notificationModel.notificationToastVisible) {
                if (!notificationHandle.drag.active && notificationHandle.swipe) {
                    if (notificationModel.notificationCenterVisible && notificationHandle.dragDelta > 0) {
                        notificationModel.notificationCenterVisible = true;
                    } else if (notificationModel.notificationCenterVisible && notificationHandle.dragDelta < 0) {
                        notificationModel.notificationCenterVisible = false;
                    } else {
                        notificationModel.notificationCenterVisible = !notificationModel.notificationCenterVisible;
                    }
                } else {
                    notificationModel.notificationCenterVisible = !notificationModel.notificationCenterVisible;
                }

                // stop drag filter timer
                notificationHandle.dragFilterTimer.running = false;
                notificationHandle.dragDelta = notificationHandle.dragTarget.y - notificationHandle.dragOrigin;

            } else {
                // close notification toast
                notificationModel.closeNotification();
            }
        }
    }
}
