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

import QtQuick 2.10
import QtQuick.Controls 2.2

import shared.Style 1.0
import shared.Sizes 1.0

import QtApplicationManager 2.0

/*!
    \qmltype MonitorOverlay
    \inherits Item
    \since 5.12
    \brief A component to display frame-rate information for a given window.

    \image control-monitoroverlay.jpg

    The MonitorOverlay provides an item on top of \l{NeptuneWindow} to display frame-rate
    information obtained from \l{QtApplicationManager::}{FrameTimer}.

    The following code snippet uses \l{MonitorOverlay}:

    \qml
    NeptuneWindow {
        id: root

        MonitorOverlay {
            id: monitorOverlay

            x: root.exposedRect.x
            y: root.exposedRect.y
            title: "System"
            width: root.exposedRect.width - 100
            height: root.exposedRect.height - 50
            fpsVisible: true
            window: root
            z: 9999

            Text {
                text: "Info 1"
            }
            Text {
                text: "Info 2"
            }
            Rectangle {
                color: "green"
                width: 100
                height: 20
            }
        }
    }
    \endqml

    \sa {QtApplicationManager::}{FrameTimer}
*/
Item {
    id: root

    /*!
      \qmlproperty Object MonitorOverlay::window

      The \l{NeptuneWindow} to be monitored, from which frame-rate information is gathered.

      \sa {QtApplicationManager::FrameTimer::}{window}
    */
    property alias window: frameTimer.window

    /*!
      \qmlproperty bool MonitorOverlay::fpsVisible

      If \c true, MonitorOverlay is shown and the frame-rate information is updated automatically.
    */
    property bool fpsVisible

    /*!
      \qmlproperty string MonitorOverlay::title

      This property holds the title of the MonitorOverlay item.
    */
    property string title

    default property alias rowData: row.data

    implicitWidth: row.width
    implicitHeight: row.height

    visible: fpsVisible

    FrameTimer {
        id: frameTimer
        running: root.fpsVisible
    }

    Rectangle {
        anchors.fill: row
        color: Style.backgroundColor
    }

    Row {
        id: row

        anchors.top: parent.top
        anchors.right: parent.right
        spacing: Sizes.dp(10)
        leftPadding: Sizes.dp(10)
        rightPadding: Sizes.dp(10)

        Label {
            text: root.title + ": "
            font.pixelSize: Sizes.fontSizeXS
            visible: root.title !== ""
        }

        Rectangle {
            id: rotatingRect
            width: Sizes.fontSizeXS
            height: Sizes.fontSizeXS
            color: Style.contrastColor
            visible: root.fpsVisible
            // Have something constantly moving on the screen to force constant rendering
            RotationAnimation {
                target: rotatingRect
                from: 0;
                to: 360;
                duration: 1000
                loops: Animation.Infinite
                running: rotatingRect.visible
            }
        }
        Label {
            text: qsTr("FPS: %1").arg(frameTimer.averageFps)
            font.pixelSize: Sizes.fontSizeXS
            visible: root.fpsVisible
        }
    }
}
