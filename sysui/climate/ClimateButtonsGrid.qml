/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
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

import QtQuick 2.10
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3

import utils 1.0

import com.pelagicore.styles.neptune 3.0

GridLayout {
    id: root

    property var model

    width: NeptuneStyle.dp(448)
    height: NeptuneStyle.dp(312)
    columns: 3
    ClimateButton {
        id: rear_defrost
        Layout.fillWidth: true
        Layout.fillHeight: true
        icon.name: checked ? "ic-rear-defrost_ON" : "ic-rear-defrost_OFF"
        checked: model.rearHeat.enabled
        onToggled: model.rearHeat.setEnabled(!model.rearHeat.enabled)
    }
    ClimateButton {
        id: front_defrost
        Layout.fillWidth: true
        Layout.fillHeight: true
        icon.name: checked ? "ic-front-defrost_ON" : "ic-front-defrost_OFF"
        checked: model.frontHeat.enabled
        onToggled: model.frontHeat.setEnabled(!model.frontHeat.enabled)
    }
    ClimateButton {
        id: recirculation
        Layout.fillWidth: true
        Layout.fillHeight: true
        icon.name: checked ? "ic-recirculation_ON" : "ic-recirculation_OFF"
        checked: model.airQuality.enabled
        onToggled: model.airQuality.setEnabled(!model.airQuality.enabled)
    }
    ClimateButton {
        id: seat_heater_driver
        Layout.fillWidth: true
        Layout.fillHeight: true
        icon.name: checked ? "ic-seat-heat-driver_ON" : "ic-seat-heat-driver_OFF"
        display: AbstractButton.TextUnderIcon
        text: qsTr("DRIVER")
        checked: model.leftSeat.heat
        onToggled: model.leftSeat.setHeat(!model.leftSeat.heat)
    }
    ClimateButton {
        id: steering_wheel_heat
        Layout.fillWidth: true
        Layout.fillHeight: true
        icon.name: checked ? "ic-steering-wheel-heat_ON" : "ic-steering-wheel-heat_OFF"
        checked: model.steeringWheelHeat.enabled
        onToggled: model.steeringWheelHeat.setEnabled(!model.steeringWheelHeat.enabled)
    }
    ClimateButton {
        id: seat_heater_passenger
        Layout.fillWidth: true
        Layout.fillHeight: true
        icon.name: checked ? "ic-seat-heat-passenger_ON" : "ic-seat-heat-passenger_OFF"
        display: AbstractButton.TextUnderIcon
        text: qsTr("PASSENGER")
        checked: model.rightSeat.heat
        onToggled: model.rightSeat.setHeat(!model.rightSeat.heat)
    }
}
