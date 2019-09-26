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
import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtIvi 1.0
import QtIvi.Media 1.0
import shared.com.pelagicore.remotesettings 1.0
import shared.com.pelagicore.drivedata 1.0

import QtQuick.Window 2.3

ApplicationWindow {
    id: root

    visible: true
    minimumHeight: 720
    minimumWidth: 400

    title: qsTr("Neptune Companion App")

    readonly property color accentColor: "#FA9E54"
    readonly property color disconnectedColor: "red"

    function neptuneScale(value) {
        return value * Screen.pixelDensity;
    }

    Component.onCompleted: {
        var screens = Qt.application.screens;
        var minH = 1080;
        var minW = 1920;
        for (var scr in screens) {
            console.info(scr)
            minH = Math.min(minH, screens[scr].height);
            minW = Math.min(minW, screens[scr].width);
        }

        // if FHD shrink to min
        if (minH <= 1080 || minW <= 1920) {
            root.width = minimumWidth;
            root.height = minimumHeight;
        } else {
            root.width = 1280;
            root.height = 800;
        }

        connectionDialog.open();
    }

    UISettings {
        id: uiSettings
    }

    InstrumentCluster {
        id: instrumentCluster

        property bool isConnected: false

        onIsInitializedChanged: {
            isConnected = isInitialized;
        }

        onErrorChanged: {
            if (error > 0) {
                //Any other state then NoError=0
                isConnected = false;
            } else {
                isConnected = isInitialized;
            }
        }
    }

    ConnectionMonitoring {
        id: connectionMonitoring
    }

    SystemUI {
        id: systemUI
    }

    MediaPlayer {
        id: mediaPlayer
    }

    ConnectionDialog {
        id: connectionDialog

        statusText: client.status
        lastUrls: client.lastUrls
        x: (parent.width-width) /2
        y: (parent.height-height) /2

        onAccepted: {
            if (accepted) {
                client.connectToServer(url);
                uiSettings.setServiceObject(null);
                instrumentCluster.setServiceObject(null);
                systemUI.setServiceObject(null);
                mediaPlayer.setServiceObject(null);
                uiSettings.startAutoDiscovery();
                instrumentCluster.startAutoDiscovery();
                systemUI.startAutoDiscovery();
                mediaPlayer.startAutoDiscovery();
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
            target: client
            onConnectedChanged: {
                if (client.connected)
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

        VehiclePage {}
        MediaPage {}
        MapsPage {}
        SettingsPage {}
        DevelopmentPage {}
    }

    footer: TabBar {
        TabButton {
            icon.source: "qrc:/assets/vehicle.png"
            text: qsTr("Vehicle")
            icon.color: uiSettings.isInitialized && client.connected ? root.accentColor : root.disconnectedColor
            display: AbstractButton.TextUnderIcon
            font.capitalization: Font.MixedCase
            onClicked: stack.currentIndex = 0
        }
        TabButton {
            icon.source: "qrc:/assets/media.png"
            text: qsTr("Media")
            icon.color: uiSettings.isInitialized && client.connected ? root.accentColor : root.disconnectedColor
            display: AbstractButton.TextUnderIcon
            font.capitalization: Font.MixedCase
            onClicked: stack.currentIndex = 1
        }
        TabButton {
            icon.source: "qrc:/assets/maps.png"
            text: qsTr("Maps")
            icon.color: instrumentCluster.isConnected ? root.accentColor : root.disconnectedColor
            display: AbstractButton.TextUnderIcon
            font.capitalization: Font.MixedCase
            onClicked: stack.currentIndex = 2
        }
        TabButton {
            icon.source: "qrc:/assets/settings.png"
            text: qsTr("Settings")
            icon.color: systemUI.isInitialized && client.connected ? root.accentColor : root.disconnectedColor
            display: AbstractButton.TextUnderIcon
            font.capitalization: Font.MixedCase
            onClicked: stack.currentIndex = 3
        }
        TabButton {
            icon.source: "qrc:/assets/development.png"
            text: qsTr("Dev")
            icon.color: systemUI.isInitialized && client.connected ? "green" : root.disconnectedColor
            display: AbstractButton.TextUnderIcon
            font.capitalization: Font.MixedCase
            onClicked: stack.currentIndex = 4
        }
    }
}
