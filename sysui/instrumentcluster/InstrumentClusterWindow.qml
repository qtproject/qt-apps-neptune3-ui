/****************************************************************************
**
** Copyright (C) 2017, 2018 Pelagicore AG
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

import QtQuick 2.7
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
    property bool invertedOrientation: root.clusterStore.invertedCluster
    property bool performanceOverlayVisible: false

    function nextApplicationICWindow() {
        applicationICWindows.next();
    }

    width: Config.instrumentClusterWidth
    height: Config.instrumentClusterHeight
    color: "black"
    title: root.clusterStore.clusterTitle
    screen: root.clusterStore.clusterScreen

    onWidthChanged: {
        root.contentItem.Sizes.scale = root.width / Config.instrumentClusterWidth;
    }

    Component.onCompleted: {
        // Would like to use a regular property binding instead. But it doesn't work and I don't know why
        visible = true;
    }

    Item {
        id: uiSlot
        anchors.centerIn: parent
        width: parent.width
        height: width / Config.instrumentClusterUIAspectRatio
        rotation: root.invertedOrientation ? 180 : 0

        Image {
            anchors.fill: parent
            source: Config.gfx("instrument-cluster-bg", Style.theme)
            fillMode: Image.Stretch
            visible: !applicationICWindows.visible
        }

        ApplicationICWindows {
            id: applicationICWindows
            anchors.fill: parent
            applicationModel: root.applicationModel

            visible: !empty

            readonly property bool selectedNavigation: {
                if (root.applicationModel) {
                    var app = root.applicationModel.applicationFromId(applicationICWindows.selectedApplicationId)
                    if (app) {
                        return app.categories.indexOf("navigation") !== -1;
                    }
                }
                return false;
            }
            Binding { target: instrumentClusterSettings; property: "navigationMode"; value: applicationICWindows.selectedNavigation }
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
