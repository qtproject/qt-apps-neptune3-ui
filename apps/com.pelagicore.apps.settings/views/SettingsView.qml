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
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import shared.utils 1.0
import shared.controls 1.0

import shared.Style 1.0
import shared.Sizes 1.0

import "../assets"
import "../store"
import "../panels"
import "../popups"

Control {
    id: root
    implicitWidth: Sizes.dp(960)
    implicitHeight: Sizes.dp(540)

    property RootStore store
    property Item rootItem
    property QtObject wifi

    property int wifiPopupWidth: Sizes.dp(910);
    property int wifiPopupHeight : Sizes.dp(820);

    WiFiPopup {
        id: wifiPopup

        manual: false
        onConnectClicked: wifi.sendCredentials(ssid, password)
        onCancelClicked: wifi.disconnectFromAccessPoint(wifi.activeAccessPoint.ssid)
    }

    ButtonGroup {
        id: toolGroup
    }

    Item {
        width: Sizes.dp(1080)
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(436)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Sizes.dp(20)
        clip: true

        Item {
            anchors.left: parent.left
            width: Sizes.dp(264)
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            ToolsColumn {
                id: toolsColumn
                width: Sizes.dp(140)
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: Sizes.dp(53)

                translationContext: "SettingsToolsColumn"
                model: Style.supportsMultipleThemes ? fullTabsModel : themelessTabsModel

                readonly property string currentIcon: model.get(currentIndex).icon

                ListModel {
                    id: fullTabsModel
                    ListElement { text: QT_TRANSLATE_NOOP("SettingsToolsColumn", "languages"); icon: 'ic-languages'; objectName: "languageViewButton"}
                    ListElement { text: QT_TRANSLATE_NOOP("SettingsToolsColumn", "date"); icon: 'ic-time'; objectName: "dateViewButton" }
                    ListElement { text: QT_TRANSLATE_NOOP("SettingsToolsColumn", "themes"); icon: 'ic-themes'; objectName: "themesViewButton" }
                    ListElement { text: QT_TRANSLATE_NOOP("SettingsToolsColumn", "colors"); icon: 'ic-color'; objectName: "colorsViewButton" }
                    ListElement { text: QT_TRANSLATE_NOOP("SettingsToolsColumn", "network"); icon: 'ic-connectivity'; objectName: "connectivityViewButton" }
                }

                ListModel {
                    id: themelessTabsModel
                    ListElement { text: QT_TRANSLATE_NOOP("SettingsToolsColumn", "languages"); icon: 'ic-languages'; objectName: "languageViewButton"}
                    ListElement { text: QT_TRANSLATE_NOOP("SettingsToolsColumn", "date"); icon: 'ic-time'; objectName: "dateViewButton" }
                    ListElement { text: QT_TRANSLATE_NOOP("SettingsToolsColumn", "colors"); icon: 'ic-color'; objectName: "colorsViewButton" }
                    ListElement { text: QT_TRANSLATE_NOOP("SettingsToolsColumn", "network"); icon: 'ic-connectivity'; objectName: "connectivityViewButton" }
                }
            }
        }

        Item {
            anchors.top: parent.top
            anchors.topMargin: Sizes.dp(53)
            anchors.right: parent.right
            anchors.rightMargin: Sizes.dp(96)
            anchors.bottom: parent.bottom
            width: Sizes.dp(720)

            ConnectivityPanel {
                objectName: "connectivityPanel"
                id: connectivityPanel

                property int view: 0 //0=menu, 1=wifi, 2=hotspot

                anchors.fill: parent
                visible: toolsColumn.currentIcon === 'ic-connectivity' && connectivityPanel.view === 0

                wifiAvailable: wifi.available
                bluetoothAvailable: false

                onWifiClicked: view = 1
                onHotspotClicked: view = 2
            }

            WiFiPanel {
                id: wifiPanel

                property int wifiPopupWidth: Sizes.dp(910);
                property int wifiPopupHeight : Sizes.dp(820);

                objectName: "wifiPanel"
                anchors.fill: parent
                visible: toolsColumn.currentIcon === 'ic-connectivity' && connectivityPanel.view === 1

                wifiEnabled: wifi.enabled
                wifiAccessPointsList: wifi.accessPoints
                rootItem: root.rootItem
                selectedWiFiStatus: {
                    if (wifi.connectionStatus == store.connectivityStatusConnecting) {
                        return "Connecting";
                    } else if (wifi.connectionStatus == store.connectivityStatusConnected) {
                        return "Connected";
                    } else if (wifi.connectionStatus == store.connectivityStatusDisconnecting) {
                        return "Disconnecting";
                    } else  {
                        return "Disconnected";
                    }
                }
                selectedWiFiSSID: wifi.activeAccessPoint.ssid

                onBackButtonClicked: connectivityPanel.view = 0
                onWifiEnabledChanged: wifi.enabled = wifiEnabled
                onConnectToWiFiClicked: wifi.connectToAccessPoint(ssid)
                onDisconnectFromWiFiClicked: wifi.disconnectFromAccessPoint(ssid)
            }

            Connections {
                target: wifi
                function onCredentialsRequested(ssid) {
                    wifiPopup.ssid = ssid;
                    wifiPopup.width = Qt.binding(() => wifiPanel.wifiPopupWidth);
                    wifiPopup.height = Qt.binding(() => wifiPanel.wifiPopupHeight);
                    wifiPopup.originItemX = Qt.binding(() => root.width / 2);
                    wifiPopup.originItemY = Qt.binding(() => root.heigh / 2);
                    wifiPopup.popupY = Qt.binding(() => {
                        return Sizes.dp(root.height/2 - wifiPopup.height/2);
                    });
                    wifiPopup.visible = true;
                }
            }

            HotspotPanel {
                objectName: "hotspotPanel"
                anchors.fill: parent
                visible: toolsColumn.currentIcon === 'ic-connectivity' && connectivityPanel.view === 2
                hotspotEnabled: wifi.hotspotEnabled
                ssid: wifi.hotspotSSID
                password: wifi.hotspotPassword

                onHotspotEnabledChanged: {
                    if (hotspotEnabled) {
                        wifi.hotspotSSID = ssid;
                        wifi.hotspotPassword = password;
                    }
                    wifi.hotspotEnabled = hotspotEnabled
                }
                onBackButtonClicked: connectivityPanel.view = 0
            }

            LanguagePanel {
                objectName: "languagePanel"
                anchors.fill: parent
                visible: toolsColumn.currentIcon === 'ic-languages'
                model: store.languageModel
                currentLanguage: store.currentLanguage
                onLanguageRequested: {
                    store.updateLanguage(languageCode, language);
                    store.update24HourTimeFormat(Qt.locale(languageCode).timeFormat(Locale.ShortFormat).indexOf("AP") === -1);
                }
            }

            DateTimePanel {
                objectName: "datePanel"
                anchors.fill: parent
                visible: toolsColumn.currentIcon === 'ic-time'
                twentyFourHourTimeFormat: store.twentyFourHourTimeFormat
                onTwentyFourHourTimeFormatRequested: store.update24HourTimeFormat(value)
            }

            Loader {
                anchors.fill: parent
                active: Style.supportsMultipleThemes
                ThemesPanel {
                    objectName: "themesPanel"
                    anchors.fill: parent
                    visible: toolsColumn.currentIcon === 'ic-themes'
                    model: store.themeModel
                    onThemeRequested: store.updateTheme(theme);
                }
            }

            ColorsPanel {
                objectName: "colorsPanel"
                anchors.fill: parent
                visible: toolsColumn.currentIcon === 'ic-color'
                model: store.accentColorsModel
                onAccentColorRequested: store.updateAccentColor(accentColor)
            }
        }
    }
}

