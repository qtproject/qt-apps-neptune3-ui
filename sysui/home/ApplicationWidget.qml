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
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import animations 1.0
import utils 1.0
import controls 1.0

import com.pelagicore.styles.neptune 3.0

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

    ScalableBorderImage {
        // extra shadow when being dragged
        anchors.fill: parent
        anchors.leftMargin: NeptuneStyle.dp(-59)
        anchors.rightMargin: NeptuneStyle.dp(-59)
        anchors.topMargin: NeptuneStyle.dp(-59)
        anchors.bottomMargin: NeptuneStyle.dp(-59)
        border { left: 160; right: 160; top: 160; bottom: 160 }
        horizontalTileMode: BorderImage.Stretch
        verticalTileMode: BorderImage.Stretch
        source: Style.gfx2("widget-bg-2-dark")
        opacity: root.active ? 0 : root.beingDragged ? 0.3 : 0
        visible: opacity > 0
        Behavior on opacity { DefaultNumberAnimation{} }
    }

    ScalableBorderImage {
        anchors.fill: parent
        anchors.leftMargin: NeptuneStyle.dp(-59)
        anchors.rightMargin: NeptuneStyle.dp(-59)
        anchors.topMargin: NeptuneStyle.dp(-59)
        anchors.bottomMargin: NeptuneStyle.dp(-59)
        border { left: 160; right: 160; top: 160; bottom: 160 }
        horizontalTileMode: BorderImage.Stretch
        verticalTileMode: BorderImage.Stretch
        source: Style.gfx2("widget-bg-2", NeptuneStyle.theme)
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
        target: root.appInfo; property: "windowScale"; value: root.NeptuneStyle.scale
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

    ScalableBorderImage {
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
        anchors.fill: parent
        anchors.leftMargin: root.active ? 0 : widgetStripe.width
        //NumberAnimation should be used here as SmoothedAnimation
        //causes some movement from right to left of the fullscreen
        //app content when going from widget to fullscreen state
        Behavior on anchors.leftMargin { DefaultNumberAnimation { } }
        layer.enabled: root.clipWindow
        layer.effect: OpacityMask {
            maskSource: mask
        }

        // don't let the window get input events outside the slot area
        clip: true
    }

    ScalableBorderImage {
        id: widgetStripe
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: NeptuneStyle.dp(40)
        border { top: 30; bottom: 30 }
        horizontalTileMode: BorderImage.Stretch
        verticalTileMode: BorderImage.Stretch
        source: Style.gfx2("widget-stripe")

        layer.enabled: true
        layer.effect: ColorOverlay {
            source: widgetStripe
            color: NeptuneStyle.accentColor
        }

        opacity: root.active ? 0 : 1
        visible: opacity != 0
        Behavior on opacity { DefaultNumberAnimation{} }

        Image {
            width: NeptuneStyle.dp(sourceSize.width)
            height: NeptuneStyle.dp(sourceSize.height)
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
        anchors.fill: widgetStripe
        anchors.margins: -Style.hspan(0.2)
        visible: root.buttonsVisible

        onMouseYChanged: root.draggedOntoPos(dragHandle.mapToItem(root, mouseX, mouseY))
        onPressed: root.dragStarted(dragHandle.mapToItem(root, mouseX, mouseY))
        onReleased: root.dragEnded()

        Image {
            anchors.centerIn: parent
            width: NeptuneStyle.dp(sourceSize.width)
            height: NeptuneStyle.dp(sourceSize.height)
            source: Style.symbol("ic-widget-move")
        }
    }

    // Close button
    MouseArea {
        anchors.horizontalCenter: widgetStripe.horizontalCenter
        anchors.bottom: parent.bottom

        width: widgetStripe.width + Style.hspan(.4)
        height: width
        visible: root.buttonsVisible

        onClicked: root.closeClicked()

        Image {
            anchors.centerIn: parent
            width: NeptuneStyle.dp(sourceSize.width)
            height: NeptuneStyle.dp(sourceSize.height)
            source: Style.symbol("ic-widget-close")
        }
    }

    // Maximize button
    Image {
        id: cornerImage
        anchors.right: parent.right
        anchors.top: parent.top
        width: NeptuneStyle.dp(sourceSize.width)
        height: NeptuneStyle.dp(sourceSize.height)
        source: Style.gfx2("widget-corner", NeptuneStyle.theme)
        opacity: root.active ? 0 : 1
        visible: opacity > 0
        Behavior on opacity { DefaultNumberAnimation {} }

        function isInRoundCorner(point) {
            var rx2 = Math.pow((cornerImage.width-point.x),2)
            var ry2 = Math.pow(point.y,2)
            var r = Math.sqrt(rx2 + ry2)
            return r < (cornerImage.width+cornerImage.height)/2
        }

        Image {
            anchors.right: parent.right
            anchors.rightMargin: Style.hspan(.5)
            anchors.top: parent.top
            anchors.topMargin: Style.vspan(.3)
            width: NeptuneStyle.dp(sourceSize.width)
            height: NeptuneStyle.dp(sourceSize.height)
            source: Style.symbol("ic-expand-to-fullscreen")
            scale: maCorner.containsPress && cornerImage.isInRoundCorner(maCorner.clickedPoint) ? 1.2 : 1.0
            Behavior on scale { DefaultNumberAnimation{} }
        }

        MouseArea {
            id: maCorner
            property var clickedPoint
            anchors.fill: parent
            onClicked: {
                var p = Qt.point(mouse.x, mouse.y)
                if (cornerImage.isInRoundCorner(p)) {
                    root.appInfo.start()
                }
            }
            onPressed: maCorner.clickedPoint = Qt.point(mouse.x, mouse.y)
        }
    }
}
