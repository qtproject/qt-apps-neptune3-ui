/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
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

import QtQuick 2.6
import QtTest 1.1

// sysui, for getting WidgetGrid
import home 1.0

import shared.utils 1.0

Item {
    id: root
    width: 600
    height: 600

    FakeAppInfo {
        id: redApp
        property Item window: Rectangle {
            color: "red"
            function setWindowProperty(name, value) {}
        }
    }

    FakeAppInfo {
        id: greenApp
        property Item window: Rectangle {
            color: "green"
            function setWindowProperty(name, value) {}
        }
        property int heightRows: 2
    }

    FakeAppInfo {
        id: blueApp
        property Item window: Rectangle {
            color: "blue"
            function setWindowProperty(name, value) {}
        }
        property int heightRows: 2
    }

    ListModel {
        id: fakeApplicationModel
        function application(index) {
            return get(index).appInfo;
        }
        property var activeAppInfo: null
    }

    WidgetGrid {
        id: widgetGrid
        anchors.fill: parent
        Component.onCompleted: {
            fakeApplicationModel.append({"appInfo":redApp})
            fakeApplicationModel.append({"appInfo":greenApp})
            fakeApplicationModel.append({"appInfo":blueApp})
            widgetGrid.applicationModel = fakeApplicationModel
        }
    }

    NeptuneTestCase {
        name: "WidgetGrid"

        /*
            While dragging a resize handle, if the widget next to it cannot be
            squeezed, squeeze the one after it, if possible.
         */
        function test_resizePropagates() {
            // check start conditions
            compare(fakeApplicationModel.count, 3);
            compare(fakeApplicationModel.get(0).appInfo.heightRows, 1);
            compare(fakeApplicationModel.get(1).appInfo.heightRows, 2);
            compare(fakeApplicationModel.get(2).appInfo.heightRows, 2);


            // get the resize handle that's under the first (top) widget, redApp.
            var resizeHandle = findChild(widgetGrid, "resizeHandle0");
            verify(resizeHandle);

            // drag the top-most resize handle all the way to the bottom of the screen
            touchDrag(resizeHandle,
                      resizeHandle.width/2, resizeHandle.height/2,
                      resizeHandle.width/2, resizeHandle.height/2 + widgetGrid.height);

            // Both the second and the third widget (top to bottom order) should have shrunk to make space for the
            // enlarged top widget
            compare(fakeApplicationModel.get(0).appInfo.heightRows, 3);
            compare(fakeApplicationModel.get(1).appInfo.heightRows, 1);
            compare(fakeApplicationModel.get(2).appInfo.heightRows, 1);

        }

    }
}

