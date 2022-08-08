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

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import shared.utils
import shared.animations
import shared.controls
import shared.Style
import shared.Sizes

import "../controls"

ListView {
    id: root
    clip: true

    opacity: visible ? 1 : 0
    Behavior on opacity { DefaultNumberAnimation { } }

    property var store

    delegate: ItemDelegate { // FIXME right component?
        objectName: "contactNr_"  + index
        width: ListView.view.width
        height: Sizes.dp(96)
        contentItem: Item {
            anchors.fill: parent

            RowLayout {
                anchors.fill: parent

                RoundImage {
                    Layout.preferredHeight: Sizes.dp(64)
                    Layout.preferredWidth: Sizes.dp(64)
                    source: "../assets/profile_photos/%1.png".arg(model.handle)
                    enableOpacityMasks: store.allowOpenGLContent
                    leftPadding: Sizes.dp(16)
                    rightPadding: Sizes.dp(16)
                }

                Label {
                    objectName: "contactNameOfNr_"  + index

                    leftPadding: Sizes.dp(16)
                    font.weight: Font.Light
                    opacity: Style.opacityHigh
                    color: Style.contrastColor
                    text: model.firstName + " " + model.surname
                }

                Item { // spacer
                    Layout.fillWidth: true
                }

                ToolButton {
                    icon.name: "ic-message-contrast"
                    Layout.preferredWidth: Sizes.dp(96)
                    opacity: 0.6
                }

                ToolButton {
                    objectName: "callButtonContactNr_" + index
                    icon.name: "ic-call-contrast"
                    Layout.preferredWidth: Sizes.dp(96)
                    opacity: 0.6
                    onClicked: { root.store.startCall(model.handle); }
                }
            }

            Image {
                anchors.bottom: parent.bottom
                width: parent.width
                source: Style.image("list-divider")
                visible: (index < (root.count - 1))
            }
        }
    }
}
