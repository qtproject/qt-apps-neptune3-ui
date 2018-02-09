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
import QtQuick.Layouts 1.3
import QtQuick.Templates 2.2 as T
import com.pelagicore.styles.triton 1.0

T.Button {
    id: control
    implicitWidth: TritonStyle.cellWidth + leftPadding + rightPadding
    implicitHeight: TritonStyle.cellHeight + leftPadding + rightPadding

    padding: 6
    leftPadding: padding + 2
    rightPadding: padding + 2
    font.pixelSize: TritonStyle.fontSizeM
    font.weight: Font.Light

    contentItem: Text {
        Layout.fillHeight: true
        Layout.fillWidth: true
        text: control.text
        font: control.font
        opacity: enabled || control.highlighted || control.checked ?
                     TritonStyle.fontOpacityHigh : TritonStyle.fontOpacityLow

        color: TritonStyle.primaryTextColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        wrapMode: Text.WordWrap
    }

    background: Rectangle {
        border.width: !control.enabled && !control.checked ? 2 : 0
        border.color: TritonStyle.contrastColor

        color: {
            if (control.checked) {
                return TritonStyle.accentColor;
            } else if (!control.enabled) {
                return "transparent"
            } else {
                return TritonStyle.contrastColor;
            }
        }

        opacity: {
            if (control.pressed && !control.checked) {
                return 0.12;
            } else if (control.checked) {
                return 1.0;
            } else {
                return 0.06;
            }
        }
        Behavior on opacity { NumberAnimation { duration: 200 } }

        radius: width / 2
    }
}
