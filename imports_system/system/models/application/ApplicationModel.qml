/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
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

import QtQuick 2.8
import QtApplicationManager.SystemUI 2.0
import system.requests 1.0

/*
  A list of ApplicationInfo objects.
*/
ListModel {
    id: root

    // The currently active application. The active application should be displayed in a maximized state.
    readonly property var activeAppInfo: d.activeAppInfo

    // The instrument cluster application.
    readonly property var instrumentClusterAppInfo: d.instrumentClusterAppInfo

    // The bottom bar application.
    readonly property var bottomBarAppInfo: d.bottomBarAppInfo

    // The HUD application.
    readonly property var hudAppInfo: d.hudAppInfo

    // The locale code (eg: "en_US") that is passed down to applications
    property string localeCode

    // Whether the model is still being populated. It's true during start up.
    readonly property alias populating: d.populating

    // Whether the Neptune 3 UI runs on single- / multi-process mode.
    readonly property bool singleProcess: ApplicationManager.singleProcess

    signal shuttingDown()
    signal applicationPopupAdded(var window)

    // Populate the model
    function populate(widgetStates) {
        // Configures which applications should be shown as widgets,
        // which, in turn, will cause them to be started.
        d.deserializeWidgetsState(widgetStates);
        d.populating = false;
    }

    // Returns an ApplicationInfo given its index
    function application(index) {
        return get(index).appInfo;
    }

    // Returns an ApplicationInfo given its id
    function applicationFromId(appId) {
        for (var i = 0; i < count; i++) {
            var appInfo = get(i).appInfo;
            if (appInfo.id === appId) {
                return appInfo;
            }
        }
        return null;
    }

    function goBack() {
        //if a request is sent
        if (d.applicationRequestHandler.history.length > 1) {
            d.applicationRequestHandler.goBack();
        } else {
            //else return to home
            goHome();
        }
    }

    function serializeWidgetsState() {
        var appWidgetIds = [];
        var appWidgetHeights = [];
        var widgetStates = [];

        for (var i = 0; i < root.count; i++) {
            var appInfo = root.get(i).appInfo;
            if (appInfo.asWidget) {
                appWidgetIds.push(appInfo.id);
                appWidgetHeights.push(appInfo.heightRows)
            }
        }

        for (var j = 0; j < appWidgetIds.length; j++) {
            var appIdAndHeight = appWidgetIds[j] + ":" + appWidgetHeights[j];
            widgetStates.push(appIdAndHeight);
        }
        return widgetStates.toString();
    }

    // Go back to the home screen.
    //
    // It deactivates the currently active application, if any.
    // When there is no active application the home screen should be
    // seen instead, hence the name.
    function goHome() {
        if (d.activeAppInfo) {
            d.activeAppInfo.priv.active = false;
            d.activeAppInfo = null;
            console.log(d.logCat, "activeAppId=<empty>");
        }
    }

    property var priv: QtObject {
        id: d
        property var activeAppInfo: null
        property var instrumentClusterAppInfo: null
        property var bottomBarAppInfo: null
        property var hudAppInfo: null
        property bool populating: true
        property ApplicationRequestHandler applicationRequestHandler: ApplicationRequestHandler {
            id: applicationRequestHandler
            activeAppId: activeAppInfo ? activeAppInfo.id : ""
        }
        readonly property var logCat: LoggingCategory {
            name: "applicationmodel"
        }

        function reactOnAppActivation(appId) {
            if (d.activeAppInfo && appId === d.activeAppInfo.id)
                return;

            var appInfo = root.applicationFromId(appId);
            if (!appInfo || !appInfo.canBeActive)
                return;

            appInfo.priv.active = true;

            if (d.activeAppInfo) {
                d.activeAppInfo.priv.active = false;
            }

            d.activeAppInfo = appInfo;
            console.log(d.logCat, "activeAppId=" + d.activeAppInfo.id);
        }

        function isInstrumentClusterApp(app)
        {
            return app.categories.indexOf("cluster") >= 0;
        }

        function isBottomBarApp(app)
        {
            return app.categories.indexOf("bottombar") >= 0;
        }

        function isHUDApp(app)
        {
            return app.categories.indexOf("hud") >= 0;
        }
        property Component appInfoComponent: Component { ApplicationInfo{} }
        function appendApplication(app) {
            var appInfo = appInfoComponent.createObject(root, {"application":app});
            appInfo.localeCode = Qt.binding(function() { return root.localeCode; });

            if (d.isInstrumentClusterApp(app)) {
                d.instrumentClusterAppInfo = appInfo;
                appInfo.start();
            } else if (d.isBottomBarApp(app)) {
                d.bottomBarAppInfo = appInfo;
                appInfo.start();
            } else if (d.isHUDApp(app)) {
                d.hudAppInfo = appInfo;
                appInfo.start();
            } else {
                root.append({"appInfo":appInfo});
            }
        }

        function deserializeWidgetsState(widgetStates)
        {
            var apps;

            // if there are no widgets stored in the settings, the default widget states is being used instead
            if (widgetStates === "") {
                apps = ["com.pelagicore.phone:2", "com.pelagicore.music:2", "com.pelagicore.calendar:1"]
            } else {
                apps = widgetStates.split(",")
            }

            var appIds = []
            var appHeights = []

            for (var i = 0; i < apps.length; i++) {
                var values = apps[i].split(":");
                appIds.push(values[0]);
                appHeights.push(values[1]);
            }

            for (var j = 0; j < appIds.length; j++) {
                var appInfos = root.applicationFromId(appIds[j]);
                if (appInfos) {
                    appInfos.asWidget = true;
                    appInfos.heightRows = Number(appHeights[j]);
                }
            }
        }
    }

    Component.onCompleted: {
        var i;
        for (i = 0; i < ApplicationManager.count; i++) {
            var app = ApplicationManager.application(i);
            d.appendApplication(app);
        }
    }

    property var appManConns: Connections {
        target: ApplicationManager

        onApplicationWasActivated: d.reactOnAppActivation(id);

        onApplicationRunStateChanged: {
            var appInfo = root.applicationFromId(id);
            if (!appInfo) {
                return;
            }

            if (runState === ApplicationObject.NotRunning) {
                if (appInfo === d.activeAppInfo) {
                    root.goHome();
                }
                if (appInfo.asWidget) {
                    // otherwise the widget would get maximized once restarted.
                    appInfo.canBeActive = false;

                    // Application was killed or crashed while being displayed as a widget.
                    // Remove it from the widget list
                    appInfo.asWidget = false;
                }
            }
        }

        onApplicationAdded: {
            var app = ApplicationManager.application(id);
            d.appendApplication(app);
        }

        onApplicationAboutToBeRemoved: {
            var appInfo = null;
            var index;

            for (index = 0; index < count; index++) {
                var someAppInfo = get(index).appInfo;
                if (someAppInfo.id === id) {
                    appInfo = someAppInfo;
                    break;
                }
            }

            console.assert(!!appInfo);

            if (d.activeAppInfo === appInfo) {
                root.goHome();
            }
            if (appInfo.asWidget) {
                appInfo.asWidget = false;
            }

            root.remove(index);
        }

        onShuttingDownChanged: {
            if (ApplicationManager.shuttingDown) {
                root.shuttingDown();
            }
        }
    }

    property var winManConns: Connections {
        target: WindowManager

        onWindowAdded: {
            var appInfo = applicationFromId(window.application.id);

            var isRegularApp = !!appInfo;

            var isPopupWindow = window.windowProperty("windowType") === "popup";

            if (isPopupWindow) {
                root.applicationPopupAdded(window)
            }

            if (isRegularApp) {
                var isApplicationICWindow = window.windowProperty("windowType") === "instrumentcluster";
                var isApplicationCCWindow = !window.windowProperty("windowType");

                if (isApplicationICWindow) {
                    appInfo.priv.icWindow = window;
                } else if (isApplicationCCWindow) {
                    appInfo.priv.window = window;
                    appInfo.canBeActive = true;
                }
            // need to check if the window is not a popup, otherwise, a popup window that belongs to the bottom bar
            // application will be added to the bottom bar window as well
            } else if (d.isBottomBarApp(window.application) && window.windowProperty("windowType") !== "popup") {
                d.bottomBarAppInfo.priv.window = window;
            } else if (d.isHUDApp(window.application)) {
                d.hudAppInfo.priv.window = window;
            } else if (d.isInstrumentClusterApp(window.application)) {
                d.instrumentClusterAppInfo.priv.window = window;
            }
        }

        onWindowAboutToBeRemoved: {
            var appInfo = applicationFromId(window.application.id);
            if (!appInfo) {
                if (d.isInstrumentClusterApp(window.application)) {
                    appInfo = d.instrumentClusterAppInfo;
                } else if (d.isBottomBarApp(window.application)) {
                    appInfo = d.bottomBarAppInfo;
                } else if (d.isHUDApp(window.application)) {
                    appInfo = d.hudAppInfo;
                }
            }

            if (appInfo.priv.window === window) {
                appInfo.priv.window = null;
            } else if (appInfo.priv.icWindow === window) {
                appInfo.priv.icWindow = null;
            }
        }

        onWindowPropertyChanged: {
            var appInfo = applicationFromId(window.application.id);
            switch (name) {
            case "activationCount":
                window.application.activated();
                d.reactOnAppActivation(window.application.id);
                break;
            }
        }
    }
}
