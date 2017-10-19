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

Slider {
    id: root
    implicitWidth: Style.hspan(16)
    implicitHeight: Style.vspan(2)

    background: Item {
        x: root.leftPadding
        y: root.topPadding + root.availableHeight / 2 - height / 2
        implicitWidth: Style.hspan(8)
        implicitHeight: Style.vspan(2)
        Image {
            anchors.centerIn: parent
            source: Style.gfx('volume_slider_overlay')
            opacity: 0.2
            asynchronous: true
        }
        ListView {
            id: view
            anchors.fill: parent
            anchors.topMargin: Style.paddingXL
            anchors.bottomMargin: Style.paddingXL
            orientation: Qt.Horizontal
            interactive: false
            model: width/12
            currentIndex: root.position * count
            Behavior on currentIndex { SmoothedAnimation { velocity: view.count*2} }
            delegate: Item {
                width: view.width/view.count
                height: view.height
                property int entry: index
                Rectangle {
                    width: 4
                    height: parent.height
                    anchors.centerIn: parent
                    border.color: Qt.darker(color, 1.1)
                    color: '#A2CED2'
                    radius: 1
                    scale: view.currentIndex >= index?1.0:0.85
                    transformOrigin: Item.Bottom
                    Behavior on scale { NumberAnimation { easing.type: Easing.OutQuad } }
                    opacity: view.currentIndex >= index?1.0:0.25
                    Behavior on opacity { NumberAnimation {} }
                }
            }
            Tracer {}
        }
        Tracer {}
    }

    handle: Item {
        // we need to have a pseudo handle otherwise drag does not work
        x: root.leftPadding + root.visualPosition * (root.availableWidth - width)
        y: root.topPadding + root.availableHeight / 2 - height / 2
        width: Style.hspan(1)
        height: Style.vspan(2)
        Tracer {}
    }
}
