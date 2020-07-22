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
import shared.controls 1.0
import shared.animations 1.0
import system.models.notification 1.0
import shared.Style 1.0

NotificationItem {
    id: root

    property NotificationModel notificationModel

    onButtonClicked: { root.notificationModel.buttonClicked(priv.notificationId); }

    onCloseClicked: {
        root.notificationModel.removeNotification(priv.notificationId);
    }

    QtObject {
        id: priv
        property int notificationId: -1
    }

    Connections {
        target: root.notificationModel
        function onNotificationAdded() {
            var currentNotification = root.notificationModel.model.get(root.notificationModel.count - 1);
            priv.notificationId = currentNotification.id;
            root.notificationIcon = currentNotification.icon;
            root.notificationText = currentNotification.summary;
            root.notificationSubtext = currentNotification.body;
            root.notificationImage = currentNotification.image;
            if (currentNotification.actions.length > 0) {
                // TODO improve actions assignment to support more than 1,
                // for now there is only one specified
                root.notificationActionText = currentNotification.actions[0].actionText;
            } else {
                root.notificationActionText = "";
            }
        }

        function onNotificationClosed() {
            priv.notificationId = -1;
        }
    }
}
