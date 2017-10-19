import QtQuick 2.6
import QtTest 1.1

// sysui, for getting WidgetDrawer
import display 1.0

Item {
    width: 600
    height: 600

    WidgetDrawer {
        y: 200
        width: 600
        height: 200

        Rectangle { color: "green"; anchors.fill: parent }
    }

    TestCase {
        name: "WidgetDrawer"
        when: windowShown

        function test_pass() {
            compare(2 + 2, 4, "2 + 2")
        }
    }
}
