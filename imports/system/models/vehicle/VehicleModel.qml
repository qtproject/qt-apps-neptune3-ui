/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
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

pragma Singleton
import QtQuick 2.0
import utils 1.0
import QtApplicationManager 1.0

QtObject {
    id: root

    property bool dialAnimation: true
    property real speed: navigationControl.navigationRunning ? navigationControl.navigationSpeed : 0
    property string rightDialBorderColor: navigationControl.dialBorderColor
    property bool warningDialAnimation: navigationControl.activateWarning

    readonly property real rightDialValue: root.speed * 0.0031

    property int displaySpeed: speed
    property real fuel: 0.5 // fuel precentage min 0.0; max 1.0;
    property string rightDialIcon: navigationControl.rightDialIcon
    property string rightDialMainText: navigationControl.mainText
    property string rightDialSubText: navigationControl.subText
    property real rightIconScale: 2

    property Timer timer: Timer {
        running: root.dialAnimation
        repeat: true
        interval: 4000
        property bool higherValue: false
        onTriggered: {
            root.speed = higherValue ? (navigationControl.navigationSpeed) : (navigationControl.navigationSpeed +5)

            higherValue = !higherValue
        }
    }

    // For simulations we need to communicate with nav app
    property QtObject navigationControl: ApplicationIPCInterface {

        property real navigationSpeed: 0
        property bool navigationRunning: false
        property bool activateWarning: false
        property string dialBorderColor: Style.colorWhite
        property string rightDialIcon: Style.gfx("cluster/my_position")
        property string mainText: "0.6mi"
        property string subText: "Service in 300km"

        Component.onCompleted: {
            ApplicationIPCManager.registerInterface(navigationControl, "com.pelagicore.navigation.control", {})
        }
    }

    Behavior on speed {
        SmoothedAnimation {
            velocity: 8
            duration : 4000
            easing.overshoot: 0
        }
    }

}
