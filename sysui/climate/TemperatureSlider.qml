/****************************************************************************
**
** Copyright (C) 2017-2018 Pelagicore AG
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
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

import utils 1.0

import com.pelagicore.styles.triton 1.0

Slider {
    id: root
    width: Style.hspan(4)

    orientation: Qt.Vertical
    snapMode: Slider.SnapOnRelease
    live: false
    stepSize: 0.5

    property var convertFunc
    property int count: stepSize != 0 ? (to-from)/stepSize : 0.5
    readonly property alias handleHeight: handleItem.height

    background: Item {
        id: bgItem
        anchors.fill: parent
        Column {
            id: rulerNumbers
            anchors.top: parent.top
            anchors.topMargin: handleItem.height/2
            anchors.bottom: parent.bottom
            anchors.bottomMargin: handleItem.height/2
            anchors.horizontalCenter: parent.horizontalCenter

            width: Style.hspan(30/45)
            spacing: Style.vspan(3/80)

            Repeater {
                model: root.count
                delegate: Rectangle {
                    id: rect
                    width: parent.width
                    height: rulerNumbers.height/root.count - rulerNumbers.spacing
                    color: TritonStyle.contrastColor
                    opacity: (handleItem.y-handleItem.height/2) > rect.y ? 0.1 : 0.6
                }
            }
        }
    }

    handle: Image {
        id: handleItem
        x: root.leftPadding + (root.availableWidth - width) / 2
        y: root.topPadding + (root.visualPosition * (root.availableHeight - height))
        source: Style.gfx2("vertical-slider-handle", TritonStyle.theme)
    }
}
