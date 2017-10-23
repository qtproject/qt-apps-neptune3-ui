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

import utils 1.0

MultiPointTouchArea {
    id: root

    property var topAppInfo
    property var bottomAppInfo

    /*
     A grid item is expected to have the following properties:
     numRows: number of rows
     rowHeight: height of each row
    */
    property Item grid

    touchPoints: [
        TouchPoint {
            id: touch1
            onXChanged: d.onTouchMoved()
            onYChanged: d.onTouchMoved()
            onPressedChanged: {
                if (pressed) {
                    d.dragging = true;

                    var gridPos = root.mapToItem(root.grid, touch1.x, touch1.y);
                    d.startGridPosY = gridPos.y

                    d.startTopHeightRows = root.topAppInfo.heightRows;

                    if (root.bottomAppInfo) {
                        d.startBottomHeightRows = root.bottomAppInfo.heightRows;
                    }
                } else {
                    d.dragging = false;
                }
            }
        }
    ]

    QtObject {
        id: d

        readonly property int heightIncrement: root.grid ? root.grid.rowHeight : 0

        property bool dragging: false

        property real startGridPosY
        property int startTopHeightRows
        property int startBottomHeightRows

        function onTouchMoved() {
            if (!d.dragging) {
                return;
            }

            var gridPos = root.mapToItem(root.grid, touch1.x, touch1.y);
            var deltaRows = Math.round((gridPos.y - d.startGridPosY) / root.grid.rowHeight);

            var targetTopHeightRows = Math.max(d.startTopHeightRows + deltaRows, root.topAppInfo.minHeightRows);
            deltaRows = targetTopHeightRows - d.startTopHeightRows;

            var targetBottomHeightRows = Math.max(d.startBottomHeightRows - deltaRows, root.bottomAppInfo.minHeightRows);
            deltaRows =  -targetBottomHeightRows + d.startBottomHeightRows;

            root.topAppInfo.heightRows = d.startTopHeightRows + deltaRows
            root.bottomAppInfo.heightRows = d.startBottomHeightRows - deltaRows
        }
    }
}
