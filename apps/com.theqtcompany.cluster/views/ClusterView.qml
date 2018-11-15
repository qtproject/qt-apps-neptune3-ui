/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Copyright (C) 2018 Pelagicore AG
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
import shared.com.pelagicore.settings 1.0
import application.windows 1.0

import shared.com.pelagicore.styles.neptune 3.0

import "../stores" 1.0
import "../panels" 1.0
import "../helpers" 1.0

Item {
    id: root

    property ClusterStoreInterface store
    property alias rtlMode: mainContent.rtlMode

    //private
    QtObject {
        id: d
        readonly property real scaleRatio: Math.min(root.width / 1920, root.height / 720)
    }

    Image {
        // Overlay between the ivi content and tellatales, cluster content
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 390 * d.scaleRatio
        source: Utils.localAsset("cluster-fullscreen-overlay", NeptuneStyle.theme)
    }

    GaugesPanel {
        id: mainContent
        anchors.fill: parent
        navigating: store.navigationMode
        speed: store.speed
        speedLimit: store.speedLimit
        cruiseSpeed: store.speedCruise
        ePower: store.ePower
        drivetrain: store.driveTrainState
    }

    TelltalesLeftPanel {
        anchors.left: mainContent.left
        anchors.leftMargin: 111 * d.scaleRatio
        y: 23 * d.scaleRatio
        width: 444 * d.scaleRatio
        height: 58 * d.scaleRatio

        lowBeamHeadLightOn: store.lowBeamHeadlight
        highBeamHeadLightOn: store.highBeamHeadlight
        fogLightOn: store.fogLight
        stabilityControlOn: store.stabilityControl
        seatBeltFastenOn: store.seatBeltFasten
        leftTurnOn: store.leftTurn
    }

    TelltalesRightPanel {
        anchors.right: mainContent.right
        anchors.rightMargin: 111 * d.scaleRatio
        y: 23 * d.scaleRatio
        width: 444 * d.scaleRatio
        height: 58 * d.scaleRatio

        rightTurnOn: store.rightTurn
        absFailureOn: store.absFailure;
        parkingBrakeOn: store.parkBrake;
        lowTyrePressureOn: store.tyrePressureLow;
        brakeFailureOn: store.brakeFailure;
        airbagFailureOn: store.airbagFailure;
    }
}
