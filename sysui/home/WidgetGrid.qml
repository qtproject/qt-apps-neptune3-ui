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

import QtQuick 2.6
import QtQuick.Controls 2.1

import controls 1.0
import utils 1.0
import animations 1.0

import TritonWidgetGrid 1.0

Item {
    id: root

    readonly property int rowHeight: height / widgetsList.numRows

    readonly property real resizerHandleHeight: Style.vspan(0.4)

    property Item activeApplicationParent
    property bool moveBottomWidgetToDrawer: false
    property Item widgetDrawer

    property var applicationModel

    WidgetListModel {
        id: widgetsList
        applicationModel: root.applicationModel
    }

    Item {
        id: column
        anchors.fill: parent

        readonly property real swapThreshold: Style.vspan(0.4)
        function onWidgetMoved(draggedDelegate) {
            var draggedWidget = draggedDelegate.widget;
            var deltaY = draggedWidget.y - draggedDelegate.y

            if (deltaY > 0) {
                // if the bottom edge of the widget being dragged comes close enough to the
                // bottom edge of some other widget we swap them.

                var draggedBottom = draggedWidget.y + draggedWidget.height

                var i;
                for (i = 0; i < repeater.count; i++) {
                    if (draggedDelegate.modelIndex === i)
                        continue;

                    var otherDelegate = repeater.itemAt(i);
                    var widgetBottom = otherDelegate.yNormal + otherDelegate.heightNormal;

                    if (Math.abs(draggedBottom - widgetBottom) <= swapThreshold) {
                        // swap!
                        widgetsList.move(draggedDelegate.modelIndex, i, 1);
                        return;
                    }
                }
            } else {
                // if the top edge of the widget being dragged comes close enough to the
                // top edge of some other widget we swap them.

                var i;
                for (i = 0; i < repeater.count; i++) {
                    if (draggedDelegate.modelIndex === i)
                        continue;

                    var widgetDelegateY = repeater.itemAt(i).yNormal;

                    if (Math.abs(draggedWidget.y - widgetDelegateY) < swapThreshold) {
                        // swap!
                        widgetsList.move(draggedDelegate.modelIndex, i, 1);
                        return;
                    }
                }
            }

        }

        property bool resizingWidgets: false
        property real startResizeDragY
        property int widgetIndexAboveHandle
        function onResizeHandlePressed(pos) {
            startResizeDragY = pos.y;

            var i = 0;
            var accumulatedHeight = 0;
            while (true) {
                var appInfo = widgetsList.application(i);
                accumulatedHeight += appInfo.heightRows * rowHeight;
                if (accumulatedHeight >= pos.y) {
                    widgetIndexAboveHandle = i;
                    break;
                } else {
                    i++;
                }
            }

            // init resize geometry
            for (i = 0; i < repeater.count; i++) {
                var delegate = repeater.itemAt(i);
                delegate.yWhenResizing = delegate.yNormal;
                delegate.heightWhenResizing = delegate.heightNormal;
            }

            resizingWidgets = true;
        }
        function onResizeHandleDragged(pos) {
            // init resize heights
            for (i = 0; i < repeater.count; i++) {
                var delegate = repeater.itemAt(i);
                delegate.heightWhenResizing = delegate.heightNormal;
            }

            var delta = withinBoundsY(pos.y) - startResizeDragY;
            delta = computeUsableDragDelta(delta);

            // above handle. positive delta enlarges widgets
            var i = widgetIndexAboveHandle;
            var remainingDelta = delta;
            while (remainingDelta !== 0 && i >= 0) {
                var delegate = repeater.itemAt(i);
                var appInfo = delegate.appInfo;
                var minHeight = appInfo.minHeightRows * rowHeight;
                var targetHeight = (appInfo.heightRows * rowHeight) + remainingDelta;

                if (remainingDelta > 0) {
                    // no upper limit at the moment on widget height (other than grid size)
                    delegate.heightWhenResizing = targetHeight;
                    remainingDelta = 0;
                } else {
                    if (targetHeight >= minHeight) {
                        delegate.heightWhenResizing = targetHeight;
                        remainingDelta = 0;
                    } else {
                        delegate.heightWhenResizing = minHeight;
                        remainingDelta -= -((appInfo.heightRows * rowHeight) - minHeight);
                        i--;
                    }
                }
            }

            // below handle. positive delta shrinks widgets
            i = widgetIndexAboveHandle + 1;
            remainingDelta = delta;
            while (remainingDelta !== 0 && i < repeater.count) {
                var delegate = repeater.itemAt(i);
                var appInfo = delegate.appInfo;
                var minHeight = appInfo.minHeightRows * rowHeight;
                var targetHeight = (appInfo.heightRows * rowHeight) - remainingDelta;

                if (remainingDelta < 0) {
                    // no upper limit at the moment on widget height (other than grid size)
                    delegate.heightWhenResizing = targetHeight;
                    remainingDelta = 0;
                } else {
                    if (targetHeight >= minHeight) {
                        delegate.heightWhenResizing = targetHeight;
                        remainingDelta = 0;
                    } else {
                        delegate.heightWhenResizing = minHeight;
                        remainingDelta -= (appInfo.heightRows * rowHeight) - minHeight;
                        i++;
                    }
                }
            }

            // update y values according to the new heights
            var accumulatedY = 0;
            for (i = 0; i < repeater.count; i++) {
                var delegate = repeater.itemAt(i);
                delegate.yWhenResizing = accumulatedY;
                accumulatedY += delegate.heightWhenResizing
            }
        }
        function onResizeHandleReleased(pos) {
            // apply sizes
            var i;
            for (i = 0; i < repeater.count; i++) {
                var delegate = repeater.itemAt(i);
                delegate.appInfo.heightRows = Math.round(delegate.heightWhenResizing / root.rowHeight);
            }

            resizingWidgets = false;
        }
        function computeUsableDragDelta(delta) {
            // above handle. positive delta enlarges widgets
            var i = widgetIndexAboveHandle;
            var remainingDelta = delta;
            var usableDeltaAbove = 0
            while (remainingDelta !== 0 && i >= 0) {
                var appInfo = widgetsList.application(i);
                var minHeight = appInfo.minHeightRows * rowHeight;
                var targetHeight = (appInfo.heightRows * rowHeight) + remainingDelta;

                if (remainingDelta > 0) {
                    // no upper limit at the moment on widget height (other than grid size)
                    usableDeltaAbove += remainingDelta;
                    remainingDelta = 0;
                } else {
                    if (targetHeight >= minHeight) {
                        usableDeltaAbove += remainingDelta;
                        remainingDelta = 0;
                    } else {
                        var thisWidgetDelta = -((appInfo.heightRows * rowHeight) - minHeight);
                        usableDeltaAbove += thisWidgetDelta;
                        remainingDelta -= thisWidgetDelta;
                        i--;
                    }
                }
            }

            // below handle. positive delta shrinks widgets
            i = widgetIndexAboveHandle + 1;
            remainingDelta = usableDeltaAbove;
            var usableDelta = 0;
            while (remainingDelta !== 0 && i < widgetsList.count) {
                var appInfo = widgetsList.application(i);
                var minHeight = appInfo.minHeightRows * rowHeight;
                var targetHeight = (appInfo.heightRows * rowHeight) - remainingDelta;

                if (remainingDelta < 0) {
                    // no upper limit at the moment on widget height (other than grid size)
                    usableDelta += remainingDelta;
                    remainingDelta = 0;
                } else {
                    if (targetHeight >= minHeight) {
                        usableDelta += remainingDelta;
                        remainingDelta = 0;
                    } else {
                        var thisWidgetDelta = (appInfo.heightRows * rowHeight) - minHeight;
                        usableDelta += thisWidgetDelta;
                        remainingDelta -= thisWidgetDelta;
                        i++;
                    }
                }
            }
            return usableDelta;
        }
        function withinBoundsY(someY) {
            return Math.max(0, Math.min(someY, height));
        }

        Repeater {
            id: repeater
            model: widgetsList

            delegate: Column {
                id: repeaterDelegate

                Component.onCompleted: {
                    initialized = true;
                }

                readonly property real yNormal: model.rowIndex * root.rowHeight
                property real yWhenResizing

                width: root.width

                readonly property real heightNormal: appInfo? appInfo.heightRows * root.rowHeight : 0
                property real heightWhenResizing


                property bool geometryBehaviorsEnabled: false
                Behavior on x { enabled: geometryBehaviorsEnabled ; DefaultSmoothedAnimation {} }
                Behavior on y { enabled: geometryBehaviorsEnabled; DefaultSmoothedAnimation {} }
                Behavior on width { enabled: geometryBehaviorsEnabled; DefaultSmoothedAnimation {} }
                Behavior on height { enabled: geometryBehaviorsEnabled; DefaultSmoothedAnimation {} }

                property alias appInfo: appWidget.appInfo
                readonly property int modelIndex: model.index

                readonly property bool isAtBottom: model.index === (repeater.count - 1)

                readonly property Item widget: appWidget

                property bool initialized: false
                state: {
                    if (initialized) {
                        return column.resizingWidgets ? "resizing" : "normal"
                    } else {
                        return "";
                    }
                }
                states: [
                    State {
                        name: "normal"
                        PropertyChanges {
                            target: repeaterDelegate; y: yNormal; height: heightNormal
                            geometryBehaviorsEnabled: true
                        }
                    },
                    State {
                        name: "resizing"
                        PropertyChanges { target: repeaterDelegate; y: yWhenResizing; height: heightWhenResizing }
                    },
                    State {
                        name: "closing"
                        PropertyChanges {
                            target: repeaterDelegate
                            y: yNormal; height: heightNormal
                            scale: 0.75; opacity: 0.0
                        }
                    }
                ]
                transitions: [
                    Transition {
                        to: "closing"
                        SequentialAnimation {
                            DefaultNumberAnimation { properties: "opacity,scale" }
                            ScriptAction { script: { widgetsList.remove(model.index); }}
                        }
                    },
                    Transition {
                        enabled: !widgetsList.populating
                        from: ""; to: "normal"
                        PropertyAction { property: "height" }
                        DefaultNumberAnimation { property: "y"; from: column.height }
                    }
                ]

                Item {
                    id: appWidgetSlot
                    width: repeaterDelegate.width
                    height: repeaterDelegate.height - resizeHandle.height


                    ApplicationWidget {
                        id: appWidget

                        appInfo: model.appInfo

                        closeButtonVisible: repeater.count > 1

                        property bool beingDragged: false

                        // in root coords
                        property real dragStartPosY
                        property real dragStartTouchPosY
                        property real dragTouchPosY

                        onDraggedOntoPos: {
                            dragTouchPosY = appWidget.mapToItem(root, pos.x, pos.y).y;
                            column.onWidgetMoved(repeaterDelegate);
                        }
                        onDragStarted: {
                            dragStartPosY = appWidget.mapToItem(root, 0, 0).y
                            dragTouchPosY = dragStartTouchPosY = appWidget.mapToItem(root, pos.x, pos.y).y
                            beingDragged = true;
                        }
                        onDragEnded: {
                            beingDragged = false;
                        }

                        onCloseClicked: {
                            repeaterDelegate.state = "closing"
                            appInfo.asWidget = false;
                        }

                        state: {
                            if (beingDragged) {
                                return "dragging"
                            } else if (active && root.activeApplicationParent) {
                                return "active"
                            } else if (repeaterDelegate.isAtBottom && root.moveBottomWidgetToDrawer) {
                                return "drawer"
                            } else {
                                return "home"
                            }
                        }
                        states: [
                            State {
                                name: "home"
                                ParentChange {
                                    target: appWidget; parent: appWidgetSlot
                                    x: 0; y: 0;
                                    width: appWidgetSlot.width; height: appWidgetSlot.height
                                }
                                PropertyChanges { target: appWidget; dragButtonVisible: repeater.count > 1 }
                            },
                            State {
                                name: "active"
                                ParentChange {
                                    target: appWidget; parent: root.activeApplicationParent
                                    x: 0; y: 0;
                                    width: root.activeApplicationParent.width; height: root.activeApplicationParent.height
                                }
                                PropertyChanges { target: appWidget; dragButtonVisible: false }
                            },
                            State {
                                name: "drawer"
                                ParentChange {
                                    target: appWidget; parent: root.widgetDrawer
                                    x: 0; y: 0;
                                    width: root.widgetDrawer.width; height: root.widgetDrawer.height
                                }
                                PropertyChanges { target: appWidget; dragButtonVisible: false }
                            },
                            State {
                                name: "dragging"
                                ParentChange {
                                    target: appWidget; parent: root
                                    x: 0; y: appWidget.dragStartPosY + (appWidget.dragTouchPosY - appWidget.dragStartTouchPosY)
                                    width: appWidgetSlot.width; height: appWidgetSlot.height
                                }
                            }
                        ]

                        transitions: Transition {
                            to: "home,active,drawer"
                            SequentialAnimation {
                                id: anim
                                property int oldDelegateZ
                                PropertyAction { target: anim; property: "oldDelegateZ"; value: repeaterDelegate.z }
                                PropertyAction { target: repeaterDelegate; property: "z"; value: 100 }
                                ParentAnimation {
                                    DefaultNumberAnimation { properties: "x,y,width,height" }
                                }
                                PropertyAction { target: repeaterDelegate; property: "z"; value: anim.oldDelegateZ }
                            }
                        }
                    }
                }
                Item {
                    id: resizeHandle
                    objectName: "resizeHandle" + model.index

                    visible: repeaterDelegate.isAtBottom ? false : true

                    width: parent.width
                    height: root.resizerHandleHeight

                    // TODO: need to be replaced with an icon
                    Rectangle {
                        id: handlerIcon
                        width: Style.vspan(1)
                        height: 2
                        color: "grey"
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        onPressed: column.onResizeHandlePressed(mapToItem(root, mouseX, mouseY))
                        onReleased: column.onResizeHandleReleased(mapToItem(root, mouseX, mouseY))
                        onPositionChanged: column.onResizeHandleDragged(mapToItem(root, mouseX, mouseY))
                    }
                }
            }
        }
    }
}
