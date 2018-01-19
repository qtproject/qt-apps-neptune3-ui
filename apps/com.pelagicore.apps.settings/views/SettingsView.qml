/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Triton IVI UI.
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

import "../assets"
import "../store"
import "../panels"

Control {
    id: root
    implicitWidth: Style.hspan(12)
    implicitHeight: Style.vspan(12)

    property RootStore store

    ButtonGroup {
        id: toolGroup
    }

    Image {
        id: placeholder
        anchors.top: parent.top
        source: Assets.gfx("hero-settings")
        asynchronous: true
    }


    RowLayout {
        anchors.top: placeholder.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.topMargin: Style.hspan(2)
        anchors.bottomMargin: Style.hspan(2)
        anchors.leftMargin: Style.hspan(1)
        anchors.rightMargin: Style.hspan(2)
        spacing: Style.hspan(1)


        ToolsColumn {
            id: toolsColumn
            Layout.preferredHeight: Style.vspan(4)
            Layout.preferredWidth: Style.hspan(4)
            anchors.top: parent.top
            translationContext: "SettingsToolsColumn"
            model: ListModel {
                ListElement { text: QT_TRANSLATE_NOOP("SettingsToolsColumn", "languages"); icon: 'ic-languages'}
                ListElement { text: QT_TRANSLATE_NOOP("SettingsToolsColumn", "date"); icon: 'ic-time' }
                ListElement { text: QT_TRANSLATE_NOOP("SettingsToolsColumn", "themes"); icon: 'ic-themes' }
            }
        }

        StackLayout {
            anchors.top: parent.top
            Layout.fillWidth: true
            Layout.fillHeight: true

            currentIndex: toolsColumn.currentIndex

            LanguagePanel {
                model: store.languageModel
                currentLanguage: store.currentLanguage
                onLanguageRequested: store.updateLanguage(language);
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
        }
    }
}
