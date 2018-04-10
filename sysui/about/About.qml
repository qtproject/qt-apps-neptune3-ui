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

import com.pelagicore.styles.neptune 3.0
import utils 1.0
import neptune.controls 1.0

import "../procmon"

NeptunePopup {
    id: root
    width: Style.hspan(22)
    height: Style.vspan(19)

    property var applicationModel

    topPadding: NeptuneStyle.dp(20)
    bottomPadding: NeptuneStyle.dp(20)

    property string currentTabName: tabBar.currentItem.name

    contentItem: ColumnLayout {
        id: mainLayout
        readonly property real contentSideMargin: Style.hspan(1.5)

        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: mainLayout.contentSideMargin
            Layout.rightMargin: mainLayout.contentSideMargin
            spacing: NeptuneStyle.dp(50)
            Image {
                Layout.fillWidth: true
                Layout.preferredWidth: parent.width / 3
                fillMode: Image.PreserveAspectFit
                source: Style.gfx("logo-theqtcompany")
            }
            Image {
                Layout.fillWidth: true
                Layout.preferredWidth: parent.width / 3
                fillMode: Image.PreserveAspectFit
                source: Style.gfx("logo-luxoft")
            }
            Image {
                Layout.fillWidth: true
                Layout.preferredWidth: parent.width / 3
                fillMode: Image.PreserveAspectFit
                source: Style.gfx("logo-kdab")
            }
        }

        TabBar {
            id: tabBar
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            Layout.leftMargin: mainLayout.contentSideMargin
            Layout.rightMargin: mainLayout.contentSideMargin
            Layout.topMargin: Style.vspan(0.5)
            TabButton {
                Layout.preferredWidth: Style.hspan(4)
                text: qsTr("System")
                property string name: "system"
            }
            TabButton {
                Layout.preferredWidth: Style.hspan(4)
                text: qsTr("Running Apps")
                property string name: "apps"
            }
            TabButton {
                Layout.preferredWidth: Style.hspan(4)
                text: qsTr("Performance")
                property string name: "performance"
            }
        }

        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.topMargin: NeptuneStyle.dp(10)
            Layout.leftMargin: mainLayout.contentSideMargin
            Layout.rightMargin: mainLayout.contentSideMargin
            Layout.bottomMargin: Style.vspan(0.3)
            currentIndex: tabBar.currentIndex
            MonitorView {
            }
            AboutRunningApps {
                applicationModel: root.applicationModel
            }
            AboutPerformance {
                applicationModel: root.applicationModel
            }
        }
    }
}
