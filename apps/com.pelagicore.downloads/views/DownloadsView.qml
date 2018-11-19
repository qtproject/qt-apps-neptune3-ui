/****************************************************************************
**
** Copyright (C) 2017-2018 Pelagicore AG
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

import QtQuick 2.8
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import shared.utils 1.0
import shared.animations 1.0
import "../stores"
import "../controls"

import shared.BasicStyle 1.0
import shared.Sizes 1.0

Item {
    id: root

    property DownloadsStore store

    property int categoryid: 1
    property string filter: ""

    BusyIndicator {
        id: busyIndicator

        width: Sizes.dp(225)
        height: Sizes.dp(440)
        anchors.centerIn: parent
        running: visible
        opacity: root.store.categoryModel.count < 1 && root.store.isOnline ? 1.0 : 0.0
        visible: opacity > 0
        Behavior on opacity { DefaultNumberAnimation { } }

        onRunningChanged: {
            if (!running) { // preselect non-empty category
                toolsColumn.currentTool = "Entertainment";
                toolsColumn.toolClicked("Entertainment", 2);
            }
        }
    }

    Loader {
        anchors.top: busyIndicator.bottom
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
            color: BasicStyle.contrastColor
            font.pixelSize: Sizes.fontSizeM
            text: qsTr("Fetching data from Neptune Server")
        }
    }

    Component {
        id: noInternetLabel

        Label {
            color: BasicStyle.contrastColor
            font.pixelSize: Sizes.fontSizeM
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("Cannot Connect to the Server") + "\n" +
                  qsTr("An Internet connection is required")
        }
    }

    Label {
        anchors.centerIn: parent
        color: BasicStyle.contrastColor
        font.pixelSize: Sizes.fontSizeM
        text: qsTr("No apps found!")
        opacity: 1.0 - busyIndicator.opacity
        visible: appList.model.count < 1 && root.store.isOnline
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
            Layout.preferredWidth: Sizes.dp(264)
            Layout.preferredHeight: Sizes.dp(320)
            Layout.alignment: Qt.AlignTop
            model: root.store.categoryModel
            onToolClicked: root.store.selectCategory(index)
        }

        DownloadAppList {
            id: appList
            Layout.preferredHeight: Sizes.dp(800)
            Layout.preferredWidth: Sizes.dp(675)
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: Sizes.dp(16)
            store: root.store

            onToolClicked: {
                if (root.store.isInstalled(appId)) {
                    root.store.uninstallApplication(appId, appName)
                } else {
                    root.store.download(appId, appName)
                }
            }
        }
    }

    Component.onCompleted: root.store.appStoreConfig.checkServer();
}
