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

import controls 1.0
import utils 1.0
import animations 1.0

import models.application 1.0
import models.system 1.0
import models.startup 1.0

Control {
    id: root

    background: Image {
        anchors.fill: root
        source: Style.gfx2(Style.displayBackground)
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
    }

    Item {
        id: mainContentArea
        y: launcherLoader.y + Style.launcherHeight
        anchors.left: parent.left
        anchors.right: parent.right
        height: root.height - Style.statusBarHeight - Style.launcherHeight - Style.climateCollapsedVspan
        opacity: launcherLoader.launcherOpen ? 0 : 1
        Behavior on opacity { DefaultNumberAnimation {} }
        enabled: !launcherLoader.launcherOpen

        Item {
            y: launcherLoader.height - Style.launcherHeight
            width: parent.width
            height: parent.height

            StageLoader {
                id: windowStackLoader

                anchors.fill: parent
                active: StagedStartupModel.loadRest
                source: "WindowStack.qml"
            }

            WidgetDrawer {
                id: widgetDrawer
                width: parent.width
                height: homePageRowHeight
                anchors.bottom: parent.bottom

                // TODO: try to make this parent swapping nicer and more declarative
                property var previousWidgetParent
                onShowingHomePageChanged: {
                    if (showingHomePage) {
                        open = true;
                        if (previousWidgetParent && homePageBottomApplicationWidget) {
                            homePageBottomApplicationWidget.parent = previousWidgetParent
                        }
                    } else if (homePageBottomApplicationWidget) {
                        previousWidgetParent = homePageBottomApplicationWidget.parent
                        homePageBottomApplicationWidget.parent = applicationWidgetSlot
                    }
                }

                dragEnabled: homePageBottomApplicationWidget && !homePageBottomApplicationWidget.active && !showingHomePage

                visible: !showingHomePage

                Item {
                    id: applicationWidgetSlot
                    width: widgetDrawer.homePageWidgetWidth
                    height: widgetDrawer.homePageRowHeight
                    anchors.horizontalCenter: widgetDrawer.horizontalCenter
                }

                property bool showingHomePage: windowStackLoader.item ? windowStackLoader.item.showingHomePage : false
                property Item homePageBottomApplicationWidget: windowStackLoader.item ? windowStackLoader.item.homePageBottomApplicationWidget : null
                property real homePageWidgetWidth: windowStackLoader.item ? windowStackLoader.item.homePageWidgetWidth : 0
                property real homePageRowHeight: windowStackLoader.item ? windowStackLoader.item.homePageRowHeight : 0
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
        height: Style.vspan(2.5)
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

    Component.onCompleted: StagedStartupModel.enterMenuState()
}
