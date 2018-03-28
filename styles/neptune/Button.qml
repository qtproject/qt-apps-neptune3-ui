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

import QtQuick 2.10
import QtQuick.Layouts 1.3
import QtQuick.Templates 2.3 as T
import QtQuick.Controls 2.3
import QtQuick.Controls.impl 2.3

import com.pelagicore.styles.neptune 3.0

T.Button {
    id: control

    property string customBackgroundColor: ""

    implicitWidth: NeptuneStyle.cellWidth + leftPadding + rightPadding
    implicitHeight: NeptuneStyle.cellHeight + leftPadding + rightPadding

    padding: NeptuneStyle.dp(6)
    leftPadding: padding + NeptuneStyle.dp(2)
    rightPadding: padding + NeptuneStyle.dp(2)
    font.pixelSize: NeptuneStyle.fontSizeM
    font.weight: Font.Light
    spacing: NeptuneStyle.dp(22)

    icon.color: NeptuneStyle.primaryTextColor

    contentItem: IconLabel {
        spacing: control.spacing
        mirrored: control.mirrored
        display: control.display

        anchors.verticalCenter: control.verticalCenter
        icon: control.icon
        text: control.text
        font: control.font
        color: NeptuneStyle.primaryTextColor
        opacity: control.enabled ? 1.0 : 0.3
    }

    background: Rectangle {
        border.width: !control.enabled && !control.checked ? NeptuneStyle.dp(2) : 0
        border.color: NeptuneStyle.contrastColor
        visible: !control.flat
        color: {
            if (customBackgroundColor !== "") {
                if (control.pressed) {
                    return Qt.darker(customBackgroundColor, (1 / 0.94))
                }
                return customBackgroundColor;
            } else if (control.checked) {
                return NeptuneStyle.accentColor;
            } else if (!control.enabled) {
                return "transparent";
            } else {
                return NeptuneStyle.contrastColor;
            }
        }
        opacity: {
            if (control.pressed && !control.checked && customBackgroundColor === "") {
                return 0.12;
            } else if (control.checked || customBackgroundColor !== "") {
                return 1.0;
            } else {
                return 0.06;
            }
        }
        Behavior on opacity { NumberAnimation { duration: 200 } }
        Behavior on color { ColorAnimation { duration: 200 } }

        radius: width / 2
    }
}
