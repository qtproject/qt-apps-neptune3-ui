/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Triton IVI UI.
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

import animations 1.0

/*
    Displays the main window of a given application using in and out transition animations

    When the given application gains its main window, ApplicationFrame will make it appear with a
    transition animation. Likewise when the application loses it.
 */
Item {
    id: root
    property var appInfo

    Binding {
        target: root.appInfo; property: "currentHeight"; value: root.height
    }

    Binding {
        target: root.appInfo; property: "windowState"; value: "Maximized"
    }

    QtObject {
        id: d
        property Item window: root.appInfo ? root.appInfo.window : null
        property Item currentWindow
    }

    states: [
        State {
            name: "showingWindow"
            when: d.window !== null
        }
    ]

    // TODO: Implement better in and out animations. The current ones are just placeholders
    transitions: [
        Transition {
            from: ""; to: "showingWindow"
            SequentialAnimation {
                ScriptAction { script: {
                    d.currentWindow = d.window;
                    d.currentWindow.parent = root;
                    d.currentWindow.x = 0;
                    d.currentWindow.y = 0;
                    d.currentWindow.z = 1;
                    d.currentWindow.width = Qt.binding(function() { return root.width; });
                    d.currentWindow.visible = true;
                }}
                DefaultNumberAnimation { target: root; property: "opacity"; from: 0; to: 1 }
            }
        },
        Transition {
            from: "showingWindow"; to: ""
            SequentialAnimation {
                DefaultNumberAnimation { target: root; property: "opacity"; from: 1; to: 0 }
                ScriptAction { script: {
                    d.currentWindow.parent = null;

                    // break bindings
                    d.currentWindow.width = d.currentWindow.width;
                    d.currentWindow.height = d.currentWindow.height;

                    d.currentWindow = null;
                }}
            }
        }
    ]
}
