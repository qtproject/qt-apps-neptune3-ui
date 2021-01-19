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

import QtQuick 2.6
import QtQuick.Controls 2.2

import shared.Style 1.0
import shared.Sizes 1.0
import shared.controls 1.0

AbstractPopupItem {
    id: root

    property alias closeToolButton: closeToolButton
    property alias popupBg: popupBg

    onVisibleChanged: {
        if (visible) {
            //put cursor on close button as default
            closeToolButton.forceActiveFocus();
        }
    }

    ScalableBorderImage {
        anchors.top: parent.top
        width: parent.width
        height: root.headerBackgroundHeight
        visible: root.headerBackgroundVisible
        source: Style.image("floating-panel-top-bg")
        border {
            //don't change these values without knowing the exact size of source image
            //QTBUG-73768 if border exceeds source image size, app crashes, avoid Sizes.dp here
            left: 56
            top: 55
            right: 56
            bottom: 0
        }
    }
    background: ScalableBorderImage {
        id: popupBg
        anchors.fill: root
        source: Style.image("popup-background-9patch")
        anchors.leftMargin: Sizes.dp(-7)
        anchors.rightMargin: Sizes.dp(-7)
        anchors.topMargin: Sizes.dp(-7)
        anchors.bottomMargin: Sizes.dp(-7)

        border{
            //don't change these values without knowing the exact size of source image
            //QTBUG-73768 if border exceeds source image size, app crashes, avoid Sizes.dp here
            left: 69
            right: 69
            top: 65
            bottom: 67
        }

        // click eater
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.AllButtons
            onWheel: wheel.accepted = true;
        }
    }

    ToolButton {
        id: closeToolButton
        z: parent.z + 1 // close button should be upper then content
        objectName: "popupClose"
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: Sizes.dp(17)
        width: Sizes.dp(50)
        height: Sizes.dp(50)
        icon.color: Style.accentColor
        icon.name: "ic-close"
        onClicked: { root.closeHandler(); }
    }
}
