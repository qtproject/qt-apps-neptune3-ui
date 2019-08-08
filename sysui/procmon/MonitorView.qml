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
import QtQuick.Window 2.2
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

import shared.Sizes 1.0
import shared.utils 1.0

ColumnLayout {
    id: root

    property var sysinfo
    property var systemModel
    property bool singleProcess

    function graphicsInformation() {
        var result = "";
        var api = GraphicsInfo.api;
        if (api === GraphicsInfo.Software) {
            result = "Software rendering";
        } else if (api === GraphicsInfo.OpenGL) {
            result = "OpenGL";
            if (GraphicsInfo.renderableType === GraphicsInfo.SurfaceFormatOpenGLES) {
                result += " ES";
            }
        } else if (api === GraphicsInfo.Direct3D12) {
            result = "Direct3D";
        }
        return result + " " + GraphicsInfo.majorVersion + "." + GraphicsInfo.minorVersion;
    }

    Flickable {
        id: flickable
        Layout.fillWidth: true
        Layout.fillHeight: true
        contentWidth: width - Sizes.dp(30)
        contentHeight: contentList.height
        clip: true
        flickableDirection: Flickable.VerticalFlick
        ScrollIndicator.vertical: ScrollIndicator {}

        Column {
            id: contentList
            width: parent.width
            spacing: Sizes.dp(24)

            Switch {
                anchors.left: parent.left
                anchors.leftMargin: Sizes.dp(24)
                text: qsTr("System Monitor Overlay")
                checked: root.systemModel ? root.systemModel.systemOverlayEnabled : false
                onToggled: {
                    root.systemModel.systemOverlayEnabled = checked;
                }
            }

            MonitorListItem {
                readonly property bool hasStartupData: StartupTimer.timeToFirstFrame > 0 && StartupTimer.systemUpTime > 0
                title: qsTr("Startup timings")
                subtitle: hasStartupData ? qsTr("From boot to System UI process start: %1 ms")
                                           .arg(Number(StartupTimer.systemUpTime).toLocaleString(Qt.locale(), 'f', 0)) + "\n" +
                                           qsTr("From System UI process start to first frame drawn: %1 ms")
                                           .arg(Number(StartupTimer.timeToFirstFrame).toLocaleString(Qt.locale(), 'f', 0))
                                         : qsTr("Startup timings not available. Make sure the environment variable AM_STARTUP_TIMER was set")
            }

            MonitorListItem {
                title: qsTr("Mode: ") + (root.singleProcess ? qsTr("single-process") : qsTr("multi-process"))
            }

            MonitorListItem {
                complexContent: CpuMonitor {
                    width: contentList.width
                    height: Sizes.dp(300)
                    systemModel: root.systemModel
                }
            }

            MonitorListItem {
                complexContent: RamMonitor {
                    width: contentList.width
                    height: Sizes.dp(300)
                    systemModel: root.systemModel
                }
            }

            MonitorListItem {
                title: qsTr("Network: %1%2")
                                .arg(sysinfo.connected ? qsTr("connected") : qsTr("disconnected"))
                                .arg(sysinfo.connected && !sysinfo.internetAccess ? qsTr(", no internet") : "");
                subtitle: sysinfo.addressList.join("\n")
            }

            MonitorListItem {
                title: qsTr("Version")
                subtitle: qsTr("Neptune 3: %1 %2").arg(Qt.application.version).arg(neptuneInfo) + "\n" +
                          qsTr("Qt Application Manager: %1").arg(qtamVersion) + "\n" +
                          qsTr("Qt IVI: %1").arg(qtiviVersion)
            }

            MonitorListItem {
                title: qsTr("Platform")
                subtitle: sysinfo.productName + " · " + sysinfo.cpu + " · " + sysinfo.kernel + " " + sysinfo.kernelVersion + " · " +
                          "Qt %1".arg(sysinfo.qtVersion) + " · " + graphicsInformation() + "\n"
            }
        }
    }
}
