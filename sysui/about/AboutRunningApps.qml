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

import QtQuick 2.8
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtApplicationManager 1.0

import com.pelagicore.styles.neptune 3.0
import utils 1.0
import controls 1.0

Item {
    id: root
    implicitWidth: NeptuneStyle.dp(810)
    implicitHeight: NeptuneStyle.dp(1280)

    property var applicationModel

    // FIXME: Name is not being updated when language changes
    Instantiator {
        model: root.applicationModel
        delegate: QtObject {
            property ProcessMonitor monitor: ProcessMonitor {
                applicationId: model.appInfo.id
                reportingInterval: 1000
                memoryReportingEnabled: root.visible
                cpuLoadReportingEnabled: root.visible
                onMemoryReportingChanged: {
                    var mPSS = (memoryPss.total / 1e6).toFixed(0)
                    var mRSS = (memoryRss.total / 1e6).toFixed(0)
                    var mVirtual = (memoryVirtual.total / 1e6).toFixed(0)
                    var indx = runningAppsModel.getAppIndex(model.appInfo.id);
                    runningAppsModel.setProperty(indx, "memoryPSS", mPSS)
                    runningAppsModel.setProperty(indx, "memoryRSS", mRSS)
                    runningAppsModel.setProperty(indx, "memoryVirtual", mVirtual)
                }
                onCpuLoadReportingChanged: {
                    var indx = runningAppsModel.getAppIndex(model.appInfo.id);
                    runningAppsModel.setProperty(indx, "cpuLoad", (load * 100).toFixed(1))
                }
            }

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
        topPadding: NeptuneStyle.dp(20)

        wrapMode: Text.WordWrap
        text: qsTr("Enabling performance monitoring forces the chosen application " +
                    " to constantly redraw itself, therefore having a constant," +
                    " unnecessary, GPU/CPU consumption.")
        font.pixelSize: NeptuneStyle.fontSizeS
    }

    ListView {
        id: listView
        clip: true
        model: runningAppsModel

        spacing: NeptuneStyle.dp(20)

        anchors.top: infoLabel.bottom
        anchors.topMargin: NeptuneStyle.dp(30)
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        delegate: Item {
            width: parent.width
            implicitHeight: column.height

            ToolButton {
                anchors.top: parent.top
                anchors.right: parent.right
                icon.name: "ic-close"
                onClicked: model.appInfo.stop()
            }

            Column {
                id: column
                width: parent.width
                Label {
                    text: model.appInfo.name
                }
                Label {
                    text: qsTr("CPU: %L1 %; Virtual: %L2 MB; RSS: %L3 MB; PSS: %L4 MB").
                            arg(model.cpuLoad).arg(model.memoryVirtual).
                            arg(model.memoryRSS).arg(model.memoryPSS)
                    font.pixelSize: NeptuneStyle.fontSizeS
                    opacity: NeptuneStyle.opacityMedium
                }
                Column {
                    width: parent.width
                    visible: !!model.appInfo.window
                    leftPadding: NeptuneStyle.dp(40)
                    Label {
                        text: qsTr("Primary Window, on Center Console")
                        font.pixelSize: NeptuneStyle.fontSizeS
                    }
                    RowLayout {
                        width: parent.width - parent.leftPadding
                        Label {
                            Layout.fillWidth: true
                            text: qsTr("Time to first frame: %1 ms").arg(model.appInfo.timeToFirstWindowFrame)
                            font.pixelSize: NeptuneStyle.fontSizeXS
                            opacity: NeptuneStyle.opacityMedium
                        }
                        Switch {
                            id: primarySwitch
                            font.pixelSize: NeptuneStyle.fontSizeXS
                            text: qsTr("Performance monitor")
                            opacity: NeptuneStyle.opacityMedium
                            Binding { target: model.appInfo; property: "windowPerfMonitorEnabled"; value: primarySwitch.checked }
                        }
                    }
                    bottomPadding: secondaryWindowColumn.visible ? 0 : NeptuneStyle.dp(20)
                }
                Column {
                    id: secondaryWindowColumn
                    width: parent.width
                    visible: !!model.appInfo.secondaryWindow
                    leftPadding: NeptuneStyle.dp(40)
                    Label {
                        text: qsTr("Secondary Window, on Instrument Cluster")
                        font.pixelSize: NeptuneStyle.fontSizeS
                    }
                    RowLayout {
                        width: parent.width - parent.leftPadding
                        Label {
                            Layout.fillWidth: true
                            text: qsTr("Time to first frame: %1 ms").arg(model.appInfo.timeToFirstSecondaryWindowFrame)
                            font.pixelSize: NeptuneStyle.fontSizeXS
                            opacity: NeptuneStyle.opacityMedium
                        }
                        Switch {
                            id: secondarySwitch
                            font.pixelSize: NeptuneStyle.fontSizeXS
                            text: qsTr("Performance monitor")
                            opacity: NeptuneStyle.opacityMedium
                            Binding { target: model.appInfo; property: "secondaryWindowPerfMonitorEnabled"; value: secondarySwitch.checked }
                        }
                    }
                    bottomPadding: NeptuneStyle.dp(20)
                }
                Image {
                    visible: model.index !== listView.model.count - 1
                    width: parent.width
                    height: NeptuneStyle.dp(sourceSize.height)
                    source: Style.gfx("list-divider", NeptuneStyle.theme)
                }
            }
        }
        ScrollIndicator.vertical: ScrollIndicator {}
    }
}
