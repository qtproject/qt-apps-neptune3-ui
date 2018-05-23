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
import utils 1.0
import controls 1.0

import com.pelagicore.styles.neptune 3.0

import "../assets"
import "../store"
import "../panels"

Control {
    id: root
    implicitWidth: NeptuneStyle.dp(960)
    implicitHeight: NeptuneStyle.dp(540)

    property RootStore store

    ButtonGroup {
        id: toolGroup
    }

    Item {
        width: NeptuneStyle.dp(1080)
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: NeptuneStyle.dp(436)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: NeptuneStyle.dp(20)

        clip: true

        Item {
            anchors.left: parent.left
            width: NeptuneStyle.dp(264)
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            ToolsColumn {
                id: toolsColumn
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: NeptuneStyle.dp(53)

                translationContext: "SettingsToolsColumn"
                model: ListModel {
                    ListElement { text: QT_TRANSLATE_NOOP("SettingsToolsColumn", "languages"); icon: 'ic-languages'}
                    ListElement { text: QT_TRANSLATE_NOOP("SettingsToolsColumn", "date"); icon: 'ic-time' }
                    ListElement { text: QT_TRANSLATE_NOOP("SettingsToolsColumn", "themes"); icon: 'ic-themes' }
                    ListElement { text: QT_TRANSLATE_NOOP("SettingsToolsColumn", "colors"); icon: 'ic-color' }
                }
            }
        }

        StackLayout {
            anchors.top: parent.top
            anchors.topMargin: NeptuneStyle.dp(53)
            anchors.right: parent.right
            anchors.rightMargin: NeptuneStyle.dp(96)
            anchors.bottom: parent.bottom
            width: NeptuneStyle.dp(720)

            currentIndex: toolsColumn.currentIndex

            LanguagePanel {
                model: store.languageModel
                currentLanguage: store.currentLanguage
                onLanguageRequested: store.updateLanguage(languageCode, language);
            }

            DateTimePanel {
                twentyFourHourTimeFormat: store.twentyFourHourTimeFormat
                onTwentyFourHourTimeFormatRequested: store.update24HourTimeFormat(value)
            }

            ThemesPanel {
                model: store.themeModel
                currentTheme: store.currentTheme
                onThemeRequested: store.updateTheme(theme);
            }

            ColorsPanel {
                model: store.accentColorsModel
                currentAccentColor: store.currentAccentColor
                onAccentColorRequested: store.updateAccentColor(accentColor)
            }
        }
    }
}
