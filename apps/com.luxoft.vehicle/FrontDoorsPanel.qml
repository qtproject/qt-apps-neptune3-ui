/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AB
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

import QtQuick 2.9
import QtQuick.Layouts 1.3

import com.pelagicore.settings 1.0
import com.pelagicore.styles.triton 1.0

import utils 1.0

Item {
    id: root

    property bool leftDoorOpen: false
    property bool rightDoorOpen: false

    readonly property string sourceSuffix: TritonStyle.theme === TritonStyle.Dark ? "-dark.png" : ".png"
    readonly property string openRightDoorSource: "assets/images/ic-door-open" + sourceSuffix
    readonly property string closeRightDoorSource: "assets/images/ic-door-closed" + sourceSuffix
    readonly property string openLeftDoorSource: "assets/images/ic-door-open-flip" + sourceSuffix
    readonly property string closeLeftDoorSource: "assets/images/ic-door-closed-flip" + sourceSuffix

    UISettings {
        id: uiSettings
        onDoor1OpenChanged: {
            root.leftDoorOpen = uiSettings.door1Open
        }
        onDoor2OpenChanged: {
            root.rightDoorOpen = uiSettings.door2Open
        }
    }

    VehicleButton {
        anchors.top: parent.top
        anchors.topMargin: Style.vspan(2.5)
        anchors.left: parent.left
        state: "REGULAR"
        text: leftDoorOpen ? qsTr("Close") : qsTr("Open")

        onClicked: {
            root.leftDoorOpen = !root.leftDoorOpen
            uiSettings.door1Open = root.leftDoorOpen
        }
    }

    VehicleButton {
        anchors.top: parent.top
        anchors.topMargin: Style.vspan(2.5)
        anchors.right: parent.right
        state: "REGULAR"
        text: rightDoorOpen ? qsTr("Close") : qsTr("Open")

        onClicked: {
            root.rightDoorOpen = !root.rightDoorOpen
            uiSettings.door2Open = root.rightDoorOpen
        }
    }

    Image {
        id: doorsImage

        source: "assets/images/car-top.png"
        anchors.top: parent.top
        anchors.topMargin: 32
        anchors.left: parent.left
        anchors.leftMargin: 140
        width: 470
        height: 670

        Image {
            anchors.fill: parent
            visible: root.leftDoorOpen
            source: "assets/images/car-top-left-door.png"
        }
        Image {
            anchors.fill: parent
            visible: root.rightDoorOpen
            source: "assets/images/car-top-right-door.png"
        }
    }
}
