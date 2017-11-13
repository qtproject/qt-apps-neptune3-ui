import QtQuick 2.6
import QtTest 1.1

// sysui, for getting WidgetDrawer
import display 1.0

Item {
    id: root
    width: 600
    height: 600

    WidgetDrawer {
        id: widgetDrawer
        y: 200
        width: 600
        height: 200

        // A fake application widget
        MultiPointTouchArea {
            anchors.fill: parent
            Rectangle { color: "green"; anchors.fill: parent }
        }
    }

    TritonTestCase {
        name: "WidgetDrawer"

        /*
            Drag the WidgetDrawer all the way right (having it almost closed/out of screen) and then
            move it back, closer to its fully open position, where you finally lift your finger.

            The WidgetDrawer should then animate back to its fully opened state from where you left it.
        */
        function test_dragRightAndBackLeft() {
            var yPos = widgetDrawer.y + widgetDrawer.height/2;

            touchDrag(root, 1, yPos, root.width*0.8, yPos,
                    true /* beginTouch */, false /* endTouch */);

            touchDrag(root, root.width*0.8, yPos, root.width*0.35, yPos,
                    false /* beginTouch */, false /* endTouch */);

            var event = touchEvent(root);
            event.release(0 /* touchId */, root, root.width*0.35, yPos);
            event.commit();

            tryCompare(widgetDrawer, "x", 0, 2000 /* timeout */,
                    "WidgetDrawer didn't move all the way back to its opened state.")
        }
    }
}
