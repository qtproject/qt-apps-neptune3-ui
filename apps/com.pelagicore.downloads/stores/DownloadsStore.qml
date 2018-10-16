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
import shared.utils 1.0

import "JSONBackend.js" as JSONBackend
import QtApplicationManager 1.0
import shared.com.pelagicore.systeminfo 1.0

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
    readonly property bool isOnline: sysinfo.online

    function formatBytes(bytes) {
        if (bytes < 1024) return qsTr("%1 Bytes").arg(bytes);
        else if (bytes < 1073741824) return qsTr("%1 MB").arg((bytes / 1048576).toFixed(2));
        else return qsTr("%1 GB").arg((bytes / 1073741824).toFixed(2));
    }

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
                } else if (data.status === "fail" && data.error === "not-logged-in"){
                    console.log(Logging.apps, ":::AppStoreServer::: not logged in")
                    showNotification(qsTr("System is not logged in"), qsTr("System is not logged in"), icon);
                } else {
                    console.log(Logging.apps, ":::AppStoreServer::: download failed: " + data.error)
                    showNotification(qsTr("%1 Download Failed").arg(name), qsTr("%1 download failed").arg(name), icon);
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
        notification.sticky = true;
        notification.show();
    }

    function getInstalledApplicationSize(id) {
        return formatBytes(ApplicationInstaller.installedApplicationSize(id));
    }

    function deviseApplicationId(id) {
        // The application name defined in a specific format for Neptune 3. It has a foo.bar.name format
        // for the application name. This function will only comply with such format.
        var strArr = id.split('.')
        var firstUpperCaseLetter = strArr[2].charAt(0).toUpperCase();
        var restLetters = strArr[2].substr(1).toLowerCase();
        var appName = firstUpperCaseLetter + restLetters;
        return appName;
    }

    Component.onCompleted: {
        root.installedApps = ApplicationManager.applicationIds()
    }

    Connections {
        target: ApplicationInstaller

        onTaskProgressChanged: root.currentInstallationProgress = progress

        onTaskFailed: {
            var appId = ApplicationInstaller.taskApplicationId(taskId);
            var icon = root.appServerUrl + "/app/icon?id=" + appId
            var application = ApplicationManager.application(appId)
            var applicationName = root.deviseApplicationId(appId);

            if (application !== null) {
                if (application.state === ApplicationObject.Installed) {
                    showNotification(qsTr("%1 Uninstallation Failed").arg(applicationName),
                                     qsTr("%1 uninstallation failed").arg(applicationName), icon);
                }
            } else {
                showNotification(qsTr("%1 Installation Failed").arg(applicationName),
                                 qsTr("%1 installation failed").arg(applicationName), icon);
            }
        }

        onTaskFinished: {
            var appId = ApplicationInstaller.taskApplicationId(taskId);
            var icon = root.appServerUrl + "/app/icon?id=" + appId;
            var application = ApplicationManager.application(appId);

            // cannot use name module from the application manager, because it won't work when the application
            // is uninstalled as it will return null. hence, the application name need to be generated from the
            // application id to be shown in the notification.
            var applicationName = root.deviseApplicationId(appId);

            if (application !== null) {
                if (application.state === ApplicationObject.Installed) {
                    root.installedApps.push(appId);
                    root.installedAppsChanged(root.installedApps);
                    showNotification(qsTr("%1 Successfully Installed").arg(applicationName),
                                     qsTr("%1 successfully installed").arg(applicationName), icon);
                }
            } else {
                root.installedApps.splice(root.installedApps.indexOf(appId), 1);
                root.installedAppsChanged(root.installedApps);
                showNotification(qsTr("%1 Successfully Uninstalled").arg(applicationName),
                                 qsTr("%1 successfully uninstalled").arg(applicationName), icon);
            }
        }
    }

    SystemInfo {
        id: sysinfo

        onOnlineChanged: {
            if (sysinfo.online) {
                appStoreConfig.checkServer();
            }
        }
    }

    // Server Configuration
    ServerConfig {
        id: appStoreConfig
        cpuArch: sysinfo.cpu + "-" + sysinfo.kernel
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
