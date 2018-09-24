/****************************************************************************
**
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

import QtQuick 2.10
import QtQuick.Controls 2.2

import shared.utils 1.0
import shared.com.pelagicore.styles.neptune 3.0

MouseArea {
    id: root

    width: NeptuneStyle.dp(300)
    height: NeptuneStyle.dp(30)

    drag.axis: Drag.YAxis
    drag.filterChildren: true

    property var dragTarget: undefined
    property int prevDragY: 0
    property int dragDelta: 0
    property int dragOrigin: 0

    property bool swipe: Math.abs(root.prevDragY - root.dragTarget.y) > 0

    property alias dragFilterTimer: dragFilterTimer

    property int notificationCount
    property bool notificationCounterVisible

    drag.target: root.dragTarget

    function circledNumber(num) {
        return String.fromCharCode(0x2460 + num - 1);
    }

    Rectangle {
        anchors.left: root.notificationCounterVisible ? parent.left : undefined
        anchors.verticalCenter: parent.verticalCenter
        width: root.notificationCounterVisible ? NeptuneStyle.dp(100) : NeptuneStyle.dp(200)
        height: NeptuneStyle.dp(2)
        anchors.centerIn: root.notificationCounterVisible ? undefined : root
        color: NeptuneStyle.contrastColor
    }

    Label {
        anchors.centerIn: root
        font.pixelSize: NeptuneStyle.fontSizeS
        text: circledNumber(root.notificationCount)
        opacity: root.notificationCounterVisible ? 1 : 0
        visible: opacity > 0
    }

    Rectangle {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        width: NeptuneStyle.dp(100)
        height: NeptuneStyle.dp(2)
        opacity: root.notificationCounterVisible ? 1 : 0
        visible: opacity > 0
        color: NeptuneStyle.contrastColor
    }

    Timer {
        id: dragFilterTimer
        interval: 100
        repeat: true
        onTriggered: {
            root.prevDragY = root.dragTarget.y;
        }
    }
}
