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

import QtQuick 2.8
import QtApplicationManager 2.0
import QtApplicationManager.SystemUI 2.0
import shared.utils 1.0

Store {
    id: root

    // to be set from outside
    property var activeAppInfo
    property bool systemOverlayEnabled: false
    property bool centerConsolePerfOverlayEnabled: false
    property bool instrumentClusterPerfOverlayEnabled: false
    property bool monitorEnabled: false

    readonly property int cpuPercentage: (cpuStatus.cpuLoad * 100).toFixed(0)
    readonly property int ramPercentage: ((ramBytes / ramTotalBytes) * 100).toFixed(0)
    readonly property int ramBytes: (memoryStatus.memoryUsed / 1e6).toFixed(0)
    readonly property int ramTotalBytes: (memoryStatus.totalMemory / 1e6).toFixed(0)

    readonly property real appCpuPercentage: (processStatus.cpuLoad * 100).toFixed(1)
    readonly property real appRamBytes: (processStatus.memoryPss.total / 1e6).toFixed(1)
    readonly property real appRamPercentage: ((appRamBytes / ramTotalBytes) * 100).toFixed(1)

    property var monitorModel: MonitorModel {
        running: root.systemOverlayEnabled || root.monitorEnabled
        interval: 1000
        CpuStatus { id: cpuStatus }
        MemoryStatus { id: memoryStatus }
    }

    property var _procStatus: ProcessStatus {
        id: processStatus
        applicationId: root.activeAppInfo ? root.activeAppInfo.id : ""
    }
    property var _procStatusTimer: Timer {
        interval: 1000
        running: root.systemOverlayEnabled && root.activeAppInfo
        repeat: true
        onTriggered: processStatus.update()
    }
}
