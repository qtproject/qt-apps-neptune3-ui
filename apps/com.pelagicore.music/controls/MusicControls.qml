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
import shared.utils 1.0
import shared.controls 1.0
import QtQuick.Controls 2.3
import shared.Style 1.0
import shared.Sizes 1.0
import shared.effects 1.0

Row {
    id: root

    width: 3 * buttonWidth
    height: Sizes.dp(240)

    property bool play: false
    property real buttonWidth: Sizes.dp(100)
    signal previousClicked()
    signal playClicked()
    signal nextClicked()

    ToolButton {
        objectName: "musicSongPrevious"
        width: root.buttonWidth
        height: parent.height
        icon.name: LayoutMirroring.enabled ? "ic_skipnext" : "ic_skipprevious"
        onClicked: root.previousClicked()
    }

    ToolButton {
        objectName: "musicSongPlayPause"
        width: root.buttonWidth
        height: parent.height
        icon.name: root.play ? "ic-pause" : "ic_play"
        icon.color: "white"
        onClicked: root.playClicked()

        background: Image {
            id: playButtonBackground
            anchors.centerIn: parent
            width: Sizes.dp(sourceSize.width)
            height: Sizes.dp(sourceSize.height)
            source: Style.image("ic_button-bg")
            fillMode: Image.PreserveAspectFit

            ScalableColorOverlay {
                anchors.fill: parent
                source: playButtonBackground
                color: Style.accentColor
            }
        }
    }

    ToolButton {
        objectName: "musicSongNext"
        width: root.buttonWidth
        height: parent.height
        icon.name: LayoutMirroring.enabled ? "ic_skipprevious" : "ic_skipnext"
        onClicked: root.nextClicked()
    }
}
