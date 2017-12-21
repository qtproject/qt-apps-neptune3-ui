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
import "assets"
import "store"


Item {
    id: root
    implicitWidth: Style.hspan(12)
    implicitHeight: Style.vspan(12)

    property Store store

    signal languageRequested(string language)

    ButtonGroup {
        id: toolGroup
    }

    ListModel {
        id: themeModel
        // TODO: This data will be populated from settings server later
        ListElement { title: QT_TR_NOOP('Light'); theme: 'light' }
        ListElement { title: QT_TR_NOOP('Dark'); theme: 'dark' }
    }

    Image {
        id: placeholder
        anchors.top: parent.top
        source: Assets.gfx("settings-placeholder")
        asynchronous: true
    }


    RowLayout {
        anchors.top: placeholder.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: Style.hspan(2)
        spacing: Style.hspan(1)


        ToolsColumn {
            Layout.preferredHeight: Style.vspan(4)
            Layout.preferredWidth: Style.hspan(4)
            anchors.top: parent.top
            model: ListModel {
                ListElement { name: QT_TR_NOOP("languages"); symbol:  'ic-languages'}
                ListElement { name: QT_TR_NOOP("date"); symbol:  'ic-time' }
                ListElement { name: QT_TR_NOOP("themes"); symbol:  'ic-themes' }
            }
            currentTool: model.get(0).name

            onToolClicked: stack.currentIndex = index
        }

        StackLayout {
            id: stack
            anchors.top: parent.top
            Layout.fillWidth: true
            Layout.fillHeight: true

            LanguagePanel {
                model: store.languageModel
                currentLanguage: store.currentLanguage
                onLanguageRequested: {
                    store.updateLanguage(language);
                    root.languageRequested(language);
                }
            }

            DateTimePanel {
                twentyFourHourTimeFormat: store.twentyFourHourTimeFormat
                onTwentyFourHourTimeFormatRequested: store.update24HourTimeFormat(value)
            }

            ThemesPanel {
                model: themeModel
                // TODO: hook this up with remote settings server request
                currentTheme: 'light'
                onThemeRequested: {
                    // TODO: hook this up with remote settings server request
                    currentTheme = theme;
                }
            }
        }
    }
}
