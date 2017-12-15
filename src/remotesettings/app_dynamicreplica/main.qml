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
import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

ApplicationWindow {
    id: root

    visible: true
    width: 1280
    height: 800
    title: qsTr("Settings app")

    readonly property bool connected: uiSettings.connected ||
                                      instrumentCluster.connected

    Component.onCompleted: {
        connectionDialog.open()
    }

    ConnectionDialog {
        id: connectionDialog
        property string defaultUrl : "tcp://127.0.0.1:9999"
        url: defaultUrl
        statusText: client.status

        width: parent.width / 2
        height: parent.height / 2

        x: (parent.width-width) /2
        y: (parent.height-height) /2

        onAccepted: {
            if (accepted) {
                client.connectToServer(url);
            }
            connectionDialog.close();
        }

        Connections {
            target: client
            onServerUrlChanged: {
                if (client.serverUrl.toString().length)
                    connectionDialog.url = client.serverUrl.toString();
                else
                    connectionDialog.url = defaultUrl;
            }
        }

        Connections {
            target: root
            onConnectedChanged: {
                if (root.connected)
                    connectionDialog.close();
            }
        }

    }

    header: ToolBar {
        leftPadding: 8
        rightPadding: 8
        RowLayout {
            anchors.fill: parent
            Label {
                text: client.status
            }
            Item {
                Layout.fillWidth: true
            }

            ToolButton {
                text: qsTr("Connect...")
                onClicked: connectionDialog.open()
            }
        }
    }

   StackLayout {
       id: stack
       anchors.fill: parent
       anchors.margins: 16
       SettingsPage {}
       ClusterPage {}
   }

   footer: TabBar {
       TabButton {
           text: qsTr("Settings")
           onClicked: stack.currentIndex = 0
       }
       TabButton {
           text: qsTr("Cluster")
           onClicked: stack.currentIndex = 1
       }
   }
}
