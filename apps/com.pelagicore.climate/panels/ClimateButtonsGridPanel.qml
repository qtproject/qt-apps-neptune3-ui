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

import QtQuick 2.10
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3

import shared.utils 1.0

import shared.Sizes 1.0

import "../controls" 1.0

GridLayout {
    id: root

    property var store

    width: Sizes.dp(448)
    height: Sizes.dp(312)
    columns: 3
    ClimateButton {
        id: rear_defrost
        objectName: "rear_defrost"
        Layout.fillWidth: true
        Layout.fillHeight: true
        icon.name: checked ? "ic-rear-defrost_ON" : "ic-rear-defrost_OFF"
        checked: store ? store.rearHeat.enabled : false
        onToggled: store.rearHeat.setEnabled(!store.rearHeat.enabled)
    }
    ClimateButton {
        id: front_defrost
        objectName: "front_defrost"
        Layout.fillWidth: true
        Layout.fillHeight: true
        icon.name: checked ? "ic-front-defrost_ON" : "ic-front-defrost_OFF"
        checked: store ? store.frontHeat.enabled : false
        onToggled: store.frontHeat.setEnabled(!store.frontHeat.enabled)
    }
    ClimateButton {
        id: recirculation
        objectName: "recirculation"
        Layout.fillWidth: true
        Layout.fillHeight: true
        icon.name: checked ? "ic-recirculation_ON" : "ic-recirculation_OFF"
        checked: store ? store.airQuality.enabled : false
        onToggled: store.airQuality.setEnabled(!store.airQuality.enabled)
    }
    ClimateButton {
        id: seat_heater_driver
        objectName: "seat_heater_driver"
        Layout.fillWidth: true
        Layout.fillHeight: true
        icon.name: checked ? "ic-seat-heat-driver_ON" : "ic-seat-heat-driver_OFF"
        display: AbstractButton.TextUnderIcon
        text: qsTr("DRIVER")
        checked: store ? store.leftSeat.heat : false
        onToggled: store.leftSeat.setHeat(!store.leftSeat.heat)
    }
    ClimateButton {
        id: steering_wheel_heat
        objectName: "steering_wheel_heat"
        Layout.fillWidth: true
        Layout.fillHeight: true
        icon.name: checked ? "ic-steering-wheel-heat_ON" : "ic-steering-wheel-heat_OFF"
        checked: store ? store.steeringWheelHeat.enabled : false
        onToggled: store.steeringWheelHeat.setEnabled(!store.steeringWheelHeat.enabled)
    }
    ClimateButton {
        id: seat_heater_passenger
        objectName: "seat_heater_passenger"
        Layout.fillWidth: true
        Layout.fillHeight: true
        icon.name: checked ? "ic-seat-heat-passenger_ON" : "ic-seat-heat-passenger_OFF"
        display: AbstractButton.TextUnderIcon
        text: qsTr("PASSENGER")
        checked: store ? store.rightSeat.heat : false
        onToggled: store.rightSeat.setHeat(!store.rightSeat.heat)
    }
}
