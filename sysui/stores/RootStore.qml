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
import Qt.labs.platform 1.0
import QtApplicationManager 2.0
import QtApplicationManager.Application 2.0
import QtApplicationManager.SystemUI 2.0
import shared.utils 1.0

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
    readonly property string hardwareVariant: ApplicationManager.systemProperties.hardwareVariant
    property alias clusterAvailable: clusterStore.clusterAvailable

    readonly property StatusBarStore statusBarStore: StatusBarStore {
        isOnline: sysInfo.internetAccess
    }

    readonly property VolumeStore volumeStore: VolumeStore {
        uiSettings: root.uiSettings
    }

    readonly property var applicationModel: ApplicationModel {
        id: applicationModel
        localeCode: Config.languageLocale
        autostartApps: settingsStore.value("autostartApps", settingsStore.defaultAutostartApps)

        // Store widget states when the UI is shutting down
        onShuttingDown: {
            settingsStore.widgetStates = applicationModel.serializeWidgetsState();

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
    }

    readonly property ApplicationPopupsStore applicationPopupsStore: ApplicationPopupsStore {}

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
            }
        }
        onThemeChanged: root.updateThemeRequested(uiSettings.theme)
        onAccentColorChanged: root.accentColorChanged(accentColor)
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
            }
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
}
