/****************************************************************************
**
** Copyright (C) 2017-2018 Pelagicore AG
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
import QtQuick.Layouts 1.3
import shared.utils 1.0
import shared.controls 1.0

import shared.Style 1.0
import shared.Sizes 1.0

import "../assets"
import "../store"
import "../panels"

Control {
    id: root
    implicitWidth: Sizes.dp(960)
    implicitHeight: Sizes.dp(540)

    property RootStore store

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
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: Sizes.dp(53)

                translationContext: "SettingsToolsColumn"
                model: Style.supportsMultipleThemes ? fullTabsModel : themelessTabsModel

                readonly property string currentIcon: model.get(currentIndex).icon

                ListModel {
                    id: fullTabsModel
                    ListElement { text: QT_TRANSLATE_NOOP("SettingsToolsColumn", "languages"); icon: 'ic-languages'}
                    ListElement { text: QT_TRANSLATE_NOOP("SettingsToolsColumn", "date"); icon: 'ic-time' }
                    ListElement { text: QT_TRANSLATE_NOOP("SettingsToolsColumn", "themes"); icon: 'ic-themes' }
                    ListElement { text: QT_TRANSLATE_NOOP("SettingsToolsColumn", "colors"); icon: 'ic-color' }
                }

                ListModel {
                    id: themelessTabsModel
                    ListElement { text: QT_TRANSLATE_NOOP("SettingsToolsColumn", "languages"); icon: 'ic-languages'}
                    ListElement { text: QT_TRANSLATE_NOOP("SettingsToolsColumn", "date"); icon: 'ic-time' }
                    ListElement { text: QT_TRANSLATE_NOOP("SettingsToolsColumn", "colors"); icon: 'ic-color' }
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

            LanguagePanel {
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
                anchors.fill: parent
                visible: toolsColumn.currentIcon === 'ic-time'
                twentyFourHourTimeFormat: store.twentyFourHourTimeFormat
                onTwentyFourHourTimeFormatRequested: store.update24HourTimeFormat(value)
            }

            Loader {
                anchors.fill: parent
                active: Style.supportsMultipleThemes
                ThemesPanel {
                    anchors.fill: parent
                    visible: toolsColumn.currentIcon === 'ic-themes'
                    model: store.themeModel
                    currentTheme: store.currentTheme
                    onThemeRequested: store.updateTheme(theme);
                }
            }

            ColorsPanel {
                anchors.fill: parent
                visible: toolsColumn.currentIcon === 'ic-color'
                model: store.accentColorsModel
                currentAccentColor: store.currentAccentColor
                onAccentColorRequested: store.updateAccentColor(accentColor)
            }
        }
    }
}
