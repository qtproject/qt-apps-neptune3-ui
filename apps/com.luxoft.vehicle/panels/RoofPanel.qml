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
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3

import shared.Sizes 1.0

import shared.animations 1.0
import shared.utils 1.0

import "../controls" 1.0

Item {
    id: root

    property real roofOpenProgress: 0.0
    property bool leftDoorOpened: false
    property bool rightDoorOpened: false
    property bool trunkOpened: false
    property bool enableOpacityMasks

    signal newRoofOpenProgressRequested(var progress)

    Behavior on roofOpenProgress { DefaultNumberAnimation { duration: 800 } }

    Rectangle {
        id: vehicleTopViewMask
        anchors.fill: vehicleTopView
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#00000000" }
            GradientStop { position: 0.28; color: "#ff000000" }
            GradientStop { position: 0.45; color: "#ff000000" }
            GradientStop { position: 1.0; color: "#00000000" }
        }
        visible: false
    }

    TopPanel {
        id: vehicleTopView
        visible: !root.enableOpacityMasks

        rotation: root.enableOpacityMasks ? 0 : 90
        transform: [
            Translate {
                x: root.enableOpacityMasks ? 0 : -width/10
                y: root.enableOpacityMasks ? 0 : -height/20
            }
        ]

        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        leftDoorOpen: root.leftDoorOpened
        rightDoorOpen: root.rightDoorOpened
        trunkOpen: root.trunkOpened
        roofOpenProgress: root.roofOpenProgress
    }

    OpacityMask {
        id: om
        rotation: 90
        transform: Translate {x: -width/10; y: -height/20}

        anchors.fill: vehicleTopView
        maskSource: vehicleTopViewMask
        source: vehicleTopView
    }

    VehicleButton {
        id: roofButton
        objectName: "roofButton"

        anchors.bottom: om.bottom
        anchors.bottomMargin: Sizes.dp(135)
        anchors.horizontalCenter: parent.horizontalCenter
        state: "REGULAR"
        text: root.roofOpenProgress > 0.0 ? qsTr("Close") : qsTr("Open")
        onClicked: root.roofOpenProgress < 1.0 ? root.newRoofOpenProgressRequested(1.0) :
                                                 root.newRoofOpenProgressRequested(0.0)
    }
}
