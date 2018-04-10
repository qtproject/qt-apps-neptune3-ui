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
import QtQml 2.2

import com.pelagicore.styles.neptune 3.0
import utils 1.0

// NB: StartupTimer is injected by qtapplicationmanager into the root context, so no import is needed.
Column {
    id: root
    spacing: NeptuneStyle.dp(20)

    Label {
        id: title
        anchors.left: parent.left
        anchors.right: parent.right
        text: qsTr("Startup timings")
        wrapMode: Text.Wrap
        height: font.pixelSize * 1.1
    }

    readonly property bool hasStartupData: StartupTimer.timeToFirstFrame > 0 && StartupTimer.systemUpTime > 0

    Label {
        id: upTimeLabel
        anchors.left: parent.left
        anchors.right: parent.right
        font.pixelSize: NeptuneStyle.fontSizeS
        font.weight: Font.Light
        text: qsTr("From boot to System UI process start: %1 ms")
                .arg(Number(StartupTimer.systemUpTime).toLocaleString(Qt.locale(), 'f', 0))
        visible: root.hasStartupData
    }
    Label {
        anchors.left: parent.left
        anchors.right: parent.right
        font.pixelSize: NeptuneStyle.fontSizeS
        font.weight: Font.Light
        text: qsTr("From System UI process start to first frame drawn: %1 ms")
                .arg(Number(StartupTimer.timeToFirstFrame).toLocaleString(Qt.locale(), 'f', 0))
        visible: root.hasStartupData
    }
    Label {
        anchors.left: parent.left
        anchors.right: parent.right
        font.pixelSize: NeptuneStyle.fontSizeS
        font.weight: Font.Light
        text: qsTr("Startup timings not available. Make sure the environment variable AM_STARTUP_TIMER was set")
        wrapMode: Text.Wrap
        visible: !root.hasStartupData
    }
}
