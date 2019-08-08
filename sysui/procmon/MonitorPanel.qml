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

import QtQuick 2.8
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

import shared.Style 1.0
import shared.Sizes 1.0
import shared.utils 1.0

Item {
    id: root

    property string descriptionText
    property string valueText
    property alias middleText: middleLineText.text
    default property alias content: graphContent.children
    property var systemModel
    property alias delegate: graph.delegate

    clip: true

    Label {
        id: titleLine
        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(24)
        anchors.left: parent.left
        anchors.leftMargin: Sizes.dp(24)
        anchors.right: parent.right

        text: root.descriptionText + root.valueText
    }

    Item {
        id: graphContainer
        anchors.top: titleLine.bottom
        anchors.topMargin: Sizes.dp(24)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Sizes.dp(24)
        anchors.left: parent.left
        anchors.right: parent.right

        Item {
            id: graphContent
            anchors.fill: parent

            LayoutMirroring.enabled: true
            LayoutMirroring.childrenInherit: true

            ListView {
                id: graph
                model: root.systemModel ? root.systemModel.monitorModel : null
                width: parent.width
                height: parent.height
                anchors.bottom: parent.bottom
                orientation: ListView.Horizontal
                interactive: false
            }
        }

        Row {
            id: dashedLine
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: Sizes.dp(8)
            height: Sizes.dp(1)

            Repeater {
                model: graphContainer.width/8

                Rectangle {
                    width: 4 // N.B. intentionally not scalable
                    height: 1
                    color: "black"
                    opacity: Style.opacityMedium
                }
            }
        }
    }

    Label {
        id: middleLineText
        width: Sizes.dp(45)
        anchors.right: parent.right
        anchors.verticalCenter: graphContainer.verticalCenter
        anchors.verticalCenterOffset: -height * 0.7
        anchors.rightMargin: Sizes.dp(24)

        font.pixelSize: Sizes.fontSizeS
        opacity: Style.opacityMedium
    }
}
