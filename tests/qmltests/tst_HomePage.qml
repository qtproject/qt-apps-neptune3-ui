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

import QtQuick 2.6
import QtTest 1.1

// sysui, for getting HomePage
import display 1.0

Item {
    width: 600
    height: 600

    QtObject {
        id: redApp
        property Item window
        property Item loadedWindow: Rectangle { color: "red" }

        property bool active: false
        property bool canBeActive: true

        property int heightRows: 1
        property int minHeightRows: 1

        function start() {
            window = loadedWindow;
        }
    }

    QtObject {
        id: greenApp
        property Item window
        property Item loadedWindow: Rectangle { color: "green" }

        property bool active: false
        property bool canBeActive: true

        property int heightRows: 2
        property int minHeightRows: 1

        function start() {
            window = loadedWindow;
        }
    }

    QtObject {
        id: blueApp
        property Item window
        property Item loadedWindow: Rectangle { color: "blue" }

        property bool active: false
        property bool canBeActive: true

        property int heightRows: 2
        property int minHeightRows: 1

        function start() {
            window = loadedWindow;
        }
    }

    HomePage {
        id: homePage
        anchors.fill: parent
        widgetsList: ListModel { id: listModel  }
        Component.onCompleted: {
            listModel.append({"appInfo":redApp})
            listModel.append({"appInfo":greenApp})
            listModel.append({"appInfo":blueApp})
        }
    }

    TritonTestCase {
        name: "HomePage"

        /*
            While dragging a resize handle, if the widget next to it cannot be
            squeezed, squeeze the one after it, if possible.
         */
        function test_resizePropagates() {
            // check start conditions
            compare(listModel.count, 3);
            compare(listModel.get(0).appInfo.heightRows, 1);
            compare(listModel.get(1).appInfo.heightRows, 2);
            compare(listModel.get(2).appInfo.heightRows, 2);


            // get the resize handle that's under the first (top) widget, redApp.
            var resizeHandle = findChild(homePage, "resizeHandle0");
            verify(resizeHandle);

            // drag the top-most resize handle all the way to the bottom of the screen
            touchDrag(resizeHandle,
                      resizeHandle.width/2, resizeHandle.height/2,
                      resizeHandle.width/2, resizeHandle.height/2 + homePage.height);

            // Both the second and the third widget (top to bottom order) should have shrunk to make space for the
            // enlarged top widget
            compare(listModel.get(0).appInfo.heightRows, 3);
            compare(listModel.get(1).appInfo.heightRows, 1);
            compare(listModel.get(2).appInfo.heightRows, 1);

        }

    }
}

