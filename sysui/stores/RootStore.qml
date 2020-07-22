/****************************************************************************
**
** Copyright (C) 2019-2020 Luxoft Sweden AB
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
import Qt.labs.platform 1.0
import QtApplicationManager 2.0
import QtApplicationManager.Application 2.0
import QtApplicationManager.SystemUI 2.0
import shared.utils 1.0
import shared.Style 1.0

import system.models.application 1.0

import shared.com.pelagicore.remotesettings 1.0
import shared.com.pelagicore.systeminfo 1.0

Store {
    id: root

    readonly property SystemStore systemStore: SystemStore {}
    readonly property var musicAppRequestsIPC: MusicAppRequestsIPCStore  {}
    readonly property SettingsStore settingsStore: SettingsStore {}
    readonly property ClusterStore clusterStore: ClusterStore { id: clusterStore }
    readonly property HUDStore hudStore: HUDStore {}
    readonly property CenterConsoleStore centerConsole: CenterConsoleStore {}
    readonly property MusicStore musicStore: MusicStore {}
    readonly property string hardwareVariant: ApplicationManager.systemProperties.hardwareVariant
    property alias clusterAvailable: clusterStore.clusterAvailable

    readonly property bool enableCursorManagement: ApplicationManager.systemProperties.enableCursorManagement
    onEnableCursorManagementChanged: {
        Config.cursorAngleOffset =Qt.binding(function(){return centerConsole.isLandscape ? 90 : 0});
        Config.enableCursorManagement = root.enableCursorManagement;
    }

    readonly property bool devMode: ApplicationManager.systemProperties.devMode

    readonly property bool showSystemAppsInLauncher: ApplicationManager.systemProperties.showSystemAppsInLauncher

    readonly property StatusBarStore statusBarStore: StatusBarStore {
        isOnline: sysInfo.internetAccess
    }

    readonly property VolumeStore volumeStore: VolumeStore {
        uiSettings: root.uiSettings
    }

    readonly property var applicationModel: ApplicationModel {
        id: applicationModel
        localeCode: Config.languageLocale
        showCluster: (WindowManager.runningOnDesktop || Qt.application.screens.length > 1) && root.clusterStore.showCluster
        showHUD: root.hudStore.showHUD

        // Store widget states when the UI is shutting down
        onShuttingDown: {
            settingsStore.setValue("widgetStates", applicationModel.serializeWidgetStates());
            if (clusterStore.qsrEnabled) {
                //not to have direct dependency on QtSafeRenderer
                var sendMessageObject = Qt.createQmlObject("import QtQuick 2.0;  import Qt.SafeRenderer 1.1;
                        QtObject {
                            function sendShuttingDown() {
                                SafeMessage.sendHeartBeat(1) //sends one message with 1 ms expire timeout
                            }
                        }
                    ", root, "sendMessageObject")

                sendMessageObject.sendShuttingDown();
            }
        }
        onAutostartAppsListChanged: { settingsStore.setValue("autostartApps", applicationModel.serializeAutostart()); }
        onAutorecoverAppsListChanged: { settingsStore.setValue("autorecoverApps", applicationModel.serializeAutorecover()); }
        onApplicationPopupAdded: applicationPopupsStore.appPopupsModel.append({"window":window});
        onWidgetStatesChanged: {
            settingsStore.setValue("widgetStates", applicationModel.serializeWidgetStates());
        }
    }

    readonly property ApplicationPopupsStore applicationPopupsStore: ApplicationPopupsStore {}

    property var chosenColor: {0: Config._initAccentColors(0)[1].color
                                   , 1: Config._initAccentColors(1)[4].color}

    readonly property SystemUI systemUISettings: SystemUI {
        id: systemUISettings
        onApplicationICWindowSwitchCountChanged: {
            root.applicationICWindowSwitchCountChanged()
        }
    }

    readonly property SystemInfo sysInfo: SystemInfo { id: sysInfo }
    readonly property UISettings uiSettings: UISettings {
        onLanguageChanged: {
            if (language !== Config.languageLocale) {
                Config.languageLocale = language;
                uiSettings.setRtlMode(Qt.locale(language).textDirection === Qt.RightToLeft)
            }
        }

        onThemeChanged: {
            if (isInitialized) {
                root.updateThemeRequested(uiSettings.theme);
                //different themes have different color pallets, we update colors on theme change
                uiSettings.accentColor = chosenColor[uiSettings.theme];
            }
        }

        onAccentColorChanged: {
            if (isInitialized) {
                if (Config._initAccentColors(uiSettings.theme)
                        .some(data => data.color === uiSettings.accentColor)) {
                    chosenColor[uiSettings.theme] = uiSettings.accentColor;
                }

                root.accentColorChanged(accentColor);
            }
        }
        onRtlModeChanged: Config.rtlMode = uiSettings.rtlMode
        Component.onCompleted: {
            Qt.callLater(function() {
                if (uiSettings.language) {
                    Config.languageLocale = uiSettings.language;
                }
            });
        }
        onIsInitializedChanged: {
            if (isInitialized) {
                theme = root.initialTheme;

                if (!language) {
                    if (uiSettings.languages.includes(Config.languageLocale)) {
                        uiSettings.setLanguage(Config.languageLocale);
                    } else {
                        uiSettings.setLanguage("en_US");
                    }
                }
                // first connection of SystemUI to UISettings backend, got all variables
                // from it, init available translations if languages list is empty
                if (languages.length === 0) {
                    languages = Config.translation.availableTranslations;
                }
            }
        }

        onVolumeChanged: {
            volumeStore.player.volume = volume * 100;
        }

        onMutedChanged: {
            volumeStore.player.muted = muted;
        }
    }
    property int initialTheme

    readonly property Notification notificationInfoInterface: Notification {
        id: notificationInfoInterface
        sticky: true
    }

    readonly property Timer languageTimer: Timer {
        id: timer
        interval: 100
        onTriggered: {
            root.uiSettings.languages = Config.translation.availableTranslations;
            root.uiSettings.twentyFourHourTimeFormat = Qt.locale().timeFormat(Locale.ShortFormat).indexOf("AP") === -1;
        }
    }

    readonly property bool layoutMirroringEnabled: Qt.locale().textDirection === Qt.RightToLeft || root.uiSettings.rtlMode
    readonly property bool layoutMirroringChildreninherit: true
    readonly property bool runningOnSingleScreenEmbedded: !WindowManager.runningOnDesktop
                                                   && (Qt.application.screens.length === 1)

    readonly property Connections instentServerConnection: Connections {
        target: IntentServer
        function onDisambiguationRequest(requestId, potentialIntents, parameters) {
            //process "activate-app" intent sent with part of app name (guess-app) as parameter
            if (potentialIntents.length > 0 && potentialIntents[0].intentId === "activate-app") {
                var guess_app = parameters["guess-app"];
                if (guess_app && guess_app !== "") {
                    if (guess_app === "home") {
                        // if "home" is called, go to home view
                        applicationModel.goHome();
                    }

                    var appId = "";

                    for (var i = 0; i < potentialIntents.length; i++) {
                        if (potentialIntents[i].applicationId.includes(guess_app)) {
                            appId = potentialIntents[i].applicationId;
                            break;
                        }
                    }

                    //found app with "guess-app" part, send intent to this app
                    if (appId !== "") {
                        let request = IntentClient.sendIntentRequest("activate-app", appId, { });
                        request.onReplyReceived.connect(function() {
                            if (request.succeeded) {
                                var result = request.result;
                                console.log(Logging.apps, "Intent result: " + result.done);
                            } else {
                                console.log(Logging.apps, "Intent request failed: ",
                                            request.errorMessage);
                            }
                        });
                    }
                }
            }
        }
    }

    signal updateThemeRequested(var currentTheme)
    signal accentColorChanged(var newAccentColor)
    signal grabImageRequested(var screenshotCCPath, var screenshotICPath)
    signal applicationICWindowSwitchCountChanged()

    function saveFile(fileUrl, text) {
        var request = new XMLHttpRequest();
        request.open("PUT", fileUrl);
        request.send("Neptune 3: %1 %2".arg(Qt.application.version).arg(neptuneInfo) + "\n" +
                     "Qt Application Manager: %1".arg(qtamVersion) + "\n" +
                     "Qt IVI: %1".arg(qtiviVersion) + "\n\n" +
                     text);
    }

    function triggerNotificationInfo(tempDir) {
        root.notificationInfoInterface.summary = qsTr("UI screenshot has been taken successfully");
        root.notificationInfoInterface.body = qsTr("UI screenshot and diagnostics information are stored in %1").arg(tempDir);
        root.notificationInfoInterface.hide(); // it's sticky, so first hide it to be able to show it again
        root.notificationInfoInterface.show();
    }

    function generateScreenshotAndInfo() {
        var tempDirUrl = StandardPaths.writableLocation(StandardPaths.TempLocation).toString();
        var tempDirPath = tempDirUrl
        // since url type doesnt provide all c++ functions we have to handle url ourself
        if (sysInfo.productName.includes("Win") || sysInfo.productName.includes("win")) {
            tempDirPath = tempDirPath.substring(tempDirPath.indexOf('://')+4); // skip :///
        } else {
            tempDirPath = tempDirPath.substring(tempDirPath.indexOf('://')+3); // skip ://
        }

        const timestamp = new Date().toLocaleString(Qt.locale(),"yyyy-MM-dd-hh-mm-ss");
        const screenshotCCPath = tempDirPath + "/" + timestamp + "_neptune3_CC_screenshot.png";
        const screenshotICPath = tempDirPath + "/" + timestamp + "_neptune3_IC_screenshot.png";

        root.grabImageRequested(screenshotCCPath, screenshotICPath)

        const diagFile = tempDirUrl + "/" + timestamp + "_neptune3_versions.txt";

        root.saveFile(diagFile, root.sysInfo.qtDiag);
        root.triggerNotificationInfo(tempDirPath);
    }

    //value: 1 -- dark, 0 -- light
    function updateTheme(value) {
        if (value !== uiSettings.theme) {
            uiSettings.setTheme(value);
        }
    }

    function triggerVoiceAssitant() {
        var request = IntentClient.sendIntentRequest("trigger-voiceassistant", { });
        request.onReplyReceived.connect(function() {
            if (request.succeeded)
                var result = request.result;
            else
                console.log("Intent request failed: " + request.errorMessage);
        })
    }
}
