/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Copyright (C) 2018 Pelagicore AG
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

import QtQuick 2.2

import shared.utils 1.0

import shared.Sizes 1.0

import "../panels" 1.0
import "../stores" 1.0

Item {
    id: root

    property VehicleStore store
    Binding { target: store; property: "cameraAngleView"; value: car3dPanel.cameraPanAngleInput; }

    Vehicle3DPanel {
        id: car3dPanel

        anchors.top: root.top
        anchors.left: root.left
        anchors.right: root.right
        height: Sizes.dp(652)
        // at the application startup it doesn't receive full screen window,
        // in that moment the car model is scaled awfully, so we wait till the app window is rescaled properly
        visible: parent.height > 2 * Sizes.dp(652)

        leftDoorOpen: root.store.leftDoorOpened
        rightDoorOpen: root.store.rightDoorOpened
        trunkOpen: root.store.trunkOpened
        roofOpenProgress: root.store.roofOpenProgress
    }

    Vehicle3DControlPanel {
        id: controlPanel

        anchors.top: car3dPanel.bottom
        anchors.topMargin: Sizes.dp(80)
        anchors.rightMargin: Sizes.dp(30)
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: parent.bottom
        menuModel: store.menuModel
        controlModel: store.controlModel
        leftDoorOpened: root.store.leftDoorOpened
        rightDoorOpened: root.store.rightDoorOpened
        trunkOpened: root.store.trunkOpened

        onLeftDoorClicked: root.store.setLeftDoor()
        onRightDoorClicked: root.store.setRightDoor()
        onTrunkClicked: root.store.setTrunk()
        onRoofOpenProgressChanged: root.store.setRoofOpenProgress(value)
    }
}
