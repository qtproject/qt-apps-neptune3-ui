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
import QtQuick.Controls 2.2

import FrameTimer 1.0
import com.pelagicore.styles.neptune 3.0

Item {
    id: root
    property alias window: frameTimer.window
    property bool fpsVisible
    property string title
    default property alias columnData: column.data

    implicitWidth: column.width
    implicitHeight: column.height

    visible: fpsVisible

    FrameTimer {
        id: frameTimer
        window: root
        enabled: root.fpsVisible
    }

    Rectangle {
        anchors.fill: column
        color: NeptuneStyle.backgroundColor
    }

    Row {
        id: column
        anchors.top: parent.top
        anchors.right: parent.right
        spacing: NeptuneStyle.dp(10)
        leftPadding: NeptuneStyle.dp(10)
        rightPadding: NeptuneStyle.dp(10)

        Label {
            text: root.title + ": "
            font.pixelSize: NeptuneStyle.fontSizeXS
            visible: root.title !== ""
        }

        Rectangle {
            id: rotatingRect
            width: NeptuneStyle.fontSizeXS
            height: NeptuneStyle.fontSizeXS
            color: NeptuneStyle.primaryTextColor
            visible: root.fpsVisible
            // Have something constantly moving on the screen to force constant rendering
            RotationAnimator {
                target: rotatingRect
                from: 0;
                to: 360;
                duration: 1000
                loops: Animation.Infinite
                running: rotatingRect.visible
            }
        }
        Label {
            text: qsTr("FPS: %1").arg(frameTimer.framesPerSecond)
            font.pixelSize: NeptuneStyle.fontSizeXS
            visible: root.fpsVisible
        }
    }
}
