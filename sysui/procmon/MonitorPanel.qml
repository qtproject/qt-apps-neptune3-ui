/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune IVI UI.
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

import QtQuick 2.8
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

import utils 1.0

Item {
    id: root
    width: 640
    height: 200

    property int leftMargin: 0.03 * width
    property alias descriptionText: descriptionText.text
    property alias valueText: valueText.text
    property real middleLine: 0.5
    property int graphHeight: 0.65 * root.height
    property alias middleText: middleLineText.text
    default property alias content: graphContent.children
    property alias model: graph.model
    property alias delegate: graph.delegate

    RowLayout {
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: root.leftMargin
        spacing: 5

        Label {
            id: descriptionText
            Layout.fillWidth: true
            font.pixelSize: Style.fontSizeL
        }

        Label {
            id: valueText
            Layout.preferredWidth: Style.hspan(2)
            font.pixelSize: Style.fontSizeL
        }
    }

    Item {
        id: graphContainer
        width: 0.86 * root.width
        height: root.graphHeight
        anchors.bottom: parent.bottom
        anchors.bottomMargin: root.leftMargin
        anchors.left: parent.left
        anchors.leftMargin: root.leftMargin

        Row {
            id: dottedLine
            y: root.graphHeight - (root.middleLine * root.graphHeight)
            spacing: 4

            Repeater {
                model: graphContainer.width/8

                Rectangle {
                    width: 4
                    height: width
                    radius: width
                    color: "#4d4d4d"
                }
            }
        }

        Label {
            id: middleLineText
            width: Style.hspan(1)
            anchors.left: dottedLine.right
            anchors.verticalCenter: dottedLine.verticalCenter
            font.pixelSize: Style.fontSizeM
        }

        Rectangle {
            width: parent.width
            height: 2
            anchors.bottom: parent.bottom
            color: "#4d4d4d"
        }

        Item {
            id: graphContent
            anchors.fill: parent
            clip: true

            ListView {
                id: graph
                anchors.fill: parent
                orientation: ListView.Horizontal
                interactive: false
            }
        }
    }
}
