/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 Cluster UI.
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
import QtQuick.Window 2.2

import shared.com.pelagicore.remotesettings 1.0
import shared.animations 1.0
import shared.Sizes 1.0
import shared.Style 1.0

import "../stores" 1.0
import "../panels" 1.0
import "../helpers" 1.0
import "../controls" 1.0

/*
    Lucee ClusterView
*/

Item {
    id: root

    property RootStoreInterface store
    property alias rtlMode: mainContent.rtlMode
    readonly property alias blinker: blinker

    Image {
        // Overlay between the ivi content and tellatales, cluster content
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: Sizes.dp(390)
        source: Utils.localAsset("cluster-fullscreen-overlay", Style.theme)
    }

    GaugesPanel {
        id: mainContent
        anchors.fill: parent

        navigating: store.behaviourInterface.navigationMode
        speed: Math.round(root.store.localization.calculateDistanceValue(store.vehicleInterface.speed))
        ePower: store.vehicleInterface.ePower
        drivetrain: store.vehicleInterface.driveTrainState
        opacity: store.behaviourInterface.hideGauges ? 0.0 : 1.0

        //Lucee properties
        outsideTemperature: store.externalDataInterface.outsideTemperature
        currentDate: store.externalDataInterface.currentDate
        twentyFourHourTimeFormat: store.localization.twentyFourHourTimeFormat
        navigationProgressPercents: store.externalDataInterface.navigationProgressPercents
        navigationRouteDistance: store.externalDataInterface.navigationRouteDistanceKm
        drivingMode: store.vehicleInterface.drivingMode
        drivingModeRangeDistance: Math.round(store.localization.calculateDistanceValue(store.vehicleInterface.drivingModeRangeKm))
        drivingModeECORangeDistance: Math.round(store.localization.calculateDistanceValue(store.vehicleInterface.drivingModeECORangeKm))
        mileage: store.vehicleInterface.mileage
        mileageUnits: store.localization.mileageUnits
        speedUnits: store.localization.speedUnits
        clusterUIMode: store.behaviourInterface.clusterUIMode

        Behavior on opacity {
            DefaultNumberAnimation {}
        }
    }

    TelltalesLeftPanel {
        LayoutMirroring.enabled: false
        anchors.right: mainContent.horizontalCenter
        anchors.rightMargin: Sizes.dp(405)
        y: Sizes.dp(23)
        width: Sizes.dp(444)
        height: Sizes.dp(58)

        lowBeamHeadLightOn: store.vehicleInterface.lowBeamHeadlight
        highBeamHeadLightOn: store.vehicleInterface.highBeamHeadlight
        fogLightOn: store.vehicleInterface.fogLight
        stabilityControlOn: store.vehicleInterface.stabilityControl
        seatBeltFastenOn: store.vehicleInterface.seatBeltFasten
        leftTurnOn: store.vehicleInterface.leftTurn
        blinker: blinker.lit
    }

    TelltalesRightPanel {
        LayoutMirroring.enabled: false
        anchors.left: mainContent.horizontalCenter
        anchors.leftMargin: Sizes.dp(405)
        y: Sizes.dp(23)
        width: Sizes.dp(444)
        height: Sizes.dp(58)

        rightTurnOn: store.vehicleInterface.rightTurn
        absFailureOn: store.vehicleInterface.absFailure;
        parkingBrakeOn: store.vehicleInterface.parkBrake;
        lowTyrePressureOn: store.vehicleInterface.tyrePressureLow;
        brakeFailureOn: store.vehicleInterface.brakeFailure;
        airbagFailureOn: store.vehicleInterface.airbagFailure;
        blinker: blinker.lit
    }

    //common switch for left and right turn and safe part
    Blinker {
        id: blinker
        running: store.vehicleInterface.rightTurn || store.vehicleInterface.leftTurn
    }
}
