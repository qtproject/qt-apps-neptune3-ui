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

import QtQuick 2.6
import QtQuick.Controls 2.1

import shared.controls 1.0
import shared.utils 1.0
import shared.animations 1.0

import shared.NeptuneWidgetGrid 1.0

import shared.Sizes 1.0

Item {
    id: root

    readonly property int rowHeight: height / widgetsList.numRows
    readonly property int maxWidgetHeight: rowHeight * widgetsList.maxWidgetHeightRows

    readonly property int widgetCount: widgetsList.count
    readonly property int maxWidgetCount: widgetsList.numRows

    readonly property real resizerHandleHeight: Sizes.dp(32)

    property real exposedRectTopMargin
    property real exposedRectBottomMargin

    property Item activeApplicationParent
    property bool moveBottomWidgetToDrawer: false
    property Item widgetDrawer

    property var applicationModel

    property string widgetStateWhenMaximized: ""
    property int clickedIndexWhenMaximized: -1

    QtObject {
        id: d
        property bool widgetIsBeingDragged: false
    }

    WidgetListModel {
        id: widgetsList
        applicationModel: root.applicationModel
    }

    Item {
        id: widgetColumn
        anchors.fill: parent

        readonly property real swapThreshold: Sizes.dp(32)
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
                    if (targetHeight <= root.maxWidgetHeight) {
                        delegate.heightWhenResizing = targetHeight;
                        remainingDelta = 0;
                    } else {
                        delegate.heightWhenResizing = root.maxWidgetHeight;
                        remainingDelta -= root.maxWidgetHeight - (appInfo.heightRows * rowHeight);
                        i--;
                    }
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
                    if (targetHeight <= root.maxWidgetHeight) {
                        delegate.heightWhenResizing = targetHeight;
                        remainingDelta = 0;
                    } else {
                        delegate.heightWhenResizing = root.maxWidgetHeight;
                        remainingDelta -= -(root.maxWidgetHeight - (appInfo.heightRows * rowHeight));
                        i++;
                    }
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
                    if (targetHeight <= root.maxWidgetHeight) {
                        usableDeltaAbove += remainingDelta;
                        remainingDelta = 0;
                    } else {
                        var thisWidgetDelta = root.maxWidgetHeight - (appInfo.heightRows * rowHeight);
                        usableDeltaAbove += thisWidgetDelta;
                        remainingDelta -= thisWidgetDelta;
                        i--;
                    }
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
                    if (targetHeight <= root.maxWidgetHeight) {
                        usableDelta += remainingDelta;
                        remainingDelta = 0;
                    } else {
                        var thisWidgetDelta = -(root.maxWidgetHeight - (appInfo.heightRows * rowHeight))
                        remainingDelta += thisWidgetDelta;
                        usableDelta += thisWidgetDelta;
                        i++;
                    }
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
                objectName: "homeWidget_" + (appInfo ? appInfo.id: "none")

                // So that the touch area of the resize handle in this item covers the widget
                // in the next delegate
                z: repeater.model.count - model.index

                Component.onCompleted: {
                    initialized = true;
                }

                readonly property real yNormal: model.rowIndex * root.rowHeight
                property real yWhenResizing

                width: root.width

                readonly property real heightNormal: appInfo? appInfo.heightRows * root.rowHeight : 0
                property real heightWhenResizing

                // Only enable geometry behaviors once WidgetGrid gets its size,
                // otherwise widgets will animate from size (0,0) to their final sizes on startup.
                property bool geometryBehaviorsEnabled: root.width > 0 && !widgetsList.populating
                Behavior on y { enabled: geometryBehaviorsEnabled; DefaultSmoothedAnimation {} }
                Behavior on height { enabled: geometryBehaviorsEnabled; DefaultSmoothedAnimation {} }

                property alias appInfo: appWidget.appInfo
                readonly property int modelIndex: model.index

                readonly property bool isAtBottom: model.index === (repeater.count - 1)

                readonly property Item widget: appWidget

                property real gridCenteredScale: 1
                property real gridCenterX
                property real gridCenterY
                transform: Scale { origin.x: gridCenterX; origin.y: gridCenterY; xScale: gridCenteredScale; yScale: gridCenteredScale}

                property bool initialized: false
                state: {
                    if (initialized) {
                        if (root.applicationModel.activeAppInfo && !appInfo.active && !isAtBottom) {
                            return "hidden";
                        } else if (!appInfo.asWidget) {
                            return "closing";
                        } else {
                            return widgetColumn.resizingWidgets ? "resizing" : "normal"
                        }
                    } else {
                        return "";
                    }
                }
                states: [
                    State {
                        name: "normal"
                        PropertyChanges {
                            target: repeaterDelegate; y: yNormal; height: heightNormal
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
                    },
                    State {
                        name: "hidden"
                        PropertyChanges {
                            target: repeaterDelegate; y: yNormal; height: heightNormal
                            gridCenteredScale: 0.9; visible: false; opacity: 0
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
                        DefaultNumberAnimation { property: "y"; from: widgetColumn.height }
                    },
                    Transition {
                        to: "hidden"
                        SequentialAnimation {
                            PropertyAction { property: "visible"; value: true }
                            ScriptAction { script: {
                                var pos = root.mapToItem(repeaterDelegate, root.width / 2, root.height / 2);
                                repeaterDelegate.gridCenterX = pos.x;
                                repeaterDelegate.gridCenterY = pos.y;
                             }}
                            DefaultNumberAnimation { properties: "gridCenteredScale,opacity" }
                        }
                    },
                    Transition {
                        from: "hidden"; to: "normal"
                        SequentialAnimation {
                            PropertyAction { property: "visible"; value: true }
                            ScriptAction { script: {
                                var pos = root.mapToItem(repeaterDelegate, root.width / 2, root.height / 2);
                                repeaterDelegate.gridCenterX = pos.x;
                                repeaterDelegate.gridCenterY = pos.y;
                             }}
                            DefaultNumberAnimation { properties: "gridCenteredScale,opacity" }
                        }
                    }
                ]

                Item {
                    id: appWidgetSlot
                    objectName: "appWidgetSlot_" + (appInfo ? appInfo.id: "none")

                    width: repeaterDelegate.width
                    height: repeaterDelegate.height - resizeHandle.height


                    ApplicationWidget {
                        id: appWidget
                        objectName: "applicationWidget_" + (appInfo ? appInfo.id : "none")

                        appInfo: model.appInfo
                        exposedRectTopMargin: active ? root.exposedRectTopMargin : 0.0
                        exposedRectBottomMargin: active ? root.exposedRectBottomMargin : 0.0

                        // in root coords
                        property real dragStartPosY
                        property real dragStartTouchPosY
                        property real dragTouchPosY

                        onDraggedOntoPos: {
                            dragTouchPosY = appWidget.mapToItem(root, pos.x, pos.y).y;
                            widgetColumn.onWidgetMoved(repeaterDelegate);
                        }
                        onDragStarted: {
                            dragStartPosY = appWidget.mapToItem(root, 0, 0).y
                            dragTouchPosY = dragStartTouchPosY = appWidget.mapToItem(root, pos.x, pos.y).y
                            beingDragged = true;
                        }
                        onDragEnded: {
                            beingDragged = false;
                        }

                        onBeingDraggedChanged: d.widgetIsBeingDragged = beingDragged

                        onCloseClicked: {
                            appInfo.asWidget = false;
                        }

                        widgetState: {
                            if (!appInfo || !appInfo.asWidget) {
                                return "";
                            } else {
                                switch (Math.round(height / (root.rowHeight - root.resizerHandleHeight))) {
                                case 0:
                                case 1:
                                    return "Widget1Row";
                                case 2:
                                    return "Widget2Rows";
                                default:
                                    return "Widget3Rows";
                                }
                            }
                        }

                        widgetHeight: {
                            if (widgetState === "Widget1Row") {
                                return root.rowHeight - root.resizerHandleHeight;
                            } else if (widgetState === "Widget2Rows") {
                                return (root.rowHeight * 2) - root.resizerHandleHeight;
                            } else {
                                return (root.rowHeight * 3) - root.resizerHandleHeight;
                            }
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
                                    x: 0; y: 0; scale: 1
                                    width: appWidgetSlot.width; height: appWidgetSlot.height
                                }
                                PropertyChanges { target: appWidget; buttonsVisible: repeater.count > 1 }
                            },
                            State {
                                name: "active"
                                ParentChange {
                                    target: appWidget; parent: root.activeApplicationParent
                                    x: 0; y: 0; scale: 1
                                    width: root.activeApplicationParent.width; height: root.activeApplicationParent.height
                                }
                                PropertyChanges { target: appWidget; buttonsVisible: false; clipWindow: false }
                            },
                            State {
                                name: "drawer"
                                ParentChange {
                                    target: appWidget; parent: root.widgetDrawer
                                    x: 0; y: 0; scale: 1
                                    width: root.widgetDrawer.width; height: root.widgetDrawer.height
                                }
                                PropertyChanges { target: appWidget; buttonsVisible: false }
                            },
                            State {
                                name: "dragging"
                                ParentChange {
                                    target: appWidget; parent: root
                                    x: 0; y: appWidget.dragStartPosY + (appWidget.dragTouchPosY - appWidget.dragStartTouchPosY)
                                    scale: 1
                                    width: appWidgetSlot.width; height: appWidgetSlot.height
                                }
                            }
                        ]

                        transitions: [
                            Transition {
                                to: "home,drawer"
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
                            },
                            Transition {
                                to: "active"
                                SequentialAnimation {
                                    id: activeAnim
                                    property int oldDelegateZ
                                    PropertyAction { target: appWidget; property: "clipWindow"; value: true }
                                    PropertyAction { target: activeAnim; property: "oldDelegateZ"; value: repeaterDelegate.z }
                                    PropertyAction { target: repeaterDelegate; property: "z"; value: 100 }
                                    ParentAnimation {
                                        DefaultNumberAnimation { properties: "x,y,width,height" }
                                    }
                                    PropertyAction { target: repeaterDelegate; property: "z"; value: activeAnim.oldDelegateZ }
                                }
                            }
                        ]
                    }
                }

                ResizeHandle {
                    id: resizeHandle
                    objectName: "resizeHandle" + model.index

                    visible: repeaterDelegate.isAtBottom || opacity === 0 ? false : true
                    opacity: d.widgetIsBeingDragged || root.applicationModel.activeAppInfo ? 0 : 1
                    Behavior on opacity { DefaultNumberAnimation{} }

                    width: parent.width
                    height: root.resizerHandleHeight

                    MouseArea {
                        anchors.fill: parent
                        objectName: "menuWidgetMenuDrag"

                        // don't let it cover the area near widget corners as they can have buttons
                        // like widget-drag and widget-close
                        anchors.leftMargin: Sizes.dp(90)
                        anchors.rightMargin: Sizes.dp(90)

                        // touch area spills out beyond resizeHandle's geometry so that it's easier to hit
                        anchors.topMargin: -parent.height
                        anchors.bottomMargin: -parent.height

                        // distance between the center of the mouse area and the point that was pressed
                        property real pressedYDelta

                        // Always tell widgetColumn that the vertical center of the handle got pressed as it
                        // sits neatly between the widget above and the widget below whereas its touch
                        // area can spill over both neighboring widgets. Makes it possible for widgetColumn
                        // to figure out which handle is being dragged without having to know about the
                        // size of their touch areas.
                        onPressed: {
                            pressedYDelta = mouseY - (height / 2);
                            widgetColumn.onResizeHandlePressed(mapToItem(root, mouseX, height / 2))
                        }
                        onReleased: widgetColumn.onResizeHandleReleased(mapToItem(root, mouseX, mouseY - pressedYDelta))
                        onPositionChanged: widgetColumn.onResizeHandleDragged(mapToItem(root, mouseX, mouseY - pressedYDelta))
                    }
                }
            }
        }
    }
}
