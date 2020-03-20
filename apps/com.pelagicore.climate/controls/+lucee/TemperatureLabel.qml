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

import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import "../helpers" 1.0
import shared.Style 1.0
import shared.Sizes 1.0

RowLayout {
    id: root
    property real seat
    Label {
        readonly property int integers: root.seat ? Math.floor(root.seat) : 0
        readonly property int decimals: root.seat ? (root.seat - Math.floor(root.seat)) * 10 : 0
        Layout.fillHeight: true

        textFormat: Text.RichText
        text: integers + "<font size=\""+Sizes.dp(40)+"px\">" + Qt.locale().decimalPoint + decimals + "</font>"

        padding: 0
        verticalAlignment: Text.AlignBottom
        font.pixelSize: Sizes.dp(55)
        font.weight: Font.Light
        color: "#5e5d5d"
    }

    // Ideally the suffix should be part of the text of the Label above
    // Qt RichtText parser doesn't handle <font> tags in the same string. Hence, we use additiomal Label
    Label {
        Layout.topMargin: Sizes.dp(15)
        text: {
            if (root.seat) {
                return  Qt.locale().measurementSystem === Locale.MetricSystem ? "°C" : "°F";
            } else {
                return "";
            }
        }
        font.pixelSize: Sizes.dp(26)
        font.weight: Font.Normal
        color: "#5e5d5d"
    }
}
