/****************************************************************************
**
** Copyright (C) 2017-2018 Pelagicore AG
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
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import animations 1.0
import utils 1.0

import com.pelagicore.styles.triton 1.0

Item {
    id: root

    signal draggedOntoPos(var pos)
    signal dragStarted(var pos)
    signal dragEnded()
    signal closeClicked()

    property bool beingDragged: false
    property bool clipWindow: true
    property bool buttonsVisible: true
    readonly property bool active: appInfo ? appInfo.active : false
    property var appInfo
    property string widgetState
    property int widgetHeight

    BorderImage {
        // extra shadow when being dragged
        anchors.fill: parent
        anchors.leftMargin: -59
        anchors.rightMargin: -59
        anchors.topMargin: -59
        anchors.bottomMargin: -59
        border { left: 160; right: 160; top: 160; bottom: 160 }
        horizontalTileMode: BorderImage.Stretch
        verticalTileMode: BorderImage.Stretch
        source: Style.gfx2("widget-bg-2-dark")
        opacity: root.active ? 0 : root.beingDragged ? 0.3 : 0
        visible: opacity > 0
        Behavior on opacity { DefaultNumberAnimation{} }
    }

    BorderImage {
        anchors.fill: parent
        anchors.leftMargin: -59
        anchors.rightMargin: -59
        anchors.topMargin: -59
        anchors.bottomMargin: -59
        border { left: 160; right: 160; top: 160; bottom: 160 }
        horizontalTileMode: BorderImage.Stretch
        verticalTileMode: BorderImage.Stretch
        source: Style.gfx2("widget-bg-2", TritonStyle.theme)
        opacity: root.active ? 0 : 1
        visible: opacity > 0
        Behavior on opacity { DefaultNumberAnimation{} }
    }

    Connections {
        target: root.appInfo ? root.appInfo : null
        onWindowChanged: {
            root.updateState()
        }
    }
    onAppInfoChanged: updateState()

    function updateState() {
        if (!root.appInfo)
            return;


        var window = root.appInfo.window
        if (window) {
            window.parent = windowSlot;
            window.width = Qt.binding(function() { return Style.hspan(24); });
            window.height = Qt.binding(function() { return Style.vspan(24); });
            window.visible = true;
            loadingStateGroup.state = "live"
        } else {
            loadingStateGroup.state = "loading"
        }
    }

    Binding {
        target: root.appInfo; property: "widgetHeight"; value: root.widgetHeight
    }

    Binding {
        target: root.appInfo; property: "currentWidth"; value: windowSlot.width
    }

    Binding {
        target: root.appInfo; property: "currentHeight"; value: windowSlot.height
    }

    Binding {
        target: root.appInfo; property: "windowState"; value: root.active ? "Maximized" : root.widgetState
    }

    BorderImage {
        id: mask
        visible: false
        anchors.fill: parent
        border { left: 0; right: 17; top: 17; bottom: 17 }
        horizontalTileMode: BorderImage.Stretch
        verticalTileMode: BorderImage.Stretch
        source: Style.gfx2("widget-window-mask")
    }
    Item {
        id: windowSlot
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: root.active ? 0 : widgetStripe.width
        Behavior on anchors.leftMargin { DefaultSmoothedAnimation { } }
        anchors.right: parent.right
        layer.enabled: root.clipWindow
        layer.effect: OpacityMask {
            maskSource: mask
        }

        // don't let the window get input events outside the slot area
        clip: true
    }

    BorderImage {
        id: widgetStripe
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        border { top: 30; bottom: 30 }
        horizontalTileMode: BorderImage.Stretch
        verticalTileMode: BorderImage.Stretch
        source: Style.gfx2("widget-stripe")

        opacity: root.active ? 0 : 1
        visible: opacity != 0
        Behavior on opacity { DefaultNumberAnimation{} }

        Image {
            width: parent.width * 0.6
            fillMode: Image.PreserveAspectFit
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: widgetStripe.border.top * 0.8
            source: root.appInfo ? root.appInfo.icon : null
        }
    }

    BusyIndicator {
        id: busyIndicator
        running: true
        anchors.centerIn: parent
    }

    StateGroup {
        id: loadingStateGroup
        state: "loading"
        states: [
            State {
                name: "loading"
            },
            State {
                name: "live"
                PropertyChanges { target: busyIndicator; running: false; visible: false }
            }
        ]
    }

    // Drag handle
    MouseArea {
        id: dragHandle
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: -Style.hspan(0.2)
        width: Style.hspan(1.6)
        height: width
        visible: root.buttonsVisible

        onMouseYChanged: root.draggedOntoPos(dragHandle.mapToItem(root, mouseX, mouseY))
        onPressed: root.dragStarted(dragHandle.mapToItem(root, mouseX, mouseY))
        onReleased: root.dragEnded()

        Image {
            anchors.fill: parent
            anchors.centerIn: parent
            source: Style.symbol("ic-widget-draghandle")
            fillMode: Image.Pad
        }
    }

    // Close button
    MouseArea {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: -Style.hspan(0.2)
        width: Style.hspan(1.6)
        height: width
        visible: root.buttonsVisible

        onClicked: root.closeClicked()

        Image {
            anchors.fill: parent
            anchors.centerIn: parent
            source: Style.symbol("ic-widget-close")
            fillMode: Image.Pad
        }
    }
}
