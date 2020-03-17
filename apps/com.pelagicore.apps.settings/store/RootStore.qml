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

import QtQml 2.2
import QtQml.Models 2.3

import QtApplicationManager.Application 2.0

import shared.utils 1.0
import shared.Style 1.0
import shared.Connectivity 1.0
import shared.com.pelagicore.remotesettings 1.0

import "../helper"

QtObject {
    id: root

    readonly property WiFi wifi: WiFi {}
    readonly property int connectivityStatusConnecting: WiFi.Connecting
    readonly property int connectivityStatusConnected: WiFi.Connected
    readonly property int connectivityStatusDisconnecting: WiFi.Disconnecting
    readonly property int connectivityStatusDisconnected: WiFi.Disconnected

    readonly property Helper helper: Helper {}

    // Time And Date Segment
    readonly property bool twentyFourHourTimeFormat: uiSettings.twentyFourHourTimeFormat !== undefined ?
                                                         uiSettings.twentyFourHourTimeFormat
                                                         // "ap" here indicates the presence of AM/PM suffix;
                                                         // Locale has no other way of telling whether it uses 12 or 24h time format
                                                       : Qt.locale().timeFormat(Locale.ShortFormat).indexOf("AP") === -1

    // Language Segment
    readonly property string currentLanguage: uiSettings.language ? uiSettings.language : Config.languageLocale
    readonly property ListModel languageModel: ListModel {}

    function populateLanguages() {
        languageModel.clear()
        var translations = uiSettings.languages.length !== 0 ? uiSettings.languages : Config.translation.availableTranslations;
        for (var i=0; i<translations.length; i++) {
            var locale = Qt.locale(translations[i]);
            languageModel.append({
                title: locale.nativeLanguageName,
                subtitle: locale.nativeCountryName,
                language: locale.name
            });
        }
    }

    function updateLanguage(languageCode, language) {
        console.log(helper.category, 'updateLanguage: ' + languageCode)
        uiSettings.setLanguage(languageCode);
        uiSettings.setRtlMode(Qt.locale(languageCode).textDirection === Qt.RightToLeft);
        helper.showNotification(qsTr("UI Language changed"), qsTr("UI Language changed into %1 (%2)").arg(language).arg(languageCode));
    }

    function update24HourTimeFormat(value) {
        console.log(helper.category, 'update24HourTimeFormat: ', value)
        uiSettings.setTwentyFourHourTimeFormat(value);
    }

    // Accent Colors & themes segment
    property var accentColorsModel: Config._initAccentColors(uiSettings.theme)
    readonly property ListModel themeModel: ListModel {
        // TODO: This data will be populated from settings server later
        // the server stores the "theme" as an integer
        ListElement { title: QT_TR_NOOP('Light'); theme: 'light' }
        ListElement { title: QT_TR_NOOP('Dark'); theme: 'dark' }
    }

    readonly property UISettings uiSettings: UISettings {
        onAccentColorChanged: {
            root.accentColorsModel.forEach(function(element) {
                element.selected = Qt.colorEqual(element.color, accentColor);
            });
        }
    }

    function selectNextAccentColor() {
        var selected = -1;
        for (var i = 0; i < root.accentColorsModel.length; ++i) {
            if (root.accentColorsModel[i].selected === true) {
                selected = i;
                break;
            }
        }

        if (selected >= 0) {
            root.accentColorsModel[selected].selected = false;
            selected = selected === root.accentColorsModel.length - 1 ? 0 : selected + 1;
            root.accentColorsModel[selected].selected = true;
            updateAccentColor(root.accentColorsModel[selected].color);
        }
    }

    function updateAccentColor(value) {
        console.log(helper.category, 'updateAccentColor: ', value)
        uiSettings.accentColor = value;
        helper.showNotification(qsTr("UI Accent Color changed"), qsTr("UI Accent Color changed into %1").arg(value));
    }

    //value: 1 -- dark, 0 -- light
    function updateTheme(value) {
        console.log(helper.category, 'updateTheme: ', value)
        uiSettings.setTheme(value);
        if (value === 0) {
            helper.showNotification(qsTr("UI Theme changed"), qsTr("UI Theme changed into Light Theme"));
        } else if (value === 1) {
            helper.showNotification(qsTr("UI Theme changed"), qsTr("UI Theme changed into Dark Theme"));
        }
    }

    readonly property IntentHandler intentHandler: IntentHandler {
        intentIds: ["activate-app", "set-next-accent-color"]
        onRequestReceived: {
            switch (request.intentId) {
            case "activate-app":
                root.requestRaiseAppReceived()
                request.sendReply({ "done": true })
                break;
            case "set-next-accent-color":
                selectNextAccentColor();
                request.sendReply({ "done": true })
                break;
            default:
                request.sendReply({ "done": true })
                break;
            }
        }
    }
    signal requestRaiseAppReceived()

    // Initialization
    Component.onCompleted: {
        populateLanguages();
    }
}
