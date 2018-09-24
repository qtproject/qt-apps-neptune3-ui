/****************************************************************************
**
** Copyright (C) 2017-2018 Pelagicore AG
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
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

import shared.utils 1.0
import shared.controls 1.0
import shared.animations 1.0

import shared.com.pelagicore.styles.neptune 3.0

Control {
    id: root

    property bool twentyFourHourTimeFormat

    signal twentyFourHourTimeFormatRequested(bool value)

    contentItem: Column {
        SwitchDelegate {
            id: twentyFourHourTime
            height: NeptuneStyle.dp(95)
            width: parent.width
            text: qsTr("24h time")
            checked: root.twentyFourHourTimeFormat
            onToggled: root.twentyFourHourTimeFormatRequested(checked)

            // TODO make the divider part of ItemDelegate's styled background
            Image {
                anchors.bottom: parent.bottom
                width: parent.width
                source: Style.gfx("list-divider", NeptuneStyle.theme)
            }
        }

        SwitchDelegate {
            height: NeptuneStyle.dp(95)
            width: parent.width
            enabled: false // TODO
            text: qsTr("Set Automatically")

            // TODO make the divider part of ItemDelegate's styled background
            Image {
                anchors.bottom: parent.bottom
                width: parent.width
                source: Style.gfx("list-divider", NeptuneStyle.theme)
            }
        }

        ItemDelegate {
            height: NeptuneStyle.dp(95)
            width: parent.width
            enabled: false // TODO
            text: qsTr("Time Zone")

            Image {
                opacity: NeptuneStyle.defaultDisabledOpacity
                anchors.right: parent.right
                anchors.rightMargin: NeptuneStyle.dp(22)
                height: parent.height
                fillMode: Image.Pad
                Layout.alignment: Qt.AlignVCenter
                source: Style.symbol("ic-next-level", NeptuneStyle.theme)
                mirror: parent.mirrored
            }
        }
    }
}
