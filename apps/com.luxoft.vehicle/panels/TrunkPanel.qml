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

import QtQuick 2.9
import QtGraphicalEffects 1.0

import shared.animations 1.0

import shared.Sizes 1.0

import "../controls" 1.0

Item {
    id: root

    property bool trunkOpened: false
    property bool leftDoorOpened: false
    property bool rightDoorOpened: false
    property real roofOpenProgress: 0.0
    property bool enableOpacityMasks

    signal trunkClicked()

    Item {
        anchors.fill: parent
        clip: true
        visible: true

        Rectangle {
            id: carImageMask

            anchors.fill: vehicleTopView
            gradient: Gradient {
                GradientStop { position: 0.22; color: "#00000000" }
                GradientStop { position: 0.44; color: "#ff000000" }
                GradientStop { position: 1.0; color: "#ff000000" }
            }
            visible: false
        }

        OpacityMask {
            anchors.fill: vehicleTopView
            maskSource: carImageMask
            source: vehicleTopView
        }

        TopPanel {
            id: vehicleTopView

            anchors.top: parent.top
            anchors.topMargin: Sizes.dp(-160)
            anchors.horizontalCenter: parent.horizontalCenter
            visible: !root.enableOpacityMasks

            trunkOpen: root.trunkOpened
            leftDoorOpen: root.leftDoorOpened
            rightDoorOpen: root.rightDoorOpened
            roofOpenProgress: root.roofOpenProgress
        }
    }

    VehicleButton {
        id: trunkCloseButton
        objectName: "trunk_OpenCloseButton"

        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(540)
        anchors.horizontalCenter: parent.horizontalCenter
        text: root.trunkOpened ? qsTr("Close") : qsTr("Open")

        onClicked: root.trunkClicked()
    }
}
