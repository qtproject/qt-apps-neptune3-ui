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
import QtMultimedia 5.9
import utils 1.0

Store {
    id: root

    property AmFmTuner tunerControl: AmFmTuner {
        discoveryMode: AmFmTuner.AutoDiscovery
        band: freqPresets === 2 ? AmFmTuner.AMBand : AmFmTuner.FMBand
        onStationChanged: root.currentStation = station
    }

    readonly property MediaPlayer player: MediaPlayer {
        source: root.currentStationUrl
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
    property var currentStation: null
    readonly property string currentStationName: root.getStationName()
    property string currentStationUrl

    readonly property int tunerBand: tunerControl.band
    readonly property real minimumFrequency: tunerBand === AmFmTuner.AMBand ? convertHzToKHz(tunerControl.minimumFrequency) :
                                                                    convertHzToMHz(tunerControl.minimumFrequency)
    readonly property real maximumFrequency: tunerBand === AmFmTuner.AMBand ? convertHzToKHz(tunerControl.maximumFrequency) :
                                                                    convertHzToMHz(tunerControl.maximumFrequency)
    readonly property real currentFrequency: tunerBand === AmFmTuner.AMBand ? convertHzToKHz(tunerControl.frequency) :
                                                                    convertHzToMHz(tunerControl.frequency)

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

    // TODO: Simulation models. QtIVI models are not updated yet and only have two available stations.
    readonly property ListModel fm1Stations: ListModel {
        ListElement {
            freq: 87.5
            stationName: "Jazzophile"
            url: "http://streaming.radionomy.com/Jazzophile?lang=en-US%2cen%3bq%3d0.9%2cid%3bq%3d0.8"
        }

        ListElement {
            freq: 99.4
            stationName: "Sunshine FM"
            url: "http://stream.composeit.hu:8100/;.m3u"
        }

        ListElement {
            freq: 101.0
            stationName: "Smooth Jazz"
            url: "http://streaming.radionomy.com/101SMOOTHJAZZ?lang=en-US%2cen%3bq%3d0.9%2cid%3bq%3d0.8"
        }

        ListElement {
            freq: 101.7
            stationName: "Alpha FM"
            url: "http://streaming.shoutcast.com/AlphaFM101-7?lang=en-US%2cen%3bq%3d0.9%2cid%3bq%3d0.8"
        }

        ListElement {
            freq: 98.7
            stationName: "Lex and Terry"
            url: "http://streaming.shoutcast.com/lexandterry?lang=en-US%2cen%3bq%3d0.9%2cid%3bq%3d0.8"
        }

        ListElement {
            freq: 91.5
            stationName: "Rok Radio"
            url: "http://s1.viastreaming.net:9155/;.m3u"
        }

        ListElement {
            freq: 93.5
            stationName: "Hotmix Radio"
            url: "http://streaming.hotmixradio.fr/hotmixradio-80-128.mp3?lang=en-US%2cen%3bq%3d0.9%2cid%3bq%3d0.8"
        }

        ListElement {
            freq: 103.8
            stationName: "Beatles Radio"
            url: "http://www.beatlesradio.com:8000/stream/1/;.m3u"
        }
    }

    readonly property ListModel fm2Stations: ListModel {

        ListElement {
            freq: 89.5
            stationName: "Calm Radio"
            url: "http://184.173.142.117:30228/stream"
        }

        ListElement {
            freq: 95.0
            stationName: "ABC Lounge"
            url: "http://streaming.radionomy.com/ABC-Lounge?lang=en-US%2cen%3bq%3d0.9%2cid%3bq%3d0.8"
        }

        ListElement {
            freq: 98.5
            stationName: "Radio Mozart"
            url: "http://streaming.radionomy.com/Radio-Mozart?lang=en-US%2cen%3bq%3d0.9%2cid%3bq%3d0.8"
        }

        ListElement {
            freq: 99.9
            stationName: "Absolute Chillout"
            url: "http://streaming.radionomy.com/ABSOLUTECHILLOUT?lang=en-US%2cen%3bq%3d0.9%2cid%3bq%3d0.8"
        }

        ListElement {
            freq: 103.0
            stationName: "FD LOUNGE RADIO"
            url: "http://streaming.radionomy.com/FD-LOUNGE-RADIO?lang=en-US%2cen%3bq%3d0.9%2cid%3bq%3d0.8"
        }

        ListElement {
            freq: 100.7
            stationName: "Radio RTM"
            url: "http://streaming.radionomy.com/RadioRTM?lang=en-US%2cen%3bq%3d0.9%2cid%3bq%3d0.8"
        }

        ListElement {
            freq: 103.8
            stationName: "One Radio"
            url: "http://107.161.180.90:9984/stream/;.m3u"
        }

        ListElement {
            freq: 104.2
            stationName: "Discofox FM"
            url: "http://87.118.78.71:12000/;.m3u"
        }
    }

    readonly property ListModel amStations: ListModel {

        ListElement {
            freq: 540
            stationName: "Radio 1"
            url: ""
        }

        ListElement {
            freq: 690
            stationName: "Radio 2"
            url: ""
        }

        ListElement {
            freq: 900
            stationName: "Radio 3"
            url: ""
        }

        ListElement {
            freq: 1001
            stationName: "Radio 4"
            url: ""
        }

        ListElement {
            freq: 1010
            stationName: "Radio 5"
            url: ""
        }

        ListElement {
            freq: 1200
            stationName: "Radio 6"
            url: ""
        }

        ListElement {
            freq: 1550
            stationName: "Radio 7"
            url: ""
        }

        ListElement {
            freq: 1690
            stationName: "Radio 8"
            url: ""
        }
    }

    readonly property ListModel currentPresetModel: {
        if (root.freqPresets === 0) {
            return root.fm1Stations;
        } else if (root.freqPresets === 1) {
            return root.fm2Stations;
        } else {
            return root.amStations;
        }
    }

    function getStationName() {
        if (freqPresets === 0) {
            return root.fm1Stations.get(root.currentStationIndex).stationName
        } else if (freqPresets === 1) {
            return root.fm2Stations.get(root.currentStationIndex).stationName
        } else if (freqPresets === 2) {
            return root.amStations.get(root.currentStationIndex).stationName
        }
    }

    function stepBack() {
        tunerControl.stepDown()
    }

    function stepForward() {
        tunerControl.stepUp()
    }

    function scanBack() {
        var randNumber = Math.floor((Math.random() * 50))
        var parameter = 0.1
        if (root.tunerBand === AmFmTuner.AMBand) {
            parameter = 10
        }

        for (var x = 0; x < randNumber; ++x) {
            if (root.currentFrequency - parameter > root.minimumFrequency) {
                root.setFrequency(root.currentFrequency - parameter)
            } else {
                root.setFrequency(root.maximumFrequency)
            }
        }
    }

    function scanForward() {
        var randNumber = Math.floor((Math.random() * 50))
        var parameter = 0.1
        if (root.tunerBand === AmFmTuner.AMBand) {
            parameter = 10
        }

        for (var x = 0; x < randNumber; ++x) {
            if (root.currentFrequency + parameter < root.maximumFrequency) {
                root.setFrequency(root.currentFrequency + parameter)
            } else {
                root.setFrequency(root.minimumFrequency)
            }
        }
    }

    function prevStation() {
        if (freqPresets === 0) {
            if (root.currentStationIndex - 1 >= 0) {
                root.currentStationIndex = root.currentStationIndex - 1;
                setFrequency(root.fm1Stations.get(root.currentStationIndex + 1).freq);
            } else {
                root.currentStationIndex = root.fm1Stations.count - 1;
                setFrequency(root.fm1Stations.get(root.fm1Stations.count - 1).freq);
            }
        } else if (freqPresets === 1) {
            if (root.currentStationIndex - 1 >= 0) {
                root.currentStationIndex = root.currentStationIndex - 1;
                setFrequency(root.fm2Stations.get(root.currentStationIndex + 1).freq);
            } else {
                root.currentStationIndex = root.fm2Stations.count - 1;
                setFrequency(root.fm2Stations.get(root.fm2Stations.count - 1).freq);
            }
        } else if (freqPresets === 2) {
            if (root.currentStationIndex - 1 >= 0) {
                root.currentStationIndex = root.currentStationIndex - 1;
                setFrequency(root.amStations.get(root.currentStationIndex + 1).freq);
            } else {
                root.currentStationIndex = root.amStations.count - 1;
                setFrequency(root.amStations.get(root.amStations.count - 1).freq);
            }
        }
    }

    function nextStation() {
        if (freqPresets === 0) {
            if (root.currentStationIndex + 1 < root.fm1Stations.count) {
                root.currentStationIndex = root.currentStationIndex + 1;
                setFrequency(root.fm1Stations.get(root.currentStationIndex + 1).freq);
            } else {
                root.currentStationIndex = 0;
                setFrequency(root.fm1Stations.get(0).freq);
            }
        } else if (freqPresets === 1) {
            if (root.currentStationIndex + 1 < root.fm2Stations.count) {
                root.currentStationIndex = root.currentStationIndex + 1;
                setFrequency(root.fm2Stations.get(root.currentStationIndex + 1).freq);
            } else {
                root.currentStationIndex = 0;
                setFrequency(root.fm2Stations.get(0).freq);
            }
        } else if (freqPresets === 2) {
            if (root.currentStationIndex + 1 < root.amStations.count) {
                root.currentStationIndex = root.currentStationIndex + 1;
                setFrequency(root.amStations.get(root.currentStationIndex + 1).freq);
            } else {
                root.currentStationIndex = 0;
                setFrequency(root.amStations.get(0).freq);
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

        if (root.freqPresets === 0 && root.fm1Stations.get(root.currentStationIndex).url !== "") {
            root.currentStationUrl = root.fm1Stations.get(root.currentStationIndex).url;
            root.player.play();
        } else if (root.freqPresets === 1 && root.fm2Stations.get(root.currentStationIndex).url !== "") {
            root.currentStationUrl = root.fm2Stations.get(root.currentStationIndex).url;
            root.player.play();
        } else if (root.freqPresets === 2 && root.amStations.get(root.currentStationIndex).url !== "") {
            root.currentStationUrl = root.amStations.get(root.currentStationIndex).url;
            root.player.play();
        } else {
            root.currentStationUrl = ""
            root.player.stop();
        }
    }

    function convertHzToKHz(frequency) {
        return frequency * 0.001
    }

    function convertHzToMHz(frequency) {
        return frequency * 0.000001
    }
}
