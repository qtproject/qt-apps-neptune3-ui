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
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

import shared.Sizes 1.0
import QtApplicationManager.Application 2.0
import QtApplicationManager 2.0

Item {
    id: root

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(100)
        spacing: Sizes.dp(50)

        Button {
            id: simpleNotiButton
            implicitWidth: Sizes.dp(500)
            implicitHeight: Sizes.dp(64)
            text: qsTr("Simple notification")
            onClicked: {
                var notification1 = ApplicationInterface.createNotification();
                notification1.summary = qsTr("Summary text: simple notification");
                notification1.body = qsTr("Body text: simple notification");
                notification1.showActionsAsIcons = true;
                notification1.actions = [{"actionText": qsTr("Action Text")}];
                notification1.show();
            }
        }

        Button {
            implicitWidth: Sizes.dp(500)
            implicitHeight: Sizes.dp(64)
            text: qsTr("Timeout notification 8 secs")
            onClicked: {
                var notification2 = ApplicationInterface.createNotification();
                notification2.summary = qsTr("Summary text: timeout notification");
                notification2.body = qsTr("Body text: timeout 8 seconds");
                notification2.timeout = 8000;
                notification2.show();
            }
        }

        Button {
            implicitWidth: Sizes.dp(500)
            implicitHeight: Sizes.dp(64)
            text: qsTr("Sticky notification")
            onClicked: {
                var notification3 = ApplicationInterface.createNotification();
                notification3.summary = qsTr("Summary text: sticky notification");
                notification3.body = qsTr("Sticky notification has an implicit timeout of 0, it will persist in the notification center");
                notification3.sticky = true;
                notification3.show();
            }
        }

        Button {
            implicitWidth: Sizes.dp(500)
            implicitHeight: Sizes.dp(64)
            text: qsTr("Long text notification")
            onClicked: {
                var notification4 = ApplicationInterface.createNotification();
                notification4.summary = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Illa sunt similia: hebes acies est cuipiam oculorum, corpore alius senescit; Negat esse eam, inquit, propter se expetendam. Quoniam, si dis placet, ab Epicuro loqui discimus. At, illa, ut vobis placet, partem quandam tuetur, reliquam deserit. Scaevola tribunus plebis ferret ad plebem vellentne de ea re quaeri.";
                notification4.body = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Illa sunt similia: hebes acies est cuipiam oculorum, corpore alius senescit; Negat esse eam, inquit, propter se expetendam. Quoniam, si dis placet, ab Epicuro loqui discimus. At, illa, ut vobis placet, partem quandam tuetur, reliquam deserit. Scaevola tribunus plebis ferret ad plebem vellentne de ea re quaeri.";
                notification4.show();
            }
        }

        // simulates battery low event if accessory button is pressed, the UI
        // jumps directly to navigation app, setting the route to the proposed charging station
        // if not, a warning notification will be shown and stored in the notification center
        Button {
            id: appRequestNotiButton
            implicitWidth: Sizes.dp(500)
            implicitHeight: Sizes.dp(64)
            text: qsTr("Notification w/ App Request")
            property var notification5: ApplicationInterface.createNotification();
            onClicked: {
                notification5.summary = qsTr("Battery level is low");
                notification5.body = qsTr("Start route to nearest charging station?");
                notification5.timeout = 4000;
                notification5.actions = [{"actionText": qsTr("Show on Map")}];
                notification5.show();

            }
            Connections {
                target: appRequestNotiButton.notification5
                function onActionTriggered() {
                    IntentClient.sendIntentRequest("show-destination", "com.pelagicore.map"
                            , {"destination": "Polis Park Kaningos Athens"});
                    appRequestNotiButton.notification5.actionAccepted = true;
                }
                function onVisibleChanged() {
                    if (!appRequestNotiButton.notification5.visible && !appRequestNotiButton.notification5.actionAccepted) {
                        //if action is not accepted, show warning
                        // it's sticky, so first hide it to be able to show it again
                        var notification6 = ApplicationInterface.createNotification();
                        notification6.summary = qsTr("Warning: Battery level is low");
                        notification6.body = qsTr("Please consider charging it in the next available station");
                        notification6.sticky = true;
                        notification6.show();
                    }
                    appRequestNotiButton.notification5.actionAccepted = false;
                }
            }
        }
    }
}
