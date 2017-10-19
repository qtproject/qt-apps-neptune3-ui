import QtQuick 2.6
import QtTest 1.1

// sysui, for getting HomePage
import display 1.0

Item {
    width: 600
    height: 600

    QtObject {
        id: foo
        property Item window
        property Item loadedWindow: Rectangle { color: "red" }

        property bool active: false
        property bool canBeActive: true

        property int heightRows: 3

        function start() {
            window = loadedWindow;
        }
    }

    HomePage {
        anchors.fill: parent
        widgetsList: ListModel { id: listModel  }
        Component.onCompleted: {
            listModel.append({"appInfo":foo})
        }
    }

    TestCase {
        name: "HomePage"
        when: windowShown

        function test_foobar() {
        }
    }
}

