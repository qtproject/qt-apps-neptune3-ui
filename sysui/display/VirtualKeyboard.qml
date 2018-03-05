/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
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

import QtQuick 2.7
import QtQuick.VirtualKeyboard 2.1
import QtQuick.VirtualKeyboard.Settings 2.1

import animations 1.0

Item {
    id: root
    height: inputPanel.height

    InputPanel {
        id: inputPanel
        anchors.left: parent.left
        anchors.right: parent.right

        states: [
            State {
                name: "active"
                when: inputPanel.active
                PropertyChanges { target: inputPanel; y: 0; visible: true }
            },
            State {
                name: "hidden"
                when: !inputPanel.active
                PropertyChanges { target: inputPanel; y: height; visible: false }
            }
        ]

        transitions: [
            Transition {
                from: "hidden"; to: "active"
                DefaultNumberAnimation { target: inputPanel; property: "y" }
            },
            Transition {
                from: "active"; to: "hidden"
                // keep it visible until the trantision finishes
                PropertyAction { target: inputPanel; property: "visible"; value: true }
                DefaultNumberAnimation { target: inputPanel; property: "y" }
            }
        ]

    }
}
