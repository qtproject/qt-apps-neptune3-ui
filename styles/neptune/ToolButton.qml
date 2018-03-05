/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
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


import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.impl 2.2
import QtQuick.Templates 2.2 as T
import com.pelagicore.styles.neptune 3.0
import controls 1.0

T.ToolButton {
    id: control

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             contentItem.implicitHeight + topPadding + bottomPadding)
    baselineOffset: contentItem.y + contentItem.baselineOffset

    padding: 6
    font.pixelSize: control.NeptuneStyle.fontSizeM
    font.family: control.NeptuneStyle.fontFamily

    scale: pressed ? 1.1 : 1.0
    Behavior on scale { NumberAnimation { duration: 50 } }

    // 5.9 does not support icon property and its subsidiaries.
    //icon.width: Symbol.symbolSizeM
    //icon.height: Symbol.symbolSizeM
    //icon.color: checked ? "#f07d00" : "transparent"

    // TODO: We should probably try to find something better than this solution. This will
    // forward the signal to the control itself. Without this, it can only be clicked on the
    // the rendered indicator.
    background: MouseArea {
        id: mouseArea
        implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding
        implicitWidth: implicitHeight
        onPressed: mouse.accepted = false
        onReleased: mouse.accepted = false
        onClicked: control.clicked()
    }

    contentItem: Label {
        text: control.text
    }
}