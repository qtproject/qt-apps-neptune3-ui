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
import QtIvi.VehicleFunctions 1.0

QtObject {
    id: root

    property ClimateControl climateControl: ClimateControl {
        discoveryMode: ClimateControl.AutoDiscovery
        onIsInitializedChanged: {
            if (isInitialized) {
                leftSeat.setValue(21.5)
                rightSeat.setValue(21.5)
            }
        }
    }

    property int measurementSystem

    property QtObject leftSeat: QtObject {
        id: leftSeat
        readonly property real minValue: 17
        readonly property real maxValue: 25
        readonly property real stepValue: 0.5
        readonly property real value: climateControl.zoneAt.FrontLeft ? climateControl.zoneAt.FrontLeft.targetTemperature : 0.0
        readonly property real localizedValue: root.calculateUnitValue(value)
        readonly property string valueString: Number(localizedValue).toLocaleString(Qt.locale(), 'f', 1)
        readonly property int measurementSystem: root.measurementSystem

        readonly property bool heat: climateControl.zoneAt.FrontLeft ? climateControl.zoneAt.FrontLeft.seatHeater > 0 : false

        function setValue(newValue) {
            climateControl.zoneAt.FrontLeft.targetTemperature = newValue
        }

        function setHeat(newHeat) {
            climateControl.zoneAt.FrontLeft.seatHeater = newHeat
        }
    }

    property QtObject rightSeat: QtObject {
        id: rightSeat
        readonly property real minValue: 17
        readonly property real maxValue: 25
        readonly property real stepValue: 0.5
        readonly property real value: climateControl.zoneAt.FrontRight ? climateControl.zoneAt.FrontRight.targetTemperature : 0.0
        readonly property real localizedValue: root.calculateUnitValue(value)
        readonly property string valueString: Number(localizedValue).toLocaleString(Qt.locale(), 'f', 1)
        readonly property int measurementSystem: root.measurementSystem

        readonly property bool heat: climateControl.zoneAt.FrontRight ? climateControl.zoneAt.FrontRight.seatHeater > 0 : false

        function setValue(newValue) {
            climateControl.zoneAt.FrontRight.targetTemperature = newValue
        }

        function setHeat(newHeat) {
            climateControl.zoneAt.FrontRight.seatHeater = newHeat
        }
    }

    property QtObject frontHeat: QtObject {
        property string symbol: "front"
        readonly property bool enabled: climateControl.defrostEnabled

        function setEnabled(newEnabled) {
            climateControl.defrostEnabled = newEnabled;
        }
    }

    property QtObject rearHeat: QtObject {
        property string symbol: "rear"
        readonly property bool enabled: climateControl.heaterEnabled

        function setEnabled(newEnabled) {
            climateControl.heaterEnabled = newEnabled;
        }
    }

    property QtObject autoClimateMode: QtObject {
        readonly property bool enabled: climateControl.climateMode === ClimateControl.AutoClimate;

        function setEnabled(newEnabled) {
            climateControl.climateMode = newEnabled ? ClimateControl.AutoClimate : ClimateControl.ClimateOn;
        }
    }

    property QtObject airCondition: QtObject {
        readonly property string symbol: "ac"
        readonly property bool enabled: climateControl.airConditioningEnabled

        function setEnabled(newEnabled) {
            climateControl.airConditioningEnabled = newEnabled;
        }
    }

    property QtObject airQuality: QtObject {
        readonly property string symbol: "air_quality"
        readonly property bool enabled: climateControl.recirculationMode === ClimateControl.RecirculationOn

        function setEnabled(newEnabled) {
            climateControl.recirculationMode = newEnabled ? ClimateControl.RecirculationOn : ClimateControl.RecirculationOff;
        }
    }

    property QtObject eco: QtObject {
        property string symbol: "eco"
        property bool enabled: false

        function setEnabled(newEnabled) {
            enabled = newEnabled;
        }
    }

    property QtObject zoneSynchronization: QtObject {
        readonly property bool enabled: climateControl.zoneSynchronizationEnabled;

        function setEnabled(newEnabled) {
            climateControl.zoneSynchronizationEnabled = newEnabled;
        }
    }

    property QtObject steeringWheelHeat: QtObject {
        readonly property string symbol: "stearing_wheel"
        readonly property bool enabled: climateControl.steeringWheelHeater >= 5

        function setEnabled(newEnabled) {
            climateControl.steeringWheelHeater = newEnabled ? 10 : 0;
        }
    }

    readonly property var climateOptions: [frontHeat, rearHeat, airCondition, airQuality, eco, steeringWheelHeat]

    property int ventilation: climateControl.fanSpeedLevel

    property int ventilationLevels: 7 // 6 + off (0)

    function setVentilation(newVentilation) {
        climateControl.fanSpeedLevel = newVentilation;
    }


    // ClimateControl.airfloDirections is a bitfield. Manipulating bitfields is a PITA.
    // Convert it into a nice set of booleans instead.
    // TODO: Change the QtIVI interface from bitfield to booleans so that this wrapping is no longer needed
    property QtObject airflow: QtObject {
        id: airflow
        property bool _lock: false
        property bool dashboard: false
        property bool floor: false
        property bool windshield: false


        onDashboardChanged: flipBit(dashboard, ClimateControl.Dashboard)
        onFloorChanged: flipBit(floor, ClimateControl.Floor)
        onWindshieldChanged: flipBit(windshield, ClimateControl.Windshield)
        function flipBit(enabled, value) {
            if (!_lock) {
                _lock = true;
                climateControl.airflowDirections ^= value;
                _lock = false;
            }
        }

        property var conns: Connections {
            target: climateControl
            function onAirflowDirectionsChanged() { airflow.updateProperties() }
        }

        function updateProperties() {
            if (!_lock) {
                _lock = true;
                dashboard = (climateControl.airflowDirections & ClimateControl.Dashboard) === ClimateControl.Dashboard
                floor = (climateControl.airflowDirections & ClimateControl.Floor) === ClimateControl.Floor
                windshield = (climateControl.airflowDirections & ClimateControl.Windshield) === ClimateControl.Windshield
                _lock = false;
            }
        }

        Component.onCompleted: updateProperties()
    }

    function calculateUnitValue(value) {
        // Default value is the celsius
        return root.measurementSystem === Locale.MetricSystem || root.measurementSystem === Locale.ImperialUKSystem ?
                    value.toFixed(1) : (value * 1.8 + 32).toFixed(1)
    }
}
