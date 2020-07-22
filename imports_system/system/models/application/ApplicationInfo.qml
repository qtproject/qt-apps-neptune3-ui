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
import QtApplicationManager.SystemUI 2.0

/*
    Wraps QtAM::Application object adding some more properties and concepts specific to Neptune 3.
 */
QtObject {
    id: root

    // The QtAM::Application object
    property var application: null

    property string localeCode

    // Whether the application is active (on foreground / fullscreen)
    // false means it's either invisible, minimized, reduced to a widget geometry
    // or might not even be running at all
    readonly property bool active: d.active

    // If false, ApplicationObject.activated signals won't cause the application to be the active one
    // TODO: try to get rid of this (ie, find a better solution)
    property bool canBeActive: true

    // The main window of this application, if any
    //
    // It can be displayed on the center console screen.
    readonly property var window: d.window

    // the application instrument cluster window of this application, if any
    //
    // It can be displayed on the instrument cluster screen
    readonly property var icWindow: d.icWindow

    // Whether the application window should be shown as a widget
    property bool asWidget: false

    // Widget geometry. Ignored if asWidget === false
    property int heightRows: 1
    property int minHeightRows: 1

    // Whether the application process is running
    readonly property bool running: application ? application.runState === ApplicationObject.Running : false

    readonly property string id: application ? application.id : ""
    readonly property url icon: application ? application.icon : ""
    readonly property var categories: application ? application.categories : []
    readonly property string name: {
        if (application) {
            var result = application.name(d.languageCode);
            return result ? result : application.name("en");
        } else {
            return "???";
        }
    }

    /*
        Whether a performance monitor overlay is enabled on the primary window
     */
    property bool windowPerfMonitorEnabled: false

    /*
        Whether a performance monitor overlay is enabled on the application IC window
     */
    property bool icWindowPerfMonitorEnabled: false

    /*
        Whether application is System Application
    */
    property bool isSystemApp: false

    /*
        Whether application is started with Neptune UI
    */
    property bool autostart: false

    /*
        Whether application is re-started after stop in
    */
    property bool autorecover: false

    /*
        Single shot Timer to restart application if set by autorecovery
        Default restart attempt in 5 seconds
    */
    property var restartTimer: Timer { property int failedAttemptsCount: 0; interval: 5000; onTriggered: { root.start(); } }

    /*
        Time elapsed between start() was called and the moment sysui received its first
        frame from window
     */
    readonly property int timeToFirstWindowFrame:
        d.startCallTime !== null && d.windowFirstFrameTime !== null ? d.windowFirstFrameTime - d.startCallTime
                                                                    : -1

    /*
        Time elapsed between start() was called and the moment sysui received its first
        frame from icWindow
     */
    readonly property int timeToFirstICWindowFrame:
        d.startCallTime !== null && d.icWindowFirstFrameTime !== null ? d.icWindowFirstFrameTime - d.startCallTime
                                                                    : -1

    /* List of apps to be launched before this app, if \s start is requested */
    property var runBefore: []

    /* List of apps to be launched after this app, if \s start is requested */
    property var runAfter: []

    function start() {
        if (!!application) {
            if (!!root.runBefore) {
                for (var appinfo_i in root.runBefore) {
                    var rb_app = root.runBefore[appinfo_i];
                    if (!!rb_app)
                        rb_app.start();
                }
            }

            if (application.runState === ApplicationObject.NotRunning && d.startCallTime === null) {
                d.startCallTime = Date.now();
            }

            application.start();

            if (!!root.runAfter) {
                for (appinfo_i in root.runAfter) {
                    var ra_app = root.runBefore[appinfo_i];
                    if (!!ra_app)
                        ra_app.start();
                }
            }
        }
    }

    function stop() {
        if (application) {
            application.stop();
        }
    }

    onAsWidgetChanged: {
        if (asWidget && application.runState === ApplicationObject.NotRunning) {
            // Starting an app causes it to emit activated() but we don't want it to go active (as being
            // active makes it maximized/fullscreen). We want it to stay as a widget.
            canBeActive = false;
            start();
        }
    }

    property var priv: QtObject {
        id: d
        property bool active: false
        property var window: null
        property var icWindow: null

        // Time when start() was called, in ms since Unix Epoch
        property var startCallTime: null

        // Time when window had its first frame rendered, in ms since Unix Epoch
        property var windowFirstFrameTime: null

        // Time when icWindow had its first frame rendered, in ms since Unix Epoch
        property var icWindowFirstFrameTime: null

        property var appConns: Connections {
            target: root.application
            enabled: target != null
            ignoreUnknownSignals: true
            function onRunStateChanged() {
                if (root.application.runState === ApplicationObject.NotRunning) {
                    d.startCallTime = null;
                }
            }
        }

        property var windowConns: Connections {
            target: d.window && d.window.waylandSurface ? d.window.waylandSurface : null
            enabled: target != null && d.windowFirstFrameTime === null
            ignoreUnknownSignals: true
            function onRedraw() {
                d.windowFirstFrameTime = Date.now();
            }
        }

        property var icWindowConns: Connections {
            target: d.icWindow && d.icWindow.waylandSurface ? d.icWindow.waylandSurface : null
            enabled: target != null && d.icWindowFirstFrameTime === null
            ignoreUnknownSignals: true
            function onRedraw() {
                d.icWindowFirstFrameTime = Date.now();
            }
        }

        onWindowChanged: {
            if (!window) {
                windowFirstFrameTime = null;
            }
        }

        onIcWindowChanged: {
            if (!icWindow) {
                icWindowFirstFrameTime = null;
            }
        }

        // ISO 639-1 two-letter language code (eg: "en", "de, "zh")
        readonly property string languageCode: {
            // eg: if locale is "en_US", the language code part is "en"
            var index = root.localeCode.indexOf("_");
            if (index === -1) {
                if (root.localeCode.length === 2) {
                    // seems it has just the language code there
                    return root.localeCode;
                } else {
                    return "en";
                }
            } else {
                return root.localeCode.substr(0, index);
            }
        }
    }
}
