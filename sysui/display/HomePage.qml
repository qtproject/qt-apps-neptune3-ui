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

import QtQuick 2.6
import QtQuick.Controls 2.1

import controls 1.0
import utils 1.0
import animations 1.0

import QtQuick.Controls 2.2

Item {
    id: root

    property var applicationModel
    property var widgetsList

    property alias bottomApplicationWidget: widgetGrid.bottomApplicationWidget
    readonly property real widgetWidth: widgetGrid.width
    readonly property real rowHeight: widgetGrid.rowHeight - widgetGrid.resizerHandleHeight

    WidgetGrid {
        id: widgetGrid

        anchors.top: parent.top
        anchors.bottom: addWidgetButton.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: Style.hspan(0.5)
        anchors.rightMargin: Style.hspan(0.5)

        widgetsList: root.widgetsList
    }

    MouseArea {
        id: addWidgetButton
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: Style.hspan(1)
        height: width
        Image {
            anchors.fill: parent
            anchors.centerIn: parent
            source: Style.symbol("ic-addwidget-plus", false /* active */)
            fillMode: Image.Pad
        }
        onClicked: popup.open()
    }

    // TODO: Make it look decent
    Popup {
        id: popup
        x: (root.width - popup.width) / 2
        y: (root.height - popup.height) / 2
        width: 400
        height: 400
        modal: true
        parent: root
        transformOrigin: Popup.Bottom
        enter: Transition {
            DefaultNumberAnimation { property: "opacity"; from: 0.25; to: 1.0}
            DefaultNumberAnimation { property: "y"; from: addWidgetButton.y + (addWidgetButton.height/2) - popup.height; to: popup.y}
            DefaultNumberAnimation { property: "scale"; from: 0.25; to: 1}
        }

        ListView {
            anchors.fill: parent
            clip: true
            model: root.applicationModel
            delegate: MouseArea {
                width: parent.width
                height: Style.vspan(1)
                enabled: !model.appInfo.asWidget
                Text {
                    anchors.fill: parent
                    text: model.name
                    color: parent.enabled ? "black" : "grey"
                }
                onClicked: {
                    model.appInfo.asWidget = true
                    popup.close()
                }
            }
        }
    }
}
