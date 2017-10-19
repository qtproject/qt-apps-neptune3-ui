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
import QtQuick.Controls 2.0

import controls 1.0
import utils 1.0

Control {
    id: root

    property alias text: label.text
    property alias symbol: symbol.name

    signal clicked()

    BorderImage {
        anchors.fill: parent
        anchors.bottomMargin: 1
        source: Style.gfx('appstore_tab_panel')
        opacity: 1-activeBackground.opacity
        border {
            left: 4
            right: 60
            top: 4
            bottom: 4
        }
        asynchronous: true
    }

    BorderImage {
        id: activeBackground
        anchors.fill: parent
        anchors.bottomMargin: 1
        source: Style.gfx('appstore_tab_panel_selected')
        opacity: root.ListView.isCurrentItem
        Behavior on opacity { NumberAnimation { duration: 200 } }
        border {
            left: 4
            right: 60
            top: 4
            bottom: 4
        }
        asynchronous: true
    }

    Label {
        id: label

        anchors.left: parent.left
        anchors.right: symbol.left
        height: parent.height
        anchors.leftMargin: Style.paddingXL
        anchors.rightMargin: symbol.width === 0 ? Style.paddingXL : 0

        font.pixelSize: Style.fontSizeS
        font.capitalization: Font.AllUppercase
        color: root.ListView.isCurrentItem ? Style.colorOrange : Style.colorWhite

        Behavior on color { ColorAnimation { duration: 200 } }
    }

    Symbol {
        id: symbol

        anchors.right: parent.right
        width: Style.hspan(name ? 2 : 0)
        height: parent.height
        active: root.ListView.isCurrentItem
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
