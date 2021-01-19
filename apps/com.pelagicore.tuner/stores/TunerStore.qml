/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Copyright (C) 2018 Pelagicore AG
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

import QtQuick 2.8
import QtMultimedia 5.9
import QtApplicationManager.Application 2.0
import QtApplicationManager 2.0
import shared.utils 1.0

Store {
    id: root

    property AmFmTuner tunerControl: AmFmTuner {
        currentBand: freqPresets === 0 ? tunerControl.band.AMBand : tunerControl.band.FMBand
    }

    readonly property MediaPlayer player: MediaPlayer {
        source: root.currentStationUrl
    }

    property bool radioPlaying: (player.playbackState === MediaPlayer.PlayingState)

    property int freqPresets: 0 // 0: AM; 1: FM1; 2: FM2;
    readonly property string currentFreqPreset: {
        switch (root.freqPresets) {
        case 0:
            return qsTr("AM")
        case 1:
            return qsTr("FM1")
        case 2:
            return qsTr("FM2")
        default:
            return ""
        }
    }
    property int currentStationIndex
    readonly property string currentStationName: root.getStationName()
    readonly property string currentStationText: root.getStationText()
    readonly property string currentStationLogo: root.getStationLogo()
    readonly property string currentStationFreq: root.getStationFrequency()
    property string currentStationUrl

    readonly property int tunerBand: tunerControl.currentBand
    readonly property real minimumFrequency: tunerBand === tunerControl.band.AMBand ? convertHzToKHz(tunerControl.amMinimumFrequency) :
                                                                    convertHzToMHz(tunerControl.fmMinimumFrequency)
    readonly property real maximumFrequency: tunerBand === tunerControl.band.AMBand ? convertHzToKHz(tunerControl.amMaximumFrequency) :
                                                                    convertHzToMHz(tunerControl.fmMaximumFrequency)
    readonly property real currentFrequency: tunerBand === tunerControl.band.AMBand ? convertHzToKHz(tunerControl.currentFrequency) :
                                                                    convertHzToMHz(tunerControl.currentFrequency)

    readonly property string freqUnit: root.tunerBand === tunerControl.band.AMBand ? qsTr("KHz") : qsTr("MHz")

    property ListModel musicSourcesModel: ListModel {
        id: musicSourcesModel
        ListElement {
            text: qsTr("AM/FM Radio")
            appId: "com.pelagicore.tuner"
        }
        ListElement {
            text: qsTr("Music")
            appId: "com.pelagicore.music"
        }
    }

    property ListModel toolsColumnModel: ListModel {
        id: toolsColumnModel
        ListElement { icon: "ic-favorite-tuner"; text: QT_TRANSLATE_NOOP("TunerToolsColumn", "favorites"); greyedOut: true }
        ListElement { icon: "ic-toolbar-am-band"; text: QT_TRANSLATE_NOOP("TunerToolsColumn", "AM band"); greyedOut: false }
        ListElement { icon: "ic-toolbar-fm-band"; text: QT_TRANSLATE_NOOP("TunerToolsColumn", "FM 1 band"); greyedOut: false }
        ListElement { icon: "ic-toolbar-fm-band"; text: QT_TRANSLATE_NOOP("TunerToolsColumn", "FM 2 band"); greyedOut: false }
        ListElement { icon: "ic-toolbar-sources-tuner"; text: QT_TRANSLATE_NOOP("TunerToolsColumn", "sources"); greyedOut: false }
    }

    property ListModel freqPresetsModel: ListModel {
        ListElement {
            name: "AM"
        }

        ListElement {
            name: "FM 1"
        }

        ListElement {
            name: "FM 2"
        }
    }

    // TODO: Simulation models. QtIVI models are not updated yet and only have two available stations.
    readonly property ListModel fm1Stations: ListModel {
        ListElement {
            freq: 87.5
            stationName: "Jazzophile"
            url: "http://streaming.radionomy.com/Jazzophile?lang=en-US%2cen%3bq%3d0.9%2cid%3bq%3d0.8"
            stationLogo: "https://upstream-i3.radionomy.com/radios/400/06f3a487-fc12-4f7a-a997-c3d4ef967677.jpg"
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
            stationLogo: "http://www.mitrofm.com/site/wp-content/uploads/2016/03/smooth-jazz.jpg"
            stationText: "24 Jazz "
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
            stationLogo: "https://static.hotmixradio.fr/wp-content/uploads/HOTMIXRADIO-Hits.png"
            stationText: "Best hits from 80s and 90s"
        }

        ListElement {
            freq: 103.8
            stationName: "Beatles Radio"
            url: "http://www.beatlesradio.com:8000/stream/1/;.m3u"
            stationLogo: "http://static.radio.net/images/broadcasts/ea/a3/1436/c175.png"
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
            stationLogo: "https://store-images.s-microsoft.com/image/apps.1062.13510798882983804.b2b1bdcd-6fef-4240-bd56-837d11282665.7fde7c77-c4b3-442d-b234-78799dadd1bd?w=180&h=180&q=60"
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
            stationLogo: "https://upload.wikimedia.org/wikipedia/commons/3/3d/RTM.png"
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
            stationText: "Best disco hits"
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
            stationText: "Non stop hits"
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
            stationText: "Sports news"
        }
    }

    readonly property ListModel currentPresetModel: {
        if (root.freqPresets === 0) {
            return root.amStations;
        } else if (root.freqPresets === 1) {
            return root.fm1Stations;
        } else {
            return root.fm2Stations;
        }
    }

    readonly property IntentHandler intentHandler: IntentHandler {
        intentIds: "activate-app"
        onRequestReceived: {
            root.requestToRise()
            request.sendReply({ "done": true })
        }
    }

    signal requestToRise()

    function playStation() {
        if (root.radioPlaying) {
            player.pause();
        } else {
            player.play();
        }
    }

    function getStationLogo() {
        if (freqPresets === 0) {
            return root.amStations.get(root.currentStationIndex).stationLogo ?
                   root.amStations.get(root.currentStationIndex).stationLogo : "";
        } else if (freqPresets === 1) {
            return root.fm1Stations.get(root.currentStationIndex).stationLogo ?
                   root.fm1Stations.get(root.currentStationIndex).stationLogo : "";
        } else if (freqPresets === 2) {
            return root.fm2Stations.get(root.currentStationIndex).stationLogo ?
                   root.fm2Stations.get(root.currentStationIndex).stationLogo : "";
        }
    }

    function getStationName() {
        if (freqPresets === 0) {
            return root.amStations.get(root.currentStationIndex).stationName;
        } else if (freqPresets === 1) {
            return root.fm1Stations.get(root.currentStationIndex).stationName;
        } else if (freqPresets === 2) {
            return root.fm2Stations.get(root.currentStationIndex).stationName;
        }
    }

    function getStationText() {
        if (freqPresets === 0) {
            return root.amStations.get(root.currentStationIndex).stationText ?
                   root.amStations.get(root.currentStationIndex).stationText : "";
        } else if (freqPresets === 1) {
            return root.fm1Stations.get(root.currentStationIndex).stationText ?
                   root.fm1Stations.get(root.currentStationIndex).stationText : "";
        } else if (freqPresets === 2) {
            return root.fm2Stations.get(root.currentStationIndex).stationText ?
                   root.fm2Stations.get(root.currentStationIndex).stationText : "";
        }
    }

    function getStationFrequency() {
        if (freqPresets === 0) {
            return root.amStations.get(root.currentStationIndex).freq;
        } else if (freqPresets === 1) {
            return root.fm1Stations.get(root.currentStationIndex).freq;
        } else if (freqPresets === 2) {
            return root.fm2Stations.get(root.currentStationIndex).freq;
        }
    }

    function stepBackward() {
        tunerControl.stepBackward()
    }

    function stepForward() {
        tunerControl.stepUp()
    }

    function scanBack() {
        var randNumber = Math.floor((Math.random() * 50))
        var parameter = 0.1
        if (root.tunerBand === tunerControl.band.AMBand) {
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
        if (root.tunerBand === tunerControl.band.AMBand) {
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
                setFrequency(root.amStations.get(root.currentStationIndex).freq);
            } else {
                root.currentStationIndex = root.amStations.count - 1;
                setFrequency(root.amStations.get(root.amStations.count - 1).freq);
            }
        } else if (freqPresets === 1) {
            if (root.currentStationIndex - 1 >= 0) {
                root.currentStationIndex = root.currentStationIndex - 1;
                setFrequency(root.fm1Stations.get(root.currentStationIndex).freq);
            } else {
                root.currentStationIndex = root.fm1Stations.count - 1;
                setFrequency(root.fm1Stations.get(root.fm1Stations.count - 1).freq);
            }
        } else if (freqPresets === 2) {
            if (root.currentStationIndex - 1 >= 0) {
                root.currentStationIndex = root.currentStationIndex - 1;
                setFrequency(root.fm2Stations.get(root.currentStationIndex).freq);
            } else {
                root.currentStationIndex = root.fm2Stations.count - 1;
                setFrequency(root.fm2Stations.get(root.fm2Stations.count - 1).freq);
            }
        }
    }

    function nextStation() {
        if (freqPresets === 0) {
            if (root.currentStationIndex + 1 < root.amStations.count) {
                root.currentStationIndex = root.currentStationIndex + 1;
                setFrequency(root.amStations.get(root.currentStationIndex).freq);
            } else {
                root.currentStationIndex = 0;
                setFrequency(root.amStations.get(0).freq);
            }
        } else if (freqPresets === 1) {
            if (root.currentStationIndex + 1 < root.fm1Stations.count) {
                root.currentStationIndex = root.currentStationIndex + 1;
                setFrequency(root.fm1Stations.get(root.currentStationIndex).freq);
            } else {
                root.currentStationIndex = 0;
                setFrequency(root.fm1Stations.get(0).freq);
            }
        } else if (freqPresets === 2) {
            if (root.currentStationIndex + 1 < root.fm2Stations.count) {
                root.currentStationIndex = root.currentStationIndex + 1;
                setFrequency(root.fm2Stations.get(root.currentStationIndex).freq);
            } else {
                root.currentStationIndex = 0;
                setFrequency(root.fm2Stations.get(0).freq);
            }
        }
    }

    function setFrequency(frequency) {
        if (root.tunerBand === tunerControl.band.FMBand) {
            var newFrequency = Math.round(frequency * 10) * 100000 // Round to get a nice number in the MHz interval
            tunerControl.setFrequency(newFrequency);
        } else {
            var newFrequencyAM = Math.round(frequency * 10) * 100 // Round to get a nice number in the KHz interval
            tunerControl.setFrequency(newFrequencyAM);
        }
        var model = root.freqPresets === 1 ? root.fm1Stations : root.freqPresets === 2 ? root.fm2Stations : root.amStations;
        var roundedFreq = (frequency % 1 === 0) ? Math.round(frequency) : frequency;
        for (var i = 0; i < model.count; i++) {
            //compare strings as types might deffer
            if (model.get(i).freq.toString() === roundedFreq.toString()) {
                root.currentStationIndex = i;
                root.currentStationUrl = model.get(i).url;
                root.player.play();
            } else {
                root.currentStationUrl = "";
                root.player.stop();
            }
        }
    }

    function convertHzToKHz(frequency) {
        return frequency * 0.001
    }

    function convertHzToMHz(frequency) {
        return frequency * 0.000001
    }

    function switchSource(source) {
        root.player.pause()
        if (source === "com.pelagicore.music") {
            var request = IntentClient.sendIntentRequest("activate-app", source, {})
            request.onReplyReceived.connect(function() {
                if (request.succeeded) {
                    var result = request.result
                    console.log(Logging.apps, "Intent result: " + result.done)
                } else {
                    console.log(Logging.apps, "Intent request failed: " + request.errorMessage)
                }
            })
        } else if (source === "com.pelagicore.webradio") {
            Qt.openUrlExternally("x-webradio://");
        } else if (source === "com.pelagicore.spotify") {
            Qt.openUrlExternally("x-spotify://");
        }
    }
}
