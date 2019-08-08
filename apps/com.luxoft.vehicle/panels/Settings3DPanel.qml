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

import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

import shared.Style 1.0
import shared.Sizes 1.0
import shared.utils 1.0
import shared.animations 1.0

import "../helpers" 1.0
import "../controls" 1.0

Item {
    id: root
    signal runtimeChanged(var qt3d)
    signal qualityChanged(var quality)

    property bool allowToChange3DSettings
    property bool qt3DStudioAvailable
    property alias qualityModel: lv.model

    Layout.fillHeight: true
    Layout.fillWidth: true

    ColumnLayout {
        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(24)
        width: parent.width - Sizes.dp(44)
        anchors.left: parent.left
        anchors.leftMargin: Sizes.dp(22)

        spacing:  Sizes.dp(50)

        ColumnLayout {
            id: section1
            visible: qt3DStudioAvailable
            Layout.fillWidth: true
            ButtonGroup { id: buttonGroupRuntimes }

            Label {
                Layout.alignment: Qt.AlignLeft
                font.weight: Font.Normal
                text: qsTr("3D Runtime")
            }

            Image {
                height: Sizes.dp(2)
                Layout.fillWidth: true
                source: Style.image("list-divider")
            }

            RowLayout {
                Label {
                    font.weight: Font.Light
                    Layout.alignment: Qt.AlignLeft
                    text: qsTr("Qt 3D")
                }

                Rectangle {
                    color: "transparent"
                    Layout.fillWidth: true
                }

                RadioButton {
                    id: qt3DButton
                    checked: true
                    enabled: root.allowToChange3DSettings
                    ButtonGroup.group: buttonGroupRuntimes
                    Layout.alignment: Qt.AlignRight
                    Layout.rightMargin: Sizes.dp(22)

                    onCheckedChanged: {
                        if (checked) {
                            root.allowToChange3DSettings = false
                            root.runtimeChanged(true)
                        }
                    }
                }
            }

            Image {
                height: Sizes.dp(2)
                Layout.fillWidth: true
                source: Style.image("list-divider")
            }

            RowLayout {
                Label {
                    font.weight: Font.Light
                    Layout.alignment: Qt.AlignLeft
                    text: qsTr("Qt 3D Studio")
                }

                Rectangle {
                    color: "transparent"
                    Layout.fillWidth: true
                }

                RadioButton {
                    id: qt3DStudioButton
                    checked: false
                    enabled: root.allowToChange3DSettings
                    ButtonGroup.group: buttonGroupRuntimes
                    Layout.alignment: Qt.AlignRight
                    Layout.rightMargin: Sizes.dp(22)

                    onCheckedChanged: {
                        if (checked) {
                            root.allowToChange3DSettings = false
                            root.runtimeChanged(false)
                        }
                    }
                }
            }

            Image {
                height: Sizes.dp(2)
                Layout.fillWidth: true
                source: Style.image("list-divider")
            }
        }

        ColumnLayout {
            id: section2
            visible: ! qt3DStudioButton.checked
            Layout.fillWidth: true
            Layout.fillHeight: true

            Label {
                Layout.alignment: Qt.AlignLeft
                font.weight: Font.Normal
                text: qsTr("Qt 3D Model Quality")
            }

            Image {
                height: Sizes.dp(2)
                Layout.fillWidth: true
                source: Style.image("list-divider")
            }

            ButtonGroup { id: buttonGroup }

            Component {
                id: cmp
                ColumnLayout {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    width: parent.width
                    spacing:  Sizes.dp(10)

                    RowLayout {
                        Label {
                            font.weight: Font.Light
                            Layout.alignment: Qt.AlignLeft
                            text: name
                        }

                        Rectangle {
                            color: "transparent"
                            Layout.fillWidth: true
                        }

                        RadioButton {
                            id: switcher
                            checked: quality === "optimized"
                            Layout.alignment: Qt.AlignRight
                            Layout.rightMargin: Sizes.dp(22)
                            ButtonGroup.group: buttonGroup
                            enabled: allowToChange3DSettings
                            onCheckedChanged: {
                                if (root.allowToChange3DSettings && checked) {
                                    root.allowToChange3DSettings = false
                                    root.qualityChanged(quality)
                                }
                            }
                        }
                    }

                    Image {
                        height: Sizes.dp(2)
                        Layout.fillWidth: true
                        source: Style.image("list-divider")
                    }
                }
            }

            ListView {
                id: lv
                Layout.preferredHeight: root.width / 2
                Layout.fillHeight: true
                Layout.fillWidth: true
                delegate: cmp
            }
        }
    }
}
