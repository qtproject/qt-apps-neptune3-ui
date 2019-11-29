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

import QtQuick 2.10
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import shared.Style 1.0
import shared.Sizes 1.0
import shared.animations 1.0
import "../helpers" 1.0

Item {
    id: root

    property string nextTurn
    property string nextTurnDistanceMeasuredIn
    property real nextTurnDistance

    Image {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        source: root.nextTurn !== ""
            ? Helper.localAsset(root.nextTurn, Style.theme)
            : ""
    }

    ProgressBar {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        height: Sizes.dp(120)
        width: Sizes.dp(20)
        orientation: Qt.Vertical
        visible: opacity > 0.0
        opacity: root.nextTurnDistance <= 300 && root.nextTurnDistanceMeasuredIn === "m" ? 1 : 0
        Behavior on opacity { DefaultNumberAnimation {} }

        value: root.nextTurnDistance <= 300 && root.nextTurnDistanceMeasuredIn === "m"
               ? root.nextTurnDistance / 300 : 0.0

        style: ProgressBarStyle {
            background: Rectangle {
                radius: 2
                color: "transparent"
                border.color: "gray"
                border.width: Sizes.dp(1)
                implicitHeight: Sizes.dp(200)
                implicitWidth: Sizes.dp(20)
            }
            progress: Rectangle {
                color: "lightsteelblue"
                border.color: "steelblue"
            }
        }
    }
}
