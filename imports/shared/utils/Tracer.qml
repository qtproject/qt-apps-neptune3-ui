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

import utils 1.0

MouseArea {
    id: root
    anchors.fill: parent
    property color color: randomColor();
    property string text: parent.objectName
    property real padding: 0.5
    visible: Style.debugMode
    property bool fill: root.opaque
    acceptedButtons: Qt.RightButton
    property bool opaque: false

    propagateComposedEvents: true

    Rectangle {
        id: fill
        anchors.fill: parent
        anchors.margins: root.padding
        color: root.fill?root.color:'transparent'
        opacity: root.opaque? 1.0 : 0.10
    }

    Rectangle {
        id: frame
        anchors.fill: parent
        anchors.margins: root.padding
        color: 'transparent'
        border.color: root.color
        border.width: 1
        opacity: 0.80
    }

    Text {
        id: note
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 4
        horizontalAlignment: Text.AlignRight
        text: root.text
        font.pixelSize: 10
        color: root.color
    }

    function randomColor() {
        return Qt.rgba(Math.random(), Math.random(), Math.random(), 1.0)
    }

    onPressAndHold: {
        console.log(Logging.sysui, 'trace: ' + root.parent)

        console.log(Logging.sysui, 'Hierarchy: ')
        var parent = root.parent;
        var indent = '  ';
        while (parent) {
            console.log(Logging.sysui, indent + '+ ' + parent)
            indent += '  ';
            parent = parent.parent;
        }
    }
}
