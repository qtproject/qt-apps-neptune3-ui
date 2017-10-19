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

/*
    Resizes a given target item while respecting the boundaries of a given grid item
 */
MultiPointTouchArea {
    id: root

    // The item to be resized
    property Item target

    /*
     A grid item is expected to have the following properties:
     numRows: number of rows
     numColumns: number of columns
     columnWidth: width of each column
     rowHeight: height of each row
    */
    property Item grid

    property int borderThickness: Style.hspan(3)

    touchPoints: [
        TouchPoint {
            id: touch1
            onXChanged: d.onTouchMoved()
            onYChanged: d.onTouchMoved()
            onPressedChanged: {
                if (pressed) {
                    d.updateBorders();
                    d.dragging = true;
                } else {
                    d.dragging = false;
                }
            }
        }
    ]

    QtObject {
        id: d

        readonly property int widthIncrement: root.grid ? root.grid.columnWidth : 0
        readonly property int heightIncrement: root.grid ? root.grid.rowHeight : 0

        property bool leftBorder: false
        property bool rightBorder: false
        property bool topBorder: false
        property bool bottomBorder: false

        property bool dragging: false

        function updateBorders() {
            var pos = mapToItem(root.target, touch1.x, touch1.y);
            leftBorder = pos.x <= root.borderThickness;
            rightBorder = pos.x >= root.target.width - root.borderThickness;
            topBorder = pos.y <= root.borderThickness;
            bottomBorder = pos.y >= root.target.height - root.borderThickness;
        }

        function onTouchMoved() {
            if (!d.dragging) {
                return;
            }

            var bounds = grid.mapToItem(root.target.parent, 0, 0, grid.width, grid.height);
            var pos = mapToItem(root.target.parent, touch1.x, touch1.y);

            var snappedPosX = Math.min(bounds.x + bounds.width, Math.max(bounds.x, pos.x));
            snappedPosX = bounds.x + Math.round((snappedPosX - bounds.x) / d.widthIncrement)*d.widthIncrement;

            var snappedPosY = Math.min(bounds.y + bounds.height, Math.max(bounds.y, pos.y));
            snappedPosY = bounds.y + Math.round((snappedPosY - bounds.y) / d.heightIncrement)*d.heightIncrement;

            if (d.leftBorder) {
                var curRightBorder = root.target.topLeftColumnIndex + root.target.widthColumns;
                var desiredTopLeftColumnIndex = (snappedPosX - bounds.x) / d.widthIncrement;
                var maxTopLeftColumnIndex = curRightBorder - root.target.minWidthColumns;

                root.target.topLeftColumnIndex = Math.min(desiredTopLeftColumnIndex, maxTopLeftColumnIndex);
                root.target.widthColumns = curRightBorder - root.target.topLeftColumnIndex;
            } else if (d.rightBorder) {
                var desiredRightBorder = (snappedPosX - bounds.x) / d.widthIncrement;
                var desiredWidth = desiredRightBorder - root.target.topLeftColumnIndex;

                root.target.widthColumns = Math.max(root.target.minWidthColumns, desiredWidth);
            }

            if (d.topBorder) {
                var curBottomIndex = root.target.topLeftRowIndex + root.target.heightRows;
                var desiredTopLeftRowIndex = (snappedPosY - bounds.y) / d.heightIncrement;
                var maxTopLeftRowIndex = curBottomIndex - root.target.minHeightRows;

                root.target.topLeftRowIndex = Math.min(desiredTopLeftRowIndex, maxTopLeftRowIndex);
                root.target.heightRows = curBottomIndex - root.target.topLeftRowIndex;
            } else if (d.bottomBorder) {
                var desiredBottomBorder = (snappedPosY - bounds.y) / d.heightIncrement;
                var desiredHeight = desiredBottomBorder - root.target.topLeftRowIndex;

                root.target.heightRows = Math.max(root.target.minHeightRows, desiredHeight);
            }

        }
    }
}
