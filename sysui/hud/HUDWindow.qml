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
import QtQuick.Controls 2.2
import shared.utils 1.0
import system.controls 1.0
import QtQuick.Window 2.3
import shared.Sizes 1.0
import shared.Style 1.0

Window {
    id: root

    property var hudAppInfo
    property var hudStore

    color: "black"
    title: "Neptune 3 UI - HUD"
    screen: root.hudStore.hudScreen

    onWidthChanged: {
        root.contentItem.Sizes.scale = root.width / Config.hudWidth;
    }

    Component.onCompleted: {
        // Would be better to use a regular property binding instead. But somehow, it doesn't work.
        visible = true;

        // Don't use bindings for setting up the initial size. Otherwise the binding is revaluated
        // on every language change, which results in resetting the window size to it's initial state
        // and might overwrite the size given by the OS or the user using the WindowManager
        // It happens because QQmlEngine::retranslate() refreshes all the engine's bindings
        width = Config.hudWidth
        height = Config.hudHeight
    }

    Item {
        anchors.centerIn: parent
        width: parent.width
        height: width / Config.hudAspectRatio

        NeptuneWindowItem {
            anchors.fill: parent
            window: hudAppInfo ?
                    hudAppInfo.window : null
        }
    }
}
