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

import QtQuick 2.8
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import shared.controls 1.0
import shared.utils 1.0

import shared.Style 1.0
import shared.Sizes 1.0

Item {
    id: root
    anchors.horizontalCenter: parent ? parent.horizontalCenter : null
    anchors.top: parent ? parent.top : null
    anchors.topMargin: Sizes.dp(40)
    anchors.bottom: parent ? parent.bottom : null

    Flickable {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: Sizes.dp(765)
        contentHeight: columnContent.height
        contentWidth: columnContent.width
        flickableDirection: Flickable.VerticalFlick
        clip: true
        ColumnLayout {
            id: columnContent
            spacing: Sizes.dp(4)

            ListItem {
                implicitWidth: Sizes.dp(765)
                implicitHeight: Sizes.dp(104)
                text: qsTr("Basic ListItem")
                dividerVisible: false
            }

            ListItem {
                implicitWidth: Sizes.dp(765)
                implicitHeight: Sizes.dp(104)
                text: qsTr("ListItem Text")
                subText: "ListItem Subtext"
            }

            ListItem {
                implicitWidth: Sizes.dp(765)
                implicitHeight: Sizes.dp(104)
                text: qsTr("ListItem with an image")
                icon.source: Style.image("fan-speed-5")
                icon.color: "transparent"
            }

            ListItem {
                implicitWidth: Sizes.dp(765)
                implicitHeight: Sizes.dp(104)
                icon.name: "ic-update"
                text: qsTr("ListItem with Icon")
            }

            ListItem {
                implicitWidth: Sizes.dp(765)
                implicitHeight: Sizes.dp(104)
                icon.name: "ic-update"
                text: qsTr("ListItem with Secondary Text")
                secondaryText: qsTr("Company")
            }

            ListItem {
                implicitWidth: Sizes.dp(765)
                implicitHeight: Sizes.dp(104)
                icon.name: "ic-update"
                rightToolSymbol: "ic-close"
                text: qsTr("ListItem with Secondary Text")
                secondaryText: qsTr("68% of 14 MB")
            }

            ListItem {
                implicitWidth: Sizes.dp(765)
                implicitHeight: Sizes.dp(104)
                icon.name: "ic-update"
                rightToolSymbol: "ic-close"
                text: qsTr("ListItem with Looooooooooonnngggg Text")
                secondaryText: qsTr("Loooooooong Secondary Text")
            }

            ListItemFlatButton {
                implicitWidth: Sizes.dp(765)
                implicitHeight: Sizes.dp(104)
                icon.name: "ic-update"
                subText: "subtitle"
                text: qsTr("ListItem with button")
                textFlatButton: qsTr("Show on map")
                closeButtonVisible: true
            }

            ListItemFlatButton {
                implicitWidth: Sizes.dp(765)
                implicitHeight: Sizes.dp(104)
                rightPadding: Sizes.dp(16)
                icon.name: "ic-update"
                symbolFlatButton: Style.image("ic-favorite")
                subText: "subtitle"
                text: qsTr("ListItem with button text")
                textFlatButton: qsTr("Text")
            }

            ListItemProgress {
                id: listItemProgress
                implicitWidth: Sizes.dp(765)
                implicitHeight: Sizes.dp(104)
                minimumValue: 0
                maximumValue: 100
                icon.name: "ic-placeholder"
                text: qsTr("Downloading application")
                secondaryText: value + qsTr(" % of 46 MB")
                cancelable: timerDowloading.running
                value: 0
                onProgressCanceled: {
                    timerDowloading.stop()
                    value = 0
                }
                onClicked: {
                    timerDowloading.start()
                }

                Timer {
                    id: timerDowloading
                    interval: 1000
                    repeat: true
                    running: true
                    onTriggered: {
                        if (listItemProgress.value === listItemProgress.maximumValue) {
                            listItemProgress.value = 0
                        } else {
                            listItemProgress.value += 5
                        }
                    }
                }
            }
            ListItemProgress {
                id: listItemProgressIndeterminate
                implicitWidth: Sizes.dp(765)
                implicitHeight: Sizes.dp(104)
                indeterminate: true
                icon.name: "ic-placeholder"
                cancelable: indeterminate
                text: indeterminate ? qsTr("Downloading pending") : qsTr("Downloading canceled")
                onProgressCanceled: indeterminate = false
                onClicked: indeterminate = true
            }

            ListItemSwitch {
                id: listItemSwitch
                implicitWidth: Sizes.dp(765)
                implicitHeight: Sizes.dp(104)
                icon.name: "ic-placeholder"
                text: "List item with a switch " + (listItemSwitch.switchOn ? "(ON)" : "(OFF)")
                onSwitchClicked: console.log("Switch is clicked")
                onSwitchToggled: console.log("Switch is toggled")
            }

            ListItemTwoButtons {
                id: listItemTwoButtons
                implicitWidth: Sizes.dp(765)
                implicitHeight: Sizes.dp(104)
                icon.name: "ic-placeholder"
                text: qsTr("List item with two accessory buttons")
                symbolAccessoryButton1: "ic-call-contrast"
                symbolAccessoryButton2: "ic-message-contrast"
                onAccessoryButton1Clicked: listItemTwoButtons.text = qsTr("Call clicked")
                onAccessoryButton2Clicked: listItemTwoButtons.text = qsTr("Message clicked")
                onClicked: listItemTwoButtons.text = qsTr("List item with two accessory buttons")
            }
        }
    }
}

