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
import Settings 1.0

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Settings")

    CultureSettings {
        id: cultureSettings
    }

    AudioSettings {
        id: audioSettings;

        volume: volumeSlider.value
        balance: balanceSlider.value
        muted: muteCheckbox.checked
    }

    NavigationSettings {
        id: navigationSettings;
    }

    Model3DSettings {
        id: model3dSettings
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10

        spacing: 10

        GroupBox {
            title: qsTr("Culture settings")

            Layout.fillWidth: true

            Row {

                Label {
                    text: qsTr("Language:")
                }

                ComboBox {
                    id: languageComboBox
                    model: cultureSettings.languages
                    currentIndex: cultureSettings.languages.indexOf(cultureSettings.language)

                    onActivated: cultureSettings.language = currentText
                }

            }

        }

        GroupBox {
            title: qsTr("Audio settings")

            Layout.fillWidth: true

            Row {
                Label {
                    text: qsTr("Volume:")
                }
                Slider {
                    id: volumeSlider
                    value: audioSettings.volume
                }
                Label {
                    text: qsTr("Balance:")
                }
                Slider {
                    id: balanceSlider
                    value: audioSettings.balance
                }
                Label {
                    text: qsTr("Mute:")
                }
                CheckBox {
                    id: muteCheckbox
                    checked: audioSettings.muted
                }
            }
        }

        GroupBox {
            title: qsTr("Navigation settings")

            Layout.fillWidth: true
        }

        GroupBox {
            title: qsTr("3D-model settings")

            Layout.fillWidth: true
        }

    }

}
