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
import shared.utils 1.0

import "JSONBackend.js" as JSONBackend
import QtApplicationManager.Application 2.0
import QtApplicationManager.SystemUI 2.0
import shared.com.pelagicore.systeminfo 1.0

Item {
    id: root

    property alias applicationModel: appModel
    property alias categoryModel: categoryListModel
    property alias appStoreConfig: appStoreConfig
    property string appServerUrl: appStoreConfig.serverUrl
    property alias cpuArch: appStoreConfig.cpuArch
    property string filter: ""
    property real currentInstallationProgress: 0.0
    readonly property var installedPackages: PackageManager.packageIds()
    readonly property IntentHandler intentHandler: IntentHandler {
        intentIds: "activate-app"
        onRequestReceived: {
            root.requestRaiseAppReceived()
            request.sendReply({ "done": true })
        }
    }
    property DownloadsStates downloadsStates: DownloadsStates {
        sysinfo: sysinfo
        appStoreConfig: appStoreConfig
        jsonCategoryModel: jsonCategoryModel
        jsonAppModel: jsonAppModel
    }

    signal requestRaiseAppReceived()

    function formatBytes(bytes) {
        if (bytes < 1024) return qsTr("%1 Bytes").arg(bytes);
        else if (bytes < 1073741824) return qsTr("%1 MB").arg((bytes / 1048576).toFixed(2));
        else return qsTr("%1 GB").arg((bytes / 1073741824).toFixed(2));
    }

    function download(packageId, name, purchaseId, iconUrl) {
        if (isPackageBusy(packageId)) {
            console.warn("Package busy... Abort download");
            return;
        }

        var url = appStoreConfig.serverUrl + "/app/purchase";
        var data = {"purchaseId": purchaseId, "device_id" : "00-11-22-33-44-55" };
        var icon = iconUrl

        JSONBackend.serverCall(url, data, function(data) {
            if (data !== 0) {
                if (data.status === "ok") {
                    console.log(Logging.apps, "start downloading");
                    var installID = PackageManager.startPackageInstallation(data.url);
                    PackageManager.acknowledgePackageInstallation(installID);
                } else if (data.status === "fail" && data.error === "not-logged-in"){
                    console.warn(Logging.apps, ":::AppStoreServer::: not logged in");
                    showNotification(qsTr("System is not logged in"), qsTr("System is not logged in"), icon);
                } else {
                    console.warn(Logging.apps, ":::AppStoreServer::: download failed: " + data.error);
                    showNotification(qsTr("%1 Download Failed").arg(name), qsTr("%1 download failed").arg(name), icon);
                }
            } else {
                console.warn(Logging.apps, ":::AppStoreServer::: download failed");
                showNotification(qsTr("%1 Download Failed").arg(name), qsTr("%1 download failed").arg(name), icon);
            }
        })
    }

    function tryStartApp(appId) {
        var app = ApplicationManager.application(appId);
        return app && app.start();
    }

    function isPackageBuiltIn(packageId) {
        var pkg = PackageManager.package(packageId);
        return !!pkg && pkg.builtIn;
    }

    function isPackageBusy(packageId) {
        var taskIds = PackageManager.activeTaskIds()
        if (taskIds.includes(packageId)) {
            return true;
        }

        return false;
    }

    function isPackageInstalledByPackageController(packageId) {
        var pkg = PackageManager.package(packageId);
        if (pkg && pkg.builtIn) {
            //only built-in part or have something to remove
            return pkg.builtInHasRemovableUpdate;
        }

        return getInstalledPackages().includes(packageId);
    }

    function uninstallPackage(packageId, name) {
        if (isPackageBusy(packageId)) {
            console.warn("Package busy... Abort uninstall");
            return;
        }

        PackageManager.removePackage(packageId, false /*keepDocuments*/, true /*force*/);
    }

    function selectCategory(index) {
        var category = categoryListModel.get(index);
        if (category) {
            jsonAppModel.categoryId = category.id;
        } else {
            jsonAppModel.categoryId = 1;
        }

        jsonAppModel.refresh();
    }

    function showNotification(summary, body, icon) {
        var notification = ApplicationInterface.createNotification();
        notification.summary = summary;
        notification.body = body;
        notification.icon = icon;
        notification.sticky = true;
        notification.show();
    }

    function getInstalledPackageSizeText(packageId) {
        if (PackageManager.installedPackageSize(packageId) < 0) {
            if (isPackageBuiltIn(packageId)) {
                return qsTr("built-in");
            } else {
                console.warn("Uknown app package size: -1", packageId);
                return qsTr("Unknown size");
            }
        }

        return formatBytes(PackageManager.installedPackageSize(packageId));
    }

    function getPackageName(packageId) {
        // The application name defined in a specific format for Neptune 3. It has a foo.bar.name format
        // for the application name. This function will only comply with such format.
        // Sometimes "name" from the application manager can't be used, because it won't work when
        // the application is uninstalled as it will return null. hence, the application
        // name need to be generated from the application id to be shown in the
        // notification.
        var appName = packageId;
        var pkg = PackageManager.package(packageId);
        if (pkg) {
            appName = pkg.name;
        } else {
            var lastNamePart = packageId.split('.').pop();
            if (lastNamePart.length > 1) {
                appName = lastNamePart.charAt(0).toUpperCase() +
                        lastNamePart.slice(1).toLowerCase();
            }
        }

        return appName;
    }

    function getInstalledPackages() {
        return PackageManager.packageIds();
    }

    Connections {
        target: PackageManager

        function onTaskProgressChanged(taskId, progress) {
            root.currentInstallationProgress = progress
        }
        function onTaskFailed(taskId) {
            var packageId = PackageManager.taskPackageId(taskId);
            var icon = PackageManager.package("com.pelagicore.downloads").icon;
            var pkg = null;
            var packageName = "";

            if (packageId !== "") {
                icon = root.appServerUrl
                        + "/app/icon?id=" + packageId
                        + "&architecture=" + root.cpuArch;
                pkg = PackageManager.package(packageId);
                packageName = root.getPackageName(packageId);
            }

            if (pkg !== null) {
                if (pkg.state === ApplicationObject.Installed) {
                    showNotification(qsTr("%1 Uninstallation Failed").arg(packageName),
                                     qsTr("%1 uninstallation failed").arg(packageName), icon);
                }
            } else {
                showNotification(qsTr("%1 Installation Failed").arg(packageName),
                                 qsTr("%1 installation failed").arg(packageName), icon);
            }

            currentInstallationProgress = 0.0;
        }
        function onTaskFinished(taskId) {
            var packageId = PackageManager.taskPackageId(taskId);
            var icon = PackageManager.package("com.pelagicore.downloads").icon;
            var pkg = null;
            var packageName = "";

            if (packageId !== "") {
                icon = root.appServerUrl
                        + "/app/icon?id=" + packageId
                        + "&architecture=" + root.cpuArch;
                pkg = PackageManager.package(packageId);

                // cannot use name module from the application manager, because it won't work when
                // the application is uninstalled as it will return null. hence, the application
                // name need to be generated from the application id to be shown in the
                // notification.
                packageName = root.getPackageName(packageId);
            }

            if (pkg !== null) {
                if (pkg.builtIn) {
                    // Always installed (updated or not)
                    if (pkg.builtInHasRemovableUpdate) {
                        showNotification(qsTr("%1 Successfully updated").arg(packageName),
                                     qsTr("%1 successfully updated").arg(packageName), icon);
                    } else {
                        showNotification(qsTr("%1 Updates successfully Uninstalled")
                                         .arg(packageName),
                                         qsTr("%1 updates successfully uninstalled")
                                         .arg(packageName), icon);
                    }
                } else {
                    if (pkg.state === ApplicationObject.Installed) {
                        showNotification(qsTr("%1 Successfully Installed").arg(packageName),
                                     qsTr("%1 successfully installed").arg(packageName), icon);
                    } else {
                        showNotification(qsTr("%1 Successfully Uninstalled").arg(packageName),
                                         qsTr("%1 successfully uninstalled").arg(packageName),
                                         icon);
                    }
                }
            } else {
                showNotification(qsTr("%1 Successfully Uninstalled").arg(packageName),
                                 qsTr("%1 successfully uninstalled").arg(packageName), icon);
            }
            root.installedPackagesChanged()
        }
    }

    SystemInfo {
        id: sysinfo

        onInternetAccessChanged: {
            appStoreConfig.checkServer();
        }
        onConnectedChanged: {
            appStoreConfig.checkServer();
        }
    }

    // Server Configuration
    ServerConfig {
        id: appStoreConfig
        cpuArch: sysinfo.cpu + "-" + sysinfo.kernel
        qtVersion: sysinfo.qtVersion
    }

    ListModel {
        id: categoryListModel
        function refresh() {
            jsonCategoryModel.refresh();
        }
    }

    JSONModel {
        id: jsonCategoryModel

        url: appStoreConfig.serverUrl + "/category/list"
        onStatusChanged: {
            if (status === "loading" && categoryListModel.count > 0) {
                categoryListModel.clear();
                jsonAppModel.categoryId = 0;
            }

            if (status === "ready") {
                categoryListModel.clear();
                for (let i = 0; i < jsonCategoryModel.count; ++i) {
                    let cat = jsonCategoryModel.get(i);
                    categoryListModel.append({
                        "id": cat.id, "text": cat.name,
                        "sourceOn": root.appServerUrl + "/category/icon?id=" + cat.id,
                        "sourceOff": root.appServerUrl + "/category/icon?id=" + cat.id,
                    });
                }
            }
        }
    }

    ListModel {
        id: appModel
    }

    JSONModel {
        id: jsonAppModel

        property int categoryId: 0
        url: appStoreConfig.serverUrl + "/app/list"
        data: jsonAppModel.categoryId >= 0 ? ({ "filter" : root.filter ,
                                              "category_id" : jsonAppModel.categoryId})
                                   : ({ "filter" : root.filter})
        onStatusChanged: {
            appModel.clear();

            if (status === "ready") {
                let appList = [];
                for (let i = 0; i < jsonAppModel.count; ++i) {
                    let app = jsonAppModel.get(i);
                    let isInstalled = isPackageInstalledByPackageController(app.id)
                    appList.push({
                        "id": app.id,
                        "name": app.name,
                        "isInstalled": isInstalled,
                        "packageSizeText": isInstalled ? getInstalledPackageSizeText(app.id) : "",
                        "packageBuiltIn": isInstalled ? isPackageBuiltIn(app.id) : false,
                        "purchaseId": app.purchaseId,
                        "iconUrl": app.iconUrl
                    });
                }
                appModel.append(appList)
            }
        }
    }
}
