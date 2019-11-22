/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
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

import QtQuick 2.9
import shared.Sizes 1.0
import QtQuick.Shapes 1.12
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.2

/*
  GaugesPanel
*/

Item {
    id: root

    property alias speed: dspeed.speed
    property alias mileage: dspeed.mileage
    property alias drivetrain: dpower.driveTrainState
    property alias ePower: dpower.ePower
    property alias outsideTemperature: dpower.outsideTemperature
    property alias navigationRouteDistance: dspeed.navigationRouteDistance
    property alias navigationProgressPercents: dspeed.navigationProgressPercents
    property alias mileageUnits: dspeed.mileageUnits
    property alias speedUnits: dspeed.speedUnits
    property alias currentDate: dspeed.currentDate
    property alias twentyFourHourTimeFormat: dspeed.twentyFourHourTimeFormat

    property bool navigating
    property int drivingModeRangeDistance
    property int drivingModeECORangeDistance
    property int drivingMode
    property int clusterUIMode

    /*!
        Defines current state of right-to-left
    */
    property bool rtlMode: false

    width: Sizes.dp(1920)
    height: Sizes.dp(720)

    onRtlModeChanged: d.restart()
    Component.onCompleted: startDelay.start();
    onClusterUIModeChanged: {
        if (root.clusterUIMode === 0) {
            //no app shown
            dspeed.state = "speed_center"
        } else {
            //app (map, music, ...) in cluster -> move speed label right
            dspeed.state = "speed_right"
        }
    }

    //private
    QtObject {
        id: d
        property bool running: false
        function start() { running = true; }
        function restart() { running = false; startDelay.interval = 900; startDelay.start(); }
    }

    Timer {
        id: startDelay
        interval: 100
        onTriggered: d.start()
    }

    /*
        left side overlay half-circles
    */
    LuceeCircles{
        id: leftCircles
        width: root.width / 2
        height: root.height
        isLeft: true
        state: root.state
    }

    /*
        right side overlay half-circles
    */
    LuceeCircles{
        id: rightCircles
        width: root.width / 2
        height: root.height
        isLeft: false
        state: root.state
    }

    /*
        driving mode indicator with range
    */
    DrivingModeRange {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: Sizes.dp(435)
        range: root.drivingModeRangeDistance
        units:  root.mileageUnits
        mode: root.drivingMode
    }

    /*
        ECO alternative driving mode indicator
    */
    DrivingModeRange {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: Sizes.dp(230)
        range: "+" +  root.drivingModeECORangeDistance
        units:  root.mileageUnits
        mode: 1 //eco
    }

    /*
        power panel with gauge on the left
    */
    DialPowerPanel {
        id: dpower
        width: parent.width / 2
        height: parent.height
        state: parent.state
        rtlMode: root.rtlMode
    }

    /*
       speed panel with gauge and speed label on the right
    */
    DialSpeedPanel {
        id: dspeed
        width: parent.width / 2
        height: parent.height
        rtlMode: root.rtlMode
        screenCenter: Qt.point(parent.width / 2 - x, parent.height / 2 - y)
    }

    //states and transitions
    state: "stopped"
    states: [
        State {
            name: "stopped"
            when: !d.running
            PropertyChanges { target: !root.rtlMode ? dpower : dspeed; x: -Sizes.dp(310); y: Sizes.dp(0) }
            PropertyChanges { target: !root.rtlMode ? dspeed : dpower; x: root.width / 2 + Sizes.dp(310); y: Sizes.dp(0) }

            PropertyChanges { target: leftCircles;  x: -root.width / 4; y: Sizes.dp(0) }
            PropertyChanges { target: rightCircles; x: root.width * 0.75 ; y: Sizes.dp(0) }
        },
        State {
            name: "normal"
            when: d.running
            PropertyChanges { target: !root.rtlMode ? dpower : dspeed; x: Sizes.dp(0); y: Sizes.dp(0) }
            PropertyChanges { target: !root.rtlMode ? dspeed : dpower; x: root.width / 2; y: Sizes.dp(0) }

            PropertyChanges { target: leftCircles; x: Sizes.dp(0); y: Sizes.dp(0) }
            PropertyChanges { target: rightCircles; x: root.width/2; y: Sizes.dp(0) }
        }
    ]

    transitions: Transition {
            from: "stopped"
            to: "normal"
            reversible: true
            SequentialAnimation {
                PauseAnimation { duration: 900 }
                PropertyAnimation { targets: [dpower, dspeed]; properties: "x, y"; duration: 200 }
            }
        }
}
