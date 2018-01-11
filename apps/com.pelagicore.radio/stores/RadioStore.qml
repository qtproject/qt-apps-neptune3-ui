/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Triton IVI UI.
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
import QtIvi 1.0
import QtIvi.Media 1.0
import utils 1.0

Store {
    id: root

    property AmFmTuner tunerControl: AmFmTuner {
        discoveryMode: AmFmTuner.AutoDiscovery
        band: freqPresets === 2 ? AmFmTuner.AMBand : AmFmTuner.FMBand
        onStationChanged: root.currentStation = station
    }

    property int freqPresets: 0 // 0: FM1; 1: FM2; 2: AM;
    readonly property string currentFreqPreset: {
        switch (root.freqPresets) {
        case 0:
            return qsTr("FM1")
        case 1:
            return qsTr("FM2")
        case 2:
            return qsTr("AM")
        default:
            return ""
        }
    }
    property int currentStationIndex

    readonly property int tunerBand: tunerControl.band
    readonly property real minimumFrequency: tunerBand === AmFmTuner.AMBand ? convertHzToKHz(tunerControl.minimumFrequency) :
                                                                    convertHzToMHz(tunerControl.minimumFrequency)
    readonly property real maximumFrequency: tunerBand === AmFmTuner.AMBand ? convertHzToKHz(tunerControl.maximumFrequency) :
                                                                    convertHzToMHz(tunerControl.maximumFrequency)
    readonly property real currentFrequency: tunerBand === AmFmTuner.AMBand ? convertHzToKHz(tunerControl.frequency) :
                                                                    convertHzToMHz(tunerControl.frequency)
    property var currentStation

    readonly property string freqUnit: root.tunerBand === AmFmTuner.AMBand ? qsTr("KHz") : qsTr("MHz")

    property ListModel freqPresetsModel: ListModel {

        ListElement {
            name: "FM 1"
        }

        ListElement {
            name: "FM 2"
        }

        ListElement {
            name: "AM"
        }
    }

    // TODO: Simulation models. Should be using the one from QtIVI.
    readonly property ListModel fm1Stations: ListModel {

        ListElement {
            freq: 87.5
            stationName: "Radio Qt"
        }

        ListElement {
            freq: 90.0
            stationName: "Radio 2"
        }

        ListElement {
            freq: 93.5
            stationName: "Radio 3"
        }

        ListElement {
            freq: 96.8
            stationName: "Radio 4"
        }

        ListElement {
            freq: 98.7
            stationName: "Radio 5"
        }

        ListElement {
            freq: 101.0
            stationName: "Radio 6"
        }

        ListElement {
            freq: 102.5
            stationName: "Radio Qt Rocks non-stop"
        }

        ListElement {
            freq: 103.8
            stationName: "Radio 8"
        }
    }

    readonly property ListModel fm2Stations: ListModel {

        ListElement {
            freq: 89.5
            stationName: "Radio 1"
        }

        ListElement {
            freq: 95.0
            stationName: "Radio 2"
        }

        ListElement {
            freq: 98.5
            stationName: "Radio 3"
        }

        ListElement {
            freq: 99.9
            stationName: "Radio 4"
        }

        ListElement {
            freq: 103.0
            stationName: "Radio 5"
        }

        ListElement {
            freq: 100.7
            stationName: "Radio 6"
        }

        ListElement {
            freq: 103.8
            stationName: "Radio 7"
        }

        ListElement {
            freq: 104.2
            stationName: "Radio 8"
        }
    }

    readonly property ListModel amStations: ListModel {

        ListElement {
            freq: 540
            stationName: "Radio 1"
        }

        ListElement {
            freq: 690
            stationName: "Radio 2"
        }

        ListElement {
            freq: 900
            stationName: "Radio 3"
        }

        ListElement {
            freq: 1001
            stationName: "Radio 4"
        }

        ListElement {
            freq: 1010
            stationName: "Radio 5"
        }

        ListElement {
            freq: 1200
            stationName: "Radio 6"
        }

        ListElement {
            freq: 1550
            stationName: "Radio 7"
        }

        ListElement {
            freq: 1690
            stationName: "Radio 8"
        }
    }

    function stepBack() {
        tunerControl.stepDown()
    }

    function stepForward() {
        tunerControl.stepUp()
    }

    function scanBack() {
        if (freqPresets === 0) {
            if (root.currentStationIndex - 1 >= 0) {
                setFrequency(root.fm1Stations.get(root.currentStationIndex + 1).freq);
                root.currentStationIndex = root.currentStationIndex - 1;
            } else {
                setFrequency(root.fm1Stations.get(7).freq);
                root.currentStationIndex = 7;
            }
        } else if (freqPresets === 1) {
            if (root.currentStationIndex - 1 >= 0) {
                setFrequency(root.fm2Stations.get(root.currentStationIndex + 1).freq);
                root.currentStationIndex = root.currentStationIndex - 1;
            } else {
                setFrequency(root.fm2Stations.get(7).freq);
                root.currentStationIndex = 7;
            }
        } else if (freqPresets === 2) {
            if (root.currentStationIndex - 1 >= 0) {
                setFrequency(root.amStations.get(root.currentStationIndex + 1).freq);
                root.currentStationIndex = root.currentStationIndex - 1;
            } else {
                setFrequency(root.amStations.get(7).freq);
                root.currentStationIndex = 7;
            }
        }
    }

    function scanForward() {
        if (freqPresets === 0) {
            if (root.currentStationIndex + 1 < 8) {
                setFrequency(root.fm1Stations.get(root.currentStationIndex + 1).freq);
                root.currentStationIndex = root.currentStationIndex + 1;
            } else {
                setFrequency(root.fm1Stations.get(0).freq);
                root.currentStationIndex = 0;
            }
        } else if (freqPresets === 1) {
            if (root.currentStationIndex + 1 < 8) {
                setFrequency(root.fm2Stations.get(root.currentStationIndex + 1).freq);
                root.currentStationIndex = root.currentStationIndex + 1;
            } else {
                setFrequency(root.fm2Stations.get(0).freq);
                root.currentStationIndex = 0;
            }
        } else if (freqPresets === 2) {
            if (root.currentStationIndex + 1 < 8) {
                setFrequency(root.amStations.get(root.currentStationIndex + 1).freq);
                root.currentStationIndex = root.currentStationIndex + 1;
            } else {
                setFrequency(root.amStations.get(0).freq);
                root.currentStationIndex = 0;
            }
        }
    }

    function setFrequency(frequency) {
        if (root.tunerBand === AmFmTuner.FMBand) {
            var newFrequency = Math.round(frequency * 10) * 100000 // Round to get a nice number in the MHz interval
            tunerControl.setFrequency(newFrequency);
        } else {
            var newFrequencyAM = Math.round(frequency * 10) * 100 // Round to get a nice number in the KHz interval
            tunerControl.setFrequency(newFrequencyAM);
        }
    }

    function convertHzToKHz(frequency) {
        return frequency * 0.001
    }

    function convertHzToMHz(frequency) {
        return frequency * 0.000001
    }
}
