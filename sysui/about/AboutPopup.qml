/****************************************************************************
**
** Copyright (C) 2017-2018 Pelagicore AG
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
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

import com.pelagicore.systeminfo 1.0
import com.pelagicore.styles.neptune 3.0
import utils 1.0
import controls 1.0

import "../procmon"

PopupItem {
    id: root
    width: NeptuneStyle.dp(910)
    height: NeptuneStyle.dp(1426)

    property var applicationModel

    headerBackgroundVisible: true
    headerBackgroundHeight: NeptuneStyle.dp(278)
    bottomPadding: NeptuneStyle.dp(20)

    property string currentTabName: tabBar.currentItem.name

    SystemInfo { id: info }

    contentItem: ColumnLayout {
        id: mainLayout
        readonly property real contentSideMargin: NeptuneStyle.dp(68)

        Item {
            id: header
            Layout.fillWidth: true
            Layout.preferredHeight: root.headerBackgroundHeight

            RowLayout {
                id: logoRow
                anchors.centerIn: parent
                width: parent.width * 0.8
                height: NeptuneStyle.dp(80)
                spacing: NeptuneStyle.dp(60)

                Image {
                    Layout.fillWidth: true
                    Layout.preferredWidth: parent.width / 3
                    Layout.maximumHeight: parent.height
                    fillMode: Image.PreserveAspectFit
                    source: Style.gfx("logo-theqtcompany")
                }
                Image {
                    Layout.fillWidth: true
                    Layout.preferredWidth: parent.width / 3
                    Layout.maximumHeight: parent.height
                    fillMode: Image.PreserveAspectFit
                    source: Style.gfx("logo-luxoft")
                }
                Image {
                    Layout.fillWidth: true
                    Layout.preferredWidth: parent.width / 3
                    Layout.maximumHeight: parent.height
                    fillMode: Image.PreserveAspectFit
                    source: Style.gfx("logo-kdab")
                }
            }
        }

        TabBar {
            id: tabBar
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            Layout.leftMargin: NeptuneStyle.dp(50)
            Layout.rightMargin: NeptuneStyle.dp(50)
            Layout.topMargin: NeptuneStyle.dp(40)
            TabButton {
                Layout.preferredWidth: NeptuneStyle.dp(180)
                text: qsTr("System")
                property string name: "system"
            }
            TabButton {
                Layout.preferredWidth: NeptuneStyle.dp(180)
                text: qsTr("Running Apps")
                property string name: "apps"
            }
            TabButton {
                Layout.preferredWidth: NeptuneStyle.dp(180)
                text: qsTr("Performance")
                property string name: "performance"
            }
            TabButton {
                Layout.preferredWidth: NeptuneStyle.dp(180)
                text: qsTr("Diagnostics")
                property string name: "diagnostics"
            }
        }

        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.topMargin: NeptuneStyle.dp(24)
            Layout.leftMargin: mainLayout.contentSideMargin
            Layout.rightMargin: mainLayout.contentSideMargin
            Layout.bottomMargin: NeptuneStyle.dp(24)
            currentIndex: tabBar.currentIndex
            MonitorView {
                sysinfo: info
            }
            AboutRunningApps {
                applicationModel: root.applicationModel
            }
            AboutPerformance {
                applicationModel: root.applicationModel
            }
            AboutDiagnostics {
                sysinfo: info
            }
        }
    }
}
