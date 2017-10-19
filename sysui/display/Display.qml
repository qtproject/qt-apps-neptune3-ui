/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Triton IVI UI.
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
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.3

import controls 1.0
import utils 1.0
import climate 1.0
import statusbar 1.0
import notification 1.0
import popup 1.0
import windowoverview 1.0

import models.application 1.0
import models.system 1.0
import models.startup 1.0

Image {
    id: root

    source: Style.gfx2(Style.displayBackground)

    property bool widgetEditingMode: false

    // Content Elements
    StatusBar {
        id: statusBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
    }

    Launcher {
        id: launcher
        anchors.top: statusBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
    }
    Button {
        text: "Edit Widgets"
        anchors.centerIn: root
        width: Style.hspan(5)
        opacity: launcher.open ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: 270; easing.type: Easing.InOutQuad } }
        visible: opacity > 0
        onClicked: {
            launcher.goHome()
            root.widgetEditMode = true;
        }
    }

    Item {
        id: mainContentArea
        y: launcher.y + Style.launcherHeight
        anchors.left: parent.left
        anchors.right: parent.right
        height: root.height - Style.statusBarHeight - Style.launcherHeight - Style.climateCollapsedVspan
        opacity: launcher.open ? 0 : 1
        Behavior on opacity { NumberAnimation { duration: 270; easing.type: Easing.InOutQuad } }
        enabled: !launcher.open

        Item {
            y: launcher.height - Style.launcherHeight
            width: parent.width
            height: parent.height

            StageLoader {
                id: windowStackLoader

                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: widgetDrawer.open ?  parent.height - widgetDrawer.height : parent.height
                active: StagedStartupModel.loadRest
                source: "WindowStack.qml"
                Behavior on height { SmoothedAnimation { easing.type: Easing.InOutQuad; duration: 270 } }
                Binding { target: windowStackeLoader.item; property: "widgetEditingMode"; value: root.widgetEditingMode }
            }

            WidgetDrawer {
                id: widgetDrawer
                width: parent.width
                height: Style.vspan(3)
                anchors.bottom: parent.bottom

                dragEnabled: !musicAppWindow.active

                ApplicationWidget {
                    id: musicAppWindow
                    width: parent.width - Style.hspan(1)
                    height: active ? expandedHeight : Style.vspan(3)
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter

                    appInfo: ApplicationManagerModel.application('com.pelagicore.music')

                    // when active the top edge will go all the way up to the bottom of the launcher
                    property real expandedHeight: mainContentArea.height

                    onActiveChanged: {
                        if (active) {
                            widgetDrawer.open = true;
                        }
                    }

                    Behavior on height {
                        SmoothedAnimation {
                            easing.type: Easing.InOutQuad
                            duration: 500
                        }
                    }
                }
            }
        }
    }


    Rectangle {
        id: mainContentMask
        anchors.fill: mainContentArea
        gradient: Gradient {
            GradientStop { position: 0.8; color: "#ffffffff" }
            GradientStop { position: 0.95; color: "#00ffffff" }
        }
        visible: false
    }

    OpacityMask {
        anchors.fill: mainContentArea
        source: mainContentArea
        maskSource: mainContentMask
        opacity: launcher.open ? 0.1 : 1
        Behavior on opacity { NumberAnimation { duration: 270; easing.type: Easing.InOutQuad } }
    }

    StageLoader {
        id: settingsLoader
        anchors.top: statusBar.bottom
        active: StagedStartupModel.loadBackgroundElements
        source: "../settings/Settings.qml"
    }

    ClimateBar {
        id: climateBar
    }

    StageLoader {
        id: toolBarMonitorLoader
        width: parent.width
        height: 200
        anchors.bottom: parent.bottom
        active: SystemModel.toolBarMonitorVisible
        source: "../dev/ProcessMonitor/ToolBarMonitor.qml"
    }

    StageLoader {
        id: windowOverviewLoader
        anchors.fill: parent
        active: StagedStartupModel.loadBackgroundElements
        source: "../windowoverview/WindowOverview.qml"
    }

    StageLoader {
        id: popupContainerLoader
        width: Style.popupWidth
        height: Style.popupHeight
        anchors.centerIn: parent
        active: StagedStartupModel.loadBackgroundElements
        source: "../popup/PopupContainer.qml"
    }

    StageLoader {
        id: notificationContainerLoader
        width: Style.screenWidth
        height: Style.vspan(2)
        active: StagedStartupModel.loadBackgroundElements
        source: "../notification/NotificationContainer.qml"
    }

    StageLoader {
        id: notificationCenterLoader
        width: Style.isPotrait ? Style.hspan(Style.notificationCenterSpan + 5) : Style.hspan(12)
        height: Style.screenHeight - Style.statusBarHeight
        anchors.top: statusBar.bottom
        active: StagedStartupModel.loadBackgroundElements
        source: "../notification/NotificationCenter.qml"
    }

    StageLoader {
        id: keyboardLoader
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        active: StagedStartupModel.loadBackgroundElements
        source: "../keyboard/Keyboard.qml"
    }

    Component.onCompleted: StagedStartupModel.enterMenuState()
}
