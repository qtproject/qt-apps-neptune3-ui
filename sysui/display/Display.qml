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

import QtQuick 2.7
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.2
import QtApplicationManager 1.0

import about 1.0
import climate 1.0
import controls 1.0
import display 1.0
import utils 1.0
import animations 1.0
import volume 1.0

import models.application 1.0
import models.climate 1.0
import models.system 1.0
import models.startup 1.0
import models.volume 1.0

import QtGraphicalEffects 1.0

import com.pelagicore.styles.neptune 3.0

Item {
    id: root

    property Item popupParent
    property var settings

    property var applicationModel: ApplicationModel {
        id: applicationModel
        cellWidth: Style.cellWidth
        cellHeight: Style.cellHeight
        localeCode: Style.languageLocale
    }

    Image {
        anchors.fill: parent
        source: Style.gfx2(NeptuneStyle.backgroundImage)
        opacity: launcherLoader.launcherOpen && NeptuneStyle.theme === NeptuneStyle.Light ? 0.7 : 1
        Behavior on opacity { DefaultNumberAnimation {} }
    }

    ClimateModel {
        id: climateModel
    }

    VolumeModel {
        id: volumeModel
    }

    Instantiator {
        model: applicationModel
        delegate: QtObject {
            property var exposedRectBottomMarginBinding: Binding {
                target: model.appInfo
                property: "exposedRectBottomMargin"
                value: model.appInfo.active && widgetDrawer.open && widgetDrawer.visible
                        ? activeApplicationSlot.height - widgetDrawer.y : climateBar.height
            }

            property var exposedRectTopMarginBinding: Binding {
                target: model.appInfo
                property: "exposedRectTopMargin"
                value: model.appInfo.active ? launcherLoader.y + Style.launcherHeight : 0
            }

            property var windowHeightBinding: Binding {
                target: model.appInfo.window
                property: "height"
                value: activeApplicationSlot.height
            }
        }
    }

    // Content Elements

    Item {
        id: mainContentArea
        anchors.left: parent.left
        anchors.right: parent.right
        height: root.height
        opacity: launcherLoader.launcherOpen ? 0 : 1
        Behavior on opacity { DefaultNumberAnimation {} }
        enabled: !launcherLoader.launcherOpen
        z: 0

        Item {
            y: launcherLoader.height - Style.launcherHeight
            width: parent.width
            height: parent.height

            StageLoader {
                id: homePageLoader

                anchors.left: parent.left
                anchors.right: parent.right

                y: launcherLoader.y + Style.launcherHeight
                height: parent.height - y - climateBar.height

                active: true //StagedStartupModel.loadRest
                source: "../home/HomePage.qml"
                Binding { target: homePageLoader.item; property: "applicationModel"; value: applicationModel.populating ? null : applicationModel }

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
                    anchors.fill: parent
                    appInfo: applicationModel.activeAppInfo && !applicationModel.activeAppInfo.asWidget ? applicationModel.activeAppInfo : null
                }
            }

            WidgetDrawer {
                id: widgetDrawer
                width: parent.width
                height: homePageLoader.homePageRowHeight
                anchors.bottom: homePageLoader.bottom

                dragEnabled: !showingHomePage
                visible: !showingHomePage && !widgetDrawerSlot.empty

                Item {
                    id: widgetDrawerSlot
                    width: widgetDrawer.homePageWidgetWidth
                    height: homePageLoader.homePageRowHeight
                    anchors.horizontalCenter: widgetDrawer.horizontalCenter
                    readonly property bool empty: children.length == 0
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
            GradientStop { position: 0; color: Qt.rgba(1, 1, 1, 0.3) }
            GradientStop { position: 0.8; color: Qt.rgba(1, 1, 1, 0.3) }
            GradientStop { position: 0.95; color: Qt.rgba(1, 1, 1, 0) }
        }
        visible: false
    }

    OpacityMask {
        anchors.fill: mainContentArea
        source: mainContentArea
        maskSource: mainContentMask
    }

    StageLoader {
        id: statusBarLoader
        height: Style.statusBarHeight
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        active: StagedStartupModel.loadDisplay
        source: "../statusbar/StatusBar.qml"
        Binding { target: statusBarLoader.item; property: "uiSettings"; value: settings }
        z: 1
    }

    StageLoader {
        id: launcherLoader
        property bool launcherOpen: launcherLoader.item ? launcherLoader.item.open : false
        anchors.top: statusBarLoader.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: launcherLoader.item ? launcherLoader.item.height : Style.launcherHeight
        active: StagedStartupModel.loadDisplay
        source: "../launcher/Launcher.qml"
        Binding { target: launcherLoader.item; property: "applicationModel"; value: applicationModel }
        Binding { target: launcherLoader.item; property: "showDevApps"; value: ApplicationManager.systemProperties.devMode }
        z: 1
    }

    ClimateBar {
        id: climateBar
        width: root.width
        height: Style.vspan(1.5)
        anchors.bottom: parent.bottom
        popupParent: root.popupParent
        model: climateModel

        Tool {
            id: leftIcon
            width: climateBar.toolWidth
            height: width
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: climateBar.lateralMargin
            symbol: volumePopup.volumeIcon
            onClicked: volumePopup.openLeft()
        }

        Tool {
            id: rightIcon
            width: climateBar.toolWidth
            height: width
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: climateBar.lateralMargin
            symbol: Style.symbol("qt-badge")
            onClicked: about.open()
        }
    }


    readonly property bool systemMonitorEnabled: SystemModel.showMonitorOverlay
                                              || (about.state === "open" && about.currentTabName === "monitor")

    Binding { target: SystemMonitor; property: "memoryReportingEnabled"; value: root.systemMonitorEnabled }
    Binding { target: SystemMonitor; property: "cpuLoadReportingEnabled"; value: root.systemMonitorEnabled }
    Binding { target: SystemMonitor; property: "reportingInterval"; value: 1000 }
    Binding { target: SystemModel; property: "ramTotalBytes"; value: (SystemMonitor.totalMemory / 1e6).toFixed(0) }
    Binding { target: SystemModel; property: "cpuPercentage"; value: (SystemMonitor.cpuLoad * 100).toFixed(0) }
    Binding { target: SystemModel; property: "ramBytes"; value: (SystemMonitor.memoryUsed / 1e6).toFixed(0) }

    VolumePopup {
        id: volumePopup
        parent: root.popupParent
        originItem: leftIcon
        model: volumeModel
    }

    // TODO load popup only before opening it and unload after closed
    About {
        id: about
        parent: root.popupParent
        originItem: rightIcon
        applicationModel: root.applicationModel
    }

    VirtualKeyboard {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }

    Component.onCompleted: {
        StagedStartupModel.enterMenuState()
    }
}
