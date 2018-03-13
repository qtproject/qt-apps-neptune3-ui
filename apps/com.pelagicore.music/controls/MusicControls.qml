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

import QtQuick 2.8
import utils 1.0
import controls 1.0
import QtQuick.Controls 2.2


Row {
    id: root

    width: 3 * buttonWidth
    height: Style.vspan(3)

    property bool play: false
    property real spacing: 0    //not used
    property real buttonWidth: Style.hspan(100/45)
    signal previousClicked()
    signal playClicked()
    signal nextClicked()

    Tool {
        width: root.buttonWidth
        height: parent.height
        symbol: Style.symbol("ic_skipprevious")
        onClicked: root.previousClicked()
    }

    AbstractButton {
        width: root.buttonWidth
        height: parent.height

        onClicked: root.playClicked()

        contentItem: Item {
            anchors.fill: parent

            Image {
                anchors.centerIn: parent
                source: Style.symbol("ic_button-bg")
                fillMode: Image.Pad
            }

            Image {
                anchors.centerIn: parent
                source: root.play ? Style.symbol("ic-pause") : Style.symbol("ic_play")
                fillMode: Image.Pad
            }
        }
    }

    Tool {
        width: root.buttonWidth
        height: parent.height
        symbol: Style.symbol("ic_skipnext")
        onClicked: root.nextClicked()
    }
}
