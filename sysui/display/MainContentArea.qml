/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AG
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

import QtQuick 2.10
import QtGraphicalEffects 1.0

import animations 1.0
import home 1.0
import launcher 1.0
import utils 1.0

import com.pelagicore.styles.neptune 3.0

import QtApplicationManager 1.0

Item {
    id: root

    property var applicationModel
    property alias launcherY: launcher.y
    property alias launcherOpen: launcher.open
    property real homeBottomMargin
    property Item popupParent
    property Item virtualKeyboard

    Instantiator {
        id: instantiator
        model: root.applicationModel
        readonly property real activeAppBottomMargin: {
            var margin = root.homeBottomMargin;
            if (widgetDrawer.open && widgetDrawer.visible)
                margin = Math.max(margin, activeApplicationSlot.height - widgetDrawer.y);
            if (root.virtualKeyboard.isOpen)
                margin = Math.max(margin, activeApplicationSlot.height - root.virtualKeyboard.y);
            return margin;
        }
        delegate: QtObject {
            property var exposedRectBottomMarginBinding: Binding {
                target: model.appInfo
                property: "exposedRectBottomMargin"
                value: model.appInfo.active ? instantiator.activeAppBottomMargin : root.homeBottomMargin
            }

            property var exposedRectTopMarginBinding: Binding {
                target: model.appInfo
                property: "exposedRectTopMargin"
                value: model.appInfo.active ? launcher.y + (launcher.open ? NeptuneStyle.dp(Style.launcherHeight)
                                                                          : launcher.height)
                                            : 0
            }

            property var windowHeightBinding: Binding {
                target: model.appInfo.window
                property: "height"
                value: activeApplicationSlot.height
            }
        }
    }

    Item {
        id: mainContentArea
        anchors.left: parent.left
        anchors.right: parent.right
        height: root.height
        opacity: launcher.open ? 0 : 1
        Behavior on opacity { DefaultNumberAnimation {} }
        enabled: !launcher.open
        z: 0

        Item {
            y: launcher.height - NeptuneStyle.dp(Style.launcherHeight)
            width: parent.width
            height: parent.height

            HomePage {
                id: homePage

                anchors.left: parent.left
                anchors.right: parent.right

                y: launcher.y + NeptuneStyle.dp(Style.launcherHeight)
                height: parent.height - y - root.homeBottomMargin

                applicationModel: !root.applicationModel || root.applicationModel.populating ? null : root.applicationModel

                // widgets will reparent themselves to the active application slot when active
                activeApplicationParent: activeApplicationSlot
                moveBottomWidgetToDrawer: !widgetDrawer.showingHomePage
                widgetDrawer: widgetDrawerSlot
                popupParent: root.popupParent
            }

            // slot for the maximized, active, application
            Item {
                id: activeApplicationSlot
                anchors.fill: parent

                ApplicationFrame {
                    anchors.fill: parent
                    appInfo: root.applicationModel && root.applicationModel.activeAppInfo
                             && !root.applicationModel.activeAppInfo.asWidget ? root.applicationModel.activeAppInfo
                                                                              : null
                }
            }

            WidgetDrawer {
                id: widgetDrawer
                width: parent.width
                height: homePage.rowHeight
                anchors.bottom: homePage.bottom

                dragEnabled: !showingHomePage
                visible: !showingHomePage && !widgetDrawerSlot.empty

                Item {
                    id: widgetDrawerSlot
                    width: homePage.widgetWidth
                    height: homePage.rowHeight
                    anchors.horizontalCenter: widgetDrawer.horizontalCenter
                    readonly property bool empty: children.length == 0
                }

                property bool showingHomePage: !root.applicationModel || root.applicationModel.activeAppInfo === null
                onShowingHomePageChanged: {
                    if (showingHomePage) {
                        widgetDrawer.open = true;
                    }
                }
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

    Launcher {
        id: launcher
        anchors.left: parent.left
        anchors.right: parent.right
        applicationModel: root.applicationModel
        showDevApps: ApplicationManager.systemProperties.devMode
        z: 1
    }
}
