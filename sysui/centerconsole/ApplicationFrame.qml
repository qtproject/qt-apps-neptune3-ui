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

import QtQuick 2.7

import shared.animations 1.0
import system.controls 1.0
import shared.Style 1.0
import shared.Sizes 1.0

/*
    Displays the main window of a given application using in and out transition animations

    When the given application gains its main window, ApplicationFrame will make it appear with a
    transition animation. Likewise when the application loses it.
 */
Item {
    id: root
    property var appInfo
    property real exposedRectTopMargin
    property real exposedRectBottomMargin

    visible: children.length > 0

    QtObject {
        id: d

        property var prevWindow
        property var currentMaxWindowItem: null
        property var window: root.appInfo ? root.appInfo.window : null
        onWindowChanged: {
            // only apply the in and out animations when incoming window is different
            // than the previous one.
            if (d.window !== d.prevWindow) {
                d.prevWindow = d.window;
                if (d.currentMaxWindowItem) {
                    d.currentMaxWindowItem.removeAnimation.start();
                    d.currentMaxWindowItem = null;
                }

                if (d.window) {
                    d.currentMaxWindowItem = maximizedWindowComponent.createObject(
                                d, {"parent":root, "appInfo": root.appInfo});
                    d.window.parent = root;
                    d.currentMaxWindowItem.addAnimation.start();
                }
            }
        }
    }

    // TODO: Implement better in and out animations. The current ones are just placeholders

    Component {
        id: maximizedWindowComponent
        ApplicationCCWindowItem {
            id: maxWindowObj
            anchors.fill: parent

            currentHeight: root.height
            currentWidth: root.width
            exposedRectTopMargin: root.exposedRectTopMargin
            exposedRectBottomMargin: root.exposedRectBottomMargin

            windowState: "Maximized"

            property var addAnimation: SequentialAnimation {
                ScriptAction { script: { maxWindowObj.windowState = "Maximized"; }}
                DefaultNumberAnimation { target: maxWindowObj; property: "opacity"; from: 0; to: 1 }
            }
            property var removeAnimation: SequentialAnimation {
                ScriptAction { script: { maxWindowObj.windowState = "Minimized"; }}
                DefaultNumberAnimation { target: maxWindowObj; property: "opacity"; from: 1; to: 0 }
                ScriptAction { script: { maxWindowObj.destroy(); }}
            }
        }
    }
}
