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
import QtQuick.Layouts 1.3

import utils 1.0
import animations 1.0
import com.pelagicore.styles.triton 1.0
import triton.controls 1.0
import controls 1.0

TritonPopup {
    id: root

    width: Style.hspan(270/45)
    height: Style.vspan(1426/80)

    headerBackgroundVisible: true
    headerBackgroundHeight: Style.vspan(140/80)

    readonly property alias value: slider.value

    property var model

    readonly property string volumeIcon: {
        if (privateValues.muted) {
            return Style.symbol("ic-volume-0")
        } else if (value <= 33) {
            return Style.symbol("ic-volume-1")
        } else if (value <= 66) {
            return Style.symbol("ic-volume-2")
        } else {
            return Style.symbol("ic-volume-3")
        }
    }

    QtObject {
        id: privateValues
        property bool muted: false
    }

    Row {
        id: labelVolumeValue
        anchors.top: parent.top
        anchors.topMargin: Style.vspan(50/80)
        anchors.horizontalCenter: parent.horizontalCenter
        Label {
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: TritonStyle.fontSizeXL
            font.weight: Font.DemiBold
            opacity: TritonStyle.fontOpacityMedium
            text: value
        }
        Label {
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: TritonStyle.fontSizeL
            opacity: TritonStyle.fontOpacityLow
            text: " %"
        }
    }

    VolumeSlider {
        id: slider
        anchors.centerIn: parent
        height: Style.vspan(14)
        from: 0
        to: 100
        value: privateValues.muted ? 0 : Math.round(model.volume*100)
        onValueChanged: {
            if (model && !privateValues.muted) {
                model.setVolume(value/100.0)
            }
        }
    }

    AbstractButton {
        id: muteButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Style.vspan(40/80)
        width: Style.hspan(200/45)
        height: Style.vspan(100/80)
        checkable: true
        checked: privateValues.muted
        background: Rectangle {
            radius: height/2
            opacity: muteButton.checked ? 1 : 0.06
            color: muteButton.checked ? TritonStyle.accentColor : TritonStyle.contrastColor
        }
        Image {
            anchors.centerIn: parent
            source: Style.symbol("ic-volume-0")
        }
        onToggled: privateValues.muted = !privateValues.muted
    }
}
