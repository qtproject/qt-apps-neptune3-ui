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

Item {
    id: root

    property var widgetsList: HomeWidgetsList {}


    // The widget grid
    Column {
        id: widgetGrid
        anchors.fill: parent
        anchors.margins: Style.hspan(2)

        readonly property int numRows: 4
        readonly property int rowHeight: height / numRows

        Repeater {
            id: repeater
            model: root.widgetsList
            delegate: Column {
                width: widgetGrid.width
                height: appInfo ? appInfo.heightRows * widgetGrid.rowHeight : 0

                Behavior on x { SmoothedAnimation { easing.type: Easing.InOutQuad; duration: 270 } }
                Behavior on y { SmoothedAnimation { easing.type: Easing.InOutQuad; duration: 270 } }
                Behavior on width { SmoothedAnimation { easing.type: Easing.InOutQuad; duration: 270 } }
                Behavior on height { SmoothedAnimation { easing.type: Easing.InOutQuad; duration: 270 } }

                ApplicationWidget {
                    id: appWidget
                    width: parent.width
                    height: parent.height - resizerHandle.height

                    appInfo: model.appInfo
                }
                Rectangle {
                    id: resizerHandle

                    readonly property bool isAtBottom: model.index === (repeater.count - 1)

                    // the last handle looks different as it separates home screen widgets from the bottom widget
                    color: isAtBottom ? "black" : "grey"
                    width: parent.width
                    height: Style.vspan(0.2)
                    Resizer {
                        anchors.fill: parent
                        topAppInfo: model.appInfo
                        bottomAppInfo: resizerHandle.isAtBottom ? null : repeater.model.get(model.index + 1).appInfo
                        grid: widgetGrid
                    }
                }
            }
        }

    }

}
