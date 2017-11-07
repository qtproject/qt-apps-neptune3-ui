import QtQuick 2.6
import QtQuick.Controls 2.1

import controls 1.0
import utils 1.0
import animations 1.0

Column {
    id: root

    readonly property int numRows: 5
    readonly property int rowHeight: height / numRows

    readonly property real resizerHandleHeight: Style.vspan(0.2)

    property Item bottomApplicationWidget

    property var widgetsList

    move: Transition {
        id: moveTransition
        enabled: false
        DefaultSmoothedAnimation { properties: "x,y,width,height" }
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

    property bool resizingWidgets: false
    property real startResizeDragY
    property int widgetIndexAboveHandle
    function onResizeHandlePressed(pos) {
        startResizeDragY = pos.y;

        var i = 0;
        var accumulatedHeight = 0;
        while (true) {
            var appInfo = root.widgetsList.application(i);
            accumulatedHeight += appInfo.heightRows * rowHeight;
            if (accumulatedHeight >= pos.y) {
                widgetIndexAboveHandle = i;
                break;
            } else {
                i++;
            }
        }

        animateWidgetResize = false;

        // init resize heights
        for (i = 0; i < repeater.count; i++) {
            var delegate = repeater.itemAt(i);
            delegate.heightWhenResizing = delegate.appInfo.heightRows * widgetGrid.rowHeight;
        }

        resizingWidgets = true;
    }
    function onResizeHandleDragged(pos) {
        // init resize heights
        for (i = 0; i < repeater.count; i++) {
            var delegate = repeater.itemAt(i);
            delegate.heightWhenResizing = delegate.appInfo.heightRows * widgetGrid.rowHeight;
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
    }
    function onResizeHandleReleased(pos) {
        // apply sizes
        var i;
        for (i = 0; i < repeater.count; i++) {
            var delegate = repeater.itemAt(i);
            delegate.appInfo.heightRows = Math.round(delegate.heightWhenResizing / widgetGrid.rowHeight);
        }

        animateWidgetResize = true;
        resizingWidgets = false;
    }
    function computeUsableDragDelta(delta) {
        // above handle. positive delta enlarges widgets
        var i = widgetIndexAboveHandle;
        var remainingDelta = delta;
        var usableDeltaAbove = 0
        while (remainingDelta !== 0 && i >= 0) {
            var appInfo = root.widgetsList.application(i);
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
        while (remainingDelta !== 0 && i < root.widgetsList.count) {
            var appInfo = root.widgetsList.application(i);
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

    property bool animateWidgetResize: true

    Repeater {
        id: repeater
        model: root.widgetsList

        delegate: Column {
            id: repeaterDelegate
            width: widgetGrid.width
            height: {
                if (widgetGrid.resizingWidgets) {
                    return heightWhenResizing
                } else {
                    return appInfo ? appInfo.heightRows * widgetGrid.rowHeight : 0
                }
            }
            property real heightWhenResizing

            Behavior on x { enabled:!moveTransition.enabled && widgetGrid.animateWidgetResize; DefaultSmoothedAnimation {} }
            Behavior on y { enabled:!moveTransition.enabled && widgetGrid.animateWidgetResize; DefaultSmoothedAnimation {} }
            Behavior on width { enabled:!moveTransition.enabled && widgetGrid.animateWidgetResize; DefaultSmoothedAnimation {} }
            Behavior on height { enabled:!moveTransition.enabled && widgetGrid.animateWidgetResize; DefaultSmoothedAnimation {} }

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
                height: repeaterDelegate.height - resizeHandle.height

                ApplicationWidget {
                    id: appWidget
                    anchors.fill: parent

                    appInfo: model.appInfo

                    // hide drag button when reparented elsewhere
                    dragButtonVisible: parent === appWidgetSlot

                    closeButtonVisible: repeater.count > 1

                    onDraggedOntoPos: {
                        var gridPos = appWidget.mapToItem(widgetGrid, pos.x, pos.y);
                        widgetGrid.moveWidgetToYPos(repeaterDelegate, gridPos.y);
                    }
                    onDragStarted: moveTransition.enabled = true
                    onDragEnded: moveTransition.enabled = false
                }
            }
            Item {
                id: resizeHandle
                objectName: "resizeHandle" + model.index

                visible: repeaterDelegate.isAtBottom ? false : true

                width: parent.width
                height: widgetGrid.resizerHandleHeight
                MouseArea {
                    anchors.fill: parent
                    onPressed: widgetGrid.onResizeHandlePressed(mapToItem(widgetGrid, mouseX, mouseY))
                    onReleased: widgetGrid.onResizeHandleReleased(mapToItem(widgetGrid, mouseX, mouseY))
                    onPositionChanged: widgetGrid.onResizeHandleDragged(mapToItem(widgetGrid, mouseX, mouseY))
                }
            }
        }
    }

}

