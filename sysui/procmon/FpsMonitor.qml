/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune IVI UI.
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
import QtApplicationManager 1.0
import com.pelagicore.styles.triton 1.0

MonitorPanel {
    id: root

    descriptionText: "FPS: "
    middleText: "60"
    middleLine: 0.6

    delegate: Item {
        id: rectContainer
        width: parent.width / root.model.count
        height: parent.height

        Repeater {
            model: frameRate

            delegate: Rectangle {
                width: rectContainer.width
                height: 3
                color: Qt.darker(root.TritonStyle.accentColor, (1 + index/10))
                y: frameRate[index]
                     ? rectContainer.height - height - (frameRate[index].average/100)*rectContainer.height
                     : rectContainer.height
            }
        }
    }
}


