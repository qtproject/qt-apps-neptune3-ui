/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Triton Cluster UI.
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

Item {
    id: normalView
    width: 1920
    height: 720

    Item {
        id: d
        property real scaleRatio: Math.min(parent.width / 1920, parent.height / 720)
    }

    Image {
        width: 1920 * d.scaleRatio
        height: 720 * d.scaleRatio
        source: "./img/bg.png"
    }

//TODO: talk to Johan to decide whether should use the telltale background pic
//    Image {
//        id: bg
//        width: 1920 * scaleRatio
//        height: 293 * scaleRatio
//        source: "./img/telltale-bg.png"
//    }

    DialSpeed {
        id: ds
        x: 10 * d.scaleRatio
        y: 120* d.scaleRatio
        width: 560 * d.scaleRatio
        height: 560 * d.scaleRatio
    }

    DialPower {
        id: dp
        x: 1350 * d.scaleRatio
        y: 120 * d.scaleRatio
        width: 560 * d.scaleRatio
        height: 560* d.scaleRatio
    }

    Timer {
        running: true
        repeat: true
        interval: 100
        onTriggered: {
            if (ds.speed < 260) {
                ds.speed = ds.speed + 1;
            } else {
                ds.speed = 0;
            }

            if (ds.speedLimit < 260) {
                ds.speedLimit = ds.speedLimit + 2;
            } else {
                ds.speedLimit = 0;
            }

            if (ds.cruiseSpeed < 260) {
                ds.cruiseSpeed = ds.cruiseSpeed + 3;
            } else {
                ds.cruiseSpeed = 0;
            }

            if (dp.ePower <= 100) {
                dp.ePower = dp.ePower + 1;
            } else {
                dp.ePower = -25;
            }
        }
    }
}
