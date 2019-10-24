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

import QtQuick 2.8

import shared.utils 1.0
import shared.animations 1.0
import shared.controls 1.0

import shared.Style 1.0
import shared.Sizes 1.0
import "../helpers" 1.0

Item {
    id: root

    property int destinationButtonrowHeight: 0

    height: destinationButtonsPanel.visible
            ? Sizes.dp(destinationButtonsPanel.sourceSize.height)
            : searchPanel.height
    ScalableBorderImage {
        id: outerShadow
        anchors.top: destinationButtonsPanel.top
        anchors.topMargin: Sizes.dp(-40)
        anchors.left: destinationButtonsPanel.left
        anchors.right: destinationButtonsPanel.right
        anchors.rightMargin: -Sizes.dp(45 * .5)
        height: root.state === "initial"
                ? Sizes.dp(sourceSize.height) * 0.7
                : Sizes.dp(sourceSize.height) * 0.7 - root.destinationButtonrowHeight
        source: Helper.localAsset("panel-shadow", Style.theme)
        border {
            //don't change these values without knowing the exact size of source image
            //QTBUG-73768 if border exceeds source image size, app crashes, avoid Sizes.dp here
            left: 0
            top: 101
            right: 101
            bottom: 106
        }
    }

    ScalableBorderImage {
        id: destinationButtonsPanel
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: -Sizes.dp(45)
        source: Helper.localAsset("panel-more-contrast-background", Style.theme)
        visible: root.state === "initial"
        height: Sizes.dp(sourceSize.height) * 0.7
        border {
            //don't change these values without knowing the exact size of source image
            //QTBUG-73768 if border exceeds source image size, app crashes, avoid Sizes.dp here
            left: 0
            top: 20
            right: 20
            bottom: 22
        }
    }

    Image {
        id: innerShadow
        anchors.top: searchPanel.bottom
        anchors.right: searchPanel.right
        anchors.left: searchPanel.left
        width: searchPanel.width
        source: Style.image("panel-inner-shadow")
    }

    ScalableBorderImage {
        id: searchPanel
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: -Sizes.dp(45)
        height: Sizes.dp(destinationButtonsPanel.sourceSize.height) * 0.7
                    - root.destinationButtonrowHeight
        source: Helper.localAsset("panel-background", Style.theme)
        border {
            //don't change these values without knowing the exact size of source image
            //QTBUG-73768 if border exceeds source image size, app crashes, avoid Sizes.dp here
            left: 0
            top: 20
            right: 22
            bottom: 0
        }
    }
}
