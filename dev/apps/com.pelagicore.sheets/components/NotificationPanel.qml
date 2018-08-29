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
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

import com.pelagicore.styles.neptune 3.0
import QtApplicationManager 1.0

Item {
    id: root

    Notification {
        id: notification1
        summary: "Summary text: simple notification"
        body: "Body text: simple notification"
        showActionsAsIcons: true
        actions: [{"actionText": "Action Text"}]
        onActionTriggered: {
            console.log("Simple notification has been triggered")
        }
    }

    Notification {
        id: notification2
        summary: "Summary text: timeout notification"
        body: "Body text: timeout 8 seconds"
        timeout: 8000
    }

    Notification {
        id: notification3
        summary: "Summary text: sticky notification"
        body: "Sticky notification has an implicit timeout of 0, it will persist in the notification center"
        sticky: true
    }

    Notification {
        id: notification4
        summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Illa sunt similia: hebes acies est cuipiam oculorum, corpore alius senescit; Negat esse eam, inquit, propter se expetendam. Quoniam, si dis placet, ab Epicuro loqui discimus. At, illa, ut vobis placet, partem quandam tuetur, reliquam deserit. Scaevola tribunus plebis ferret ad plebem vellentne de ea re quaeri."
        body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Illa sunt similia: hebes acies est cuipiam oculorum, corpore alius senescit; Negat esse eam, inquit, propter se expetendam. Quoniam, si dis placet, ab Epicuro loqui discimus. At, illa, ut vobis placet, partem quandam tuetur, reliquam deserit. Scaevola tribunus plebis ferret ad plebem vellentne de ea re quaeri."
    }

    // simulates battery low event if accessory button is pressed, the UI
    // jumps directly to navigation app, setting the route to the proposed charging station
    // if not, a warning notification will be shown and stored in the notification center
    Notification {
        id: notification5
        property bool actionAccepted: false
        summary: qsTr("Battery level is low")
        body: qsTr("Start route to nearest charging station?")
        timeout: 4000
        actions: [{"actionText": qsTr("Show on Map")}]
        onActionTriggered: {
            //jump to navigation app
            Qt.openUrlExternally("x-map://getMeTo/Polis Park Kaningos Athens");
            actionAccepted = true;
        }
        onVisibleChanged: {
            if (!visible && !actionAccepted) {
                //if action is not accepted, show warning
                notification6.hide(); // it's sticky, so first hide it to be able to show it again
                notification6.show();
            }
            actionAccepted = false;
        }
    }

    Notification {
        id: notification6
        summary: qsTr("Warning: Battery level is low")
        body: qsTr("Please consider charging it in the next available station")
        sticky: true
    }

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: NeptuneStyle.dp(100)
        spacing: NeptuneStyle.dp(50)
        Button {
            width: NeptuneStyle.dp(500)
            height: NeptuneStyle.dp(64)
            text: "Simple notification"
            onClicked: notification1.show()
        }
        Button {
            width: NeptuneStyle.dp(500)
            height: NeptuneStyle.dp(64)
            text: "Timeout notification 8 secs"
            onClicked: notification2.show()
        }
        Button {
            width: NeptuneStyle.dp(500)
            height: NeptuneStyle.dp(64)
            text: "Sticky notification"
            onClicked: notification3.show()
        }
        Button {
            width: NeptuneStyle.dp(500)
            height: NeptuneStyle.dp(64)
            text: "Long text notification"
            onClicked: notification4.show()
        }
        Button {
            width: NeptuneStyle.dp(500)
            height: NeptuneStyle.dp(64)
            text: "Notification w/ App Request"
            onClicked: notification5.show()
        }
    }
}
