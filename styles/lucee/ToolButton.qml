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
import QtQuick.Templates 2.5 as T
import QtQuick.Controls 2.5
import QtQuick.Controls.impl 2.5

import shared.utils 1.0
import shared.controls 1.0
import shared.Style 1.0
import shared.Sizes 1.0

T.ToolButton {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)
    baselineOffset: contentItem ? contentItem.y + contentItem.baselineOffset : 0

    padding: Sizes.dp(6)
    spacing: Sizes.dp(6)

    font.pixelSize: Sizes.fontSizeM
    font.family: Style.fontFamily
    opacity: enabled ? 1.0 : Style.defaultDisabledOpacity
    icon.color: (checked || highlighted) ? Style.accentColor : Style.contrastColor

    scale: pressed ? 1.1 : 1.0

    property alias iconFillMode: iconLabel.iconFillMode
    property alias iconRectWidth: iconLabel.iconRectWidth
    property alias iconRectHeight: iconLabel.iconRectHeight

    Behavior on scale { NumberAnimation { duration: 50 } }

    Cursor {
        onActivated: {
            control.clicked();
        }

        onPressAndHold: {
            control.pressAndHold();
        }
    }

    contentItem: NeptuneIconLabel {
        id: iconLabel

        readonly property real textOpacity: !enabled ? Style.defaultDisabledOpacity
                                                     : control.checkable && !control.checked && control.display === AbstractButton.TextUnderIcon // ToolsColumn
                                                       ? Style.opacityLow : Style.opacityHigh

        iconScale: Sizes.scale
        spacing: control.spacing
        mirrored: control.mirrored
        display: control.display
        icon: control.icon
        text: control.text
        font: control.font
        color: Qt.rgba(control.icon.color.r, control.icon.color.g, control.icon.color.b, textOpacity)
    }
}
