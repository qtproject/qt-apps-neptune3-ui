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
import QtQuick.Layouts 1.0
import utils 1.0
Item {
    width: 1280
    height: 800
    visible: Style.gridMode

    Loader {
        anchors.fill: parent
        active: Style.gridMode
        sourceComponent: Component {
            Item {
                id: root
                property int padding: Style.padding
                property int columns:24
                property int rows:24
                property int hmargin: (root.width-columns*cellWidth)/2
                property int vmargin: (root.height-rows*cellHeight)/2
                property int cellWidth: Style.cellWidth
                property int cellHeight: Style.cellHeight
                opacity: 0.5

                //    property int rows:

                GridView {
                    anchors.fill: parent
                    anchors.leftMargin: root.hmargin
                    anchors.rightMargin: root.hmargin
                    anchors.topMargin: root.vmargin
                    anchors.bottomMargin: root.vmargin
                    cellWidth: root.cellWidth
                    cellHeight: root.cellHeight
                    model: root.columns*root.rows
                    interactive: false

                    delegate: DisplayGridCell {
                        width: root.cellWidth
                        height: root.cellHeight
                        padding: root.padding
                    }
                }

                Text {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    color: '#fff'
                    text: "hmargin: " + root.hmargin + ' vmargin: ' + root.vmargin
                }
            }
        }
    }
}

