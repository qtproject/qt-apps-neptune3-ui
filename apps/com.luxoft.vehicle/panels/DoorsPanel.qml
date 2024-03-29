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

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import shared.Style

import shared.animations
import shared.utils

Item {
    id: root

    property alias leftDoorOpened: frontDoorsPanel.leftDoorOpened
    property alias rightDoorOpened: frontDoorsPanel.rightDoorOpened
    property alias trunkOpened: trunkPanel.trunkOpened
    property alias roofOpenProgress: roofPanel.roofOpenProgress

    property bool enableOpacityMasks: true

    signal leftDoorClicked()
    signal rightDoorClicked()
    signal trunkClicked()
    signal newRoofOpenProgressRequested(var progress)

    TabBar {
        id: tabBar
        objectName: "viewDoorsPanel"

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        TabButton {
            objectName: "subViewButton_roof"
            text: qsTr("Sun roof")
        }
        TabButton {
            objectName: "subViewButton_doors"
            text: qsTr("Doors")
        }
        TabButton {
            objectName: "subViewButton_trunk"
            text: qsTr("Trunk")
        }
    }

    StackLayout {
        anchors.top: tabBar.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        currentIndex: tabBar.currentIndex

        RoofPanel {
            id: roofPanel
            objectName: "subView_roof"

            enableOpacityMasks: root.enableOpacityMasks
            leftDoorOpened: root.leftDoorOpened
            rightDoorOpened: root.rightDoorOpened
            trunkOpened: root.trunkOpened

            onNewRoofOpenProgressRequested: function(progress) { root.newRoofOpenProgressRequested(progress) }
        }

        FrontDoorsPanel {
            id: frontDoorsPanel
            objectName: "subView_doors"

            enableOpacityMasks: root.enableOpacityMasks
            onLeftDoorClicked: root.leftDoorClicked()
            onRightDoorClicked: root.rightDoorClicked()

            trunkOpened: root.trunkOpened
            roofOpenProgress: root.roofOpenProgress
        }

        TrunkPanel {
            id: trunkPanel
            objectName: "subView_trunk"
            onTrunkClicked: root.trunkClicked()

            enableOpacityMasks: root.enableOpacityMasks
            leftDoorOpened: root.leftDoorOpened
            rightDoorOpened: root.rightDoorOpened
            roofOpenProgress: root.roofOpenProgress
        }
    }
}
