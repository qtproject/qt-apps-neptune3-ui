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

    property bool qt3DStudioAvailable
    property alias qualityModel: lv.model
    property string quality
    property string runtime
    signal showNotificationAboutChange
    QtObject {
        id: d
        property string currentActiveRuntime
    }
    onRuntimeChanged: {
        if (d.currentActiveRuntime.length == 0 && runtime.length != 0) {
            d.currentActiveRuntime = runtime;
            if (d.currentActiveRuntime === "qt3d") {
                qt3DButton.checked = true;
            } else {
                qt3DStudioButton.checked = true;
            }
        }
    }

    Layout.fillHeight: true
    Layout.fillWidth: true

    ColumnLayout {
        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(24)
        width: parent.width - Sizes.dp(44)
        anchors.left: parent.left
        anchors.leftMargin: Sizes.dp(22)

        spacing:  Sizes.dp(50)

        SequentialAnimation {
            id: buttonAnimation
            loops: Animation.Infinite
            onStopped: {
                na1.targets[0].opacity = 1.0;
                na1.targets[1].opacity = 1.0;
            }

            NumberAnimation {
                id: na1
                property: "opacity"
                duration: 750
                from: 1.0
                to: 0.0
                easing.type: Easing.Linear
            }
            NumberAnimation {
                id: na2
                property: "opacity"
                duration: 750
                from: 0.0
                to: 1.0
                easing.type: Easing.Linear
            }
        }

        ColumnLayout {
            id: section1
            visible: qt3DStudioAvailable
            Layout.fillWidth: true
            ButtonGroup {
                id: buttonGroupRuntimes
                exclusive: true
                onClicked: {
                    // send change outside panel
                    if (button.checked) {
                        root.runtime = button === qt3DButton ? "qt3d" : "3DStudio";
                    } else {
                        root.runtime = d.currentActiveRuntime;
                    }

                    // handle next runtime button
                    if (root.runtime === d.currentActiveRuntime) {
                        buttonAnimation.stop();
                        qt3DButtonText.visible = false;
                        qt3DStudioButtonText.visible = false;
                    } else {
                        var targetB = root.runtime === "qt3d" ? qt3DButton : qt3DStudioButton;
                        var targetT = root.runtime === "qt3d" ? qt3DButtonText : qt3DStudioButtonText;
                        targetT.visible = true;
                        na1.targets = [ targetB, targetT ];
                        na2.targets = [ targetB, targetT ];
                        buttonAnimation.start();
                        root.showNotificationAboutChange();
                    }
                }
            }

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

                Label {
                    id: qt3DButtonText
                    visible: false
                    Layout.alignment: Qt.AlignLeft
                    font.weight: Font.ExtraLight
                    text: qsTr("Vehicle App needs to be restarted")
                }

                RadioButton {
                    id: qt3DButton
                    ButtonGroup.group: buttonGroupRuntimes
                    Layout.alignment: Qt.AlignRight
                    Layout.rightMargin: Sizes.dp(22)
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

                Label {
                    id: qt3DStudioButtonText
                    visible: false
                    Layout.alignment: Qt.AlignLeft
                    font.weight: Font.ExtraLight
                    text: qsTr("Vehicle App needs to be restarted")
                }

                RadioButton {
                    id: qt3DStudioButton
                    ButtonGroup.group: buttonGroupRuntimes
                    Layout.alignment: Qt.AlignRight
                    Layout.rightMargin: Sizes.dp(22)
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
            visible: d.currentActiveRuntime === "qt3d"
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
                            checked: quality === root.quality
                            Layout.alignment: Qt.AlignRight
                            Layout.rightMargin: Sizes.dp(22)
                            ButtonGroup.group: buttonGroup
                            onCheckedChanged: {
                                if (checked) {
                                    root.quality = quality;
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
