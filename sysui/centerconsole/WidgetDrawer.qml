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
import shared.utils 1.0
import shared.Sizes 1.0

/*
  Displays a child item on the screen which can be dismissed by swiping it to the right.

  It will them remain on the right side of the screen, with just a small part of its left
  side sticking out so that it can be dragged back into full view.

  Usage:

  WidgetDrawer {
     anchors.left: parent.left
     anchors.right: parent.right
     height: someHeight
     SomeItem {}
  }
 */
Item {
    id: root

    // how much of it should be sticking out from the right side of the display when
    // the widget drawer has been closed
    readonly property real stickOutWidth: Sizes.dp(90)

    property Item slot: widgetDrawerSlot
    property alias slotWidth: widgetDrawerSlot.width
    property alias slotHeight: widgetDrawerSlot.height
    property alias empty: widgetDrawerSlot.empty

    // true if in full view, false if it's tucked away on the right side of the display
    property bool open: true
    onOpenChanged: d.applyOpenState()

    opacity: 0.5 + 0.5 * (1 - Math.abs(root.x) / d.widthWithoutStick)

    Item {
        id: widgetDrawerSlot
        anchors.horizontalCenter: root.horizontalCenter
        readonly property bool empty: children.length === 0
    }

    MouseArea {
        id: handl
        width: root.stickOutWidth
        height: root.height
        anchors.left: root.left

        drag.target: root
        drag.axis: Drag.XAxis

        drag.minimumX: d.layoutMirroringEnabled ? - d.widthWithoutStick : 0
        drag.maximumX: d.layoutMirroringEnabled ? 0 : d.widthWithoutStick
    }

    Connections {
        target: handl.drag
        function onActiveChanged() {
            if (handl.drag.active) {
                d.lastX = root.x;
                d.direction = 0;
                d.dragging = true;
            } else {
                d.dragging = false;
                var delta = Math.abs(d.lastX - d.startX);
                if (delta >= d.minimumDrag) {
                    if (d.direction === 1 && root.open) {
                        root.open = false;
                    } else if (d.direction === -1 && !root.open) {
                        root.open = true;
                    } else {
                        d.applyOpenState();
                    }
                } else {
                    d.applyOpenState();
                }
            }
        }
    }

    QtObject {
        id: d
        property real startX
        property real lastX
        property int direction
        property bool dragging: false
        readonly property real minimumDrag: Sizes.dp(90)
        readonly property real widthWithoutStick: root.width - root.stickOutWidth
        readonly property bool layoutMirroringEnabled: root.LayoutMirroring.enabled

        onLayoutMirroringEnabledChanged: {
            d.dragging = true
            d.applyOpenState()
        }

        function applyOpenState() {
            if (root.open) {
                root.x = 0;
            } else {
                root.x = d.layoutMirroringEnabled ? - d.widthWithoutStick : d.widthWithoutStick;
            }
        }
    }
    onXChanged: {
        if (!d.dragging) {
            return;
        }
        let isDirectionForOpening = d.layoutMirroringEnabled ? (x < d.lastX) : (x > d.lastX)
        if (isDirectionForOpening) {
            if (d.direction !== 1) {
                d.direction = 1;
                d.startX = x;
            }
        } else if (d.direction !== -1) {
            d.direction = -1;
            d.startX = x;
        }
        d.lastX = x;
    }

    Behavior on x {
        SmoothedAnimation {
            easing.type: Easing.InOutQuad
            velocity: Sizes.dp(1800)
        }
        enabled: !d.dragging
    }
}
