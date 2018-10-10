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

import QtQuick 2.8
import Qt.labs.platform 1.0
import QtApplicationManager 1.0
import shared.utils 1.0

import system.models.application 1.0

import shared.com.pelagicore.settings 1.0
import shared.com.pelagicore.systeminfo 1.0

Store {
    id: root

    readonly property SystemStore systemStore: SystemStore {}
    readonly property var musicAppRequestsIPC: MusicAppRequestsIPCStore  {}
    readonly property SettingsStore settingsStore: SettingsStore {}
    readonly property ClusterStore clusterStore: ClusterStore { id: clusterStore }
    readonly property CenterConsoleStore centerConsole: CenterConsoleStore {}
    property alias clusterAvailable: clusterStore.clusterAvailable

    readonly property StatusBarStore statusBarStore: StatusBarStore {
        isOnline: sysInfo.online
    }

    readonly property VolumeStore volumeStore: VolumeStore {
        uiSettings: root.uiSettings
    }

    readonly property var applicationModel: ApplicationModel {
        id: applicationModel
        localeCode: Style.languageLocale

        // Store widget states when the UI is shutting down
        onShuttingDown: settingsStore.widgetStates = applicationModel.serializeWidgetsState();
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
            if (language !== Style.languageLocale) {
                Style.languageLocale = language;
            }
        }
        onThemeChanged: root.updateThemeRequested(uiSettings.theme)
        onAccentColorChanged: root.accentColorChanged(accentColor)
        Component.onCompleted: {
            Qt.callLater(function() {
                if (uiSettings.language) {
                    Style.languageLocale = uiSettings.language;
                }
            });
            root.updateThemeRequested(uiSettings.theme)
        }
    }

    readonly property Notification notificationInfoInterface: Notification {
        id: notificationInfoInterface
        sticky: true
    }

    readonly property Timer languageTimer: Timer {
        id: timer
        interval: 100
        onTriggered: {
            root.uiSettings.languages = Style.translation.availableTranslations;
            root.uiSettings.twentyFourHourTimeFormat = Qt.locale().timeFormat(Locale.ShortFormat).indexOf("AP") === -1;
        }
    }

    readonly property bool layoutMirroringEnabled: Qt.locale().textDirection === Qt.RightToLeft || root.uiSettings.rtlMode
    readonly property bool layoutMirroringChildreninherit: true
    readonly property bool runningOnSingleScreenEmbedded: !WindowManager.runningOnDesktop
                                                   && (Qt.application.screens.length === 1)


    signal updateThemeRequested(var currentTheme)
    signal accentColorChanged(var newAccentColor)
    signal grabImageRequested(var screenshotUrl)
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
        var tempDir = StandardPaths.writableLocation(StandardPaths.TempLocation).toString();
        tempDir = tempDir.substring(tempDir.indexOf('://')+3); // convert from url to filepath
        const timestamp = new Date().toLocaleString(Qt.locale(),"yyyy-MM-dd-hh-mm-ss");
        const screenshotUrl = tempDir + "/" + timestamp + "_neptune3_screenshot.png";

        root.grabImageRequested(screenshotUrl)

        const diagFile = tempDir + "/" + timestamp + "_neptune3_versions.txt";

        root.saveFile(diagFile, root.sysInfo.qtDiag);
        root.triggerNotificationInfo(tempDir);
    }
}
