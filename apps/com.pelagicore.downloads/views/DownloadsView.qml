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

import QtQuick 2.8
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import shared.utils 1.0
import shared.animations 1.0
import "../stores" 1.0
import "../controls" 1.0

import shared.Style 1.0
import shared.Sizes 1.0

Item {
    id: root

    property DownloadsStore store

    BusyIndicator {
        id: busyIndicator

        width: Sizes.dp(225)
        height: Sizes.dp(440)
        anchors.centerIn: parent
        running: visible
        opacity: root.store.isBusy ? 1.0 : 0.0
        visible: opacity > 0.0
        Behavior on opacity {
            PauseAnimation { duration: 1000 }
            DefaultNumberAnimation { }
        }

        onRunningChanged: {
            if (!running) { // preselect non-empty category
                toolsColumn.toolClicked(0);
            }
        }
    }

    Loader {
        anchors.top: root.store.isBusy ? busyIndicator.bottom : undefined
        anchors.centerIn: busyIndicator.visible ? undefined : root
        anchors.topMargin: Sizes.dp(8)
        anchors.horizontalCenter: parent.horizontalCenter
        sourceComponent: root.store.isOnline ? fetchingLabel : noInternetLabel
        visible: opacity > 0
        opacity: root.store.isOnline ? busyIndicator.opacity : 1.0
        Behavior on opacity { DefaultNumberAnimation { } }
    }

    Component {
        id: fetchingLabel

        Label {
            color: Style.contrastColor
            font.pixelSize: Sizes.fontSizeM
            text: qsTr("Fetching data from Neptune Server")
        }
    }

    Component {
        id: noInternetLabel

        Column {
            id: column
            anchors.centerIn: parent
            spacing: Sizes.dp(50)
            Label {
                color: Style.contrastColor
                font.pixelSize: Sizes.fontSizeM
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("Cannot Connect to the Server") + "\n" +
                      qsTr("A Network connection is required")
            }
            Label {
                color: Style.contrastColor
                font.pixelSize: Sizes.fontSizeM
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("Reconnecting...")
                visible: store.isReconnecting
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Button {
                text: qsTr("Retry")
                implicitHeight: Sizes.dp(70)
                implicitWidth: Sizes.dp(315)
                font.pixelSize: Sizes.fontSizeS
                anchors.horizontalCenter: column.horizontalCenter
                visible: !store.isReconnecting
                onClicked: {
                    store.appStoreConfig.checkServer()
                }
            }
        }
    }

    Label {
        anchors.centerIn: parent
        color: Style.contrastColor
        font.pixelSize: Sizes.fontSizeM
        text: qsTr("No apps found!")
        opacity: 1.0 - busyIndicator.opacity
        visible: root.store.isBusy
    }

    RowLayout {
        id: downloadsContent
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(500)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Sizes.dp(20)
        visible: opacity > 0
        opacity: root.store.isOnline ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation { } }

        DownloadsToolsColumn {
            id: toolsColumn
            objectName: "downloadsAppColumn"
            Layout.preferredWidth: Sizes.dp(264)
            Layout.preferredHeight: Sizes.dp(320)
            Layout.alignment: Qt.AlignTop
            model: root.store.categoryModel
            serverUrl: root.store.appServerUrl
            onToolClicked: root.store.selectCategory(index)
        }

        DownloadAppList {
            id: appList
            objectName: "downloadAppList"
            Layout.preferredHeight: Sizes.dp(800)
            Layout.preferredWidth: Sizes.dp(675)
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: Sizes.dp(16)
            store: root.store

            onToolClicked: {
                if (root.store.isPackageBusy(appId)) {
                    console.warn("Package busy... Aborting", appId)
                    return;
                }
                if (root.store.isPackageInstalledByPackageController(appId)) {
                    root.store.uninstallPackage(appId, appName);
                } else {
                    root.store.download(appId, appName);
                }
            }
        }
    }
}
