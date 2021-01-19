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
import application.windows 1.0
import shared.utils 1.0
import shared.animations 1.0
import shared.controls 1.0
import QtGraphicalEffects 1.0

import shared.Style 1.0
import shared.Sizes 1.0

import "views" 1.0
import "controls" 1.0
import "stores" 1.0

ApplicationCCWindow {
    id: root

    MultiPointTouchArea {
        id: multiPoint
        anchors.fill: parent
        anchors.margins: Sizes.dp(30)
        touchPoints: [ TouchPoint { id: touchPoint1 } ]

        onReleased: {
            root.riseWindow()
        }
    }

    ScalableBorderImage {
        id: fullscreenTopPartBackground

        x: root.exposedRect.x
        y: 0
        width: root.exposedRect.width
        height: Sizes.dp(660)

        border{
            //don't change these values without knowing the exact size of source image
            //QTBUG-73768 if border exceeds source image size, app crashes, avoid Sizes.dp here
            bottom: 0
            top: sourceSize.height - 1
            left: 0
            right: 0
        }

        opacity: (root.neptuneState === "Maximized") ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation {} }
        visible: opacity > 0

        source: Style.image("app-fullscreen-top-bg")
    }

    BlurredImageBackground {
        opacity: (root.neptuneState === "Maximized" && phone.callerHandle !== "") ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation {} }
        visible: opacity > 0
        anchors.fill: fullscreenTopPartBackground
        callerHandle: phone.callerHandle
        enableOpacityMasks: store.allowOpenGLContent
    }

    PhoneStore { id: store; onRequestRaiseAppReceived: root.riseWindow(); }

    PhoneView {
        id: phone
        x: root.exposedRect.x
        y: 0//root.exposedRect.y
        width: root.exposedRect.width
        height: (root.exposedRect.height + root.exposedRect.y)
        state: root.neptuneState
        onActivateApp: root.riseWindow()
        store: store
    }
}
