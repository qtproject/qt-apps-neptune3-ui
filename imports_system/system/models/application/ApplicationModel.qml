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

    // The Voice Assistant System UI Window (app window)
    readonly property var voiceAssistantWindow: d.voiceAssistantWindow

    // The HUD application.
    readonly property var hudAppInfo: d.hudAppInfo

    // The locale code (eg: "en_US") that is passed down to applications
    property string localeCode

    // Whether the model is still being populated. It's true during start up.
    readonly property alias populating: d.populating

    property bool showCluster: false
    property bool showHUD: false

    // Whether the Neptune 3 UI runs on single- / multi-process mode.
    readonly property bool singleProcess: ApplicationManager.singleProcess

    signal shuttingDown()
    signal applicationPopupAdded(var window)
    signal autostartAppsListChanged()
    signal autorecoverAppsListChanged()
    signal widgetStatesChanged()
    signal appRemoved(var appInfo);

    // Populate the model
    function populate(widgetStates, autostart, autorecover) {
        // Configures which applications should be shown as widgets,
        // which, in turn, will cause them to be started.
        d.deserializeWidgetStates(widgetStates);
        d.deserializeAutostart(autostart);
        d.deserializeAutorecover(autorecover);
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

    // Returns if item is system app
    function isSystemApp(appId) {
        var r = d.isBottomBarApp(appId);
        if (r)
            return true;

        r = d.isHUDApp(appId)
        if (r)
            return true;

        r = d.isInstrumentClusterApp(appId)
        if (r)
            return true;

        return false;
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

    function updateAutostart(appId, autostart) {
        for (var i = 0; i < root.count; i++) {
            var item = root.get(i);

            if (item.appInfo.id === appId)
                item.appInfo.autostart = autostart
        }
        root.autostartAppsListChanged()
    }

    function updateAutorecover(appId, autorecover) {
        for (var i = 0; i < root.count; i++) {
            var item = root.get(i);

            if (item.appInfo.id === appId) {
                item.appInfo.autorecover = autorecover
                //set default restart time to 5000 ms
                item.appInfo.restartTimer.interval = 5000
                item.appInfo.restartTimer.failedAttemptsCount = 0
            }
        }
        root.autorecoverAppsListChanged()
    }

    // Returns string list of autostart app's ids
    function serializeAutostart() {
        var appIds = [];

        for (var i = 0; i < root.count; i++) {
            var appInfo = root.get(i).appInfo;

            if (appInfo.autostart) {
                appIds.push(appInfo.id);
            }
        }
        return appIds.toString();
    }

    function serializeWidgetStates() {
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

    function serializeAutorecover() {
        var result = [];

        for (var i = 0; i < root.count; i++) {
            var appInfo = root.get(i).appInfo;
            if (appInfo.autorecover) {
                result.push(appInfo.id + ":" + appInfo.restartTimer.interval);
            }
        }
        return result.toString();
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
        property var widgetsStatesBeforeClose: ({})
        property var activeAppInfo: null
        property var instrumentClusterAppInfo: null
        property var bottomBarAppInfo: null
        property var hudAppInfo: null
        property var voiceAssistantWindow: null
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

            if (isInstrumentClusterApp(appInfo.application)) {
                d.instrumentClusterAppInfo = appInfo;
                return;
            }

            if (isHUDApp(appInfo.application)) {
                d.hudAppInfo = appInfo;
                return;
            }

            if (isBottomBarApp(appInfo.application)) {
                d.bottomBarAppInfo = appInfo;
                return;
            }

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

        function isVoiceAssistantApp(app)
        {
            return app.id === "com.luxoft.alexa"
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
            var appInfo = appInfoComponent.createObject(root, {"application": app});
            appInfo.localeCode = Qt.binding(function() { return root.localeCode; });

            appInfo.isSystemApp = root.isSystemApp(app)

            if (d.isInstrumentClusterApp(app)) {
                d.instrumentClusterAppInfo = appInfo;
            } else if (d.isBottomBarApp(app)) {
                d.bottomBarAppInfo = appInfo;
            } else if (d.isHUDApp(app)) {
                d.hudAppInfo = appInfo;
            }

            root.append({"appInfo": appInfo})
        }

        function deserializeWidgetStates(widgetStates)
        {
            var apps = widgetStates.split(",")

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

        function deserializeAutorecover(str)
        {
            var apps;

            var result = []
            apps = str.split(",")

            for (var i = 0; i < apps.length; i++) {
                var values = apps[i].split(":");
                result.push( {"id":values[0], "interval":values[1]} );
            }

            //reset to defaults
            for (i = 0; i < root.count; i++) {
                root.get(i).appInfo.autorecover = false;
                root.get(i).appInfo.restartTimer.interval = 0;
                root.get(i).appInfo.restartTimer.failedAttemptsCount = 0
            }

            //fill current values
            for (i = 0; i < result.length; i++) {
                var appInfo = root.applicationFromId(result[i].id);
                if (appInfo) {
                    appInfo.autorecover = true
                    appInfo.restartTimer.interval = result[i].interval
                }
            }
        }

        function deserializeAutostart(str)
        {
            //reset to defaults
            for (var i = 0; i < root.count; i++) {
                root.get(i).appInfo.autostart = false;
            }

            var apps;

            var result = []
            apps = str.split(",")

            for (i = 0; i < apps.length; i++) {
                var appInfo = root.applicationFromId(apps[i]);

                if (appInfo)
                    appInfo.autostart = true;
                else continue;

                var app = appInfo.application;
                if (!d.isInstrumentClusterApp(app) && !d.isHUDApp(app)) {
                    appInfo.start();
                    goHome(); // TODO: whether it always necessary?
                }

                // check if additional screen is attached and cluster is expected to be shown
                if (root.showCluster && d.isInstrumentClusterApp(app)) {
                    appInfo.start();
                }

                // check if additional screen is attached and hud is expected to be shown
                if (root.showHUD && d.isHUDApp(app)) {
                    appInfo.start();
                }
            }
        }

        function sendNotification(summary, body, icon) {
            var notification = Qt.createQmlObject("import QtApplicationManager 2.0; Notification {}", root, "notification")
            notification.summary = summary;
            notification.body = body;
            notification.icon = icon;
            notification.sticky = true;
            notification.priority = 2;
            notification.show();
        }
    }

    // this function iterates through current model and tries to fill 'runBefore' and 'runAfter' for
    // each appInfo inside it with available in current model appInfo-s
    function fillStartListsForCurrentModel() {
        // this loop works with AppInfo objects
        for (var i = 0; i < count; ++i) {
            var appInfo = get(i).appInfo;
            var runBefore = appInfo.application.applicationProperties["runBefore"];
            if (!!runBefore) {
                for (var rbi in runBefore) {
                    var rb_app = root.applicationFromId(runBefore[rbi]);
                    if (!!rb_app)
                        appInfo.runBefore.push(rb_app);
                }
            }

            var runAfter = appInfo.application.applicationProperties["runAfter"];
            if (!!runAfter) {
                for (var ra in runAfter) {
                    var ra_app = root.applicationFromId(ra);
                    if (!!ra_app)
                        appInfo.runAfter.push(ra_app);
                }
            }
        }

        for (i = 0; i < count; ++i) {
            appInfo = get(i).appInfo;
            appInfo.runBefore = [...new Set(appInfo.runBefore)];
            appInfo.runAfter = [...new Set(appInfo.runAfter)];
        }
    }

    Component.onCompleted: {
        // details: the loop below fills the application model from 'raw' QtAM::application
        // with AppInfo objects
        var i;
        for (i = 0; i < ApplicationManager.count; i++) {
            var app = ApplicationManager.application(i);
            d.appendApplication(app);
        }

        fillStartListsForCurrentModel();
    }

    property var appManConns: Connections {
        target: ApplicationManager
        function onApplicationWasActivated(id, aliasId) { d.reactOnAppActivation(id); }
        function onApplicationRunStateChanged(id, runState) {
            var appInfo = root.applicationFromId(id);
            if (!appInfo) {
                return;
            }

            if (runState === ApplicationObject.NotRunning) {
                if (!root.isSystemApp(appInfo)) {
                    if (appInfo === d.activeAppInfo) {
                        root.goHome();
                    }

                    d.widgetsStatesBeforeClose[appInfo.name] = appInfo.asWidget;
                    if (appInfo.asWidget) {
                        // otherwise the widget would get maximized once restarted.
                        appInfo.canBeActive = false;

                        // Application was killed or crashed while being displayed as a widget.
                        // Remove it from the widget list
                        appInfo.asWidget = false;
                    }
                }

                if (appInfo.autorecover) {

                    if (appInfo.application) {
                        //non-zero exit code or crash exit -> increase failed attempts
                        if ( (appInfo.application.lastExitStatus === Am.NormalExit) && (appInfo.application.exitCode !== 0)
                                || (appInfo.application.lastExitStatus === Am.CrashExit) ) {
                            appInfo.restartTimer.failedAttemptsCount = appInfo.restartTimer.failedAttemptsCount + 1
                        }

                        if (appInfo.restartTimer.failedAttemptsCount < 3) {
                            //start single-shot timer to restart app in timer interval time
                            appInfo.restartTimer.start()
                        } else {
                            appInfo.autorecover = false
                            var text = qsTr("Failed to start " + appInfo.name)
                            d.sendNotification(text, text, appInfo.icon)
                        }
                    }
                }
            }

            if (runState === ApplicationObject.Running && appInfo.autorecover
                    && appInfo.name in d.widgetsStatesBeforeClose)
            {
                appInfo.asWidget = d.widgetsStatesBeforeClose[appInfo.name]
            }
        }

        function onApplicationAdded(id) {
            var app = ApplicationManager.application(id);
            d.appendApplication(app);

            fillStartListsForCurrentModel();
        }

        function onApplicationAboutToBeRemoved(id) {
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

            if (d.instrumentClusterAppInfo === appInfo) {
                d.instrumentClusterAppInfo = null;
            } else if (d.hudAppInfo === appInfo) {
                d.hudAppInfo = null;
            } else if (d.bottomBarAppInfo === appInfo) {
                d.bottomBarAppInfo = null;
            }

            root.remove(index);
            root.appRemoved(appInfo);
        }

        function onShuttingDownChanged() {
            if (ApplicationManager.shuttingDown) {
                root.shuttingDown();
            }
        }
    }

    property var winManConns: Connections {
        target: WindowManager

        function onWindowAdded(window) {
            var appInfo = applicationFromId(window.application.id);

            var isRegularApp = !!appInfo && !root.isSystemApp(appInfo);

            var isPopupWindow = window.windowProperty("windowType") === "popup" || !!window.popup;

            if (isPopupWindow) {
                root.applicationPopupAdded(window)
            }

            if (isRegularApp && !isPopupWindow) {
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
            }

            if (d.isBottomBarApp(window.application) && !isPopupWindow) {
                d.bottomBarAppInfo.priv.window = window;
            }

            if (d.isHUDApp(window.application)) {
                d.hudAppInfo.priv.window = window;
            }

            if (d.isInstrumentClusterApp(window.application)) {
                d.instrumentClusterAppInfo.priv.window = window;
            }

            if (d.isVoiceAssistantApp(window.application)
                    && window.windowProperty("windowType") === "statusbar") {
                d.voiceAssistantWindow = window;
            }
        }

        function onWindowAboutToBeRemoved(window) {
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

            if (d.isVoiceAssistantApp(appInfo)) {
                d.voiceAssistantWindow = null
            }
        }

        function onWindowPropertyChanged(window, name, value) {
            var appInfo = applicationFromId(window.application.id);
            switch (name) {
            case "activationCount":
                //rises running app on property change, can be used to show-up window of
                //already running app e.g. from intent
                window.application.activated();
                d.reactOnAppActivation(window.application.id);
                break;
            case "neptuneState":
                if (window.windowProperty(name).startsWith("Widget") && root.activeAppInfo === null)
                    root.widgetStatesChanged()
                break;
            }
        }
    }
}
