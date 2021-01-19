/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
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
import QtApplicationManager.Application 2.0
import shared.com.pelagicore.remotesettings 1.0
import shared.com.pelagicore.drivedata 1.0
import shared.com.pelagicore.systeminfo 1.0

/*!
    \qmltype ClusterStore
    A component, extending ClusterStoreInterface with Cluster-specific properties
*/

RootStoreInterface {
    id: root

    readonly property InstrumentCluster clusterDataSource: InstrumentCluster {}
    /*!
        \qmlproperty UISettings ClusterStore::uiSettings
        Needed here to get twentyFourHourTimeFormat
    */
    readonly property UISettings uiSettings: UISettings {}
    // true if QtSafeRenderer is enabled
    readonly property bool qsrEnabled: ApplicationInterface.systemProperties["qsrEnabled"]
    readonly property SystemInfo systemInfo: SystemInfo {}

    vehicleInterface: VehicleInterface {
        speed: clusterDataSource.speed
        speedLimit: clusterDataSource.speedLimit
        speedCruise: clusterDataSource.speedCruise
        driveTrainState: clusterDataSource.driveTrainState
        ePower: clusterDataSource.ePower
        drivingMode: clusterDataSource.drivingMode
        drivingModeRangeKm: clusterDataSource.drivingModeRangeKm
        drivingModeECORangeKm: clusterDataSource.drivingModeECORangeKm

        mileage: localization.calculateDistanceValue(clusterDataSource.mileageKm)

        lowBeamHeadlight: clusterDataSource.lowBeamHeadlight
        highBeamHeadlight: clusterDataSource.highBeamHeadlight
        fogLight: clusterDataSource.fogLight
        stabilityControl: clusterDataSource.stabilityControl
        seatBeltFasten: clusterDataSource.seatBeltNotFastened
        leftTurn: clusterDataSource.leftTurn

        rightTurn: clusterDataSource.rightTurn
        absFailure: clusterDataSource.ABSFailure
        parkBrake: clusterDataSource.parkBrake
        tyrePressureLow: clusterDataSource.tyrePressureLow
        brakeFailure: clusterDataSource.brakeFailure
        airbagFailure: clusterDataSource.airbagFailure
    }

    behaviourInterface: BehaviourInterface {
        Loader {
            visible: false
            source: "../helpers/Qt3DStudioAvailable.qml"
            onLoaded: {
                root.behaviourInterface.qt3DStudioAvailable = true
                source = ""
            }
        }

        threeDGauges: systemInfo.allow3dStudioPresentations && qt3DStudioAvailable
                      && uiSettings.threeDGauges
        hideGauges: uiSettings.hideGauges
        navigationMode: uiSettings.navigationMode
    }

    externalDataInterface: ExternalDataInterface {
        outsideTemperature: QtObject {
            readonly property real value: clusterDataSource.outsideTemperatureCelsius

            readonly property real minValue: -100
            readonly property real maxValue: 100
            readonly property real stepValue: 0.5
            readonly property real localizedValue: localization.calculateUnitValue(value)
            readonly property string valueString: Number(localizedValue).toLocaleString(Qt.locale(), 'f', 1)
            readonly property string localizedUnits: root.localization.temperature
        }

        currentDate: new Date();
        readonly property QtObject d_timer: Timer {
            interval: 1000
            repeat: true
            running: true
            onTriggered: parent.currentDate = new Date()
        }

        readonly property real navigationProgressPercents: clusterDataSource.navigationProgressPercents
        readonly property real navigationRouteDistanceKm: clusterDataSource.navigationRouteDistanceKm
    }


    readonly property QtObject localization: QtObject {
        property string mileageUnits: {
            if (Qt.locale().measurementSystem === Locale.MetricSystem)
                return qsTr("km")
            else
                return qsTr("mi")
        }

        readonly property string speedUnits: {
            if (Qt.locale().measurementSystem === Locale.MetricSystem)
                return qsTr("km/h")
            else
                return qsTr("mph")
        }

        readonly property string temperature: {
            if (Qt.locale().measurementSystem === Locale.MetricSystem)
                return qsTr("°C")
            else
                return qsTr("°F")
        }

        readonly property bool twentyFourHourTimeFormat: uiSettings.twentyFourHourTimeFormat

        /*!
            Convert distance from km to mi
        */
        function calculateDistanceValue(value) {
            return Qt.locale().measurementSystem === Locale.MetricSystem
                    ? value
                    : value / 1.60934
        }

        /*!
            Convert temperature from C to F
        */
        function calculateUnitValue(value) {
            // Default value is the celsius
            return Qt.locale().measurementSystem === Locale.MetricSystem
                    ? value
                    : Math.round(value * 1.8 + 32.0)
        }
    }
}
