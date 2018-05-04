/****************************************************************************
**
** Copyright (C) 2017-2018 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 IVI UI.
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
import QtApplicationManager 1.0

import animations 1.0
import com.pelagicore.styles.neptune 3.0

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
        target: root.appInfo; property: "currentWidth"; value: root.width
    }

    Binding {
        target: root.appInfo; property: "windowScale"; value: root.NeptuneStyle.scale
    }

    Binding {
        target: root.appInfo; property: "windowState"; value: "Maximized"
    }

    visible: children.length > 0

    QtObject {
        id: d

        property var window: root.appInfo ? root.appInfo.window : null
        onWindowChanged: {
            if (currentMaxWindow) {
                currentMaxWindow.removeAnimation.start();
                currentMaxWindow = null;
            }

            if (window) {
                currentMaxWindow = maximizedWindowComponent.createObject(d, {"parent":root,"window":window});
                window.parent = root;
                currentMaxWindow.addAnimation.start();
            }
        }

        property var currentMaxWindow: null
    }

    // TODO: Implement better in and out animations. The current ones are just placeholders

    Component {
        id: maximizedWindowComponent
        WindowItem {
            id: maxWindowObj
            anchors.fill: parent
            property var addAnimation: SequentialAnimation {
                DefaultNumberAnimation { target: maxWindowObj; property: "opacity"; from: 0; to: 1 }
            }
            property var removeAnimation: SequentialAnimation {
                DefaultNumberAnimation { target: maxWindowObj; property: "opacity"; from: 1; to: 0 }
                ScriptAction { script: {
                    // self destruct
                    maxWindowObj.destroy();
                }}
            }
        }
    }
}
