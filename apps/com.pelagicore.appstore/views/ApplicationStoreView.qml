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
import utils 1.0
import animations 1.0
import "../stores"
import "../controls"

import com.pelagicore.styles.neptune 3.0

Item {
    id: root

    property AppStoreServer store

    property int categoryid: 1
    property string filter: ""

    BusyIndicator {
        id: busyIndicator

        width: NeptuneStyle.dp(225)
        height: NeptuneStyle.dp(440)
        anchors.centerIn: parent
        running: visible
        opacity: root.store.categoryModel.count < 1 ? 1.0 : 0.0
        visible: opacity > 0
        Behavior on opacity { DefaultNumberAnimation { } }

        onRunningChanged: {
            if (!running) { // preselect non-empty category
                toolsColumn.currentTool = "Entertainment";
                toolsColumn.toolClicked("Entertainment", 2);
            }
        }
    }

    Label {
        anchors.top: busyIndicator.bottom
        anchors.topMargin: NeptuneStyle.dp(8)
        anchors.horizontalCenter: parent.horizontalCenter
        color: NeptuneStyle.contrastColor
        font.pixelSize: NeptuneStyle.fontSizeM
        opacity: busyIndicator.opacity
        text: qsTr("Fetching data from Neptune Server")
    }

    Label {
        anchors.centerIn: parent
        color: NeptuneStyle.contrastColor
        font.pixelSize: NeptuneStyle.fontSizeM
        text: qsTr("No apps found!")
        opacity: 1.0 - busyIndicator.opacity
        visible: appList.model.count < 1
    }

    RowLayout {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: NeptuneStyle.dp(500)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: NeptuneStyle.dp(20)

        AppStoreToolsColumn {
            id: toolsColumn
            Layout.preferredWidth: NeptuneStyle.dp(264)
            Layout.preferredHeight: NeptuneStyle.dp(320)
            Layout.alignment: Qt.AlignTop
            model: root.store.categoryModel
            onToolClicked: root.store.selectCategory(index)
        }

        DownloadAppList {
            id: appList
            installedApps: root.store.installedApps
            Layout.preferredHeight: NeptuneStyle.dp(800)
            Layout.preferredWidth: NeptuneStyle.dp(675)
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: NeptuneStyle.dp(16)
            model: root.store.applicationModel
            appServerUrl: root.store.appServerUrl
            installationProgress: root.store.currentInstallationProgress
            onToolClicked: {
                if (root.store.isInstalled(appId)) {
                    root.store.uninstallApplication(appId)
                } else {
                    root.store.download(appId)
                }
            }
        }
    }

    Component.onCompleted: root.store.appStoreConfig.checkServer();
}
