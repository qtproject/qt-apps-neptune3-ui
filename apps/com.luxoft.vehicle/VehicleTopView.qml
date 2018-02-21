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

import animations 1.0

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
        anchors.topMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        source: "assets/images/car-model-base.png"
    }

    Image {
        id: sunroof

        anchors.top: parent.top
        anchors.topMargin: 284
        anchors.horizontalCenter: parent.horizontalCenter
        source: "assets/images/sunroof.png"
    }

    Image {
        id: trunk

        anchors.top: parent.top
        anchors.topMargin: 466
        anchors.horizontalCenter: parent.horizontalCenter
        height: root.trunkOpen ? sourceSize.height * 0.3 : sourceSize.height
        Behavior on height { DefaultNumberAnimation { duration: 800 } }
        source: "assets/images/trunk.png"
    }

    Image {
        id: leftDoor

        anchors.top: parent.top
        anchors.topMargin: 167
        anchors.left: parent.left
        anchors.leftMargin: 218
        transformOrigin: Item.TopLeft
        rotation: root.leftDoorOpen ? 60 : 0
        Behavior on rotation { DefaultNumberAnimation { duration: 800 } }
        source: "assets/images/door-left.png"
    }

    Image {
        id: rightDoor

        anchors.top: parent.top
        anchors.topMargin: 167
        anchors.right: parent.right
        anchors.rightMargin: 218
        mirror: true
        transformOrigin: Item.TopRight
        rotation: root.rightDoorOpen ? -60 : 0
        Behavior on rotation { DefaultNumberAnimation { duration: 800 } }
        source: "assets/images/door-left.png"
    }

    Image {
        id: top

        anchors.top: parent.top
        anchors.topMargin: 124
        anchors.horizontalCenter: parent.horizontalCenter
        source: "assets/images/car-model-top.png"
    }
}
