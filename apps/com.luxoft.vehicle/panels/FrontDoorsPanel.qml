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
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import shared.Sizes 1.0

import shared.utils 1.0

import "../controls" 1.0

Item {
    id: root

    LayoutMirroring.enabled: false
    LayoutMirroring.childrenInherit: true

    property bool leftDoorOpened: false
    property bool rightDoorOpened: false
    property bool trunkOpened: false
    property real roofOpenProgress: 0.0
    property bool enableOpacityMasks

    signal leftDoorClicked()
    signal rightDoorClicked()

    VehicleButton {
        objectName: "vehicleDoorLeft_OpenCloseButton"
        z: vehicleTopView.z + 1
        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(320)
        anchors.left: parent.left
        anchors.leftMargin: Sizes.dp(45)
        state: "REGULAR"
        text: root.leftDoorOpened ? qsTr("Close") : qsTr("Open")

        onClicked: root.leftDoorClicked()
    }

    VehicleButton {
        objectName: "vehicleDoorRight_OpenCloseButton"
        z: vehicleTopView.z + 1
        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(320)
        anchors.right: parent.right
        anchors.rightMargin: Sizes.dp(45)
        state: "REGULAR"
        text: root.rightDoorOpened ? qsTr("Close") : qsTr("Open")

        onClicked: root.rightDoorClicked();
    }

    Rectangle {
        id: vehicleTopViewMask
        anchors.fill: vehicleTopView
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#00000000" }
            GradientStop { position: 0.28; color: "#ff000000" }
            GradientStop { position: 1.0; color: "#ff000000" }
        }
        visible: false
    }

    OpacityMask {
        anchors.fill: vehicleTopView
        maskSource: vehicleTopViewMask
        source: vehicleTopView
    }

    TopPanel {
        id: vehicleTopView
        anchors.horizontalCenter: parent.horizontalCenter
        visible: !root.enableOpacityMasks

        leftDoorOpen: root.leftDoorOpened
        rightDoorOpen: root.rightDoorOpened
        roofOpenProgress: root.roofOpenProgress
        trunkOpen: root.trunkOpened
    }
}
