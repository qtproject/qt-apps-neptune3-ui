/****************************************************************************
**
** Copyright (C) 2017-2018 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 IVI UI.
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
import QtQuick.Layouts 1.3

import utils 1.0
import animations 1.0
import com.pelagicore.styles.neptune 3.0
import neptune.controls 1.0
import controls 1.0

NeptunePopup {
    id: root
    width: Style.hspan(910/45)
    height: Style.vspan(1426/80)
    headerBackgroundVisible: true
    headerBackgroundHeight: Style.hspan(278/45)

    property var model
    property bool seatTemperaturesLinked: false

    onSeatTemperaturesLinkedChanged: {
        if (seatTemperaturesLinked) {
            model.rightSeat.setValue(model.leftSeat.value);
        }
    }

    onModelChanged: {
        if (model) {
            // need to set "to" and "from" before "value", as modifying them also causes
            // "value" to change

            leftTempSlider.from = model.leftSeat.minValue
            leftTempSlider.to = model.leftSeat.maxValue
            leftTempSlider.value = model.leftSeat.value

            rightTempSlider.from = model.rightSeat.minValue
            rightTempSlider.to = model.rightSeat.maxValue
            rightTempSlider.value = model.rightSeat.value
        }
    }

    ClimateHeader {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: Style.hspan(278/45)
        temperatureDriverSeat: model.leftSeat.valueString
        temperaturePassengerSeat: model.rightSeat.valueString
        onDriverSeatTemperatureIncreased: {
            if (model.leftSeat.value < model.leftSeat.maxValue) {
                model.leftSeat.setValue(model.leftSeat.value + leftTempSlider.stepSize)
            }
        }
        onDriverSeatTemperatureDecreased: {
            if (model.leftSeat.value > model.leftSeat.minValue) {
                model.leftSeat.setValue(model.leftSeat.value - leftTempSlider.stepSize)
            }
        }
        onPassengerSeatTemperatureIncreased: {
            if (model.rightSeat.value < model.rightSeat.maxValue) {
                model.rightSeat.setValue(model.rightSeat.value + rightTempSlider.stepSize)
            }
        }
        onPassengerSeatTemperatureDecreased: {
            if (model.rightSeat.value > model.rightSeat.minValue) {
                model.rightSeat.setValue(model.rightSeat.value - rightTempSlider.stepSize)
            }
        }
        onLinkToggled: root.seatTemperaturesLinked = !root.seatTemperaturesLinked
    }

    ClimateButtonsGrid {
        id: buttonsGrid
        anchors.top: header.bottom
        anchors.topMargin: Style.vspan(36/45)
        anchors.horizontalCenter: parent.horizontalCenter
        model: root.model
    }

    ClimateAirFlow {
        id: airFlow
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: buttonsGrid.bottom
        anchors.topMargin: Style.vspan(36/45)
        model: root.model
    }

    Button {
        id: bigFatButton
        width: Style.hspan(460/45)
        height: Style.vspan(1)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Style.vspan(118/80)
        checkable: true
        text: qsTr("Auto")
        onCheckedChanged: {
            airFlow.autoMode = checked
            //TODO: connect to the backend
        }
    }

    TemperatureSlider {
        id: leftTempSlider
        anchors.top: parent.top
        anchors.topMargin: Style.vspan(130/80) - leftTempSlider.handleHeight/2
        anchors.left: parent.left
        anchors.leftMargin: -leftTempSlider.width/2 + Style.hspan(30/45)/2
        height: Style.vspan(15)
        convertFunc: model.calculateUnitValue

        property bool sliderChanging: false
        onValueChanged: {
            if (pressed) {
                sliderChanging = true;
                model.leftSeat.setValue(value);
                sliderChanging = false;
            }
        }
    }
    Connections {
        target: model ? model.leftSeat : null
        onValueChanged: {
            if (!leftTempSlider.sliderChanging) {
                leftTempSlider.value = target.value
            }
            if (seatTemperaturesLinked) {
                model.rightSeat.setValue(model.leftSeat.value);
            }
        }
    }


    TemperatureSlider {
        id: rightTempSlider
        anchors.top: parent.top
        anchors.topMargin: Style.vspan(130/80) - rightTempSlider.handleHeight/2
        anchors.right: parent.right
        anchors.rightMargin: -rightTempSlider.width/2 + Style.hspan(30/45)/2
        height: Style.vspan(15)
        convertFunc: model.calculateUnitValue

        property bool sliderChanging: false
        onValueChanged: {
            if (pressed) {
                sliderChanging = true;
                model.rightSeat.setValue(value);
                sliderChanging = false;
            }
        }
    }
    Connections {
        target: model ? model.rightSeat : null
        onValueChanged: {
            if (!rightTempSlider.sliderChanging) {
                rightTempSlider.value = target.value
            }
            if (seatTemperaturesLinked) {
                model.leftSeat.setValue(model.rightSeat.value);
            }
        }
    }
}
