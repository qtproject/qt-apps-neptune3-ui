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

pragma Singleton
import QtQuick 2.8
import QtApplicationManager 1.0
import utils 1.0

QtObject {
    id: root

    property string activeAppId
    onActiveAppIdChanged: console.log("******* activeAppId = " + activeAppId)

    signal applicationSurfaceReady(ApplicationInfo appInfo, Item item)

    property var appInfoMap: new Object

    property var loggingCategory: LoggingCategory {
        id: logCategory
        name: "triton.applicationmanagermodel"
    }

    property var _appInfoComponent: Component {
        id: appInfoComponent
        ApplicationInfo {}
    }

    function application(appId) {
        if (!appInfoMap[appId]) {
            var appInfo = appInfoComponent.createObject();
            appInfo.application = ApplicationManager.application(appId);
            appInfoMap[appId] = appInfo;
            return appInfo;
        } else {
            return appInfoMap[appId];
        }
    }

    function appIdFromWindow(item) {
        return WindowManager.get(WindowManager.indexOfWindow(item)).applicationId
    }

    function goHome() {
        var appInfo = appInfoMap[root.activeAppId]
        if (appInfo) {
            appInfo.active = false;
        }
        root.activeAppId = ""
    }

    Component.onCompleted: {
        loadAppInfoMap();

        ApplicationManager.applicationWasActivated.connect(applicationActivatedHandler)
        WindowManager.windowReady.connect(windowReadyHandler)

        // TODO do something about it
        //WindowManager.windowClosing.connect(windowClosingHandler)

        WindowManager.windowLost.connect(windowLostHandler)
        WindowManager.windowPropertyChanged.connect(windowPropertyChangedHandler)
    }

    function loadAppInfoMap() {
        // TODO Get it from some file or database
        var appInfo = application("com.pelagicore.calendar");
        appInfo.widgetState = "home";
        appInfo.heightRows = 2;

        appInfo = application("com.pelagicore.maps");
        appInfo.widgetState = "home"
        appInfo.heightRows = 2;

        appInfo = application("com.pelagicore.music");
        appInfo.widgetState = "bottom";
    }

    function applicationActivatedHandler(appId, appAliasId) {
        console.log(logCategory, "applicationActivatedHandler: appId:" + appId + ", appAliasId:" + appAliasId)

        if (appId === root.activeAppId)
            return;

        var appInfo = application(appId)
        if (!appInfo.canBeActive)
            return;

        appInfo.active = true;

        appInfo = appInfoMap[root.activeAppId]
        if (appInfo) {
            appInfo.active = false;
        }

        root.activeAppId = appId

        for (var i = 0; i < WindowManager.count; i++) {
            if (!WindowManager.get(i).isClosing && WindowManager.get(i).applicationId === appId) {
                var item = WindowManager.get(i).windowItem
                root.applicationSurfaceReady(appInfo, item)
                break
            }
        }
    }

    function windowReadyHandler(index, item) {
        console.log(logCategory, "windowReadyHandler: index:" + index + ", item:" + item)

        var appID = WindowManager.get(index).applicationId;

        var appInfo = application(appID);
        appInfo.window = item;

        root.applicationSurfaceReady(appInfo, item)
    }

    function windowLostHandler(index, item) {
        // TODO care about animating before releasing
        WindowManager.releaseWindow(item)
    }


    function windowPropertyChangedHandler(window, name, value) {
        if (name === "activationCount") {
            var appId = WindowManager.get(WindowManager.indexOfWindow(window)).applicationId;
            ApplicationManager.application(appId).activated();
            root.applicationActivatedHandler(appId, appId);
        }
    }
}
