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
import QtQuick.Controls 2.2
import shared.controls 1.0
import shared.utils 1.0
import shared.animations 1.0
import shared.Style 1.0
import shared.Sizes 1.0

ToolButton {
    id: root

    property bool gridOpen: false
    property alias editModeBgOpacity: editModeBg.opacity
    property alias editModeBgColor: editModeBg.color

    background: Rectangle {
        id: editModeBg
        anchors.fill: parent
        Behavior on opacity { DefaultNumberAnimation { } }
    }

    contentItem: Item {
        anchors.fill: parent
        Image {
            width: Sizes.dp(68)
            anchors.centerIn: icon
            fillMode: Image.PreserveAspectFit
            visible: root.checked && !root.gridOpen
            source: Style.image("ic-app-active-bg")
        }

        AppIcon {
            id: icon
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -appLabel.font.pixelSize/2
            width: Sizes.dp(50)
            height: Sizes.dp(50)
            checked: root.checked && !root.gridOpen
            source: root.icon.name
        }

        Label {
            id: appLabel
            anchors.top: icon.bottom
            anchors.topMargin: Sizes.dp(10)
            anchors.horizontalCenter: parent.horizontalCenter
            width: root.width*0.8
            font.pixelSize: Sizes.fontSizeS
            opacity: root.gridOpen ? 1.0 : 0.0
            Behavior on opacity { DefaultNumberAnimation { } }
            color: "white"
            visible: opacity > 0
            elide: Text.ElideRight
            maximumLineCount: 2
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            lineHeight: 0.9
            text: root.text
        }
    }
}
