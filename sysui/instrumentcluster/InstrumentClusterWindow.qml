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
import utils 1.0
import QtQuick.Window 2.3

import QtApplicationManager 1.0

import com.pelagicore.styles.neptune 3.0
import com.pelagicore.settings 1.0 as Settings

Window {
    id: root
    width: Style.instrumentClusterWidth
    height: Style.instrumentClusterHeight
    title: "Neptune UI - Instrument Cluster"

    color: "black"


    property var applicationModel
    property bool invertedOrientation: false
    property bool performanceOverlayVisible: false

    function nextSecondaryWindow() {
        secondaryAppWindows.next();
    }

    Component.onCompleted: {
        WindowManager.registerCompositorView(root)
    }

    readonly property var window: applicationModel && applicationModel.instrumentClusterAppInfo
            ? applicationModel.instrumentClusterAppInfo.window : null

    Binding { target: root.window; property: "width"; value: uiSlot.width }
    Binding { target: root.window; property: "height"; value: uiSlot.height }
    Binding { target: root.window; property: "parent"; value: uiSlot }
    Binding { target: root.window; property: "z"; value: 2 }


    Settings.InstrumentCluster {
        id: instrumentClusterSettings
    }

    Settings.SystemUI {
        id: sysuiSettings
        onSecondaryWindowSwitchCountChanged: secondaryAppWindows.next();
    }

    onWidthChanged: {
        root.contentItem.NeptuneStyle.scale = root.width / Style.instrumentClusterWidth;
    }

    Item {
        id: uiSlot
        anchors.centerIn: parent
        width: parent.width
        height: width / Style.instrumentClusterUIAspectRatio
        rotation: root.invertedOrientation ? 180 : 0

        Image {
            anchors.fill: parent
            source: Style.gfx("instrument-cluster-bg", NeptuneStyle.theme)
            fillMode: Image.Stretch
            visible: !secondaryAppWindows.visible
        }

        SecondaryAppWindows {
            id: secondaryAppWindows
            anchors.fill: parent
            z: 1
            applicationModel: root.applicationModel

            visible: !empty

            readonly property bool selectedNavigation: {
                if (root.applicationModel) {
                    var app = root.applicationModel.applicationFromId(secondaryAppWindows.selectedApplicationId)
                    if (app) {
                        return app.categories.indexOf("navigation") !== -1;
                    }
                }
                return false;
            }
            Binding { target: instrumentClusterSettings; property: "navigationMode"; value: secondaryAppWindows.selectedNavigation }
        }
    }

    MonitorOverlay {
        anchors.fill: parent
        fpsVisible: root.performanceOverlayVisible
        window: root
        rotation: root.invertedOrientation ? 180 : 0
    }


    // lazy way of putting the instrument cluster in a separate screen, if available
    screen: Qt.application.screens[Qt.application.screens.length - 1]

    visible: window != null
}
