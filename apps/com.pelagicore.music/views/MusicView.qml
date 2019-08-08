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
import QtQuick.Controls 2.2

import "../stores" 1.0
import "../panels" 1.0
import "../controls" 1.0

import shared.Sizes 1.0

Item {
    id: root

    property MusicStore store
    signal flickableAreaClicked()
    property alias fullscreenTopHeight: fullscreenTop.height
    property Item rootItem

    state: "Widget1Row"

    onStateChanged: {
        if (fullscreenTop.topExpanded) { fullscreenTop.topExpanded = false; }
    }

    WidgetContentView { //widget content (and items shared with fullscreen)
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: Sizes.dp(260)
        state: root.state
        store: root.store
        onFlickableAreaClicked: { root.flickableAreaClicked(); }
    }

    FullScreenTopView {  //but not items shared with widget
        id: fullscreenTop
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: topExpanded ? (root.height - Sizes.dp(100)) : (Sizes.dp(660 - 224))
        Behavior on height { DefaultNumberAnimation { duration: 270 } }
        opacity: root.state === "Maximized" ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation {} }
        visible: opacity > 0
        store: root.store
    }

    FullScreenBottomView {
        id: fullscreenBottom
        width: Sizes.dp(1080)
        anchors.left: parent.left
        anchors.leftMargin: root.state === "Maximized" ? 0 : -80
        Behavior on anchors.leftMargin { DefaultNumberAnimation {} }
        anchors.top: fullscreenTop.bottom
        anchors.bottom: parent.bottom

        opacity: root.state === "Maximized" && !fullscreenTop.topExpanded ? 1.0 : 0.0
        Behavior on opacity {
            SequentialAnimation {
                //delay fadeIn when playing queue is closing
                PauseAnimation { duration: root.state === "Maximized" && !fullscreenTop.topExpanded ? 0 : 100 }
                DefaultNumberAnimation {}
            }
        }
        visible: opacity > 0
        store: root.store
        rootItem: root.rootItem
    }
}
