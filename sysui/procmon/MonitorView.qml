/****************************************************************************
**
** Copyright (C) 2017, 2018 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Triton IVI UI.
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
import QtQuick.Window 2.2
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

import utils 1.0
import models.system 1.0
import QtApplicationManager 1.0

import com.pelagicore.styles.triton 1.0

Item {
    id: root
    clip: true

    property int ram: 0
    property real ramUsed: 0
    property int cpu: 0
    property var rootWindow
    property var applicationWindows: []
    property int reportingInterval: 1000
    property int modelCount: 12
    property var applicationModel

    onCpuChanged: SystemModel.cpuUsage = root.cpu
    onRamUsedChanged: {
        SystemModel.ramPercentage = root.ram
        SystemModel.ramUsage = root.ramUsed
    }
    Component.onCompleted: initialize()

    function initialize() {
        SystemMonitor.reportingInterval = root.reportingInterval
        SystemMonitor.count = root.modelCount
        SystemMonitor.cpuLoadReportingEnabled = true
        root.rootWindow = Window.window
    }

    function getApplicationWindows() {
        root.applicationWindows = [];
        if (root.applicationModel.activeAppId === "")
            return
        for (var i = 0; i < WindowManager.count; ++i) {
            if (WindowManager.get(i).applicationId === root.applicationModel.activeAppId) {
                root.applicationWindows.push(WindowManager.get(i).windowItem);
            }
        }
    }

    Connections {
        target: SystemMonitor
        onCpuLoadReportingChanged: root.cpu = (load * 100).toFixed(0)
    }

    ProcessMonitor {
        id: processMon
        applicationId: root.applicationModel.activeAppId
        reportingInterval: root.reportingInterval
        count: root.modelCount

        memoryReportingEnabled: true
        frameRateReportingEnabled: true
        monitoredWindows: (applicationId === "" || ApplicationManager.singleProcess) ? [root.rootWindow] : root.applicationWindows
        onMemoryReportingChanged: {
            root.ram = (memoryPss.total/SystemMonitor.totalMemory * 100).toFixed(0)
            root.ramUsed = (memoryPss.total / 1e6).toFixed(0);
        }

        onFrameRateReportingChanged: {
            fpsMonitor.valueText = ""
            for (var i in frameRate) {
                fpsMonitor.valueText += "|"
                fpsMonitor.valueText += frameRate[i].average.toFixed(0)
                fpsMonitor.valueText += "|"
                SystemModel.frameRate = frameRate[i].average.toFixed(0)
            }
        }

        onApplicationIdChanged: getApplicationWindows()
    }

    ColumnLayout {
        anchors.fill: parent

        FpsMonitor {
            id: fpsMonitor
            Layout.fillWidth: true
            model: processMon
        }

        CpuMonitor {
            Layout.fillWidth: true
            valueText: root.cpu + "%"
        }

        RamMonitor {
            Layout.fillWidth: true
            model: processMon
            valueText: root.ram + "% " + root.ramUsed + "MB"
        }

        NetworkMonitor {
            Layout.fillWidth: true
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }

    Label {
        id: switchLabel
        anchors.top: parent.top
        anchors.topMargin: Style.vspan(0.2)
        anchors.right: switchControl.left
        text: qsTr("Process Monitor on Status Bar")
        font.pixelSize: TritonStyle.fontSizeXS
    }

    Switch {
        id: switchControl

        anchors.right: parent.right
        anchors.verticalCenter: switchLabel.verticalCenter
        indicator: Rectangle {
            implicitWidth: Style.hspan(0.7)
            implicitHeight: Style.vspan(0.2)
            x: switchControl.leftPadding
            y: parent.height / 2 - height / 2
            radius: 13
            color: switchControl.checked ? TritonStyle.accentColor : "#ffffff"
            border.color: switchControl.checked ? TritonStyle.accentColor : "#cccccc"

            Rectangle {
                x: switchControl.checked ? parent.width - width : 0
                width: Style.vspan(0.2)
                height: width
                radius: 13
                color: switchControl.down ? "#cccccc" : "#ffffff"
                border.color: switchControl.checked ? TritonStyle.accentColor : "#999999"
            }
        }

        onCheckedChanged: SystemModel.showProcessMonitor = checked
    }
}
