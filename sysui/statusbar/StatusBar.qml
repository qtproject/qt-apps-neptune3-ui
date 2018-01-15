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

import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

import utils 1.0
import controls 1.0
import models.statusbar 1.0
import models.system 1.0

import com.pelagicore.styles.triton 1.0

Pane {
    id: root

    height: Style.statusBarHeight

    property var uiSettings

    IndicatorTray {
        Layout.fillHeight: true
        model: StatusBarModel.indicators
        anchors.left: parent.left
        anchors.top: parent.top
    }

    // TODO: Update with the real Notification implementation when spec is available.
    Rectangle {
        id: notificationCenterHandlePlaceHolder
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: Style.hspan(5)
        height: Style.vspan(0.04)
        color: "#3a3a3a"
    }

    ColumnLayout {
        visible: SystemModel.showProcessMonitor
        anchors.left: notificationCenterHandlePlaceHolder.right
        anchors.leftMargin: Style.hspan(4)
        Label {
            text: qsTr("FPS: %1").arg(SystemModel.frameRate)
            font.pixelSize: TritonStyle.fontSizeXS
            font.weight: Style.fontWeight
        }
        Label {
            text: qsTr("CPU: %1 %").arg(SystemModel.cpuUsage)
            font.pixelSize: TritonStyle.fontSizeXS
            font.weight: Style.fontWeight
        }
        Label {
            text: qsTr("RAM: %1 MB (%2 %)").arg(SystemModel.ramUsage).arg(SystemModel.ramPercentage)
            font.pixelSize: TritonStyle.fontSizeXS
            font.weight: Style.fontWeight
        }
    }


    RowLayout {
        spacing: Style.paddingXL * 2
        Layout.maximumWidth: Style.hspan(12)
        Layout.maximumHeight: Style.statusBarHeight
        anchors.right: parent.right
        anchors.top: parent.top

        DateAndTime {
            Layout.fillHeight: true
            currentDate: StatusBarModel.currentDate
            uiSettings: root.uiSettings
        }
    }
}
