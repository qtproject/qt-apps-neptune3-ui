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

import QtQuick 2.6
import shared.utils 1.0
import shared.Sizes 1.0

MonitorPanel {
    id: root

    descriptionText: qsTr("CPU: ")
    middleText: qsTr("50%")
    valueText: systemModel ? "%1%".arg(systemModel.cpuPercentage) : ""

    delegate: Item {
        width: root.width / root.systemModel.monitorModel.maximumCount
        height: parent.height

        Rectangle {
            width: parent.width
            height: parent.height
            color: "#0F000000"
            opacity: Math.min(1, (root.systemModel.monitorModel.maximumCount - index - 0.5) * 0.3)

            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width - Sizes.dp(2)
                anchors.horizontalCenter: parent.horizontalCenter
                height: model.cpuLoad * parent.height
                color: "#30000000"
            }
        }
    }
}


