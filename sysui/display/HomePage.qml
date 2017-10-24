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

Item {
    id: root

    property var widgetsList: HomeWidgetsList {}

    property Item bottomApplicationWidget
    readonly property real widgetWidth: widgetGrid.width
    readonly property real rowHeight: widgetGrid.rowHeight - widgetGrid.resizerHandleHeight

    // The widget grid
    Column {
        id: widgetGrid
        anchors.fill: parent
        anchors.leftMargin: Style.hspan(0.5)
        anchors.rightMargin: Style.hspan(0.5)

        readonly property int numRows: 5
        readonly property int rowHeight: height / numRows

        readonly property real resizerHandleHeight: Style.vspan(0.2)

        move: Transition {
            id: moveTransition
            enabled: false
            SmoothedAnimation { properties: "x,y,width,height"; easing.type: Easing.InOutQuad; duration: 270 }
        }

        function moveWidgetToYPos(draggedWidget, yPos) {
            if (moveTransition.running)
                return;

            var targetRowIndex = Math.round(yPos / rowHeight);
            targetRowIndex = Math.max(0, Math.min(targetRowIndex, numRows - 1));

            var i;
            for (i = 0; i < repeater.count; i++) {
                if (draggedWidget.modelIndex === i)
                    continue;

                var widgetDelegate = repeater.itemAt(i);
                var widgetRowIndex = Math.round(widgetDelegate.y / rowHeight);
                if (widgetRowIndex === targetRowIndex) {
                    // swap!
                    root.widgetsList.move(draggedWidget.modelIndex, i, 1);
                    return;
                }
            }
        }

        Repeater {
            id: repeater
            model: root.widgetsList
            delegate: Column {
                id: repeaterDelegate
                width: widgetGrid.width
                height: appInfo ? appInfo.heightRows * widgetGrid.rowHeight : 0

                Behavior on x { enabled:!moveTransition.enabled; SmoothedAnimation { easing.type: Easing.InOutQuad; duration: 270 } }
                Behavior on y { enabled:!moveTransition.enabled; SmoothedAnimation { easing.type: Easing.InOutQuad; duration: 270 } }
                Behavior on width { enabled:!moveTransition.enabled; SmoothedAnimation { easing.type: Easing.InOutQuad; duration: 270 } }
                Behavior on height { enabled:!moveTransition.enabled; SmoothedAnimation { easing.type: Easing.InOutQuad; duration: 270 } }

                property alias appInfo: appWidget.appInfo
                readonly property int modelIndex: model.index

                readonly property bool isAtBottom: model.index === (repeater.count - 1)

                Binding {
                    when: repeaterDelegate.isAtBottom
                    target: root
                    property: "bottomApplicationWidget"
                    value: appWidget
                }

                Item {
                    id: appWidgetSlot
                    width: repeaterDelegate.width
                    height: repeaterDelegate.height - resizerHandle.height

                    ApplicationWidget {
                        id: appWidget
                        anchors.fill: parent

                        appInfo: model.appInfo

                        // hide drag button when reparented elsewhere
                        dragButtonVisible: parent === appWidgetSlot

                        onDraggedOntoPos: {
                            var gridPos = appWidget.mapToItem(widgetGrid, pos.x, pos.y);
                            widgetGrid.moveWidgetToYPos(repeaterDelegate, gridPos.y);
                        }
                        onDragStarted: moveTransition.enabled = true
                        onDragEnded: moveTransition.enabled = false
                    }
                }
                Rectangle {
                    id: resizerHandle

                    visible: repeaterDelegate.isAtBottom ? false : true

                    color: "grey"
                    width: parent.width
                    height: widgetGrid.resizerHandleHeight
                    Resizer {
                        anchors.fill: parent
                        topAppInfo: model.appInfo
                        bottomAppInfo: repeaterDelegate.isAtBottom ? null : repeater.model.get(model.index + 1).appInfo
                        grid: widgetGrid
                    }
                }
            }
        }

    }

}
