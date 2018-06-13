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
import com.pelagicore.settings 1.0
import QtApplicationManager 1.0

import com.pelagicore.styles.neptune 3.0

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

    UISettings {
        onThemeChanged: updateTheme()
        onAccentColorChanged: {
            // In single-process mode we don't have a contentItem, so we need to use root instead
            // TODO This should be fixed in the appman abstraction at some point
            if (root.contentItem)
                root.contentItem.NeptuneStyle.accentColor = accentColor;
            else
                root.NeptuneStyle.accentColor = accentColor;
        }
        Component.onCompleted: updateTheme()
        function updateTheme() {
            // In single-process mode we don't have a contentItem, so we need to use root instead
            // TODO This should be fixed in the appman abstraction at some point
            if (root.contentItem)
                root.contentItem.NeptuneStyle.theme = theme === 0 ? NeptuneStyle.Light : NeptuneStyle.Dark;
            else
                root.NeptuneStyle.theme = theme === 0 ? NeptuneStyle.Light : NeptuneStyle.Dark;
        }
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
        height: 390 * d.scaleRatio
        readonly property string sourceSuffix: NeptuneStyle.theme === NeptuneStyle.Dark ? "-dark.png" : ".png"
        source: "img/cluster-fullscreen-overlay" + sourceSuffix
    }

    Gauges {
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

        lowBeamHeadLightOn: dataSource.lowBeamHeadlight
        highBeamHeadLightOn: dataSource.highBeamHeadlight
        fogLightOn: dataSource.fogLight
        stabilityControlOn: dataSource.stabilityControl
        seatBeltFastenOn: dataSource.seatBeltNotFastened
        leftTurnOn: dataSource.leftTurn
    }

    TelltalesRight {
        anchors.right: mainContent.right
        anchors.rightMargin: 111 * d.scaleRatio
        y: 23 * d.scaleRatio
        width: 444 * d.scaleRatio
        height: 58 * d.scaleRatio

        rightTurnOn: dataSource.rightTurn
        absFailureOn: dataSource.ABSFailure;
        parkingBrakeOn: dataSource.parkBrake;
        lowTyrePressureOn: dataSource.tyrePressureLow;
        brakeFailureOn: dataSource.brakeFailure;
        airbagFailureOn: dataSource.airbagFailure;
    }
}
