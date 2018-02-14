/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Triton Cluster UI.
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
import com.pelagicore.settings 1.0
import QtApplicationManager 1.0

ApplicationManagerWindow {
    id: root
    visible: true
    width: 1920
    height: 720
    title: qsTr("Instrument Cluster")
    color: "transparent"

    InstrumentCluster {
        id: dataSource
    }

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
        source: "img/cluster-fullscreen-overlay.png"
    }

    Normal {
        id: mainContent
        anchors.fill: parent
        navigating: dataSource.navigationMode
        speed: dataSource.speed
        speedLimit: dataSource.speedLimit
        cruiseSpeed: dataSource.speedCruise
        ePower: dataSource.ePower
        drivetrain: dataSource.driveTrainState
    }

    TelltalesLeft {
        anchors.left: mainContent.left
        anchors.leftMargin: 111 * d.scaleRatio
        y: 23 * d.scaleRatio
        width: 444 * d.scaleRatio
        height: 58 * d.scaleRatio
        margin: 30 * d.scaleRatio

        controlBitLowBeamHeadLight: dataSource.lowBeamHeadlight
        controlBitHighBeamHeadLight: dataSource.highBeamHeadlight
        controlBitFogLight: dataSource.fogLight
        controlBitStabilityControl: dataSource.stabilityControl
        controlBitSeatBeltFasten: dataSource.seatBeltNotFastened
        controlBitLeftTurn: dataSource.leftTurn
    }

    TelltalesRight {
        anchors.right: mainContent.right
        anchors.rightMargin: 111 * d.scaleRatio
        y: 23 * d.scaleRatio
        width: 444 * d.scaleRatio
        height: 58 * d.scaleRatio
        margin: 30 * d.scaleRatio

        controlBitRightTurn: dataSource.rightTurn
        controlBitAbsFailure: dataSource.ABSFailure;
        controlBitParkBrake: dataSource.parkBrake;
        controlBitTyrePressLow: dataSource.tyrePressureLow;
        controlBitBrakeFailure: dataSource.brakeFailure;
        controlBitAirbagFailure: dataSource.airbagFailure;
    }
}
