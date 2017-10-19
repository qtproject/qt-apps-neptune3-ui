/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
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

import QtQuick 2.8
import QtQuick.Controls 2.1
import QtQuick.Controls.impl 2.1

Item {
    implicitWidth: 56
    implicitHeight: 28

    property Item control

    Rectangle {
        y: parent.height / 2 - height / 2
        width: 56
        height: 16
        radius: 8
        color: control.checked ? (control.visualFocus ? Default.focusColor : Default.buttonCheckedColor) : Default.buttonColor
        border.width: control.visualFocus ? 2 : 0
        border.color: Default.focusColor
    }

    Rectangle {
        x: Math.max(0, Math.min(parent.width - width, control.visualPosition * parent.width - (width / 2)))
        y: (parent.height - height) / 2
        width: 28
        height: 28
        radius: 16
        color: control.enabled ? (control.down
            ? (control.visualFocus ? Default.focusPressedColor : Default.indicatorPressedColor)
            : (control.visualFocus ? Default.focusLightColor : Default.backgroundColor)) : Default.indicatorDisabledColor
        border.width: control.visualFocus ? 2 : 1
        border.color: control.enabled ? (control.visualFocus
            ? Default.focusColor
            : (control.down ? Default.indicatorFramePressedColor : Default.indicatorFrameColor)) : Default.indicatorFrameDisabledColor

        Behavior on x {
            enabled: !control.down
            SmoothedAnimation { velocity: 200 }
        }
    }
}
