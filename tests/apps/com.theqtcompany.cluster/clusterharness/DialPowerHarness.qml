/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Copyright (C) 2018 Pelagicore AG
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

import QtQuick
import shared.utils

import shared.Style
import shared.Sizes
import panels

Item {
    id: root
    width: Sizes.dp(560)
    height: width

    readonly property real scaleRatio: Math.min(root.width / 560, root.height / 560)
    onScaleRatioChanged: {
        root.Sizes.scale = scaleRatio
    }

    Image {
        anchors.fill: parent
        source: Style.image("instrument-cluster-bg")
        fillMode: Image.Stretch
    }

    DialPowerPanel {
        id: dp
        anchors.fill: parent
        state: dp.ePower < 40 ? "normal" : "navi"

        Timer {
            interval: 500
            running: true
            repeat: true
            onTriggered: {
                if (dp.ePower < 80) {
                    dp.ePower = dp.ePower + 2;
                } else {
                    dp.ePower = 0;
                }

                if (dp.remainingKm < 200) {
                    dp.remainingKm = dp.remainingKm + 10;
                } else {
                    dp.remainingKm = 0;
                }

                if (dp.remainingPower < 100) {
                    dp.remainingPower = dp.remainingPower + 10;
                } else {
                    dp.remainingPower = 0;
                }
            }
        }
    }

    Component.onCompleted: {
        root.Style.theme = Style.Dark
    }
}
