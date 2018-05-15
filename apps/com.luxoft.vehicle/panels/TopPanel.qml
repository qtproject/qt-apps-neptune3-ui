/****************************************************************************
**
** Copyright (C) 2018 Luxoft GmbH
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

import QtQuick 2.9

import animations 1.0

import com.pelagicore.styles.neptune 3.0

import "../helpers/pathsProvider.js" as Paths

Item {
    id: root

    height: base.height
    width: base.width

    property bool trunkOpen: false
    property bool leftDoorOpen: false
    property bool rightDoorOpen: false

    Image {
        id: base

        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        source: Paths.getImagePath("car-model-base.png")
        width: NeptuneStyle.dp(sourceSize.width)
        height: NeptuneStyle.dp(sourceSize.height)
    }

    Image {
        id: sunroof

        anchors.top: parent.top
        anchors.topMargin: NeptuneStyle.dp(284)
        anchors.horizontalCenter: parent.horizontalCenter
        source: Paths.getImagePath("sunroof.png")
        width: NeptuneStyle.dp(sourceSize.width)
        height: NeptuneStyle.dp(sourceSize.height)
    }

    Image {
        id: trunk

        anchors.top: parent.top
        anchors.topMargin: NeptuneStyle.dp(466)
        anchors.horizontalCenter: parent.horizontalCenter
        source: Paths.getImagePath("trunk.png")
        width: NeptuneStyle.dp(sourceSize.width)
        height: NeptuneStyle.dp(root.trunkOpen ? sourceSize.height * 0.3 : sourceSize.height)
        Behavior on height { DefaultNumberAnimation { duration: 800 } }
    }

    Image {
        id: leftDoor

        anchors.top: parent.top
        anchors.topMargin: NeptuneStyle.dp(167)
        anchors.right: trunk.left
        transformOrigin: Item.TopLeft
        rotation: root.leftDoorOpen ? 60 : 0
        Behavior on rotation { DefaultNumberAnimation { duration: 800 } }
        source: Paths.getImagePath("door-left.png")
        width: NeptuneStyle.dp(sourceSize.width)
        height: NeptuneStyle.dp(sourceSize.height)
    }

    Image {
        id: rightDoor

        anchors.top: parent.top
        anchors.topMargin: NeptuneStyle.dp(167)
        anchors.left: trunk.right
        mirror: true
        transformOrigin: Item.TopRight
        rotation: root.rightDoorOpen ? -60 : 0
        Behavior on rotation { DefaultNumberAnimation { duration: 800 } }
        source: Paths.getImagePath("door-left.png")
        width: NeptuneStyle.dp(sourceSize.width)
        height: NeptuneStyle.dp(sourceSize.height)
    }

    Image {
        id: top

        anchors.top: parent.top
        anchors.topMargin: NeptuneStyle.dp(124)
        anchors.horizontalCenter: parent.horizontalCenter
        source: Paths.getImagePath("car-model-top.png")
        width: NeptuneStyle.dp(sourceSize.width)
        height: NeptuneStyle.dp(sourceSize.height)
    }
}
