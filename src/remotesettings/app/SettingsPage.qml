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
import QtQuick 2.8
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3


Flickable {
    id: root
    flickableDirection: Flickable.VerticalFlick
    contentHeight: baseLayout.height

    ScrollIndicator.vertical: ScrollIndicator { }

    ColumnLayout {
        id: baseLayout
        enabled: uiSettings.isInitialized && client.connected
        spacing: 20
        anchors.horizontalCenter: parent.horizontalCenter

        Label {
            text: qsTr("UI Settings:")
            Layout.alignment: Qt.AlignHCenter
            font.bold: true
        }

        GridLayout {
            columns: 2

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

            // right hand drive mode
            Label {
                text: qsTr("Right-to-left mode:")
            }
            CheckBox {
                checked: uiSettings.rtlMode
                onToggled: uiSettings.rtlMode = checked
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

            Label {
                text: qsTr("3D Gauges:")
            }
            CheckBox {
                checked: uiSettings.threeDGauges
                onClicked: uiSettings.threeDGauges = checked
            }
        }
    }
}
