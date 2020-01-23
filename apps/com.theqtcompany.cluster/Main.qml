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
import application.windows 1.0

import shared.utils 1.0
import shared.Sizes 1.0
import shared.Style 1.0

import "views" 1.0
import "stores" 1.0

NeptuneWindow {
    id: root
    visible: true
    title: qsTr("Instrument Cluster")

    width: Sizes.dp(Config.instrumentClusterWidth)
    height: root.width / Config.instrumentClusterUIAspectRatio

    Component.onCompleted: {
        setWindowProperty("windowType", "instrumentcluster");
    }

    ClusterView {
        id: clusterView
        anchors.fill: parent
        rtlMode: root.LayoutMirroring.enabled
        store: RootStore {}

        Loader {
            id: safeTelltalesLoader
            anchors.fill: parent
            active: clusterView.store.qsrEnabled
            source: "panels/SafeTelltalesPanel.qml"
            onLoaded: {
                item.blinker = Qt.binding( function() {return clusterView.blinker.lit} )
                item.lowBeamHeadLightOn = Qt.binding( function() {return clusterView.store.vehicleInterface.lowBeamHeadlight})
                item.highBeamHeadLightOn = Qt.binding( function() {return clusterView.store.vehicleInterface.highBeamHeadlight})
                item.fogLightOn = Qt.binding( function() {return clusterView.store.vehicleInterface.fogLight})
                item.stabilityControlOn = Qt.binding( function() {return clusterView.store.vehicleInterface.stabilityControl})
                item.seatBeltFastenOn = Qt.binding( function() {return clusterView.store.vehicleInterface.seatBeltFasten})
                item.leftTurnOn = Qt.binding( function() {return clusterView.store.vehicleInterface.leftTurn})
                item.rightTurnOn = Qt.binding( function() {return clusterView.store.vehicleInterface.rightTurn})
                item.absFailureOn = Qt.binding( function() {return clusterView.store.vehicleInterface.absFailure})
                item.parkingBrakeOn = Qt.binding( function() {return clusterView.store.vehicleInterface.parkBrake})
                item.lowTyrePressureOn = Qt.binding( function() {return clusterView.store.vehicleInterface.tyrePressureLow})
                item.brakeFailureOn = Qt.binding( function() {return clusterView.store.vehicleInterface.brakeFailure})
                item.airbagFailureOn = Qt.binding( function() {return clusterView.store.vehicleInterface.airbagFailure})
            }
        }
    }

    onWindowPropertyChanged: {
        if (name === "clusterUIMode") {
            //set UI mode for cluster: no app or some app running under cluster view
            clusterView.store.behaviourInterface.clusterUIMode = value
        }
    }
}
