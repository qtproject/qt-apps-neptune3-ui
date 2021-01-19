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
import QtQuick.Controls 2.3
import shared.utils 1.0
import shared.Sizes 1.0

import shared.controls 1.0

Item {
    id: root

    property alias model: toolsColumn.model
    property string serverUrl

    signal toolClicked(int index)
    signal refresh()

    BusyIndicator {
        id: busyIndicator

        running: false
        anchors.horizontalCenter: root.horizontalCenter
        opacity: 0.0;
        visible: opacity > 0.0
        width: Sizes.dp(100); height: width
    }

    ToolsColumn {
        id: toolsColumn

        property bool refreshRequired: false

        interactive: true
        width: Sizes.dp(264)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(53)
        onClicked: root.toolClicked(currentIndex)
        onContentYChanged: {
            if (atYBeginning) {
                var d = Math.abs(contentY);
                busyIndicator.opacity = d / busyIndicator.height;
                if (d > busyIndicator.height) {
                    if (!busyIndicator.running) {
                        busyIndicator.running = true;
                        refreshRequired = true;
                    }
                } else {
                    busyIndicator.running = false;
                    // if we drag back - no refresh
                    if (dragging)
                        refreshRequired = false;
                }
            }
        }
        onMovementEnded: {
            busyIndicator.opacity = 0.0;
            if (refreshRequired) {
                refreshRequired = false;
                refresh();
            }
        }
    }
}
