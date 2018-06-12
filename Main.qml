/****************************************************************************
**
** Copyright (C) 2017, 2018 Pelagicore AG
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
import QtQuick.Controls 2.2
import Qt.labs.platform 1.0

import animations 1.0
import com.pelagicore.styles.neptune 3.0
import display 1.0
import notification 1.0
import models.system 1.0
import utils 1.0
import instrumentcluster 1.0
import com.pelagicore.settings 1.0

import QtQuick.Window 2.3

import QtApplicationManager 1.0

Window {
    id: root

    title: "Neptune UI - Center Console"
    color: "black"

    readonly property bool isLandscape: width > height
    readonly property real smallerDimension: isLandscape ? height : width
    readonly property real largerDimension: isLandscape ? width : height

    // Load the full UI once a first frame has been drawn with the ligth UI version
    // FIXME: Find a better way of finding out when the first proper frame has been
    //       rendered (scene no longer dirty. render thread idle)
    Connections {
        id: windowConns
        target: root
        onFrameSwapped: {
            display.loadUI();
            notificationLoader.active = true;
            windowConns.enabled = false;
        }
    }

    Display {
        id: display

        onWidthChanged: {
            root.contentItem.NeptuneStyle.scale = display.width / Style.centerConsoleWidth;
        }

        onScreenshotRequested: screenshot.dumpScreenshotAndVersion()

        // If the Window aspect ratio differs from Style.centerConsoleAspectRatio the Display item will be
        // letterboxed so that a Style.centerConsoleAspectRatio is preserved.
        states: [
            State {
                name: "constrainWidth"
                when: display.availableAspectRatio > Style.centerConsoleAspectRatio
                PropertyChanges { target: display
                    width: display.height * Style.centerConsoleAspectRatio
                    height: display.availableHeight
                }
            },
            State {
                name: "constrainHeight"
                when: display.availableAspectRatio <= Style.centerConsoleAspectRatio
                PropertyChanges { target: display
                    width: display.availableWidth
                    height: display.width / Style.centerConsoleAspectRatio
                }
            }
        ]

        readonly property real availableAspectRatio: availableWidth / availableHeight
        readonly property real availableWidth: orientationIsSomePortrait ? root.smallerDimension : root.largerDimension
        readonly property real availableHeight: orientationIsSomePortrait ? root.largerDimension : root.smallerDimension

        readonly property bool orientationIsSomePortrait: orientation === Qt.PortraitOrientation
                                                       || orientation === Qt.InvertedPortraitOrientation

        property int orientation: {
            var value = root.orientationFromString(ApplicationManager.systemProperties.orientation);
            return invertedOrientation ? root.invertOrientation(value) : value;
        }
        property bool invertedOrientation: false

        anchors.centerIn: parent

        settings: uiSettings

        rotation: {
            if (root.isLandscape) {
                switch (orientation) {
                    case Qt.PortraitOrientation:
                        return 90;
                    case Qt.LandscapeOrientation:
                        return 0;
                    case Qt.InvertedPortraitOrientation:
                        return -90;
                    case Qt.InvertedLandscapeOrientation:
                        return 180;
                    default:
                        return 0;
                }
            } else {
                switch (orientation) {
                    case Qt.PortraitOrientation:
                        return 0;
                    case Qt.LandscapeOrientation:
                        return -90;
                    case Qt.InvertedPortraitOrientation:
                        return 180;
                    case Qt.InvertedLandscapeOrientation:
                        return 90;
                    default:
                        return 0;
                }
            }
        }

        popupParent: popupParent

        focus: true

        UISettings {
            id: uiSettings
            onLanguageChanged: {
                if (language !== Style.languageLocale) {
                    Style.languageLocale = language;
                }
            }
            onThemeChanged: updateTheme()
            onAccentColorChanged: {
                root.contentItem.NeptuneStyle.accentColor = accentColor;
            }
            Component.onCompleted: updateTheme()
            function updateTheme() {
                var chosenTheme = theme === 0 ? NeptuneStyle.Light : NeptuneStyle.Dark;
                if (popupParent.visible) {
                    popupParent.updateOverlay();
                }
                root.contentItem.NeptuneStyle.theme = chosenTheme;
                if (instrumentClusterWindowLoader.item) {
                    instrumentClusterWindowLoader.item.contentItem.NeptuneStyle.theme = chosenTheme;
                }
            }
        }

        InstrumentCluster {
            id: clusterSettings
            available: instrumentClusterWindowLoader.item && instrumentClusterWindowLoader.item.visible
        }

        // N.B. need to use a Timer here to "push" the available languages to settings server
        // since it uses QMetaObject::invokeMethod(), possibly running in a different thread
        Timer {
            id: timer
            interval: 100
            onTriggered: uiSettings.languages = Style.translation.availableTranslations;
        }

        Component.onCompleted: {
            timer.start();
        }

        Shortcut {
            sequence: "Ctrl+r"
            context: Qt.ApplicationShortcut
            onActivated: {
                display.invertedOrientation = !display.invertedOrientation
            }
        }
        Shortcut {
            sequence: "Ctrl+Shift+r"
            context: Qt.ApplicationShortcut
            onActivated: {
                instrumentClusterWindowLoader.invertedOrientation = !instrumentClusterWindowLoader.invertedOrientation
            }
        }
        Shortcut {
            sequence: "Ctrl+t"
            context: Qt.ApplicationShortcut
            onActivated: {
                uiSettings.theme = uiSettings.theme === 0 ? 1 : 0
            }
        }
        Shortcut {
            sequence: "Ctrl+l"
            context: Qt.ApplicationShortcut
            onActivated: {
                const locales = Style.translation.availableTranslations;
                const currentLocale = Style.languageLocale;
                const currentIndex = locales.indexOf(currentLocale);
                var nextIndex = currentIndex === locales.length - 1 ? 0 : currentIndex + 1;
                uiSettings.language = locales[nextIndex];
            }
        }

        Shortcut {
            sequence: "Ctrl+c"
            context: Qt.ApplicationShortcut
            onActivated: {
                if (instrumentClusterWindowLoader.item)
                    instrumentClusterWindowLoader.item.nextSecondaryWindow();
            }
        }
        Shortcut {
        //simulates hard key back press
            sequence: "Ctrl+b"
            context: Qt.ApplicationShortcut
            onActivated: {
                display.applicationModel.goBack();
            }
        }
        Shortcut {
            sequence: "Ctrl+n"
            context: Qt.ApplicationShortcut
            onActivated: {
                notificationInterface.show();
            }
        }

        Shortcut {
            id: screenshot
            sequence: "Ctrl+p"
            context: Qt.ApplicationShortcut

            function saveFile(fileUrl, text) {
                var request = new XMLHttpRequest();
                request.open("PUT", fileUrl);
                request.send("Neptune 3: " + Qt.application.version + "\n" +
                             "Qt Application Manager: %1".arg(qtamVersion) + "\n" +
                             "Qt IVI: %1".arg(qtiviVersion) + "\n\n" +
                             text);
            }

            function dumpScreenshotAndVersion() {
                var tempDir = StandardPaths.writableLocation(StandardPaths.TempLocation).toString();
                tempDir = tempDir.substring(tempDir.indexOf('://')+3); // convert from url to filepath
                const timestamp = new Date().toISOString();
                const screenshotUrl = tempDir + "/" + timestamp + "_neptune3_screenshot.png";
                display.grabToImage(function(result) {
                    var ret = result.saveToFile(screenshotUrl);
                    console.info("Screenshot was", ret ? "" : "NOT", "saved to file", screenshotUrl);
                });

                const diagFile = tempDir + "/" + timestamp + "_neptune3_versions.txt";
                saveFile(diagFile, display.sysInfo.qtDiag);

                notificationInterfaceInfo.summary = qsTr("UI screenshot has been taken successfully");
                notificationInterfaceInfo.body = qsTr("UI screenshot and diagnostics information are stored in %1").arg(tempDir);
                notificationInterfaceInfo.show();
            }

            onActivated: {
                dumpScreenshotAndVersion();
            }
        }
    }

    ModalOverlay {
        id: popupParent
        anchors.fill: display
        target: display
    }

    // simulates battery low event if accessory button is pressed, the UI
    // jumps directly to navigation app, setting the route to the proposed charging station
    // if not, a warning notification will be shown and stored in the notification center
    Notification {
        id: notificationInterface
        property bool actionAccepted: false
        summary: qsTr("Battery level is low")
        body: qsTr("Start route to nearest charging station?")
        timeout: 4000
        showActionsAsIcons: true
        actions: [{"actionText": qsTr("Show on Map")}]
        category: "notification"
        onActionTriggered: {
            //jump to navigation app
            Qt.openUrlExternally("x-map://getMeTo/Polis Park Kaningos Athens");
            actionAccepted = true;
        }
        onVisibleChanged: {
            if (!visible && !actionAccepted) {
                //if action is not accepted, show warning
                notificationInterfaceInfo.show();
            }
            actionAccepted = false;
        }
    }

    // simulates battery low warning event
    Notification {
        id: notificationInterfaceInfo
        summary: qsTr("Warning: Battery level is low");
        body: qsTr("Please consider charging it in the next available station");
        category: "notification"
    }

    StageLoader {
        id: notificationLoader

        anchors.fill: display
        source: "sysui/notification/NotificationContent.qml"

        Binding { target: notificationLoader.item; property: "target";
            value: popupParent.showModalOverlay ? popupParent : display }
    }

    CenterConsoleMonitorOverlay {
        anchors.fill: display
        rotation: display.rotation
        model: SystemModel
        fpsVisible: SystemModel.centerConsolePerfOverlayEnabled
        activeAppId: display.applicationModel.activeAppInfo ? display.applicationModel.activeAppInfo.id : ""
        window: root
    }

    function orientationFromString(str) {
        str = str.trim().toLowerCase().replace('-','').replace('_','').replace('orientation','')

        if (str === "portrait") {
            return Qt.PortraitOrientation;
        } else if (str === "invertedportrait") {
            return Qt.InvertedPortraitOrientation;
        } else if (str === "landscape") {
            return Qt.LandscapeOrientation;
        } else if (str === "invertedlandscape") {
            return Qt.InvertedLandscapeOrientation;
        } else {
            // default to portrait
            return Qt.PortraitOrientation;
        }
    }

    function invertOrientation(orientation) {
        switch (orientation) {
            case Qt.PortraitOrientation:
                return Qt.InvertedPortraitOrientation;
            case Qt.InvertedPortraitOrientation:
                return Qt.PortraitOrientation;
            case Qt.LandscapeOrientation:
                return Qt.InvertedLandscapeOrientation;
            case Qt.InvertedLandscapeOrientation:
                return Qt.LandscapeOrientation;
            default:
                return orientation;
        }
    }

    Loader {
        id: instrumentClusterWindowLoader
        sourceComponent: Component {
            InstrumentClusterWindow {
                applicationModel: display.applicationModel
                invertedOrientation: instrumentClusterWindowLoader.invertedOrientation
                performanceOverlayVisible: SystemModel.instrumentClusterPerfOverlayEnabled
                Component.onCompleted: uiSettings.updateTheme()
            }
        }

        readonly property bool runningOnSingleScreenEmbedded: !WindowManager.runningOnDesktop
                                                       && (Qt.application.screens.length === 1)

        active: !runningOnSingleScreenEmbedded && ApplicationManager.systemProperties.showCluster

        property bool invertedOrientation: false
    }

    Component.onCompleted: {
        // Don't use bindings for setting up the initial size. Otherwise the binding is revaluated
        // on every language change, which results in resetting the window size to it's initial state
        // and might overwrite the size given by the OS or the user using the WindowManager
        width = Style.centerConsoleWidth
        height = Style.centerConsoleHeight
    }
}
