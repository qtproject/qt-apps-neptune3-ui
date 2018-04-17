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

import QtQuick 2.8
import utils 1.0
import QtQuick.Controls 2.2

import com.pelagicore.styles.neptune 3.0

Control {
    id: root

    property bool labelOnTop: true
    property string progressText: "0:0 / 0:0"
    property real value // 0 <= value <=1
    property int progressBarLabelLeftMargin: NeptuneStyle.dp(10)
    readonly property int progressBarWidth: root.width - (root.labelOnTop
                                                ? NeptuneStyle.dp(6) : NeptuneStyle.dp(5))

    signal updatePosition(var value)

    contentItem: Item {
        anchors.fill: root
        Label {
            id: progressLabel
            anchors.top: parent.top
            anchors.topMargin: root.labelOnTop ? NeptuneStyle.dp(48) : 0
            anchors.left: parent.left
            anchors.leftMargin: root.progressBarLabelLeftMargin
            font.pixelSize: NeptuneStyle.fontSizeS
            font.weight: Font.Light
            text: root.progressText
            opacity: NeptuneStyle.fontOpacityMedium
        }

        Slider {
            id: trackProgressBar
            implicitWidth: root.progressBarWidth
            implicitHeight: NeptuneStyle.dp(40)
            anchors.centerIn: parent
            anchors.verticalCenterOffset: NeptuneStyle.dp(-24)
            anchors.horizontalCenterOffset: root.labelOnTop ? 0 : NeptuneStyle.dp(90)
            value: root.value

            padding: NeptuneStyle.dp(2)

            onValueChanged: {
                if (trackProgressBar.pressed) {
                    root.updatePosition(value)
                }
            }

            handle: null

            background: Rectangle {
                x: trackProgressBar.leftPadding
                y: trackProgressBar.topPadding + trackProgressBar.availableHeight / 2 - height / 2
                implicitWidth: root.progressBarWidth
                implicitHeight: NeptuneStyle.dp(0.9)
                width: trackProgressBar.availableWidth
                height: implicitHeight
                color: "#828282"
                radius: 1

                Rectangle {
                    width: trackProgressBar.visualPosition * parent.width
                    height: NeptuneStyle.dp(6.75)
                    anchors.verticalCenter: parent.verticalCenter
                    radius: height
                    color: NeptuneStyle.accentColor
                }
            }
        }
    }
}
