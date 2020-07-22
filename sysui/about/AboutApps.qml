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
import QtQml 2.14
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

    function isPackageBuiltIn(appId) {
        var app = ApplicationManager.application(appId)
        return app && app.builtIn;
    }

    function isApplicationBusy(appId) {
        var taskIds = ApplicationInstaller.activeTaskIds()
        if (taskIds.includes(appId)) {
            return true;
        }

        return false;
    }

    function uninstallApplication(appId) {
        if (isApplicationBusy(appId)) {
            console.warn("Application busy... Abort uninstall", appId);
            return;
        }
        ApplicationInstaller.removePackage(appId, false /*keepDocuments*/, true /*force*/);
    }

    Instantiator {
        model: root.applicationModel
        delegate: QtObject {
            property var con: Connections {
                target: model.appInfo
                Component.onCompleted: {
                    runningAppsModel.appendAppInfo(model.appInfo);
                    runningAppsModel.sortApps()
                }
            }
        }
    }

    Connections {
        target: applicationModel
        ignoreUnknownSignals: true
        function onAppRemoved(appInfo) {
            runningAppsModel.removeAppInfo(appInfo)
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
                       "cpuLoad": 0.0
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

        function lessApp(left, right) {
            return left.appInfo.name > right.appInfo.name;
        }

        function sortApps() {
            var swapped;
            do {
                swapped = false;
                for (var i = 0; i < count - 1; i++) {
                    if (lessApp(get(i), get(i + 1))) {
                        move(i, i+1, 1);
                        swapped = true;
                    }
                }
            } while (swapped);
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
        font.pixelSize: Sizes.fontSizeXS
    }

    ListView {
        id: listView
        clip: true
        model: runningAppsModel
        spacing: Sizes.dp(10)
        anchors.top: infoLabel.bottom
        anchors.topMargin: Sizes.dp(30)
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        delegate: itemDelegate
        ScrollIndicator.vertical: ScrollIndicator {}
    }

    Component {
        id: itemDelegate
        Item {
            id: delegateRoot

            width: parent.width
            implicitHeight: Sizes.dp(265)

            function getWindowTypeName(window) {

                if (window) {
                    switch (window.windowProperty("windowType")) {
                    case undefined:
                        return qsTr("Center Console Window")
                    case "bottombar":
                        return qsTr("Bottom Bar Window");
                    case "hud":
                        return qsTr("HUD Window");
                    case "instrumentcluster":
                        return qsTr("Instrument Cluster Window");
                    }
                }

                return qsTr("No Window");
            }

            ProcessStatus {
                id: processStatus
                applicationId: model.appInfo ? model.appInfo.id : ""
            }

            Timer {
                interval: 1000
                running: root.visible && model.appInfo.running
                repeat: true
                onTriggered: {
                    processStatus.update()
                    model.cpuLoad = processStatus.cpuLoad
                }
            }

            ColumnLayout {
                anchors.fill: parent; spacing: 0.0

                RowLayout{
                    Label {
                        text: model.appInfo ? model.appInfo.name : qsTr("Unknown app")
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Item { Layout.fillWidth: true }

                    ToolButton {
                        icon.name: "ic-remove"
                        visible: appInfo? !root.isPackageBuiltIn(appInfo.id) : false
                        display: NeptuneIconLabel.IconOnly
                        spacing: 0.0; padding: 0.0
                        Layout.alignment: Qt.AlignVCenter; Layout.leftMargin: Sizes.dp(10)
                        onClicked: root.uninstallApplication(appInfo.id)
                    }

                    Label {
                        text: model.appInfo ? model.appInfo.id : ""
                        font.pixelSize: Sizes.fontSizeXS
                        opacity: Style.opacityMedium
                        Layout.alignment: Qt.AlignVCenter; Layout.rightMargin: Sizes.dp(20)
                    }
                }

                RowLayout {
                    ColumnLayout {
                        spacing: 0.0

                        Label {
                            readonly property string memoryPSS: (processStatus.memoryPss.total
                                                                 / 1e6).toFixed(0)
                            readonly property string memoryRSS: (processStatus.memoryRss.total
                                                                 / 1e6).toFixed(0)
                            readonly property string cpuLoad: (processStatus.cpuLoad
                                                               * 100).toFixed(1)

                            text: qsTr("CPU: %L1 %; RSS: %L3 MB; PSS: %L4 MB")
                                            .arg(cpuLoad)
                                            .arg(memoryRSS)
                                            .arg(memoryPSS)
                            font.pixelSize: Sizes.fontSizeS
                            opacity: model.appInfo.running ? Style.opacityMedium : 0.0
                            Layout.leftMargin: Sizes.dp(40)
                        }

                        RowLayout {

                            Switch {
                                font.pixelSize: Sizes.fontSizeXS
                                text: qsTr("Autostart")
                                Component.onCompleted: {
                                    checked = model.appInfo.autostart
                                }
                                onCheckedChanged: {
                                    root.applicationModel.updateAutostart(model.appInfo.id, checked)
                                }
                            }

                            Switch {
                                id: autorecoverSwitch

                                font.pixelSize: Sizes.fontSizeXS
                                text: qsTr("Autorecover")
                                checked: model.appInfo.autorecover
                                onCheckedChanged: {
                                    root.applicationModel.updateAutorecover(model.appInfo.id,
                                                                        autorecoverSwitch.checked)
                                }
                            }

                            Item { Layout.fillWidth: true }

                            ToolButton {
                                icon.name: appInfo.running ? "ic-close" : "ic-start"
                                display: NeptuneIconLabel.IconOnly
                                font.pixelSize: Sizes.fontSizeXS
                                spacing: 0.0; padding: 0.0
                                Layout.alignment: Qt.AlignVCenter; Layout.rightMargin: Sizes.dp(10)
                                onClicked: {
                                    appInfo.running ? model.appInfo.stop() : model.appInfo.start()
                                }
                            }
                        }
                    }


                }

                ColumnLayout {
                    visible: model.appInfo ? !!model.appInfo.window : false
                    spacing: 0.0
                    Layout.fillWidth: true; Layout.leftMargin: Sizes.dp(40)

                    Label {
                        text: delegateRoot.getWindowTypeName(model.appInfo.window)
                        font.pixelSize: Sizes.fontSizeS
                    }

                    RowLayout {
                        width: parent.width - parent.leftPadding

                        Label {
                            text: qsTr("Time to first frame: %1 ms")
                                        .arg(model.appInfo.timeToFirstWindowFrame === -1
                                                            ? qsTr("N/A")
                                                            : model.appInfo.timeToFirstWindowFrame)
                            font.pixelSize: Sizes.fontSizeXS
                            opacity: Style.opacityMedium
                            Layout.fillWidth: true
                        }

                        Switch {
                            id: primarySwitch

                            font.pixelSize: Sizes.fontSizeXS
                            text: qsTr("Performance monitor")
                            opacity: Style.opacityMedium
                            Binding {
                                restoreMode: Binding.RestoreBinding;
                                target: model.appInfo; property: "windowPerfMonitorEnabled";
                                value: primarySwitch.checked;
                            }
                            visible: !model.appInfo.isSystemApp
                        }
                    }
                }

                ColumnLayout {
                    visible: model.appInfo ? !!model.appInfo.icWindow : false
                    spacing: 0.0
                    Layout.fillWidth: true; Layout.leftMargin: Sizes.dp(40)

                    Label {
                        text: delegateRoot.getWindowTypeName(model.appInfo.icWindow)
                        font.pixelSize: Sizes.fontSizeS
                    }

                    RowLayout {
                        Label {
                            text: qsTr("Time to first frame: %1 ms")
                                            .arg(model.appInfo.timeToFirstICWindowFrame === -1
                                                           ? qsTr("N/A")
                                                           : model.appInfo.timeToFirstICWindowFrame)
                            font.pixelSize: Sizes.fontSizeXS
                            opacity: Style.opacityMedium
                            Layout.fillWidth: true
                        }

                        Switch {
                            id: secondarySwitch

                            font.pixelSize: Sizes.fontSizeXS
                            text: qsTr("Performance monitor")
                            opacity: Style.opacityMedium
                            Binding {
                                restoreMode: Binding.RestoreBinding;
                                target: model.appInfo; property: "icWindowPerfMonitorEnabled";
                                value: secondarySwitch.checked;
                            }
                        }
                    }
                }

                Item { Layout.fillHeight: true }
            }

            Image {
                visible: model.index !== listView.model.count - 1
                width: parent.width
                height: Sizes.dp(sourceSize.height)
                source: Style.image("list-divider")
                anchors.bottom: delegateRoot.bottom
            }
        }
    }
}
