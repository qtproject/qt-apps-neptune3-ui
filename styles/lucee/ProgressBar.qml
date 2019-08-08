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

import shared.controls 1.0
import shared.Style 1.0
import shared.Sizes 1.0

T.ProgressBar {
    id: control

    property bool backgroundVisible: true

    readonly property real progressBarWidth: control.width - Sizes.dp(5)

    contentItem: NeptuneProgressBar {
        implicitWidth: control.progressBarWidth
        implicitHeight: Sizes.dp(7)
        scale: control.mirrored ? -1 : 1
        progress: control.position
        indeterminate: control.visible && control.indeterminate
        color: Style.accentColor
        radius: height / 2
    }

    background: Rectangle {
        visible: control.backgroundVisible
        anchors.verticalCenter: parent.verticalCenter
        implicitWidth: control.progressBarWidth
        implicitHeight: Sizes.dp(1)
        width: control.progressBarWidth
        height: implicitHeight
        //TODO check with designer if color is correct
        color: Style.contrastColor
        opacity: Style.opacityMedium
        radius: height / 2
    }
}
