/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 IVI UI.
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
import QtQuick 2.6

QtObject {
    id: root

    property int measurementSystem: Qt.locale().measurementSystem

    property bool settingsPageVisible: false
    property bool clusterVisible: true

    readonly property ListModel profiles: ListModel {
        ListElement { name: QT_TR_NOOP("Driver 1") }
        ListElement { name: QT_TR_NOOP("Driver 2") }
        ListElement { name: QT_TR_NOOP("Driver 3") }
        ListElement { name: QT_TR_NOOP("Driver 4") }
    }
    property int currentProfileIndex: 0

    property bool appUpdatesEnabled: false
    property bool liveTrafficEnabled: false
    property bool satelliteViewEnabled: false

    property int windowTransitionsIndex: 0

    property ListModel entries: ListModel {
        ListElement { title: QT_TR_NOOP("USER PROFILE"); icon: "profile"; checked: true; hasChildren: true; hasCheck: true }
        ListElement { title: QT_TR_NOOP("SERVICE & SUPPORT"); icon: "service"; checked: false; hasChildren: false }
        ListElement { title: QT_TR_NOOP("TRAFFIC INFORMATION"); icon: "warning"; checked: true; hasChildren: true }
        ListElement { title: QT_TR_NOOP("TOLL & CONGESTION FEES"); icon: "toll"; checked: false; hasChildren: true }
        ListElement { title: QT_TR_NOOP("METRIC SYSTEM"); icon: "fees"; checked: true; hasChildren: false }
        ListElement { title: QT_TR_NOOP("APP UPDATES"); icon: "updates"; checked: true; hasChildren: true }
        ListElement { title: QT_TR_NOOP("SYSTEM MONITOR"); icon: "insurance"; checked: false; hasChildren: true }
    }

    property var carSettings: [ // FIXME l10n section ?
        { section: "Units", option: speedOption },
        { section: "Communication", option: bluetoothOption }
    ]

    property var speedOption: QtObject {
        property var options: ['KMH', 'MPH']
        property string name: "Speed" // FIXME l10n name?
        property int active: 0

        function setActive(index) { active = index }
    }

    property var bluetoothOption: QtObject {

        property string name: "Bluetooth" // FIXME l10n name?
        property bool active: false

        function setActive(value) { active = value }
    }

    property ListModel functions: ListModel {
        ListElement {
            description: QT_TR_NOOP("Hill Descent Control")
            icon: "hill_descent_control"
            active: true
        }
        ListElement {
            description: QT_TR_NOOP("Intelligent Speed Adaptation")
            icon: "intelligent_speed_adaptation"
            active: false
        }
        ListElement {
            description: QT_TR_NOOP("Automatic Beam Switching")
            icon: "automatic_beam_switching"
            active: true
        }
        ListElement {
            description: QT_TR_NOOP("Collision Avoidance")
            icon: "collision_avoidance"
            active: false
        }
        ListElement {
            description: QT_TR_NOOP("Lane Assist")
            icon: "lane_keeping_assist"
            active: false
        }
        ListElement {
            description: QT_TR_NOOP("Traffic Jam Assist")
            icon: "traffic_jam_assist"
            active: false
        }
        ListElement {
            description: QT_TR_NOOP("Driver Drowsiness Alert")
            icon: "driver_drownsyness_alert"
            active: true
        }
        ListElement {
            description: QT_TR_NOOP("Park Assist")
            icon: "park_assist"
            active: false
        }
    }
}
