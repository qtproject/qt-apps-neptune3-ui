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
import QtQuick.Templates 2.3 as T
import QtQuick.Controls 2.3
import QtQuick.Controls.impl 2.3

import shared.utils 1.0
import shared.animations 1.0
import shared.controls 1.0
import shared.Style 1.0
import shared.Sizes 1.0

// TODO: Fix the height and width more according to UI spec and based on external variables
// TODO: Provide a better way to develop these UI controls in a more controlable fashion

T.SwitchDelegate {
    id: control

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             Math.max(contentItem.implicitHeight,
                                      indicator ? indicator.implicitHeight : 0) + topPadding + bottomPadding)
    baselineOffset: contentItem.y + contentItem.baselineOffset

    padding: Sizes.dp(12)
    spacing: Sizes.dp(12)

    font.pixelSize: Sizes.fontSizeM
    font.family: Style.fontFamily
    font.weight: Font.Light

    Cursor {
        onActivated: {
            control.toggle();
        }
    }

    indicator: PaddedRectangle {
        implicitWidth: Sizes.dp(56)
        implicitHeight: Sizes.dp(32)

        x: text ? (control.mirrored ? control.leftPadding : control.width - width - control.rightPadding) : control.leftPadding + (control.availableWidth - width) / 2
        y: control.topPadding + (control.availableHeight - height) / 2

        radius: Sizes.dp(16)
        leftPadding: 0
        rightPadding: 0
        padding: (height - Sizes.dp(32)) / 2
        color: 'transparent'
        border.width: control.visualFocus ? Sizes.dp(2) : Sizes.dp(1.4)
        border.color: control.checked ? control.Style.accentColor : control.Style.contrastColor
        opacity: enabled ? Style.opacityHigh : Style.defaultDisabledOpacity

        Rectangle {
            x: Math.max(0, Math.min(parent.width - width, control.visualPosition * parent.width - (width / 2)))
            y: (parent.height - height) / 2
            width: Sizes.dp(28)
            height: Sizes.dp(28)
            radius: Sizes.dp(16)
            color: control.checked ? control.Style.accentColor : control.Style.contrastColor
            border.width: control.visualFocus ? Sizes.dp(2) : Sizes.dp(1)
            border.color: control.visualFocus ? control.palette.highlight : control.enabled ? control.palette.mid : control.palette.midlight

            Behavior on x {
                enabled: !control.down
                DefaultSmoothedAnimation {}
            }
        }
    }

    contentItem: NeptuneIconLabel {
        iconScale: Sizes.scale

        leftPadding: control.mirrored ? control.indicator.width + control.spacing : 0
        rightPadding: !control.mirrored ? control.indicator.width + control.spacing : 0

        spacing: control.spacing
        mirrored: control.mirrored
        display: control.display
        alignment: control.display === IconLabel.IconOnly || control.display === IconLabel.TextUnderIcon ? Qt.AlignCenter : Qt.AlignLeft

        icon: control.icon
        text: control.text
        font: control.font
        opacity: enabled ? Style.opacityHigh : Style.defaultDisabledOpacity
        color: Style.contrastColor
    }
}
