/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Copyright (C) 2018 Pelagicore AG
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

import QtQuick 2.8
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtApplicationManager.SystemUI 2.0

import shared.Style 1.0
import shared.Sizes 1.0
import shared.utils 1.0
import shared.controls 1.0

Item {
    id: root
    implicitWidth: Sizes.dp(810)
    implicitHeight: Sizes.dp(1280)

    property var applicationModel

    Instantiator {
        model: root.applicationModel
        delegate: QtObject {
            property var con: Connections {
                target: model.appInfo
                onRunningChanged: {
                    if (model.appInfo.running) {
                        runningAppsModel.appendAppInfo(model.appInfo);
                    } else {
                        runningAppsModel.removeAppInfo(model.appInfo);
                    }
                }
                Component.onCompleted: {
                    if (model.appInfo.running) {
                        runningAppsModel.appendAppInfo(model.appInfo);
                    }
                }
            }
        }
    }

    ListModel {
        id: runningAppsModel

        function appendAppInfo(appInfo) {
            append({
                       "appInfo": appInfo,
                       "memoryPSS": "0",
                       "memoryRSS": "0",
                       "memoryVirtual": "0",
                       "cpuLoad": "0.0"
                   });
        }
        function removeAppInfo(appInfo) {
            var i;
            for (i = 0; i < count; i++) {
                var item = get(i);
                if (item.appInfo.id === appInfo.id) {
                    remove(i, 1);
                    break;
                }
            }
        }
        function getAppIndex(id) {
            for (var j = 0; j < count; j++) {
                var item = get(j);
                if (item.appInfo.id === id) {
                    return j;
                }
            }
            return -1;
        }
    }

    Label {
        id: infoLabel
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        topPadding: Sizes.dp(20)

        wrapMode: Text.WordWrap
        text: qsTr("Enabling performance monitoring forces the chosen application " +
                    " to constantly redraw itself, therefore having a constant," +
                    " unnecessary, GPU/CPU consumption.")
        font.pixelSize: Sizes.fontSizeS
    }

    ListView {
        id: listView
        clip: true
        model: runningAppsModel

        spacing: Sizes.dp(20)

        anchors.top: infoLabel.bottom
        anchors.topMargin: Sizes.dp(30)
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        delegate: Item {
            width: parent.width - Sizes.dp(20)
            implicitHeight: column.height

            ProcessStatus {
                id: processStatus
                applicationId: model.appInfo.id
            }
            Timer {
                interval: 1000
                running: root.visible
                repeat: true
                onTriggered: processStatus.update()
            }

            ToolButton {
                anchors.top: parent.top
                anchors.right: parent.right
                icon.name: "ic-close"
                onClicked: model.appInfo.stop()
            }

            Column {
                id: column
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.rightMargin: Sizes.dp(60)
                Label {
                    text: model.appInfo.name
                }
                Label {
                    readonly property string memoryPSS: (processStatus.memoryPss.total / 1e6).toFixed(0)
                    readonly property string memoryRSS: (processStatus.memoryRss.total / 1e6).toFixed(0)
                    readonly property string cpuLoad: (processStatus.cpuLoad * 100).toFixed(1)
                    text: qsTr("CPU: %L1 %; RSS: %L3 MB; PSS: %L4 MB").
                            arg(cpuLoad).arg(memoryRSS).arg(memoryPSS)
                    font.pixelSize: Sizes.fontSizeS
                    opacity: Style.opacityMedium
                }
                Column {
                    width: parent.width
                    visible: !!model.appInfo.window
                    leftPadding: Sizes.dp(40)
                    Label {
                        text: qsTr("Primary Window, on Center Console")
                        font.pixelSize: Sizes.fontSizeS
                    }
                    RowLayout {
                        width: parent.width - parent.leftPadding
                        Label {
                            Layout.fillWidth: true
                            text: qsTr("Time to first frame: %1 ms").arg(model.appInfo.timeToFirstWindowFrame)
                            font.pixelSize: Sizes.fontSizeXS
                            opacity: Style.opacityMedium
                        }
                        Switch {
                            id: primarySwitch
                            font.pixelSize: Sizes.fontSizeXS
                            text: qsTr("Performance monitor")
                            opacity: Style.opacityMedium
                            Binding { target: model.appInfo; property: "windowPerfMonitorEnabled"; value: primarySwitch.checked }
                        }
                    }
                    bottomPadding: applicationICWindowColumn.visible ? 0 : Sizes.dp(20)
                }
                Column {
                    id: applicationICWindowColumn
                    width: parent.width
                    visible: !!model.appInfo.icWindow
                    leftPadding: Sizes.dp(40)
                    Label {
                        text: qsTr("Application IC Window, on Instrument Cluster")
                        font.pixelSize: Sizes.fontSizeS
                    }
                    RowLayout {
                        width: parent.width - parent.leftPadding
                        Label {
                            Layout.fillWidth: true
                            text: qsTr("Time to first frame: %1 ms").arg(model.appInfo.timeToFirstICWindowFrame)
                            font.pixelSize: Sizes.fontSizeXS
                            opacity: Style.opacityMedium
                        }
                        Switch {
                            id: secondarySwitch
                            font.pixelSize: Sizes.fontSizeXS
                            text: qsTr("Performance monitor")
                            opacity: Style.opacityMedium
                            Binding { target: model.appInfo; property: "applicationICWindowPerfMonitorEnabled"; value: secondarySwitch.checked }
                        }
                    }
                    bottomPadding: Sizes.dp(20)
                }
                Image {
                    visible: model.index !== listView.model.count - 1
                    width: parent.width
                    height: Sizes.dp(sourceSize.height)
                    source: Style.image("list-divider")
                }
            }
        }
        ScrollIndicator.vertical: ScrollIndicator {}
    }
}
