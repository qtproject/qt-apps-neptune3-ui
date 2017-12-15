import QtQuick 2.8
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3


Page {
    id: root
    padding: 16
    GridLayout {
        anchors.centerIn: parent
        columns: 2

        // Language Field
        Label {
            text: qsTr("Language:")
        }
        ComboBox {
            id: languageComboBox
            model: uiSettings.languages
            currentIndex: uiSettings.languages.indexOf(uiSettings.language)
            onActivated: uiSettings.language = currentText
        }

        // Volume Field
        Label {
            text: qsTr("Volume:")
        }
        Slider {
            id: volumeSlider
            value: uiSettings.volume
            from: 1.0
            to: 0.0
            onValueChanged: if (pressed) { uiSettings.volume = value }
        }

        // Balance Field
        Label {
            text: qsTr("Balance:")
        }
        Slider {
            id: balanceSlider
            value: uiSettings.balance
            from: 1.0
            to: -1.0
            onValueChanged: if (pressed) { uiSettings.balance = value }
        }

        // Mute Field
        Label {
            text: qsTr("Mute:")
        }
        CheckBox {
            id: muteCheckbox
            checked: uiSettings.muted
            onClicked: uiSettings.muted = checked
        }

        // Theme Field
        Label {
            text: qsTr("Theme:")
        }

        ComboBox {
            id: themeComboBox
            model: [qsTr("Light"), qsTr("Dark")]
            currentIndex: uiSettings.theme
            onActivated: uiSettings.theme = currentIndex
        }

        // Door 1 Field
        Label {
            text: qsTr("Door 1:")
        }
        CheckBox {
            id: door1OpenCheckbox
            checked: uiSettings.door1Open
            onClicked: uiSettings.door1Open = checked
        }

        // Door 2 Field
        Label {
            text: qsTr("Door 2:")
        }
        CheckBox {
            id: door2OpenCheckbox
            checked: uiSettings.door2Open
            onClicked: uiSettings.door2Open = checked
        }
    }
}
