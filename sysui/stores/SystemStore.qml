/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AG
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
import QtApplicationManager.SystemUI 1.0
import shared.utils 1.0

Store {
    id: root

    // to be set from outside
    property var activeAppInfo
    property bool systemOverlayEnabled: false
    property bool centerConsolePerfOverlayEnabled: false
    property bool instrumentClusterPerfOverlayEnabled: false
    property bool monitorEnabled: false

    readonly property int cpuPercentage: (systemMonitor.cpuLoad * 100).toFixed(0)
    readonly property int ramPercentage: ((ramBytes / ramTotalBytes) * 100).toFixed(0)
    readonly property int ramBytes: (systemMonitor.memoryUsed / 1e6).toFixed(0)
    readonly property int ramTotalBytes: (systemMonitor.totalMemory / 1e6).toFixed(0)

    readonly property real appCpuPercentage: (processMonitor.cpuLoad * 100).toFixed(1)
    readonly property real appRamBytes: (processMonitor.memoryPss.total / 1e6).toFixed(1)
    readonly property real appRamPercentage: ((appRamBytes / ramTotalBytes) * 100).toFixed(1)

    property var monitorModel: SystemMonitor {
        id: systemMonitor
        memoryReportingEnabled: root.systemOverlayEnabled || root.monitorEnabled
        cpuLoadReportingEnabled: root.systemOverlayEnabled || root.monitorEnabled
        reportingInterval: 1000
    }

    property var _procMon: ProcessMonitor {
        id: processMonitor
        applicationId: root.activeAppInfo ? root.activeAppInfo.id : ""
        reportingInterval: 1000
        memoryReportingEnabled: root.systemOverlayEnabled && root.activeAppInfo
        cpuLoadReportingEnabled: root.systemOverlayEnabled && root.activeAppInfo
    }
}
