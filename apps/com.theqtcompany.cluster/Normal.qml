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

import QtQuick 2.9

Item {
    id: root
    width: 1920
    height: 720

    //public functions
    function state2begin() {
        if (state === "stopped") {
            ds.state2begin();
            dp.state2begin();
            state = "normal"
        }
    }
    function state2Navigation() {
        if (state === "normal") {
            ds.state2Navigation();
            dp.state2Navigation();
            state = "navi"
        }
    }
    function state2Normal() {
        if (state === "navi") {
            ds.state2Normal();
            dp.state2Normal();
            state = "normal"
        }
    }
    function state2end() {
        if (state === "normal" || state === "navi"){
            ds.state2end();
            dp.state2end();
            state = "stopped"
        }
    }

    //public
    property alias speed: ds.speed
    property alias speedLimit: ds.speedLimit
    property alias cruiseSpeed: ds.cruiseSpeed
    property alias drivetrain:dp.drivetrain
    property alias ePower: dp.ePower

    //private
    Item {
        id: d
        property real scaleRatio: Math.min(parent.width / 1920, parent.height / 720)
    }

    //states and transitions
    state: "stopped"
    states: [
        State {
            name: "stopped"
            PropertyChanges { target: ds; x: 680; y: 120 }
            PropertyChanges { target: dp; x: 680; y: 120 }
        },
        State {
            name: "normal"
            PropertyChanges { target: ds; x: 10; y: 120 }
            PropertyChanges { target: dp; x: 1350; y: 120 }
        },
        State {
            name: "navi"
            PropertyChanges { target: ds; x: 10; y: 180 }
            PropertyChanges { target: dp; x: 1350; y: 180 }
        }
    ]

    transitions: [
        Transition {
            from: "stopped"
            to: "normal"
            reversible: true
            SequentialAnimation {
                //wait DialFrame to expand
                PauseAnimation { duration: 470 }
                PropertyAnimation { targets: [ds, dp]; properties: "x, y"; duration: 500 }
            }
        },
        Transition {
            from: "normal"
            to: "navi"
            reversible: true
            SequentialAnimation {
                //wait ds/dp to shrinp
                PauseAnimation { duration: 1000 }
                PropertyAnimation { targets: [ds, dp]; properties: "x, y"; duration: 500 }
                //wait ds/dp to shrinp
                PauseAnimation { duration: 1000 }
            }
        },
        Transition {
            from: "navi"
            to: "stopped"
            reversible: false
            SequentialAnimation {
                //wait ds/dp to finish transition
                PauseAnimation { duration: 270 }
                PropertyAnimation { targets: [ds, dp]; properties: "y"; duration: 500 }
                PropertyAnimation { targets: [ds, dp]; properties: "x"; duration: 500 }
            }
        }
    ]

    //visual components
    Image {
        width: 1920 * d.scaleRatio
        height: 720 * d.scaleRatio
        source: "./img/bg.png"
    }

    DialSpeed {
        id: ds
        x: 10 * d.scaleRatio
        y: 120* d.scaleRatio
        width: 560 * d.scaleRatio
        height: width
    }

    DialPower {
        id: dp
        x: 1350 * d.scaleRatio
        y: 120 * d.scaleRatio
        width: 560 * d.scaleRatio
        height: width
    }

//TODOs:talk to Johan to decide whether should use the telltale background pic
//    Image {
//        id: bg
//        width: 1920 * scaleRatio
//        height: 293 * scaleRatio
//        source: "./img/telltale-bg.png"
//    }



//TEST CODE
//MouseArea simulate state changing
//Animation simulate value changing
    MouseArea {
        id: needChange
        anchors.fill: parent
        property int beats: 0
        onClicked: {
            switch (beats) {
            case 0:
                state2begin();
                break;
            case 1:
                state2end();
                break;
            case 2:
                state2begin();
                break;
            case 3:
                state2Navigation();
                break;
            case 4:
                state2Normal();
                break;
            case 5:
                state2Navigation();
                break;
            case 6:
                state2end();
                beats = 0;
                return;
            default:
                beats = 0;
                return;
            }
            beats++;
        }
    }
//    SequentialAnimation {
//        running: true
//        loops: Animation.Infinite
//        ParallelAnimation{
//            PropertyAnimation {target: ds; properties: "speed, speedLimit, cruiseSpeed"; to: 260; duration: 2000 }
//            PropertyAnimation {target: dp; property: "ePower"; to: 100; duration: 1000 }
//        }
//        PauseAnimation { duration: 1000 }
//        ParallelAnimation{
//            PropertyAnimation {target: ds; properties: "speed, speedLimit, cruiseSpeed"; to: 0; duration: 2000 }
//            PropertyAnimation {target: dp; property: "ePower"; to: -25; duration: 1000 }
//        }
//        PauseAnimation { duration: 1000 }
//    }
}
