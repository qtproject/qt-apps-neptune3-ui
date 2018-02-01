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

        //ToDo: It should be a separate button item later
        Image {
            anchors.top: parent.top
            anchors.topMargin: 200
            anchors.left: parent.left
            anchors.leftMargin: 40
            source: "assets/images/round-button" + root.sourceSuffix

            Image {
                anchors.centerIn: parent
                source: root.leftDoorOpen ? root.openLeftDoorSource : root.closeLeftDoorSource
            }

            MouseArea {
                width: 100
                height: 100
                anchors.centerIn: parent

                onClicked: {
                    root.leftDoorOpen = !root.leftDoorOpen
                    uiSettings.door1Open = root.leftDoorOpen
                }
                onPressed: (parent.scale = 1.1)
                onReleased: (parent.scale = 1.0)
            }
        }

        Image {
            anchors.top: parent.top
            anchors.topMargin: 200
            anchors.right: parent.right
            anchors.rightMargin: 40
            source: "assets/images/round-button" + root.sourceSuffix

            Image {
                anchors.centerIn: parent
                source: root.rightDoorOpen ? root.openRightDoorSource : root.closeRightDoorSource
            }

            MouseArea {
                width: 100
                height: 100
                anchors.centerIn: parent

                onClicked: {
                    root.rightDoorOpen = !root.rightDoorOpen
                    uiSettings.door2Open = root.rightDoorOpen
                }
                onPressed: (parent.scale = 1.1)
                onReleased: (parent.scale = 1.0)
            }
        }
    }
}
