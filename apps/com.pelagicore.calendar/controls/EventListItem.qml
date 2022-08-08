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
import shared.utils

import shared.Style
import shared.Sizes

ItemDelegate {
    id: root

    property string eventTimeStart
    property string eventTimeEnd
    property alias eventLabel: event.text

    highlighted: false
    background: null

    contentItem: Item {
        anchors.fill: root
        RowLayout {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: Sizes.dp(45)
            spacing: Sizes.dp(45)

            ColumnLayout {
                Layout.preferredWidth: Sizes.dp(45)
                Label {
                    text: root.eventTimeStart
                    font.pixelSize: Sizes.fontSizeXS
                }
                Label {
                    visible: root.eventTimeStart !== root.eventTimeEnd
                    text: root.eventTimeEnd
                    font.pixelSize: Sizes.fontSizeXS
                    opacity: Style.opacityMedium
                }
            }

            Label {
                id: event
                visible: text !== ""
                font.pixelSize: Sizes.fontSizeS
            }
        }

        Image {
            width: parent.width
            height: Sizes.dp(5)
            anchors.bottom: parent.bottom
            source: Style.image("divider")
        }
    }
}
