/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
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

import QtInterfaceFramework.Media

Flickable {
    id: root
    flickableDirection: Flickable.VerticalFlick
    contentHeight: baseLayout.height

    ScrollIndicator.vertical: ScrollIndicator { }

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        Label {
            text: qsTr("Music controls:")
            Layout.alignment: Qt.AlignHCenter
            font.bold: true
        }

        GridLayout {
            id: baseLayout
            enabled: uiSettings.isInitialized && client.connected
            columns: 2

            // Volume Field
            Label {
                text: qsTr("Volume:")
            }
            Slider {
                id: volumeSlider
                value: uiSettings.volume
                from: 0.0
                to: 1.0
                onMoved: uiSettings.volume = value
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
                onValueChanged: {
                    if (pressed) {
                        uiSettings.balance = value
                    }
                }
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
        }

        GridLayout {
            Row {
                spacing: 30

                Button {
                    width: 70
                    height: 70
                    icon.source: "qrc:/assets/ic_skipprevious.png"
                    onClicked:  {
                        mediaPlayer.previous()
                    }
                }

                Button {
                    width: 70
                    height: 70
                    icon.source: mediaPlayer.playState === MediaPlayer.Playing
                                 ? "qrc:/assets/ic_pause.png" : "qrc:/assets/ic_play.png"
                    onClicked: {
                        if (mediaPlayer.playState === MediaPlayer.Playing) {
                            mediaPlayer.pause()
                        } else {
                            mediaPlayer.play()
                        }
                    }
                }

                Button {
                    width: 70
                    height: 70
                    icon.source: "qrc:/assets/ic_skipnext.png"
                    onClicked:  {
                        mediaPlayer.next()
                    }
                }
            }
        }
    }
}
