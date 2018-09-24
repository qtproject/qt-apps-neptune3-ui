/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
** Copyright (C) 2018 Luxoft Sweden AB
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
import QtQuick.Templates 2.3 as T
import QtQuick.Controls 2.3
import QtQuick.Controls.impl 2.3

import shared.com.pelagicore.styles.neptune 3.0

T.ToolButton {
    id: control

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             contentItem.implicitHeight + topPadding + bottomPadding)
    baselineOffset: contentItem.y + contentItem.baselineOffset

    padding: NeptuneStyle.dp(6)
    spacing: NeptuneStyle.dp(6)

    font.pixelSize: NeptuneStyle.fontSizeM
    font.family: NeptuneStyle.fontFamily
    opacity: enabled ? 1.0 : NeptuneStyle.defaultDisabledOpacity
    icon.color: (checked || highlighted) ? NeptuneStyle.accentColor : NeptuneStyle.contrastColor

    scale: pressed ? 1.1 : 1.0
    Behavior on scale { NumberAnimation { duration: 50 } }

    contentItem: NeptuneIconLabel {
        readonly property real textOpacity: !enabled ? NeptuneStyle.defaultDisabledOpacity
                                                     : control.checkable && !control.checked && control.display === AbstractButton.TextUnderIcon // ToolsColumn
                                                       ? NeptuneStyle.opacityLow : NeptuneStyle.opacityHigh

        iconScale: NeptuneStyle.scale
        spacing: control.spacing
        mirrored: control.mirrored
        display: control.display
        icon: control.icon
        text: control.text
        font: control.font
        color: Qt.rgba(control.icon.color.r, control.icon.color.g, control.icon.color.b, textOpacity)
    }
}
