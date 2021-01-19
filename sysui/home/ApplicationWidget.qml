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

AbstractApplicationWidget {
    id: root

    windowLeftMargin: widgetStripe.width

    ScalableBorderImage {
        id: widgetStripe
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: Sizes.dp(40)
        border { top: 25; bottom: 25 }
        horizontalTileMode: BorderImage.Stretch
        verticalTileMode: BorderImage.Stretch
        source: Style.image("widget-stripe")

        layer.enabled: true
        layer.effect: ColorOverlay {
            source: widgetStripe
            color: Style.accentColor
        }

        mirror: LayoutMirroring.enabled

        opacity: root.active ? 0 : 1
        visible: opacity != 0
        Behavior on opacity { DefaultNumberAnimation{} }
    }

    // Application icon
    NeptuneIconLabel {
        display: NeptuneIconLabel.IconOnly
        iconFillMode: Image.PreserveAspectFit
        iconRectHeight: Sizes.dp(25)
        iconRectWidth: iconRectHeight
        anchors.horizontalCenter: widgetStripe.horizontalCenter
        anchors.top: widgetStripe.top
        anchors.topMargin: iconRectHeight * 0.8
        icon.source: root.appInfo ? root.appInfo.icon : null
        icon.color: "white"
        opacity: root.active ? 0 : 1
        visible: opacity > 0
        Behavior on opacity { DefaultNumberAnimation{} }
    }

    // Drag handle
    MouseArea {
        id: dragHandle
        anchors.fill: widgetStripe
        anchors.margins: Sizes.dp(-9)
        visible: root.buttonsVisible

        onMouseYChanged: root.draggedOntoPos(dragHandle.mapToItem(root, mouseX, mouseY))
        onPressed: root.dragStarted(dragHandle.mapToItem(root, mouseX, mouseY))
        onReleased: root.dragEnded()

        Image {
            anchors.centerIn: parent
            width: Sizes.dp(sourceSize.width)
            height: Sizes.dp(sourceSize.height)
            source: Style.image("ic-widget-move")
        }
    }

    // Close button
    ToolButton {
        anchors.horizontalCenter: widgetStripe.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: implicitWidth

        objectName: "appWidgetClose_" + (root.appInfo ?
                                            (root.appInfo.id ? root.appInfo.id : "none")
                                            : "nothing"
                                            )
        implicitWidth: Sizes.dp(25)
        implicitHeight: implicitWidth
        visible: root.buttonsVisible

        onClicked: root.closeClicked()
        iconFillMode: Image.PreserveAspectFit
        display: NeptuneIconLabel.IconOnly
        iconRectHeight: implicitWidth
        iconRectWidth: implicitWidth
        icon.color: "white"
        icon.source: Style.image("ic-widget-close")
        padding: 0
    }

    // Maximize button
    ToolButton {
        id: maximizeToolButton
        width: Sizes.dp(cornerImage.sourceSize.width)
        height: Sizes.dp(cornerImage.sourceSize.height)
        anchors.right: parent.right
        anchors.top: parent.top
        contentItem: Image {
            id: cornerImage
            mirror: LayoutMirroring.enabled
            anchors.fill: parent
            source: Style.image("widget-corner")
            opacity: root.active ? 0 : 1
            visible: opacity > 0
            Behavior on opacity { DefaultNumberAnimation {} }

            Image {
                anchors.right: parent.right
                anchors.rightMargin: Sizes.dp(23)
                anchors.top: parent.top
                anchors.topMargin: Sizes.dp(24)
                width: Sizes.dp(sourceSize.width)
                height: Sizes.dp(sourceSize.height)
                source: Style.image("ic-expand-to-fullscreen")
                scale: maximizeToolButton.containsPress && cornerImage.isInRoundCorner(maximizeToolButton.clickedPoint) ? 1.2 : 1.0
                Behavior on scale { DefaultNumberAnimation{} }
            }
        }

        onClicked: {
            root.appInfo.start();
        }
    }
}
