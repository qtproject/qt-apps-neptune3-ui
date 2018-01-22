import QtQuick 2.9
import QtQuick.Window 2.3

import utils 1.0
import com.pelagicore.styles.triton 1.0

Window {
    id: root
    width: 1080
    height: 1920

    color: root.contentItem.TritonStyle.theme === TritonStyle.Dark ? "black" : "white"

    Binding { target: Style; property: "cellWidth"; value: root.width / 24 }
    Binding { target: Style; property: "cellHeight"; value: root.height / 24 }
    Binding { target: Style; property: "assetPath"; value: Qt.resolvedUrl("/opt/triton/imports/assets/") }

    Shortcut {
        sequence: "Ctrl+t"
        context: Qt.ApplicationShortcut
        onActivated: {
            var otherTheme = root.contentItem.TritonStyle.theme === TritonStyle.Dark ? TritonStyle.Light
                                                                                     : TritonStyle.Dark;
            root.contentItem.TritonStyle.theme = otherTheme;
        }
    }

    Maps {
        anchors.fill: parent
    }
}
