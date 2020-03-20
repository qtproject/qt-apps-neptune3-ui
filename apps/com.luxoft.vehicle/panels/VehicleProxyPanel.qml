/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
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

import QtQuick 2.9
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.12

import shared.Sizes 1.0
import shared.Style 1.0

import "../helpers"  1.0

Item {
    id: root
    anchors.fill: parent

    property string errorText: ""

    Image {
        id: proxyImage
        anchors.fill: parent
        source: Style.theme === Style.Dark
                ? Paths.getImagePath("carPlaceholderCC-dark.png")
                : Paths.getImagePath("carPlaceholderCC-light.png")
    }

    Label {
        anchors.top: proxyImage.top
        anchors.topMargin: Sizes.dp(160)
        anchors.horizontalCenter: proxyImage.horizontalCenter
        text: errorText
        font.pixelSize: Sizes.fontSizeL
        visible: errorText.length !== 0
    }

    ProgressBar {
        anchors.bottom: parent.bottom
        implicitWidth: parent.width
        implicitHeight: Sizes.dp(8)
        from: 0
        to: 1
        value: 0
        indeterminate: true
        backgroundVisible: false
        SequentialAnimation on value {
            loops: Animation.Infinite
            PropertyAnimation { to: 0; duration: 1000 }
            PropertyAnimation { to: 1; duration: 1000 }
        }
    }
}
