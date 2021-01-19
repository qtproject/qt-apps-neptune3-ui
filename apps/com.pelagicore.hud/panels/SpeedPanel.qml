/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 Cluster UI.
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

import QtQuick 2.8
import QtQuick.Controls 2.2
import shared.Style 1.0
import shared.Sizes 1.0

Item {
    id: root

    property real currentSpeed
    property real speedLimit
    property real cruiseSpeed

    Rectangle {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: Sizes.dp(60)
        anchors.rightMargin: Sizes.dp(20)
        width: Sizes.dp(50)
        height: Sizes.dp(50)
        radius: width / 2
        border.color: (root.currentSpeed > root.speedLimit) ? "red" : "grey"
        border.width: Sizes.dp(6)
        opacity: (root.currentSpeed > root.speedLimit) ? 1.0 : 0.0
        Behavior on opacity {
            NumberAnimation { easing.type: Easing.OutCubic; duration: 270 }
        }
        Label {
            anchors.centerIn: parent
            text: Math.round(speedLimit)
            opacity: Style.opacityHigh
            font.pixelSize: Sizes.fontSizeXS
            color: root.Style.theme === Style.Dark ? Style.mainColor : Style.contrastColor
        }
    }

    Image {
        id: cruiseIcon
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: -Sizes.dp(18)
        anchors.bottom: speed.top
        opacity: (root.cruiseSpeed >= 30) ? 1 : 0.0
        width: Sizes.dp(35)
        height: Sizes.dp(31)
        source: "../assets/ic-acc.png"
        Behavior on opacity {
            NumberAnimation { easing.type: Easing.OutCubic; duration: 270 }
        }
    }

    Label {
        anchors.left: cruiseIcon.right
        anchors.leftMargin: Sizes.dp(10)
        anchors.verticalCenter: cruiseIcon.verticalCenter
        text: Math.round(root.cruiseSpeed)
        font.weight: Font.Light
        font.pixelSize: Sizes.fontSizeS
        opacity: cruiseIcon.opacity
        color: "white"
    }

    Label {
        id: speed
        anchors.centerIn: parent
        text: Math.round(root.currentSpeed)
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignHCenter
        font.weight: Font.DemiBold
        color: Style.accentColor
        opacity: Style.opacityHigh
        font.pixelSize: Sizes.fontSizeXXL
    }

    Label {
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: Sizes.dp(88)
        text: qsTr("km/h")
        font.weight: Font.Light
        color: Style.accentColor
        opacity: Style.opacityLow
        font.pixelSize: Sizes.fontSizeM
    }
}
