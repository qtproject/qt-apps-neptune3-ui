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

import QtQuick 2.10
import QtQuick.Controls 2.3

import com.pelagicore.styles.neptune 3.0
import models.system 1.0

Flickable {
    id: root

    property var applicationModel

    clip: true
    contentWidth: column.width
    contentHeight: column.height

    Column {
        id: column
        width: root.width

        topPadding: NeptuneStyle.dp(20)
        spacing: NeptuneStyle.dp(20)

        Label {
            width: parent.width
            wrapMode: Text.WordWrap
            text: qsTr("Enabling performance monitoring forces System UI and/or the chosen" +
                        " application to constantly redraw itself, therefore having a constant," +
                        " unnecessary, GPU/CPU consumption.")
            font.pixelSize: NeptuneStyle.fontSizeS
        }

        Label {
            text: qsTr("System UI Compositing Windows:")
            font.weight: Font.Bold
        }

        SwitchDelegate {
            width: parent.width
            text: qsTr("Center Console Performance Overlay")
            checked: SystemModel.centerConsolePerfOverlayEnabled
            onToggled: {
                SystemModel.centerConsolePerfOverlayEnabled = checked;
            }
        }

        SwitchDelegate {
            width: parent.width
            text: qsTr("Instrument Cluster Performance Overlay")
            checked: SystemModel.instrumentClusterPerfOverlayEnabled
            onToggled: {
                SystemModel.instrumentClusterPerfOverlayEnabled = checked;
            }
        }

        Label {
            text: qsTr("Application Windows:")
            font.weight: Font.Bold
        }

        Repeater {
            model: root.applicationModel
            delegate: Column {
                width: parent.width
                height: implicitHeight
                spacing: NeptuneStyle.dp(20)
                visible: model.appInfo.window != null || model.appInfo.secondaryWindow != null
                SwitchDelegate {
                    id: primarySwitch
                    width: parent.width
                    text: qsTr("%1 primary window").arg(model.appInfo.name)
                    visible: model.appInfo.window != null
                    Binding { target: model.appInfo; property: "windowPerfMonitorEnabled"; value: primarySwitch.checked }
                }
                SwitchDelegate {
                    id: secondarySwitch
                    width: parent.width
                    text: qsTr("%1 secondary window").arg(model.appInfo.name)
                    visible: model.appInfo.secondaryWindow != null
                    Binding { target: model.appInfo; property: "secondaryWindowPerfMonitorEnabled"; value: secondarySwitch.checked }
                }
            }
        }
    }
}
