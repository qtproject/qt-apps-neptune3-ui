/****************************************************************************
**
** Copyright (C) 2017-2018 Pelagicore AG
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
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

import utils 1.0
import triton.controls 1.0

import "../procmon"

TritonPopup {
    id: root
    width: Style.hspan(22)
    height: Style.vspan(19)

    property var applicationModel

    bottomPadding: Style.hspan(0.35)

    property string currentTabName: tabBar.currentItem.name

    contentItem: ColumnLayout {
        Image {
            Layout.fillWidth: true
            source: Style.gfx2("hero-about")
            asynchronous: true
        }

        // TODO: fix appearance of tab bar style
        TabBar {
            id: tabBar
            Layout.preferredWidth: Style.hspan(8)
            Layout.alignment: Qt.AlignHCenter
            TabButton {
                Layout.preferredWidth: Style.hspan(4)
                text: qsTr("Marketing")
                property string name: "marketing"
            }
            TabButton {
                Layout.preferredWidth: Style.hspan(4)
                text: qsTr("Monitor")
                property string name: "monitor"
            }
            TabButton {
                Layout.preferredWidth: Style.hspan(4)
                text: qsTr("Running Apps")
                property string name: "apps"
            }
        }

        StackLayout {
            id: stack
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: tabBar.currentIndex
            AboutMarketing {}
            MonitorView {
                implicitWidth: Style.hspan(18)
                implicitHeight: Style.vspan(16)
            }
            AboutRunningApps {
                applicationModel: root.applicationModel
            }
        }
    }
}
