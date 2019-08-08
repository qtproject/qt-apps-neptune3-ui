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
import QtQuick.Layouts 1.3

import shared.utils 1.0
import shared.animations 1.0
import shared.Style 1.0
import shared.controls 1.0
import shared.Sizes 1.0
import system.controls 1.0

PopupItem {
    id: root
    objectName: "volumePopupItem"

    width: Sizes.dp(270)
    height: Sizes.dp(1426)

    headerBackgroundVisible: true
    headerBackgroundHeight: Sizes.dp(140)

    readonly property alias value: slider.value

    property var model

    Row {
        id: labelVolumeValue
        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(50)
        anchors.horizontalCenter: parent.horizontalCenter
        Label {
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: Sizes.fontSizeXL
            font.weight: Font.DemiBold
            opacity: Style.opacityMedium
            text: value
        }
        Label {
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: Sizes.fontSizeL
            opacity: Style.opacityLow
            text: " %"
        }
    }

    VolumeSlider {
        id: slider
        objectName: "volumeSlider"
        anchors.centerIn: parent
        height: Sizes.dp(1120)
        from: 0
        to: 100
        value: Math.round(root.model.volume*100)
        onValueChanged: {
            if (root.model) {
                if (root.model.muted) {
                    root.model.setMuted(false);
                }
                model.setVolume(value/100.0);
            }
        }
    }

    Button {
        id: muteButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Sizes.dp(40)
        width: Sizes.dp(200)
        height: Sizes.dp(100)
        checkable: true
        checked: root.model ? root.model.muted : false
        icon.name: "ic-volume-0"
        onToggled: if (root.model) { root.model.setMuted(!root.model.muted); }
    }
}
