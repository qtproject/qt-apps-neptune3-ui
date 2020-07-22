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
import QtQuick.Controls 2.2
import shared.controls 1.0
import application.windows 1.0

import shared.Sizes 1.0

import "../controls" 1.0

Item {
    id: root

    property var store
    property bool seatTemperaturesLinked

    onSeatTemperaturesLinkedChanged: {
        if (seatTemperaturesLinked) {
            root.store.rightSeat.setValue(root.store.leftSeat.value);
        }
        root.store.zoneSynchronization.setEnabled(seatTemperaturesLinked);
    }

    onStoreChanged: {
        if (store) {
            // need to set "to" and "from" before "value", as modifying them also causes
            // "value" to change

            //keep init order not to have negative model size warning, Slider defaults 0.0 .. 1.0
            leftTempSlider.to = root.store.leftSeat.maxValue
            leftTempSlider.from = root.store.leftSeat.minValue
            leftTempSlider.value = root.store.leftSeat.value

            rightTempSlider.to = root.store.rightSeat.maxValue
            rightTempSlider.from = root.store.rightSeat.minValue
            rightTempSlider.value = root.store.rightSeat.value
        }
    }

    ClimateHeaderPanel {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: Sizes.dp(278)
        leftSeat: root.store ? root.store.calculateUnitValue(leftTempSlider.value) : null
        rightSeat: root.store ? root.store.calculateUnitValue(rightTempSlider.value) : null

        zoneSynchronizationEnabled: root.seatTemperaturesLinked
        onDriverSeatTemperatureIncreased: {
            if (root.store.leftSeat.value < root.store.leftSeat.maxValue) {
                root.store.leftSeat.setValue(root.store.leftSeat.value + leftTempSlider.stepSize)
            }
        }
        onDriverSeatTemperatureDecreased: {
            if (root.store.leftSeat.value > root.store.leftSeat.minValue) {
                root.store.leftSeat.setValue(root.store.leftSeat.value - leftTempSlider.stepSize)
            }
        }
        onPassengerSeatTemperatureIncreased: {
            if (root.store.rightSeat.value < root.store.rightSeat.maxValue) {
                root.store.rightSeat.setValue(root.store.rightSeat.value + rightTempSlider.stepSize)
            }
        }
        onPassengerSeatTemperatureDecreased: {
            if (root.store.rightSeat.value > root.store.rightSeat.minValue) {
                root.store.rightSeat.setValue(root.store.rightSeat.value - rightTempSlider.stepSize)
            }
        }
        onLinkToggled: root.seatTemperaturesLinked = !root.seatTemperaturesLinked
    }

    ClimateButtonsGridPanel {
        id: buttonsGrid
        anchors.top: header.bottom
        anchors.topMargin: Sizes.dp(64)
        anchors.horizontalCenter: parent.horizontalCenter
        store: root.store
    }

    ClimateAirFlowPanel {
        id: airFlow
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: buttonsGrid.bottom
        anchors.topMargin: Sizes.dp(64)
        store: root.store ? root.store : undefined
    }

    Button {
        id: bigFatButton
        width: Sizes.dp(460)
        height: Sizes.dp(80)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Sizes.dp(118)
        checkable: true
        checked: root.store ? root.store.autoClimateMode.enabled : false
        text: qsTr("Auto")
        onToggled: {
            airFlow.autoMode = checked;
            store.autoClimateMode.setEnabled(checked);
        }
    }

    TemperatureSlider {
        id: leftTempSlider
        objectName: "leftTempSlider"
        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(130) - leftTempSlider.handleHeight/2
        anchors.left: parent.left
        height: Sizes.dp(1200)
        onSliderReleased: {
            root.store.leftSeat.setValue(value);
        }
    }

    Connections {
        target: root.store ? root.store.leftSeat : null
        function onValueChanged() {
            if (!leftTempSlider.pressed) {
                leftTempSlider.value = target.value
            }
            if (seatTemperaturesLinked) {
                root.store.rightSeat.setValue(root.store.leftSeat.value);
            }
        }
    }

    TemperatureSlider {
        id: rightTempSlider
        objectName: "rightTempSlider"
        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(130) - rightTempSlider.handleHeight/2
        anchors.right: parent.right
        height: Sizes.dp(1200)
        onSliderReleased: {
            root.store.rightSeat.setValue(value);
        }
    }

    Connections {
        target: root.store ? root.store.rightSeat : null
        function onValueChanged() {
            if (!rightTempSlider.pressed) {
                rightTempSlider.value = target.value
            }
            if (seatTemperaturesLinked) {
                root.store.leftSeat.setValue(root.store.rightSeat.value);
            }
        }
    }
}
