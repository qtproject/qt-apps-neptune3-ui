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

import QtTest

/*
    Collects some generally useful functions for test cases.
 */
TestCase {
    when: windowShown

    function touchDrag(item, x, y, toX, toY, beginTouch, endTouch, timeStep, iterations) {
        if (!item)
            qtest_fail("no item given", 1);

        // Make sure the item is rendered
        waitForRendering(item);

        var root = fetchRootItem(item);
        var rootFrom = item.mapToItem(root, x, y);
        var rootTo = item.mapToItem(root, toX, toY);

        // Default to true for beginTouch if not present
        beginTouch = (beginTouch !== undefined) ? beginTouch : true

        // Default to true for endTouch if not present
        endTouch = (endTouch !== undefined) ? endTouch : true

        // Set a default timeStep if not specified
        timeStep = (timeStep !== undefined) ? timeStep : 25

        // Set a default iterations if not specified
        var iterations = (iterations !== undefined) ? iterations : 10

        var diffX = (rootTo.x - rootFrom.x) / iterations
        var diffY = (rootTo.y - rootFrom.y) / iterations
        if (beginTouch) {
            var event = touchEvent(item)
            event.press(0 /* touchId */, root, rootFrom.x, rootFrom.y)
            event.commit()
        }
        for (var i = 0; i < iterations; ++i) {
            if (i === iterations - 1) {
                // Avoid any rounding errors by making the last move be at precisely
                // the point specified
                wait(timeStep)
                var event = touchEvent(item)
                event.move(0 /* touchId */, root, rootTo.x, rootTo.y)
                event.commit()
            } else {
                wait(timeStep)
                var event = touchEvent(item)
                event.move(0 /* touchId */, root, rootFrom.x + (i + 1) * diffX, rootFrom.y + (i + 1) * diffY)
                event.commit()
            }
        }
        if (endTouch) {
            var event = touchEvent(item)
            event.release(0 /* touchId */, root, rootTo.x, rootTo.y)
            event.commit()
        }
    }

    function fetchRootItem(item) {
        if (!item)
            qtest_fail("no item given", 1);

        if (item.parent)
            return fetchRootItem(item.parent)
        else
            return item
    }
}
