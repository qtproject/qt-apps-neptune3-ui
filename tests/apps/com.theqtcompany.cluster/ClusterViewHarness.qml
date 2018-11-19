/****************************************************************************
**
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
import shared.utils 1.0

import shared.BasicStyle 1.0

import views 1.0
import stores 1.0

Item {
    id: root
    width: 1920
    height: 720

    Image {
        anchors.fill: parent
        source: Style.gfx("instrument-cluster-bg", root.BasicStyle.theme)
        fillMode: Image.Stretch
    }

    ClusterView {
        anchors.fill: parent
        rtlMode: root.LayoutMirroring.enabled
        store: ClusterStoreInterface {
            id: dummystore
            navigationMode: false
            speed: 0.0
            speedLimit: 120
            speedCruise: 40.0
            driveTrainState: 2
            ePower: 50

            lowBeamHeadlight: true
            highBeamHeadlight: true
            fogLight: true
            stabilityControl: true
            seatBeltFasten: true
            leftTurn: true

            rightTurn: true
            absFailure: true
            parkBrake: true
            tyrePressureLow: true
            brakeFailure: true
            airbagFailure: true
        }

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: {
                if (dummystore.speed < 140) {
                    dummystore.speed = dummystore.speed + 10;
                } else {
                    dummystore.speed = 0.0;
                }

                if (dummystore.ePower < 80) {
                    dummystore.ePower = dummystore.ePower + 2;
                } else {
                    dummystore.ePower = 0.0;
                }

                if (dummystore.speedLimit < 100) {
                    dummystore.speedLimit = dummystore.speedLimit + 10;
                } else {
                    dummystore.speedLimit = 0;
                }

                if (dummystore.speedCruise < 100) {
                    dummystore.speedCruise = dummystore.speedCruise + 10;
                } else {
                    dummystore.speedCruise = 0;
                }
            }
        }
    }

    Component.onCompleted: {
        root.BasicStyle.theme = BasicStyle.Dark
    }
}
