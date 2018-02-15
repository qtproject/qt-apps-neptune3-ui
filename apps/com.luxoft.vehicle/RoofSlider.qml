/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AG
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
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0

import com.pelagicore.styles.triton 1.0

Slider {
    id: root

    background: Item {
        implicitWidth: root.width
        implicitHeight: 110

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            implicitWidth: root.width * root.visualPosition
            implicitHeight: 11

            color: "#555352"
            border.width: 1
            border.color: "#6d6b69"

            Rectangle {
                anchors.left: parent.right
                implicitWidth: root.width * (1 - root.visualPosition)
                implicitHeight: 11

                color: "#d5d0ce"
                border.width: 1
                border.color: "#e0dbd8"
            }
        }
    }

    handle: Item {
        width: 52
        height: 110
        x: root.leftPadding + root.visualPosition * (root.availableWidth - width)
        y: root.topPadding + root.availableHeight / 2 - height / 2

        RectangularGlow {
            id: glow

            anchors.fill: rect
            glowRadius: 2
            spread: 0.1
            color: TritonStyle.contrastColor
            opacity: 0.5
            cornerRadius: rect.radius
        }

        Rectangle {
            id: rect

            anchors.centerIn: parent
            implicitWidth: 52
            implicitHeight: 110

            color: TritonStyle.offMainColor
            radius: implicitWidth / 2
        }
    }
}
