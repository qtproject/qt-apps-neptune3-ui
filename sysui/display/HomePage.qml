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
import QtQuick.Controls 2.1

import controls 1.0
import utils 1.0
import widgets 1.0

import models.application 1.0

Item {
    id: root

    property bool widgetEditingMode: false

    // The widget grid
    Item {
        id: widgetGrid
        anchors.fill: parent
        anchors.margins: Style.hspan(2)

        readonly property int numRows: 5
        readonly property int numColumns: 2
        readonly property int columnWidth: width / numColumns
        readonly property int rowHeight: height / numRows

        ApplicationWidget {
            id: mapWidget
            x: topLeftColumnIndex * widgetGrid.columnWidth
            y: topLeftRowIndex * widgetGrid.rowHeight
            width: widthColumns * widgetGrid.columnWidth
            height: heightRows * widgetGrid.rowHeight
            property int topLeftRowIndex: 0
            property int topLeftColumnIndex: 0
            property int widthColumns: 2
            property int heightRows: 3
            property int minWidthColumns: 1
            property int minHeightRows: 1

            appInfo: ApplicationManagerModel.application('com.pelagicore.maps')

            Behavior on x { SmoothedAnimation { easing.type: Easing.InOutQuad; duration: 270 } }
            Behavior on y { SmoothedAnimation { easing.type: Easing.InOutQuad; duration: 270 } }
            Behavior on width { SmoothedAnimation { easing.type: Easing.InOutQuad; duration: 270 } }
            Behavior on height { SmoothedAnimation { easing.type: Easing.InOutQuad; duration: 270 } }

        }
        Resizer {
            anchors.fill: mapWidget
            target: mapWidget
            grid: widgetGrid
            visible: root.widgetEditMode
        }
    }

}
