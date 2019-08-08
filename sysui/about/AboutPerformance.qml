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

import shared.Sizes 1.0

Flickable {
    id: root

    property var applicationModel
    property var systemModel

    clip: true
    contentWidth: column.width
    contentHeight: column.height

    flickableDirection: Flickable.VerticalFlick
    ScrollIndicator.vertical: ScrollIndicator {}

    Column {
        id: column
        width: root.width - Sizes.dp(20)

        topPadding: Sizes.dp(20)
        spacing: Sizes.dp(20)

        Label {
            width: parent.width
            wrapMode: Text.WordWrap
            text: qsTr("Enabling performance monitoring forces System UI " +
                        " to constantly redraw itself, therefore having a constant," +
                        " unnecessary, GPU/CPU consumption.")
            font.pixelSize: Sizes.fontSizeS
        }

        SwitchDelegate {
            width: parent.width
            text: qsTr("Center Console Performance Overlay")
            checked: root.systemModel ? root.systemModel.centerConsolePerfOverlayEnabled : false
            onToggled: {
                root.systemModel.centerConsolePerfOverlayEnabled = checked;
            }
        }

        SwitchDelegate {
            width: parent.width
            text: qsTr("Instrument Cluster Performance Overlay")
            checked: root.systemModel ? root.systemModel.instrumentClusterPerfOverlayEnabled : false
            onToggled: {
                root.systemModel.instrumentClusterPerfOverlayEnabled = checked;
            }
        }
    }
}
