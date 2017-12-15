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
            PropertyChanges { target: ds; x: 310 * d.scaleRatio; y: 120 * d.scaleRatio }
            PropertyChanges { target: dp; x: 1050 * d.scaleRatio; y: 120 * d.scaleRatio }
        },
        State {
            name: "normal"
            PropertyChanges { target: ds; x: 10 * d.scaleRatio; y: 120 * d.scaleRatio }
            PropertyChanges { target: dp; x: 1350 * d.scaleRatio; y: 120 * d.scaleRatio }
        },
        State {
            name: "navi"
            PropertyChanges { target: ds; x: 10 * d.scaleRatio; y: 180 * d.scaleRatio }
            PropertyChanges { target: dp; x: 1350 * d.scaleRatio; y: 180 * d.scaleRatio }
        }
    ]

    transitions: [
        Transition {
            from: "stopped"
            to: "normal"
            reversible: true
            SequentialAnimation {
                //wait DialFrame to fade in
                PauseAnimation { duration: 900 }
                PropertyAnimation { targets: [ds, dp]; properties: "x, y"; duration: 200 }
            }
        },
        Transition {
            from: "normal"
            to: "navi"
            reversible: true
            SequentialAnimation {
                //wait ds/dp to shrink
                PauseAnimation { duration: 1000 }
                PropertyAnimation { targets: [ds, dp]; properties: "x, y"; duration: 200 }
            }
        },
        Transition {
            from: "navi"
            to: "stopped"
            reversible: false
            SequentialAnimation {
                //wait ds/dp to finish transition
                PauseAnimation { duration: 70 }
                PropertyAnimation { targets: [ds, dp]; properties: "y"; duration: 200 }
                PropertyAnimation { targets: [ds, dp]; properties: "x"; duration: 200 }
            }
        }
    ]

    //visual components
    DialSpeed {
        id: ds
        x: 10 * d.scaleRatio
        y: 120* d.scaleRatio
        width: 560 * d.scaleRatio
        height: width
        state: parent.state
    }

    DialPower {
        id: dp
        x: 1350 * d.scaleRatio
        y: 120 * d.scaleRatio
        width: 560 * d.scaleRatio
        height: width
        state: parent.state
    }

//TEST CODE
//MouseArea simulate state changing
//Animation simulate value changing
    Component.onCompleted: {
        state = "normal"
        needChange.beats = 1;
    }

    MouseArea {
        id: needChange
        anchors.fill: parent
        property int beats: 0
        onClicked: {
            switch (beats) {
            case 0:
                parent.state = "normal"
                break;
            case 1:
                parent.state = "stopped"
                break;
            case 2:
                parent.state = "normal"
                break;
            case 3:
                parent.state = "navi"
                break;
            case 4:
                parent.state = "normal"
                break;
            case 5:
                parent.state = "navi"
                break;
            case 6:
                parent.state = "stopped"
                beats = 0;
                return;
            default:
                beats = 0;
                return;
            }
            beats++;
        }
    }

    Timer {
        property bool max: false
        repeat: true
        running: true
        interval: 5000
        onTriggered: {
            if (max) {
                max = false;
                ds.speed = 260
                ds.speedLimit = 260
                ds.cruiseSpeed = 260
                dp.ePower = 100
            } else {
                max = true;
                ds.speed = 0;
                ds.speedLimit = 0;
                ds.cruiseSpeed = 0;
                dp.ePower = -25;
            }
        }
    }
}
