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
import QtQml.Models

import shared.utils
import shared.controls
import shared.animations

import shared.Style
import shared.Sizes

Control {
    id: root

    property bool twentyFourHourTimeFormat

    signal twentyFourHourTimeFormatRequested(bool value)

    contentItem: Column {
        SwitchDelegate {
            id: twentyFourHourTime
            objectName: "dateTimeSwitch"
            height: Sizes.dp(95)
            width: parent.width
            text: qsTr("24h time")
            checked: root.twentyFourHourTimeFormat
            onToggled: root.twentyFourHourTimeFormatRequested(checked)

            // TODO make the divider part of ItemDelegate's styled background
            Image {
                anchors.bottom: parent.bottom
                width: parent.width
                source: Style.image("list-divider")
            }
        }

        SwitchDelegate {
            height: Sizes.dp(95)
            width: parent.width
            enabled: false // TODO
            text: qsTr("Set Automatically")

            // TODO make the divider part of ItemDelegate's styled background
            Image {
                anchors.bottom: parent.bottom
                width: parent.width
                source: Style.image("list-divider")
            }
        }

        ItemDelegate {
            height: Sizes.dp(95)
            width: parent.width
            enabled: false // TODO
            text: qsTr("Time Zone")

            Image {
                opacity: Style.defaultDisabledOpacity
                anchors.right: parent.right
                anchors.rightMargin: Sizes.dp(22)
                height: parent.height
                fillMode: Image.Pad
                Layout.alignment: Qt.AlignVCenter
                source: Style.image("ic-next-level")
                mirror: parent.mirrored
            }
        }
    }
}
