/****************************************************************************
**
** Copyright (C) 2020 Luxoft Sweden AB
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

import QtQuick 2.14
import QtQuick.Controls 2.14

import shared.utils 1.0
import shared.Style 1.0
import shared.Sizes 1.0
import shared.animations 1.0

import "../helpers" 1.0

Item {
    id: root

    property bool clusterWindow: false
    property alias errorText: errorLabel.text

    clip: true

    Image {
        width: root.clusterWindow
                ? Sizes.dp(Config.instrumentClusterWidth)
                : Sizes.dp(Config.centerConsoleWidth)
        height: root.clusterWindow
                ? Sizes.dp(Config.instrumentClusterWidth / Config.instrumentClusterUIAspectRatio)
                : Sizes.dp(Config.centerConsoleHeight)

        anchors.centerIn: root
        source: root.clusterWindow
                ? Helper.localAsset("proxy-cluster", Style.theme)
                : Helper.localAsset("proxy-CC", Style.theme)
    }

    Image {
        anchors.fill: root
        source: Helper.localAsset("bg-home-navigation-overlay", Style.theme)
        visible: root.clusterWindow && mainWindow.neptuneState === "Maximized"
        scale: mainWindow.neptuneState === "Maximized" ? 1.2 : 1.6
        Behavior on scale {
            DefaultNumberAnimation { }
        }
    }

    Label {
        id: errorLabel
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        font.pixelSize: Sizes.fontSizeM
        font.bold: true

        anchors.topMargin: root.clusterWindow
            ? root.height / 2
            : mainWindow.currentHeight / 2

        Behavior on anchors.topMargin {
            DefaultNumberAnimation { }
        }
    }
}
