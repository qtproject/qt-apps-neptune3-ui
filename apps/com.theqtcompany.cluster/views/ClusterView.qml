/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Copyright (C) 2018 Pelagicore AG
** Copyright (C) 2017 The Qt Company Ltd.
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
//import application.windows 1.0

import shared.Sizes 1.0
import shared.Style 1.0

import shared.animations 1.0

import "../stores" 1.0
import "../panels" 1.0
import "../helpers" 1.0
import "../controls" 1.0

Item {
    id: root

    property RootStoreInterface store
    property bool rtlMode
    readonly property alias blinker: blinker

    Image {
        // Overlay between the ivi content and tellatales, cluster content
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: Sizes.dp(390)
        source: Utils.localAsset("cluster-fullscreen-overlay", Style.theme)
    }

    Loader {
        id: gaugesPanelLoader
        active: !store.behaviourInterface.threeDGauges
        source: "../panels/GaugesPanel.qml"
        opacity: store.behaviourInterface.hideGauges ? 0.0 : 1.0
        anchors.fill: parent
        Behavior on opacity {
            DefaultNumberAnimation {}
        }
        onLoaded: {
            item.rtlMode = Qt.binding( function() {return root.rtlMode} )
            item.navigating = Qt.binding( function() {return store.behaviourInterface.navigationMode})
            item.speed = Qt.binding( function() {return store.vehicleInterface.speed})
            item.speedLimit = Qt.binding( function() {return store.vehicleInterface.speedLimit})
            item.cruiseSpeed = Qt.binding( function() {return store.vehicleInterface.speedCruise})
            item.ePower = Qt.binding( function() {return store.vehicleInterface.ePower})
            item.drivetrain = Qt.binding( function() {return store.vehicleInterface.driveTrainState})
            item.clusterUIMode = Qt.binding( function() {return store.behaviourInterface.clusterUIMode})
        }
    }

    Loader {
        id: _3dgaugesPanelLoader
        active: store.behaviourInterface.threeDGauges
        source: "../panels/GaugesPanel3D.qml"
        opacity: store.behaviourInterface.hideGauges ? 0.0 : 1.0
        anchors.fill: parent
        Behavior on opacity {
            DefaultNumberAnimation {}
        }
        onLoaded: {
            item.rtlMode = Qt.binding( function() {return root.rtlMode} )
            item.navigating = Qt.binding( function() {return store.behaviourInterface.navigationMode})
            item.speed = Qt.binding( function() {return store.vehicleInterface.speed})
            item.speedLimit = Qt.binding( function() {return store.vehicleInterface.speedLimit})
            item.cruiseSpeed = Qt.binding( function() {return store.vehicleInterface.speedCruise})
            item.ePower = Qt.binding( function() {return store.vehicleInterface.ePower})
            item.drivetrain = Qt.binding( function() {return store.vehicleInterface.driveTrainState})
            item.clusterUIMode = Qt.binding( function() {return store.behaviourInterface.clusterUIMode})
        }
    }

    TelltalesLeftPanel {
        LayoutMirroring.enabled: false
        anchors.right: parent.horizontalCenter
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
        anchors.left: parent.horizontalCenter
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
