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

import QtQuick 2.7
import QtQml 2.14
import shared.utils 1.0
import QtQuick.Window 2.3
import system.controls 1.0
import shared.Style 1.0
import shared.Sizes 1.0

Window {
    id: root

    property var clusterStore
    property var applicationModel
    property var instrumentClusterSettings: root.clusterStore.clusterSettings
    property var uiSettings
    property bool invertedOrientation: root.clusterStore.invertedCluster
    property bool performanceOverlayVisible: false
    property int clusterPosition: root.clusterStore.clusterPosition // 0: top 1: center 2: bottom

    function nextApplicationICWindow() {
        applicationICWindows.next();
    }

    // Demo case to stick QtSafeRendererWindow to Cluster on Desktop
    // should be also enabled on "Safe" part
    // send x,y of window, x,y of uiSlot (contains cluster view item) inside window,
    // width and height of uiSlot item
    function sendWindowStateToSafeUI() {
        if (root.clusterStore.runningOnDesktop) {
            var sendMessageObject = Qt.createQmlObject(
                    "import QtQuick 2.0;  import Qt.SafeRenderer 1.1;
                     QtObject {
                         function sendClusterWindowState(x,y, dx, dy, width, height) {
                             SafeMessage.moveItem(\"mainWindowPos\", Qt.point(x, y))
                             SafeMessage.moveItem(\"mainWindowPanelOrigin\", Qt.point(dx, dy))
                             SafeMessage.moveItem(\"mainWindowPanelSize\", Qt.point(width, height))
                         }
                     }", root, "sendMessageObject");
            sendMessageObject.sendClusterWindowState(root.x, root.y, uiSlot.x, uiSlot.y,
                                                   uiSlot.width, uiSlot.height);
        }
    }

    color: "black"
    title: root.clusterStore.clusterTitle
    screen: root.clusterStore.clusterScreen

    Component.onCompleted: {
        // Would like to use a regular property binding instead. But it doesn't work and I don't know why
        visible = true;

        // Don't use bindings for setting up the initial size. Otherwise the binding is revaluated
        // on every language change, which results in resetting the window size to it's initial state
        // and might overwrite the size given by the OS or the user using the WindowManager
        // It happens because QQmlEngine::retranslate() refreshes all the engine's bindings
        if (!clusterStore.runningOnDesktop) {
            root.width = Config.instrumentClusterWidth;
            root.height = Config.instrumentClusterHeight;
        } else {
            root.width = clusterStore.desktopWidth;
            root.height = clusterStore.desktopHeight;
        }
    }

    // Use these two Connections to send (if qsr enabled) cluster window positions to QSR Safe UI
    // QSR Safe UI window then moves to cluster item 0,0 position
    // panel properties for scale are sent from SafeTelltalesPanel
    // Desktop-specific demo case
    Connections {
        target: root
        enabled: root.clusterStore.qsrEnabled
        function onXChanged() { sendWindowStateToSafeUI(); }
        function onYChanged() { sendWindowStateToSafeUI(); }
        function onActiveChanged() { sendWindowStateToSafeUI(); }
    }
    Connections {
        target: uiSlot
        enabled: root.clusterStore.qsrEnabled
        function onWidthChanged() { sendWindowStateToSafeUI(); }
        function onHeightChanged() { sendWindowStateToSafeUI(); }
        function onYChanged() { sendWindowStateToSafeUI(); }
        function onXChanged() { sendWindowStateToSafeUI(); }
    }

    Item {
        id: uiSlot

        states: [
            State {
                name: "top"
                when: root.clusterPosition === 0
                AnchorChanges {
                    target: uiSlot
                    anchors.top: parent.top
                    anchors.bottom: undefined
                    anchors.verticalCenter: undefined
                }
            },
            State {
                name: "center"
                when: root.clusterPosition === 1
                AnchorChanges {
                    target: uiSlot
                    anchors.top: undefined
                    anchors.bottom: undefined
                    anchors.verticalCenter: parent.verticalCenter
                }
            },
            State {
                name: "bottom"
                when: root.clusterPosition === 2
                AnchorChanges {
                    target: uiSlot
                    anchors.top: undefined
                    anchors.bottom: parent.bottom
                    anchors.verticalCenter: undefined
                }
            }
        ]

        anchors.horizontalCenter: parent.horizontalCenter
        rotation: root.invertedOrientation ? 180 : 0
        height: Math.floor(root.width / Config.instrumentClusterUIAspectRatio) <= root.height
                ? root.width / Config.instrumentClusterUIAspectRatio
                : root.height;
        width: height * Config.instrumentClusterUIAspectRatio

        onWidthChanged: {
            root.contentItem.Sizes.scale = uiSlot.width / Config.instrumentClusterWidth;
        }

        Image {
            anchors.fill: parent
            source: Style.image("instrument-cluster-bg")
            fillMode: Image.Stretch
            visible: !applicationICWindows.visible
        }

        ApplicationICWindows {
            id: applicationICWindows
            anchors.fill: parent
            applicationModel: root.applicationModel

            visible: !empty && (selectedApplicationId !== "")

            readonly property bool selectedNavigation: {
                if (root.applicationModel) {
                    var app = root.applicationModel.applicationFromId(applicationICWindows.selectedApplicationId)
                    if (app) {
                        return app.categories.indexOf("navigation") !== -1;
                    }
                }
                return false;
            }

            onSelectedApplicationIdChanged: {
                /*
                    change UI mode of cluster according to app behind gauges
                */
                var clusterUIMode = 0; //no app running default

                if (selectedApplicationId !== "") {
                    var app = root.applicationModel.applicationFromId(selectedApplicationId)
                    if (app) {
                        if (app.categories.indexOf("navigation") !== -1) {
                            clusterUIMode = 2; //navi app
                        } else {
                            clusterUIMode = 1; //some app
                        }
                    }
                }

                if ( root.applicationModel.instrumentClusterAppInfo &&
                        root.applicationModel.instrumentClusterAppInfo.window ) {
                    root.applicationModel.instrumentClusterAppInfo.window.setWindowProperty("clusterUIMode", clusterUIMode)
                }
            }
            Binding {
                restoreMode: Binding.RestoreBinding;
                target: uiSettings; property: "navigationMode";
                value: applicationICWindows.selectedNavigation;
            }
        }

        ApplicationICWindowItem {
            id: windowItem
            anchors.fill: parent
            appInfo: applicationModel && applicationModel.instrumentClusterAppInfo
                     ? applicationModel.instrumentClusterAppInfo : null
            window: appInfo ? appInfo.window : null
        }
    }

    MonitorOverlay {
        anchors.fill: parent
        fpsVisible: root.performanceOverlayVisible
        window: root
        rotation: root.invertedOrientation ? 180 : 0
    }

    Shortcut {
        sequence: "Ctrl+c"
        context: Qt.ApplicationShortcut
        onActivated: root.nextApplicationICWindow();
    }
}
