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
import QtQuick.Controls 2.2
import QtApplicationManager 1.0

import controls 1.0
import display 1.0
import utils 1.0
import animations 1.0

import models.application 1.0
import models.system 1.0
import models.startup 1.0

import QtGraphicalEffects 1.0

Image {
    id: root

    property Item popupParent

    source: Style.gfx2(Style.displayBackground)

    ApplicationModel {
        id: applicationModel
        applicationManager: ApplicationManager
        windowManager: WindowManager
        cellWidth: Style.cellWidth
        cellHeight: Style.cellHeight
        homePageRowHeight: homePageLoader.homePageRowHeight
    }

    // Give some time for sysui to load itself before launching apps. Besides, starting the apps
    // that are shown as widgets immediately on ApplicationModel creation fails anyway.
    Timer {
        interval: 500
        running: true
        repeat: false
        onTriggered: applicationModel.readyToStartApps = true
    }

    Instantiator {
        model: applicationModel
        delegate: QtObject {
            property var exposedRectBottomMarginBinding: Binding {
                target: model.appInfo
                property: "exposedRectBottomMargin"
                value: model.appInfo.active && widgetDrawer.open ? activeApplicationSlot.height - widgetDrawer.y : 0
            }

            property var windowHeightBinding: Binding {
                target: model.appInfo.window
                property: "height"
                value: activeApplicationSlot.height
            }
        }
    }

    // Content Elements

    StageLoader {
        id: statusBarLoader
        height: Style.statusBarHeight
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        active: StagedStartupModel.loadDisplay
        source: "../statusbar/StatusBar.qml"
    }

    StageLoader {
        id: launcherLoader
        width: Style.launcherWidth
        height: launcherLoader.item && launcherLoader.item.open ? launcherLoader.item.expandedHeight : Style.launcherHeight
        Behavior on height { DefaultSmoothedAnimation {} }

        property bool launcherOpen: launcherLoader.item ? launcherLoader.item.open : false
        anchors.top: statusBarLoader.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        active: StagedStartupModel.loadDisplay
        source: "../launcher/Launcher.qml"
        Binding { target: launcherLoader.item; property: "applicationModel"; value: applicationModel }
    }

    Item {
        id: mainContentArea
        y: launcherLoader.y + Style.launcherHeight
        anchors.left: parent.left
        anchors.right: parent.right
        height: root.height - Style.statusBarHeight - Style.launcherHeight - climateLoader.height
        opacity: launcherLoader.launcherOpen ? 0 : 1
        Behavior on opacity { DefaultNumberAnimation {} }
        enabled: !launcherLoader.launcherOpen

        Item {
            y: launcherLoader.height - Style.launcherHeight
            width: parent.width
            height: parent.height

            StageLoader {
                id: homePageLoader

                anchors.fill: parent
                active: true //StagedStartupModel.loadRest
                source: "../home/HomePage.qml"
                Binding { target: homePageLoader.item; property: "applicationModel"; value: applicationModel }

                // widgets will reparent themselves to the active application slot when active
                Binding { target: homePageLoader.item; property: "activeApplicationParent"; value: activeApplicationSlot }
                Binding { target: homePageLoader.item; property: "moveBottomWidgetToDrawer"; value: !widgetDrawer.showingHomePage }
                Binding { target: homePageLoader.item; property: "widgetDrawer"; value: widgetDrawerSlot }
                Binding { target: homePageLoader.item; property: "popupParent"; value: popupParent }

                property real homePageRowHeight: item ? item.rowHeight : 0
            }

            // slot for the maximized, active, application
            Item {
                id: activeApplicationSlot
                anchors.fill: parent

                ApplicationFrame {
                    id: activeAppFrame
                    anchors.fill: parent
                    appInfo: applicationModel.activeAppInfo && !applicationModel.activeAppInfo.asWidget ? applicationModel.activeAppInfo : null
                }
            }

            WidgetDrawer {
                id: widgetDrawer
                width: parent.width
                height: homePageLoader.homePageRowHeight
                anchors.bottom: parent.bottom

                dragEnabled: !showingHomePage
                visible: !showingHomePage

                Item {
                    id: widgetDrawerSlot
                    width: widgetDrawer.homePageWidgetWidth
                    height: homePageLoader.homePageRowHeight
                    anchors.horizontalCenter: widgetDrawer.horizontalCenter
                }

                property bool showingHomePage: applicationModel.activeAppInfo === null
                onShowingHomePageChanged: {
                    if (showingHomePage) {
                        widgetDrawer.open = true;
                    }
                }

                property real homePageWidgetWidth: homePageLoader.item ? homePageLoader.item.widgetWidth : 0
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
        opacity: launcherLoader.launcherOpen ? 0.1 : 1
        Behavior on opacity { DefaultSmoothedAnimation {} }
    }

    StageLoader {
        id: climateLoader
        width: Style.screenWidth
        height: Style.vspan(1.4)
        anchors.bottom: parent.bottom
        active: StagedStartupModel.loadDisplay
        source: "../climate/ClimateBar.qml"
    }

// TODO: Update below components according to the newest spec of Triton-UI when available
//    StageLoader {
//        id: toolBarMonitorLoader
//        width: parent.width
//        height: 200
//        anchors.bottom: parent.bottom
//        active: SystemModel.toolBarMonitorVisible
//        source: "../dev/ProcessMonitor/ToolBarMonitor.qml"
//    }

//    StageLoader {
//        id: windowOverviewLoader
//        anchors.fill: parent
//        active: StagedStartupModel.loadBackgroundElements
//        source: "../windowoverview/WindowOverview.qml"
//    }

//    StageLoader {
//        id: popupContainerLoader
//        width: Style.popupWidth
//        height: Style.popupHeight
//        anchors.centerIn: parent
//        active: StagedStartupModel.loadBackgroundElements
//        source: "../popup/PopupContainer.qml"
//    }

//    StageLoader {
//        id: notificationContainerLoader
//        width: Style.screenWidth
//        height: Style.vspan(2)
//        active: StagedStartupModel.loadBackgroundElements
//        source: "../notification/NotificationContainer.qml"
//    }

//    StageLoader {
//        id: notificationCenterLoader
//        width: Style.isPotrait ? Style.hspan(Style.notificationCenterSpan + 5) : Style.hspan(12)
//        height: Style.screenHeight - Style.statusBarHeight
//        anchors.top: statusBar.bottom
//        active: StagedStartupModel.loadBackgroundElements
//        source: "../notification/NotificationCenter.qml"
//    }

//    StageLoader {
//        id: keyboardLoader
//        anchors.left: parent.left
//        anchors.right: parent.right
//        anchors.bottom: parent.bottom
//        active: StagedStartupModel.loadBackgroundElements
//        source: "../keyboard/Keyboard.qml"
//    }

    Component.onCompleted: {
        StagedStartupModel.enterMenuState()
    }
}
