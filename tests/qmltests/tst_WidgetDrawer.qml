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

import QtQuick
import QtTest

// sysui, for getting WidgetDrawer
import centerconsole

import shared.utils

Item {
    id: root
    width: 600
    height: 600

    WidgetDrawer {
        id: widgetDrawer
        y: 200
        width: 600
        height: 200

        // A fake application widget
        MultiPointTouchArea {
            anchors.fill: parent
            Rectangle { color: "green"; anchors.fill: parent }
        }
    }

    NeptuneTestCase {
        name: "WidgetDrawer"

        /*
            Drag the WidgetDrawer all the way right (having it almost closed/out of screen) and then
            move it back, closer to its fully open position, where you finally lift your finger.

            The WidgetDrawer should then animate back to its fully opened state from where you left it.
        */
        function test_dragRightAndBackLeft() {
            var yPos = widgetDrawer.y + widgetDrawer.height/2;

            touchDrag(root, 1, yPos, root.width*0.8, yPos,
                    true /* beginTouch */, false /* endTouch */);

            touchDrag(root, root.width*0.8, yPos, root.width*0.35, yPos,
                    false /* beginTouch */, false /* endTouch */);

            var event = touchEvent(root);
            event.release(0 /* touchId */, root, root.width*0.35, yPos);
            event.commit();

            tryCompare(widgetDrawer, "x", 0, 2000 /* timeout */,
                    "WidgetDrawer didn't move all the way back to its opened state.")
        }
    }
}
