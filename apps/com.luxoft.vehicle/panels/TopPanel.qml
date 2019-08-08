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

import shared.animations 1.0

import shared.Sizes 1.0

import "../helpers" 1.0

Item {
    id: root

    height: base.height
    width: base.width

    property bool trunkOpen: false
    property bool leftDoorOpen: false
    property bool rightDoorOpen: false
    property real roofOpenProgress: 0.0

    Image {
        id: base

        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        source: Paths.getImagePath("car-model-base.png")
        width: Sizes.dp(sourceSize.width)
        height: Sizes.dp(sourceSize.height)
    }

    Image {
        id: sunroof

        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(284 + sourceSize.height * root.roofOpenProgress)
        anchors.horizontalCenter: parent.horizontalCenter
        source: Paths.getImagePath("sunroof.png")
        width: Sizes.dp(sourceSize.width)
        height: Sizes.dp(sourceSize.height * (1.0 - root.roofOpenProgress))
    }

    Image {
        id: trunk

        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(466)
        anchors.horizontalCenter: parent.horizontalCenter
        source: Paths.getImagePath("trunk.png")
        width: Sizes.dp(sourceSize.width)
        height: Sizes.dp(root.trunkOpen ? sourceSize.height * 0.3 : sourceSize.height)
        Behavior on height { DefaultNumberAnimation { duration: 800 } }
    }

    Image {
        id: leftDoor

        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(167)
        anchors.right: trunk.left
        anchors.rightMargin: Sizes.dp(7)
        transformOrigin: Item.TopLeft
        rotation: root.leftDoorOpen ? 60 : 0
        Behavior on rotation { DefaultNumberAnimation { duration: 800 } }
        source: Paths.getImagePath("door-left.png")
        width: Sizes.dp(sourceSize.width)
        height: Sizes.dp(sourceSize.height)
    }

    Image {
        id: rightDoor

        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(167)
        anchors.left: trunk.right
        anchors.leftMargin: Sizes.dp(7)
        mirror: true
        transformOrigin: Item.TopRight
        rotation: root.rightDoorOpen ? -60 : 0
        Behavior on rotation { DefaultNumberAnimation { duration: 800 } }
        source: Paths.getImagePath("door-left.png")
        width: Sizes.dp(sourceSize.width)
        height: Sizes.dp(sourceSize.height)
    }

    Image {
        id: top

        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(124)
        anchors.horizontalCenter: parent.horizontalCenter
        source: Paths.getImagePath("car-model-top.png")
        width: Sizes.dp(sourceSize.width)
        height: Sizes.dp(sourceSize.height)
    }
}
