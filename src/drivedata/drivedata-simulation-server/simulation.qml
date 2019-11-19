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

import QtQuick 2.0
import shared.com.pelagicore.drivedata.simulation 1.0

Item {
    InstrumentClusterBackend {
        id: backend
        property var settings : IviSimulator.findData(IviSimulator.simulationData, "InstrumentCluster")

        function initialize() {
            IviSimulator.initializeDefault(settings, backend)
            Base.initialize()
        }

        property int currentSimulationSet: 1

        property Timer driveTrainTimer: Timer {
            interval: 5000
            onTriggered: {
                if (backend.driveTrainState === 0) {
                    backend.driveTrainState = 1
                } else if (backend.driveTrainState === 1) {
                    backend.driveTrainState = 2
                    backend.speedCruise = 50
                    speedTimer.start()
                }
            }
            running: backend.driveTrainState !== 2
        }

        property Timer simulationSetTimer: Timer {
            interval: 12000
            onTriggered: {
                if (backend.currentSimulationSet === 1) {
                    backend.currentSimulationSet = 2
                    backend.speedLimit = 50
                    backend.speedCruise = 55
                } else if (backend.currentSimulationSet === 2) {
                    backend.currentSimulationSet = 3
                    backend.speedLimit = 80
                    backend.speedCruise = 75
                } else if (backend.currentSimulationSet === 3) {
                    backend.currentSimulationSet = 1
                    backend.speedLimit = 120
                    backend.speedCruise = 122
                }
            }
            repeat: true
            running: backend.driveTrainState === 2
        }

        property Timer speedTimer: Timer {
            id: speedTimer
            interval: 200
            onTriggered: {
                if (backend.speed < backend.speedCruise) {
                    backend.speed = backend.speed + 1;
                } else if (backend.speed > backend.speedCruise) {
                    backend.speed = backend.speed - 1;
                }
            }
            repeat: true
        }

        property Timer powerTimer: Timer {
            interval: 5000
            onTriggered: {
                if (backend.ePower === 0) {
                    backend.ePower = 100;
                } else {
                    backend.ePower = backend.ePower - 5;
                }
            }
            repeat: true
            running: backend.driveTrainState === 2
        }

        /*
          One shot timer to have values initialized
        */
        property Timer initTimer: Timer {
            interval: 2000
            onTriggered: {
                backend.lowBeamHeadlight = true;
                backend.outsideTemperatureCelsius = 20.0;
                backend.mileageKm = 8124;
                backend.drivingModeRangeKm = 600;
                backend.drivingModeECORangeKm = 720;
                backend.navigationProgressPercents = 0.7;
                backend.navigationRouteDistanceKm = 42;
            }
            repeat: false
            running: true
        }

        /*
          Telltales simulation
            - left/right turn, lights are controlled manually
        */
        property Timer telltalesTimer: Timer {
            interval: 3000
            onTriggered: {
                backend.stabilityControl = getNewTelltaleState();
                backend.seatBeltNotFastened = getNewTelltaleState();
                backend.ABSFailure = getNewTelltaleState();
                backend.parkBrake = getNewTelltaleState();
                backend.tyrePressureLow = getNewTelltaleState();
                backend.brakeFailure = getNewTelltaleState();
                backend.airbagFailure = getNewTelltaleState();
            }
            repeat: true
            running: true
            function getNewTelltaleState() {
                return Math.round(Math.random());
            }
        }

        /*
          Lucee elements timer
        */
        property Timer luceeTimer: Timer {
            interval: 2000
            onTriggered: {
                backend.mileageKm = backend.mileageKm + 0.2;

                backend.drivingModeRangeKm = backend.drivingModeRangeKm - 0.2;
                backend.drivingModeECORangeKm = backend.drivingModeRangeKm - 0.2;
                if (backend.drivingModeRangeKm < 20) {
                    backend.drivingModeRangeKm = 1000;
                    backend.drivingModeECORangeKm = 1200;
                }

                backend.navigationProgressPercents = backend.navigationProgressPercents + 0.01
                if (backend.navigationProgressPercents > 1.0) {
                    backend.navigationProgressPercents = 0.0;
                }
            }
            repeat: true
            running: true
        }
    }
}
