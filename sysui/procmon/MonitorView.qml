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

import com.pelagicore.styles.triton 1.0

ColumnLayout {
    id: root

    Item {
        Layout.fillWidth: true
        Layout.preferredHeight: switchLabel.height

        Label {
            id: switchLabel
            anchors.top: parent.top
            anchors.topMargin: Style.vspan(0.2)
            anchors.right: switchControl.left
            text: qsTr("System Monitor Overlay")
            font.pixelSize: TritonStyle.fontSizeS
        }

        Switch {
            id: switchControl
            anchors.right: parent.right
            anchors.verticalCenter: switchLabel.verticalCenter
            property bool propagateValue: false;
            onCheckedChanged: {
                if (propagateValue) {
                    SystemModel.showMonitorOverlay = checked;
                }
            }
            Component.onCompleted: {
                checked = SystemModel.showMonitorOverlay;
                propagateValue = true;
            }
        }
    }

    CpuMonitor {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.vspan(2.5)
        Layout.topMargin: Style.vspan(0.25)
    }

    RamMonitor {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.vspan(2.5)
        Layout.topMargin: Style.vspan(0.25)
    }

    NetworkMonitor {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.topMargin: Style.vspan(0.25)
    }

    Label {
        text: qsTr("Version")
        Layout.fillWidth: true
        Layout.preferredHeight: font.pixelSize * 1.1
        Layout.topMargin: Style.vspan(0.25)
    }
    Label {
        text: Qt.application.version
        font.pixelSize: Style.fontSizeS
        Layout.fillWidth: true
        Layout.preferredHeight: font.pixelSize * 1.1
    }
}
