/****************************************************************************
**
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

import QtQuick 2.7
import QtApplicationManager 1.0 as AM

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

    // If false, Application.activated signals won't cause the application to be the active one
    // TODO: try to get rid of this (ie, find a better solution)
    property bool canBeActive: true

    // The main window of this application, if any
    //
    // It can be displayed on the center console screen.
    readonly property var window: d.window

    // the secondary window of this application, if any
    //
    // It can be displayed on the instrument cluster screen
    readonly property var secondaryWindow: d.secondaryWindow

    // State if the main window in the neptune system UI
    // Valid values are: "Widget1Row", "Widget2Rows", "Widget3Rows" and "Maximized"
    // See also: window, widgetHeight
    property string windowState

    // When the window is being displayed as a widget, that's the height its UI should have
    property int widgetHeight: 0

    // Currrent window height
    //
    // The window is kept maximized and it's clipped to fit currentHeight
    // Application code relayouts *all* of its contents so that they fit currentHeight
    property int currentHeight: 0

    // Currrent window width
    property int currentWidth: 0

    // UI scale factor to be applied to window. See NeptuneStyle.scale
    property real windowScale: 1

    // UI scale factor to be applied to secondaryWindow. See NeptuneStyle.scale
    property real secondaryWindowScale: 1

    // Whether the application window should be shown as a widget
    property bool asWidget: false

    // Widget geometry. Ignored if asWidget === false
    property int heightRows: 1
    property int minHeightRows: 1

    // Whether the application process is running
    readonly property bool running: application ? application.runState === AM.Application.Running : false

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
        Margins of the exposed rectangular area of the apps main window

        The area of the apps main window that is directly visible to the user (ie, exposed) and not occluded
        by other items in the system ui is defined by a rectangle anchored to all screen edges.
     */
    property real exposedRectBottomMargin
    property real exposedRectTopMargin

    /*
        Whether a performance monitor overlay is enabled on the primary window
     */
    property bool windowPerfMonitorEnabled: false

    /*
        Whether a performance monitor overlay is enabled on the secondary window
     */
    property bool secondaryWindowPerfMonitorEnabled: false

    /*
        Time elapsed between start() was called and the moment sysui received its first
        frame from window
     */
    readonly property int timeToFirstWindowFrame:
        d.startCallTime !== null && d.windowFirstFrameTime !== null ? d.windowFirstFrameTime - d.startCallTime
                                                                    : -1

    /*
        Time elapsed between start() was called and the moment sysui received its first
        frame from secondaryWindow
     */
    readonly property int timeToFirstSecondaryWindowFrame:
        d.startCallTime !== null && d.secondaryWindowFirstFrameTime !== null ? d.secondaryWindowFirstFrameTime - d.startCallTime
                                                                    : -1
    function start() {
        // TODO Add a start() method to QtAM::Application itself
        if (application) {
            if (application.runState === AM.Application.NotRunning && d.startCallTime === null) {
                d.startCallTime = Date.now();
            }
            AM.ApplicationManager.startApplication(id);
        }
    }

    function stop() {
        // TODO Add a stop() method to QtAM::Application itself
        if (application) {
            AM.ApplicationManager.stopApplication(id);
        }
    }

    onWindowChanged: {
        if (window) {
            AM.WindowManager.setWindowProperty(window, "neptuneScale", windowScale);
            AM.WindowManager.setWindowProperty(window, "neptuneWidgetHeight", widgetHeight);
            AM.WindowManager.setWindowProperty(window, "neptuneCurrentWidth", currentWidth);
            AM.WindowManager.setWindowProperty(window, "neptuneCurrentHeight", currentHeight);
            AM.WindowManager.setWindowProperty(window, "neptuneState", windowState);
            AM.WindowManager.setWindowProperty(window, "exposedRectBottomMargin", exposedRectBottomMargin);
            AM.WindowManager.setWindowProperty(window, "exposedRectTopMargin", exposedRectTopMargin);
            AM.WindowManager.setWindowProperty(window, "performanceMonitorEnabled", windowPerfMonitorEnabled);
        }
    }

    onWindowScaleChanged: {
        if (window)
            AM.WindowManager.setWindowProperty(window, "neptuneScale", windowScale);
    }
    onWidgetHeightChanged: {
        if (window)
            AM.WindowManager.setWindowProperty(window, "neptuneWidgetHeight", widgetHeight);
    }
    onCurrentWidthChanged: {
        if (window)
            AM.WindowManager.setWindowProperty(window, "neptuneCurrentWidth", currentWidth);
    }
    onCurrentHeightChanged: {
        if (window)
            AM.WindowManager.setWindowProperty(window, "neptuneCurrentHeight", currentHeight);
    }
    onWindowStateChanged: {
        if (window)
            AM.WindowManager.setWindowProperty(window, "neptuneState", windowState);
    }
    onExposedRectBottomMarginChanged: {
        if (window)
            AM.WindowManager.setWindowProperty(window, "exposedRectBottomMargin", exposedRectBottomMargin);
    }
    onExposedRectTopMarginChanged: {
        if (window)
            AM.WindowManager.setWindowProperty(window, "exposedRectTopMargin", exposedRectTopMargin);
    }
    onWindowPerfMonitorEnabledChanged: {
        if (window)
            AM.WindowManager.setWindowProperty(window, "performanceMonitorEnabled", windowPerfMonitorEnabled);
    }
    onSecondaryWindowPerfMonitorEnabledChanged: {
        if (window)
            AM.WindowManager.setWindowProperty(secondaryWindow, "performanceMonitorEnabled", secondaryWindowPerfMonitorEnabled);
    }

    onSecondaryWindowChanged: {
        if (secondaryWindow)
            AM.WindowManager.setWindowProperty(secondaryWindow, "neptuneScale", secondaryWindowScale);
            AM.WindowManager.setWindowProperty(secondaryWindow, "performanceMonitorEnabled", secondaryWindowPerfMonitorEnabled);
    }

    onSecondaryWindowScaleChanged: {
        if (secondaryWindow)
            AM.WindowManager.setWindowProperty(secondaryWindow, "neptuneScale", secondaryWindowScale);
    }

    onAsWidgetChanged: {
        if (asWidget && application.runState === AM.Application.NotRunning) {
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
        property var secondaryWindow: null

        // Time when start() was called, in ms since Unix Epoch
        property var startCallTime: null

        // Time when window had its first frame rendered, in ms since Unix Epoch
        property var windowFirstFrameTime: null

        // Time when secondaryWindow had its first frame rendered, in ms since Unix Epoch
        property var secondaryWindowFirstFrameTime: null

        property var appConns: Connections {
            target: root.application
            enabled: target != null
            ignoreUnknownSignals: true
            onRunStateChanged: {
                if (root.application.runState === AM.Application.NotRunning) {
                    d.startCallTime = null;
                }
            }
        }

        property var windowConns: Connections {
            target: d.window ? d.window.surface : null
            enabled: target != null && d.windowFirstFrameTime === null
            ignoreUnknownSignals: true
            onRedraw: {
                d.windowFirstFrameTime = Date.now();
            }
        }

        property var secondaryWindowConns: Connections {
            target: d.secondaryWindow ? d.secondaryWindow.surface : null
            enabled: target != null && d.secondaryWindowFirstFrameTime === null
            ignoreUnknownSignals: true
            onRedraw: {
                d.secondaryWindowFirstFrameTime = Date.now();
            }
        }

        onWindowChanged: {
            if (!window) {
                windowFirstFrameTime = null;
            }
        }

        onSecondaryWindowChanged: {
            if (!secondaryWindow) {
                secondaryWindowFirstFrameTime = null;
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
