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

import QtQuick 2.6
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import utils 1.0
import animations 1.0
import com.pelagicore.styles.neptune 3.0
import controls 1.0

NeptunePopup {
    id: root

    width: NeptuneStyle.dp(270)
    height: NeptuneStyle.dp(1426)

    headerBackgroundVisible: true
    headerBackgroundHeight: NeptuneStyle.dp(140)

    readonly property alias value: slider.value

    property var model

    Row {
        id: labelVolumeValue
        anchors.top: parent.top
        anchors.topMargin: NeptuneStyle.dp(50)
        anchors.horizontalCenter: parent.horizontalCenter
        Label {
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: NeptuneStyle.fontSizeXL
            font.weight: Font.DemiBold
            opacity: NeptuneStyle.opacityMedium
            text: value
        }
        Label {
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: NeptuneStyle.fontSizeL
            opacity: NeptuneStyle.opacityLow
            text: " %"
        }
    }

    VolumeSlider {
        id: slider
        anchors.centerIn: parent
        height: NeptuneStyle.dp(1120)
        from: 0
        to: 100
        value: root.model && root.model.muted ? 0 : Math.round(model.volume*100)
        onValueChanged: {
            if (root.model && !root.model.muted) {
                model.setVolume(value/100.0)
            }
        }
    }

    Button {
        id: muteButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: NeptuneStyle.dp(40)
        width: NeptuneStyle.dp(200)
        height: NeptuneStyle.dp(100)
        checkable: true
        checked: root.model ? root.model.muted : false
        icon.name: "ic-volume-0"
        onToggled: if (root.model) { root.model.muted = !root.model.muted }
    }
}
