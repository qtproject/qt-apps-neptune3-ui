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
import shared.utils 1.0
import shared.com.pelagicore.remotesettings 1.0
import shared.Style 1.0

import "../helper"

QtObject {
    id: root

    readonly property Helper helper: Helper {}
    readonly property UISettings uiSettings: UISettings {
        onAccentColorChanged: {
            accentColorsModel.forEach(function(element) {
                var c1 = Qt.lighter(element.color, 1.0)
                var c2 = Qt.lighter(accentColor, 1.0)
                element.selected = Qt.colorEqual(element.color, accentColor)
                    ||  Math.abs(c1.r - c2.r) + Math.abs(c1.g - c2.g) + Math.abs(c1.b - c2.b) < 0.01;
            });
        }
    }

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
        helper.showNotification(qsTr("UI Language changed"), qsTr("UI Language changed into %1 (%2)").arg(language).arg(languageCode));
    }

    function update24HourTimeFormat(value) {
        console.log(helper.category, 'update24HourTimeFormat: ', value)
        uiSettings.setTwentyFourHourTimeFormat(value);
    }

    // Theme Segment
    readonly property int currentTheme: uiSettings.theme !== undefined ? uiSettings.theme : 1 // dark

    readonly property ListModel themeModel: ListModel {
        // TODO: This data will be populated from settings server later
        // the server stores the "theme" as an integer
        ListElement { title: QT_TR_NOOP('Light'); theme: 'light' }
        ListElement { title: QT_TR_NOOP('Dark'); theme: 'dark' }
    }

    function updateTheme(value) {
        console.log(helper.category, 'updateTheme: ', value)
        uiSettings.setTheme(value);

        if (value === 0) {
            helper.showNotification(qsTr("UI Theme changed"), qsTr("UI Theme changed into Light Theme"));
        } else if (value === 1) {
            helper.showNotification(qsTr("UI Theme changed"), qsTr("UI Theme changed into Dark Theme"));
        }


    }

    // (Accent) Colors segment
    readonly property color currentAccentColor: !!uiSettings.accentColor ? uiSettings.accentColor : Style.accentColor

    function _initColors() {
        var arr = [{ color: Style.accentColor, value: 5, selected: true }]
        var c = Style.accentColor

        var hue = isNaN(c.hslHue) ? 0.075 : c.hslHue
        var lightness = isNaN(c.hslLightness) ? 0.65 : c.hslLightness
        var a = isNaN(c.a) ? 1.0 : c.a

        for (var i = 1; i < 10; ++i) {
            if (hue - i * 0.1 >= 0) {
                arr.push({ color: Qt.hsla(hue - i * 0.1, 0.7, lightness, a)
                            , value: 5, selected: false })
            }

            if (hue + i * 0.1 <= 1) {
                arr.push({ color: Qt.hsla(hue + i * 0.1, 0.7, lightness, a)
                            , value: 5, selected: false })
            }
        }

        return arr;
    }

    property var accentColorsModel: []
    function updateAccentColor(value) {
        console.log(helper.category, 'updateAccentColor: ', value)
        uiSettings.accentColor = value;
        helper.showNotification(qsTr("UI Accent Color changed"), qsTr("UI Accent Color changed into %1").arg(value));
    }

    // Initialization
    Component.onCompleted: {
        populateLanguages();
        accentColorsModel = _initColors();
    }
}
