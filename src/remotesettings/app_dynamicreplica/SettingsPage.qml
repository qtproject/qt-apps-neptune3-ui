/****************************************************************************
**
** Copyright (C) 2017, 2018 Pelagicore AG
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
import QtQuick 2.8
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3


Page {
    id: root
    padding: 16
    GridLayout {
        anchors.centerIn: parent
        columns: 2

        enabled: uiSettings.connected

        // Language Field
        Label {
            text: qsTr("Language:")
        }
        ComboBox {
            id: languageComboBox
            model: uiSettings.languages
            currentIndex: uiSettings.languages.indexOf(uiSettings.language)
            onActivated: uiSettings.language = currentText
        }

        // 24h format Field
        Label {
            text: qsTr("24h time format:")
        }
        CheckBox {
            checked: uiSettings.twentyFourHourTimeFormat
            onToggled: uiSettings.twentyFourHourTimeFormat = checked
        }

        // Volume Field
        Label {
            text: qsTr("Volume:")
        }
        Slider {
            id: volumeSlider
            value: uiSettings.volume
            from: 1.0
            to: 0.0
            onValueChanged: if (pressed) { uiSettings.volume = value }
        }

        // Balance Field
        Label {
            text: qsTr("Balance:")
        }
        Slider {
            id: balanceSlider
            value: uiSettings.balance
            from: 1.0
            to: -1.0
            onValueChanged: if (pressed) { uiSettings.balance = value }
        }

        // Mute Field
        Label {
            text: qsTr("Mute:")
        }
        CheckBox {
            id: muteCheckbox
            checked: uiSettings.muted
            onClicked: uiSettings.muted = checked
        }

        // Theme Field
        Label {
            text: qsTr("Theme:")
        }

        ComboBox {
            id: themeComboBox
            model: [qsTr("Light"), qsTr("Dark")]
            currentIndex: uiSettings.theme
            onActivated: uiSettings.theme = currentIndex
        }

        // Door 1 Field
        Label {
            text: qsTr("Door 1:")
        }
        CheckBox {
            id: door1OpenCheckbox
            checked: uiSettings.door1Open
            onClicked: uiSettings.door1Open = checked
        }

        // Door 2 Field
        Label {
            text: qsTr("Door 2:")
        }
        CheckBox {
            id: door2OpenCheckbox
            checked: uiSettings.door2Open
            onClicked: uiSettings.door2Open = checked
        }
    }
}
