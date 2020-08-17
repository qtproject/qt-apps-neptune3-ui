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
import shared.utils 1.0
import shared.animations 1.0
import "../stores" 1.0
import "../controls" 1.0

import shared.Style 1.0
import shared.Sizes 1.0

Item {
    id: root

    property DownloadsStore store

    states: [
        State {
            when: store.downloadsStates.noNetwork.active
            PropertyChanges { target: busyMessage; opacity: 1.0 }
            PropertyChanges { target: downloadsContent; opacity: 0.0 }
            PropertyChanges {
                target: busyIndicator
                opacity: store.downloadsStates.connectingToServer.active ? 1.0 : 0.0
            }
            PropertyChanges {
                target: topMessageText
                text: qsTr("Cannot Connect to the Server") + "\n" +
                      qsTr("A Network connection is required")
            }
            PropertyChanges {
                target: bottomMessageText
                text: qsTr("Reconnecting...")
                opacity: store.downloadsStates.connectingToServer.active ? 1.0 : 0.0
            }
            PropertyChanges {
                target: retryButton
                visible: !store.downloadsStates.connectingToServer.active
            }
        },
        State {
            when: store.downloadsStates.networkConnected.active
                  && store.downloadsStates.connectingToServer.active
            PropertyChanges { target: busyMessage; opacity: 1.0 }
            PropertyChanges { target: downloadsContent; opacity: 0.0 }
            PropertyChanges { target: busyIndicator; opacity: 1.0 }
            PropertyChanges {
                target: topMessageText
                text: qsTr("Connecting to server...")
            }
            PropertyChanges { target: bottomMessageText; opacity: 0.0 }
            PropertyChanges { target: retryButton; visible: false }
        },
        State {
            when: store.downloadsStates.networkConnected.active
                  && store.downloadsStates.checkServerError.active
            PropertyChanges { target: busyMessage; opacity: 1.0 }
            PropertyChanges { target: downloadsContent; opacity: 0.0 }
            PropertyChanges { target: busyIndicator; opacity: 1.0 }
            PropertyChanges {
                target: topMessageText
                text: qsTr("Connecting to server...")
            }
            PropertyChanges { target: bottomMessageText; opacity: 0.0 }
            PropertyChanges { target: retryButton; visible: false }
        },
        State {
            when: store.downloadsStates.serverNA.active
            PropertyChanges { target: busyMessage; opacity: 1.0 }
            PropertyChanges { target: downloadsContent; opacity: 0.0 }
            PropertyChanges { target: busyIndicator; opacity: 0.0 }
            PropertyChanges {
                target: topMessageText
                text: qsTr("Server is not available")
            }
            PropertyChanges { target: retryButton; visible: true }
        },
        State {
            when: store.downloadsStates.serverOnMaintance.active
            PropertyChanges { target: busyMessage; opacity: 1.0 }
            PropertyChanges { target: downloadsContent; opacity: 0.0 }
            PropertyChanges { target: busyIndicator; opacity: 0.0 }
            PropertyChanges {
                target: topMessageText
                text: qsTr("Server is on Maintance")
            }
            PropertyChanges { target: retryButton; visible: true }
        },
        State {
            when: store.downloadsStates.connectedError.active
            PropertyChanges { target: busyMessage; opacity: 1.0 }
            PropertyChanges { target: downloadsContent; opacity: 0.0 }
            PropertyChanges { target: busyIndicator; opacity: 0.0 }
            PropertyChanges {
                target: topMessageText
                text: store.downloadsStates.connectedError.errorText
            }
            PropertyChanges { target: retryButton; visible: true }
        },
        State {
            when: store.downloadsStates.fetchingApps.active
                  || store.downloadsStates.fetchingCategories.active
            PropertyChanges { target: busyMessage; opacity: 1.0 }
            PropertyChanges { target: downloadsContent; opacity: 1.0 }
            PropertyChanges { target: appList; opacity: 0.0 }
            PropertyChanges { target: busyIndicator; opacity: 1.0 }
            PropertyChanges {
                target: topMessageText
                text: qsTr("Fetching data from Neptune Server")
            }
            PropertyChanges { target: bottomMessageText; text: "" }
            PropertyChanges { target: retryButton; visible: false }
        },
        State {
            when: store.downloadsStates.appsLoaded.active && appList.count === 0
            PropertyChanges { target: busyMessage; opacity: 1.0 }
            PropertyChanges { target: downloadsContent; opacity: 1.0 }
            PropertyChanges { target: busyIndicator; opacity: 0.0 }
            PropertyChanges {
                target: topMessageText
                text: qsTr("No apps")
            }
            PropertyChanges { target: bottomMessageText; text: "" }
            PropertyChanges { target: retryButton; visible: false }
        },
        State {
            when: store.downloadsStates.appsLoaded.active && appList.count > 0
            PropertyChanges { target: busyMessage; opacity: 0.0 }
            PropertyChanges { target: downloadsContent; opacity: 1.0 }
            PropertyChanges { target: appList; opacity: 1.0 }
        }
    ]

    RowLayout {
        id: downloadsContent

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(500)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Sizes.dp(20)
        opacity: 0.0
        visible: opacity > 0

        DownloadsToolsColumn {
            id: toolsColumn

            objectName: "downloadsAppColumn"
            Layout.preferredWidth: Sizes.dp(264)
            Layout.fillHeight: true
            model: root.store.categoryModel
            serverUrl: root.store.appServerUrl
            onToolClicked: root.store.selectCategory(index)
            onRefresh: root.store.categoryModel.refresh()
        }

        DownloadAppList {
            id: appList

            objectName: "downloadAppList"
            Layout.preferredHeight: Sizes.dp(800)
            Layout.preferredWidth: Sizes.dp(675)
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: Sizes.dp(16)
            appServerUrl: root.store.appServerUrl
            cpuArch: root.store.cpuArch
            applicationModel: root.store.applicationModel
            currentInstallationProgress: root.store.currentInstallationProgress
            onToolClicked: {
                if (root.store.isPackageBusy(appId)) {
                    console.warn("Package busy... Aborting", appId)
                    return;
                }
                if (root.store.isPackageInstalledByPackageController(appId)) {
                    root.store.uninstallPackage(appId, appName);
                } else {
                    root.store.download(appId, appName, purchaseId, iconUrl);
                }
            }
            onAppClicked: { root.store.tryStartApp(appId); }

            Behavior on opacity { DefaultNumberAnimation { duration: 200 } }

            Connections {
                target: root.store
                function onInstalledPackagesChanged() {
                    // update states of app items, pass functions to update function
                    appList.refreshAppsInfo(root.store.isPackageInstalledByPackageController,
                                            root.store.isPackageBuiltIn,
                                            root.store.getInstalledPackageSizeText)
                }
            }
        }
    }

    Item {
        id: busyMessage

        anchors.fill: parent
        Behavior on opacity {
            SequentialAnimation{
                // keep invisible and only show if nothing happens not to blink
                PauseAnimation { duration: 400 }
                DefaultNumberAnimation { }
            }
        }

        ColumnLayout {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: Sizes.dp(400)

            BusyIndicator {
                id: busyIndicator

                implicitWidth: Sizes.dp(225)
                implicitHeight: Sizes.dp(440)
                opacity: 0.0
                Layout.alignment: Qt.AlignHCenter
                Behavior on opacity  {
                    SequentialAnimation{
                        PauseAnimation { duration: 1000 }
                        DefaultNumberAnimation { }
                    }
                }
            }

            Label {
                id: topMessageText

                color: Style.contrastColor
                font.pixelSize: Sizes.fontSizeM
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
            }

            Label {
                id: bottomMessageText

                color: Style.contrastColor
                font.pixelSize: Sizes.fontSizeM
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
            }

            Button {
                id: retryButton

                text: qsTr("Retry")
                implicitHeight: Sizes.dp(70)
                implicitWidth: Sizes.dp(315)
                font.pixelSize: Sizes.fontSizeS
                visible: false
                Layout.alignment: Qt.AlignHCenter
                onClicked: { store.appStoreConfig.checkServer() }
            }
        }
    }

    /*

    // Debug visual output for states changes

    Loader {
        active: true
        sourceComponent: Component {
            id: debugStatesComponent

            ListView {
                width: parent.width; height: Sizes.dp(600)
                model: statesModel
                delegate: Row {
                    Rectangle {
                        width: Sizes.dp(20); height: Sizes.dp(30);
                        color: model.stateValue ? "green" : "red"
                    }
                    Label { text: model.stateName }
                }

                function updateStatesList() {
                    statesModel.clear();
                    statesModel.append({"stateName": "noNetwork", "stateValue": store.downloadsStates.noNetwork.active });
                    statesModel.append({"stateName": "networkConnected", "stateValue": store.downloadsStates.networkConnected.active });
                    statesModel.append({"stateName": "connectingToServer", "stateValue": store.downloadsStates.connectingToServer.active });
                    statesModel.append({"stateName": "connectedError", "stateValue": store.downloadsStates.connectedError.active });
                    statesModel.append({"stateName": "connectedToServer", "stateValue": store.downloadsStates.connectedToServer.active });
                    statesModel.append({"stateName": "fetchingApps", "stateValue": store.downloadsStates.fetchingApps.active });
                    statesModel.append({"stateName": "fetchingCategories", "stateValue": store.downloadsStates.fetchingCategories.active });
                    statesModel.append({"stateName": "appsLoaded", "stateValue": store.downloadsStates.appsLoaded.active });
                    statesModel.append({"stateName": "serverOnMaintance", "stateValue": store.downloadsStates.serverOnMaintance.active });
                    statesModel.append({"stateName": "serverNA", "stateValue": store.downloadsStates.serverNA.active });
                    statesModel.append({"stateName": "loggingIn", "stateValue": store.downloadsStates.loggingIn.active });
                    statesModel.append({"stateName": "categoriesLoaded", "stateValue": store.downloadsStates.categoriesLoaded.active });
                    statesModel.append({"stateName": "checkServerError", "stateValue": store.downloadsStates.checkServerError.active });
                }

                ListModel {
                    id: statesModel
                    Component.onCompleted: { updateStatesList(); }
                }

                Connections {
                    target: root
                    function onStateChanged() { updateStatesList(); }
                }
            }

        }
    }

    */
}
