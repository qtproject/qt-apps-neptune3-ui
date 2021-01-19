/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Copyright (C) 2018 Pelagicore AG
** Copyright (C) 2017 The Qt Company Ltd.
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
import shared.utils 1.0

Item {
    id: root

    width: Sizes.dp(Config.instrumentClusterWidth)
    height: width / Config.instrumentClusterUIAspectRatio

    //public
    property bool navigating
    property alias speed: ds.speed
    property alias speedLimit: ds.speedLimit
    property alias cruiseSpeed: ds.cruiseSpeed
    property alias drivetrain:dp.drivetrain
    property alias ePower: dp.ePower
    property int clusterUIMode // unused here

    property bool rtlMode
    onRtlModeChanged: d.restart()

    //private
    QtObject {
        id: d
        property bool running: false
        function start() { running = true; }
        function restart() { running = false; startDelay.interval = 900; startDelay.start(); }
    }

    Component.onCompleted: startDelay.start();
    Timer {
        id: startDelay
        interval: 100
        onTriggered: d.start()
    }

    //states and transitions
    state: "stopped"
    states: [
        State {
            name: "stopped"
            when: !d.running
            PropertyChanges { target: !root.rtlMode ? ds : dp; x: Sizes.dp(310); y: Sizes.dp(120) }
            PropertyChanges { target: !root.rtlMode ? dp : ds; x: Sizes.dp(1050); y: Sizes.dp(120) }
        },
        State {
            name: "normal"
            when: d.running && !root.navigating
            PropertyChanges { target: !root.rtlMode ? ds : dp; x: Sizes.dp(10); y: Sizes.dp(120) }
            PropertyChanges { target: !root.rtlMode ? dp : ds; x: Sizes.dp(1350); y: Sizes.dp(120) }
        },
        State {
            name: "navi"
            when: d.running && root.navigating
            PropertyChanges { target: !root.rtlMode ? ds : dp; x: Sizes.dp(10); y: Sizes.dp(180) }
            PropertyChanges { target: !root.rtlMode ? dp : ds; x: Sizes.dp(1350); y: Sizes.dp(180) }
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
                PauseAnimation { duration: 500 }
                PropertyAnimation { targets: [ds, dp]; properties: "x, y"; duration: 100 }
            }
        },
        Transition {
            from: "navi"
            to: "stopped"
            reversible: false
            SequentialAnimation {
                //wait ds/dp to finish transition
                PauseAnimation { duration: 70 }
                PropertyAnimation { targets: [ds, dp]; properties: "x, y"; duration: 200 }
            }
        }
    ]

    //visual components

    DialSpeedPanel {
        id: ds
        width: Sizes.dp(560)
        height: width
        state: parent.state
    }

    DialPowerPanel {
        id: dp
        width: Sizes.dp(560)
        height: width
        state: parent.state
    }
}
