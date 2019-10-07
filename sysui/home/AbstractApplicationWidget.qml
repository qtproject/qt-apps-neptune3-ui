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
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import shared.animations 1.0
import shared.utils 1.0
import shared.controls 1.0
import system.controls 1.0

import shared.Style 1.0
import shared.Sizes 1.0

Item {
    id: root

    property bool beingDragged: false
    property bool clipWindow: true
    property bool buttonsVisible: true
    readonly property bool active: appInfo ? appInfo.active : false
    property var appInfo
    property string widgetState
    property int widgetHeight

    property int widgetLeftMargin: Sizes.dp(-59)
    property int widgetRightMargin: Sizes.dp(-59)
    property int widgetTopMargin: Sizes.dp(-59)
    property int widgetBottomMargin: Sizes.dp(-59)
    property alias widgetDraggedShadowOpacity: draggedShadow.opacity
    property alias windowMaskBorder: mask.border
    property int windowLeftMargin: 0

    property alias exposedRectTopMargin: windowItem.exposedRectTopMargin
    property alias exposedRectBottomMargin: windowItem.exposedRectBottomMargin

    signal draggedOntoPos(var pos)
    signal dragStarted(var pos)
    signal dragEnded()
    signal closeClicked()

    ScalableBorderImage {
        id: draggedShadow
        // extra shadow when being dragged
        anchors.fill: parent
        anchors.leftMargin: root.widgetLeftMargin
        anchors.rightMargin: root.widgetRightMargin
        anchors.topMargin: root.widgetTopMargin
        anchors.bottomMargin: root.widgetBottomMargin
        border {
            //don't change these values without knowing the exact size of source image
            //QTBUG-73768 if border exceeds source image size, app crashes, avoid Sizes.dp here
            left: 160; right: 160; top: 160; bottom: 160
        }
        horizontalTileMode: BorderImage.Stretch
        verticalTileMode: BorderImage.Stretch
        source: Style.image("widget-dragged-bg")
        opacity: root.active ? 0 : root.beingDragged ? 0.3 : 0
        visible: opacity > 0
        Behavior on opacity { DefaultNumberAnimation{} }
    }

    ScalableBorderImage {
        anchors.fill: parent
        anchors.leftMargin: root.widgetLeftMargin
        anchors.rightMargin: root.widgetRightMargin
        anchors.topMargin: root.widgetTopMargin
        anchors.bottomMargin: root.widgetBottomMargin
        border { left: 160; right: 160; top: 160; bottom: 160 }
        horizontalTileMode: BorderImage.Stretch
        verticalTileMode: BorderImage.Stretch
        source: Style.image("widget-bg")
        opacity: root.active ? 0 : 1
        visible: opacity > 0
        Behavior on opacity { DefaultNumberAnimation{} }
    }

    ScalableBorderImage {
        id: mask
        visible: false
        anchors.fill: parent
        mirror: LayoutMirroring.enabled
        border { left: 0; right: 17; top: 17; bottom: 17 }
        horizontalTileMode: BorderImage.Stretch
        verticalTileMode: BorderImage.Stretch
        source: Style.image("widget-window-mask")
    }

    Item {
        id: windowSlot
        anchors.fill: parent
        anchors.leftMargin: root.active ? 0 : root.windowLeftMargin
        //NumberAnimation should be used here as SmoothedAnimation
        //causes some movement from right to left of the fullscreen
        //app content when going from widget to fullscreen state
        Behavior on anchors.leftMargin { DefaultSmoothedAnimation {} }
        layer.enabled: root.clipWindow
        layer.effect: OpacityMask {
            maskSource: mask
        }

        // don't let the window get input events outside the slot area
        clip: true

        ApplicationCCWindowItem {
            id: windowItem

            property bool isRunning: root.appInfo ? root.appInfo.running : false
            onIsRunningChanged: {
                if (isRunning) {
                    warningLabel.visible = false;
                } else {
                    warningLabel.visible = true;
                }
            }

            widgetHeight: root.widgetHeight
            currentWidth: windowSlot.width
            currentHeight: windowSlot.height
            windowState: root.active ? "Maximized" : root.widgetState
            appInfo: root.appInfo ? root.appInfo : null
            width: Sizes.dp(Config.centerConsoleWidth)
            height: Sizes.dp(Config.centerConsoleHeight)
            exposedRectTopMargin: root.exposedRectTopMargin
            exposedRectBottomMargin: root.exposedRectBottomMargin
        }
    }

    BusyIndicator {
        id: busyIndicator
        running: !windowItem.window
        visible: running
        anchors.centerIn: parent
        Behavior on opacity { DefaultNumberAnimation {} }
    }

    Label {
        id: warningLabel
        anchors.centerIn: parent
        opacity: 0.0
        text: qsTr("Application window of %1 is not available.
                    Please remove the widget and try to restart the application").arg(root.appInfo.id)
        Behavior on opacity { DefaultNumberAnimation {} }
    }

    Timer {
        running: busyIndicator.running
        interval: 10000
        onTriggered: {
            if (!windowItem.window) {
                busyIndicator.opacity = 0.0;
                warningLabel.opacity = 1.0;
            }
        }
    }
}
