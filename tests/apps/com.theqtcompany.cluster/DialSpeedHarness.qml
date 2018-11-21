/****************************************************************************
**
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

import QtQuick 2.8
import shared.utils 1.0

import shared.Style 1.0

import panels 1.0

Item {
    id: root
    width: 600
    height: 600

    Image {
        anchors.fill: parent
        source: Style.image("instrument-cluster-bg")
        fillMode: Image.Stretch
    }

    DialSpeedPanel {
        id: ds
        anchors.fill: parent
        state: ds.speed > 70 ? "normal" : "navi"

        Timer {
            interval: 2000
            running: true
            repeat: true
            onTriggered: {
                if (ds.speed < 140) {
                    ds.speed = ds.speed + 10;
                } else {
                    ds.speed = 0.0;
                }

                if (ds.speedLimit < 100) {
                    ds.speedLimit = ds.speedLimit + 10;
                } else {
                    ds.speedLimit = 0;
                }

                if (ds.cruiseSpeed < 100) {
                    ds.cruiseSpeed = ds.cruiseSpeed + 10;
                } else {
                    ds.cruiseSpeed = 0;
                }
            }
        }
    }

    Component.onCompleted: {
        root.Style.theme = Style.Dark
    }
}
