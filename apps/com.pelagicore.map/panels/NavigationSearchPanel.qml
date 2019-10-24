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

import QtQuick 2.8
import QtQuick.Controls 2.2

import shared.controls 1.0 as NeptuneControls
import shared.utils 1.0
import shared.Style 1.0
import shared.Sizes 1.0
import "../helpers" 1.0

Row {
    id: root

    property bool offlineMapsEnabled: false
    signal openSearchTextInput()

    spacing: Sizes.dp(45 * .5)

    Item {
        width: parent.width/2
        height: Sizes.dp(72)
        Label {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: Sizes.dp(26)
            text: qsTr("Where do you want to go?")
        }
    }

    Button {
        id: searchButton
        enabled: !root.offlineMapsEnabled
        width: parent.width / 2
        height: Sizes.dp(72)
        scale: pressed ? 1.1 : 1.0
        Behavior on scale { NumberAnimation { duration: 50 } }

        contentItem: Item {
            Row {
                anchors.centerIn: parent
                spacing: Sizes.dp(45 * 0.3)
                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.PreserveAspectFit
                    source: Helper.localAsset("ic-search", Style.theme)
                    width: Sizes.dp(sourceSize.width)
                    height: Sizes.dp(sourceSize.height)
                }
                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.offlineMapsEnabled ? qsTr("Search not available offline") : qsTr("Search")
                    font.pixelSize: Sizes.fontSizeS
                }
            }
        }
        onClicked: root.openSearchTextInput()
    }
}
