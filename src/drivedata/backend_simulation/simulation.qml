/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
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
import shared.com.pelagicore.drivedata.simulation 1.0

Item {
    InstrumentClusterBackend {
        id: backend
        property var settings : IfSimulator.findData(IfSimulator.simulationData, "InstrumentCluster")

        function initialize() {
            IfSimulator.initializeDefault(settings, backend)
            Base.initialize()
        }

        property Timer timer: Timer {
            interval: 200
            onTriggered: {
                if (backend.speed < 130) {
                    backend.speed = backend.speed + 1;
                } else {
                    backend.speed = 0;
                }
            }
            repeat: true
            running: true
        }

        property Timer powerTimer: Timer {
            interval: 2000
            onTriggered: {
                if (backend.ePower < 100) {
                    backend.ePower = 100;
                } else {
                    backend.ePower = backend.ePower - 5;
                }
            }
            repeat: true
            running: true
        }
    }
}
