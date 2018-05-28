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
import utils 1.0

import "JSONBackend.js" as JSONBackend
import QtApplicationManager 1.0

Item {
    id: root

    property alias applicationModel: appModel
    property alias categoryModel: catModel
    property alias appStoreConfig: appStoreConfig
    property string appServerUrl: appStoreConfig.serverUrl
    property int categoryid: 0
    property string filter: ""
    property real currentInstallationProgress: 0.0
    property var installedApps: []

    function download(id, name) {
        var url = appStoreConfig.serverUrl + "/app/purchase"
        var data = {"id": id, "device_id" : "00-11-22-33-44-55" }

        JSONBackend.serverCall(url, data, function(data) {
            if (data !== 0) {
                if (data.status === "ok") {
                    console.log(Logging.apps, "start downloading")
                    var icon = root.appServerUrl + "/app/icon?id=" + id
                    var installID = ApplicationInstaller.startPackageInstallation("internal-0", data.url);
                    ApplicationInstaller.acknowledgePackageInstallation(installID);
                    root.installedApps.push(id);
                    root.installedAppsChanged(root.installedApps);
                    showNotification(qsTr("%1 Successfully Installed").arg(name), qsTr("%1 successfully installed").arg(name), icon);
                } else if (data.status === "fail" && data.error === "not-logged-in"){
                    console.log(Logging.apps, ":::AppStoreServer::: not logged in")
                } else {
                    console.log(Logging.apps, ":::AppStoreServer::: download failed: " + data.error)
                }
            }
        })
    }

    function isInstalled(appId) {
        return root.installedApps.indexOf(appId) !== -1;
    }

    function uninstallApplication(id, name) {
        var icon = root.appServerUrl + "/app/icon?id=" + id
        ApplicationInstaller.removePackage(id, false /*keepDocuments*/, true /*force*/);
        root.installedApps.splice(root.installedApps.indexOf(id), 1);
        root.installedAppsChanged(root.installedApps);
        showNotification(qsTr("%1 Successfully Uninstalled").arg(name), qsTr("%1 successfully uninstalled").arg(name), icon);
    }

    function selectCategory(index) {
        var category = categoryModel.get(index);
        if (category) {
            root.categoryid = category.id;
        } else {
            root.categoryid = 1;
        }
        appModel.refresh();
    }

    function showNotification(summary, body, icon) {
        var notification = ApplicationInterface.createNotification();
        notification.summary = summary;
        notification.body = body;
        notification.icon = icon;
        notification.category = "notification";
        notification.show();
    }

    Component.onCompleted: {
        root.installedApps = ApplicationManager.applicationIds()
    }

    Connections {
        target: ApplicationInstaller

        onTaskProgressChanged: root.currentInstallationProgress = progress
    }

    // Application Store Server Configuration
    AppStoreConfig {
        id: appStoreConfig
        onLoginSuccessful: categoryModel.refresh()
    }

    JSONModel {
        id: catModel
        url: appStoreConfig.serverUrl + "/category/list"
    }

    JSONModel {
        id: appModel
        url: appStoreConfig.serverUrl + "/app/list"
        data: root.categoryid >= 0 ? ({ "filter" : root.filter , "category_id" : root.categoryid}) : ({ "filter" : root.filter})
    }
}
