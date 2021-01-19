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

import QtQuick 2.0
import QtQuick.Controls 2.12

import shared.Style 1.0
import shared.Sizes 1.0

Control {
    id: root
    height: background.width
    width: background.height

    property var chartData
    signal accentColorRequested(color accentColor)

    background: Image {
        width: Sizes.dp(sourceSize.width)
        height: width
        source: Style.image("colorSelector/color-wheel")

        Image {
            //selected color overlay
            height: Sizes.dp(sourceSize.width)
            width: Sizes.dp(sourceSize.height)
            source: Style.image("colorSelector/"+Style.accentColor)
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                // circle with chartData.length sectors, the selected one is bigger then others
                // here we decide on which area click/touch was made
                var x0 = parent.width / 2;
                var y0 = parent.height / 2;
                var distance = Math.sqrt((mouseX - x0) ** 2 + (mouseY - y0) ** 2);
                if (distance > parent.width / 20 && chartData.length > 0) {
                    var sector = 2 * Math.PI / chartData.length;
                    var angle = Math.atan2(mouseY - y0, mouseX - x0) + Math.PI / 2;
                    angle = angle < 0.0 ? angle + 2 * Math.PI : angle;
                    root.accentColorRequested(chartData[(angle / sector) | 0].color);
                }
            }
        }
    }
}
