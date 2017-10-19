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

import QtQuick 2.0
import QtQuick.Controls 2.0
import utils 1.0

Control {
    id: root

    width: Style.hspan(4)
    height: Style.vspan(2)

    property string text
    signal clicked()

    property alias color: background.color
    property bool solid: false

    Rectangle {
        id: background
        anchors.fill: parent
        color: '#576071'
        opacity: root.solid?1.0:0.5
        border.color: Qt.lighter(Qt.tint(color, '#66ffffff'), area.containsMouse?1.5:1.0)
    }

    Text {
        id: label
        anchors.centerIn: parent
        color: '#fff'
        font.pixelSize: 14
        text: root.text
    }
    Text {
        id: info
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 4
        color: '#fff'
        font.pixelSize: 10
        text: root.width + 'x' + root.height
        horizontalAlignment: Text.AlignRight
        opacity: area.containsMouse?0.5:0.0
        Behavior on opacity { NumberAnimation {} }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        onClicked: root.clicked()
        hoverEnabled: true
    }
}
