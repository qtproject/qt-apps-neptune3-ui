/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Copyright (C) 2018 Pelagicore AG
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

import QtQuick 2.8
import shared.com.pelagicore.settings 1.0

/*!
    \qmltype ClusterStore
    A component, extending ClusterStoreInterface with Cluster-specific properties
*/

ClusterStoreInterface {
    id: root

    readonly property InstrumentCluster clusterDataSource: InstrumentCluster {}
    /*!
        \qmlproperty UISettings ClusterStore::uiSettings
        Needed here to get twentyFourHourTimeFormat
    */
    readonly property UISettings uiSettings: UISettings {}

    hideGauges: clusterDataSource.hideGauges
    navigationMode: clusterDataSource.navigationMode
    speed: clusterDataSource.speed
    speedLimit: clusterDataSource.speedLimit
    speedCruise: clusterDataSource.speedCruise
    driveTrainState: clusterDataSource.driveTrainState
    ePower: clusterDataSource.ePower

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

    /*!
        \qmlproperty real ClusterStore::mileage
        Holds localized mileage, converted from mileageKm value in km
    */
    property real mileage: calculateDistanceValue(clusterDataSource.mileageKm)
    /*!
        \qmlproperty real ClusterStore::mileageUnits
        Holds localized mileage units
    */
    property string mileageUnits: {
        if (Qt.locale().measurementSystem === Locale.MetricSystem)
            return qsTr("km")
        else
            return qsTr("mi")
    }
    /*!
        \qmlproperty real ClusterStore::speedUnits
        Holds localized spped units
    */
    property string speedUnits: {
        if (Qt.locale().measurementSystem === Locale.MetricSystem)
            return qsTr("km/h")
        else
            return qsTr("mph")
    }

    /*!
        \qmlproperty var ClusterStore::currentDate
        \qmlproperty QObject ClusterStore::timer
        Used as time source for cluster
    */
    property var currentDate: new Date();
    property QtObject timer: Timer {
        interval: 1000; repeat: true; running: true
        onTriggered: { currentDate = new Date(); }
    }

    /*!
        \qmlproperty real ClusterStore::navigationRouteDistance
        Holds localized value for route distance
    */
    property real navigationRouteDistance: calculateDistanceValue(clusterDataSource.navigationRouteDistanceKm)
    navigationProgressPercents: clusterDataSource.navigationProgressPercents

    twentyFourHourTimeFormat: uiSettings.twentyFourHourTimeFormat
    drivingMode: clusterDataSource.drivingMode
    drivingModeRangeKm: clusterDataSource.drivingModeRangeKm
    drivingModeECORangeKm: clusterDataSource.drivingModeECORangeKm

    outsideTemp: QtObject {
        readonly property real minValue: -100
        readonly property real maxValue: 100
        readonly property real stepValue: 0.5
        readonly property real value: clusterDataSource.outsideTempCelsius
        readonly property real localizedValue: root.calculateUnitValue(value)
        readonly property string valueString: Number(localizedValue).toLocaleString(Qt.locale(), 'f', 1)
        readonly property string localizedUnits: {
            if (Qt.locale().measurementSystem === Locale.MetricSystem)
                return qsTr("°C")
            else
                return qsTr("°F")
        }
    }
}
