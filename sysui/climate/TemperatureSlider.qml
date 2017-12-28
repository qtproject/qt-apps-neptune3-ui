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
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

import utils 1.0

import com.pelagicore.styles.triton 1.0

Slider {
    id: root
    width: Style.hspan(4)

    orientation: Qt.Vertical
    stepSize: 0.5
    snapMode: Slider.SnapOnRelease

    readonly property int leftSide: 0
    readonly property int rightSide: 1
    property int rulerSide: leftSide
    property var convertFunc

    background: Item {
        id: bgItem

        x: root.leftPadding + (root.availableWidth - width) / 2
        y: root.topPadding
        width: root.availableWidth
        height: root.availableHeight

        state: root.rulerSide === root.leftSide ? "rulerLeft" : "rulerRight"
        states: [
            State {
                name: "rulerLeft"
                PropertyChanges { target: rulerNumbers; anchors.right: rulerMarks.left }
                PropertyChanges { target: rulerMarks; anchors.right: rail.left }
                PropertyChanges { target: minMaxLabels; anchors.left: rail.right }
            },
            State {
                name: "rulerRight"
                PropertyChanges { target: rulerNumbers; anchors.left: rulerMarks.right }
                PropertyChanges { target: rulerMarks; anchors.left: rail.right }
                PropertyChanges { target: minMaxLabels; anchors.right: rail.left }
            }
        ]

        Item {
            id: rulerNumbers
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: Style.hspan(1)

            property int count: (to - from) + 1
            property real stepHeight: (height - handleItem.height) / (count - 1)

            Repeater {
                model: rulerNumbers.count
                delegate: Label {
                    y: (handleItem.height / 2) + (model.index * rulerNumbers.stepHeight) - (height / 2)
                    width: parent.width
                    height: Style.vspan(0.5)
                    text: root.convertFunc ? root.convertFunc(to - model.index) : to - model.index
                    font.pixelSize: TritonStyle.fontSizeM
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
        Item {
            id: rulerMarks
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: Style.hspan(0.3)

            property int count: (rulerNumbers.count * 2) - 1
            property real stepHeight: (height - handleItem.height) / (count - 1)

            Repeater {
                model: rulerMarks.count
                delegate: Rectangle {
                    y: (handleItem.height / 2) + (model.index * rulerMarks.stepHeight) - (height / 2)
                    width: parent.width
                    height: Style.vspan(0.03)
                    color: TritonStyle.primaryTextColor
                }
            }
        }
        Image {
            id: rail
            anchors.centerIn: parent
            width: Style.hspan(1)
            height: parent.height
            source: Style.gfx2("temperature-slider-bg")
            fillMode: Image.PreserveAspectFit
        }
        Item {
            id: minMaxLabels
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: Style.hspan(1)
            Label {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                opacity: 0.6

                //: Maximum value in a slider control
                text: qsTr("MAX")

                font.pixelSize: TritonStyle.fontSizeS
                horizontalAlignment: Text.AlignHCenter
                enabled: false
            }
            Label {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                opacity: 0.6

                //: Minimum value in a slider control
                text: qsTr("MIN")

                font.pixelSize: TritonStyle.fontSizeS
                horizontalAlignment: Text.AlignHCenter
                enabled: false
            }
        }
    }

    handle: Image {
        id: handleItem
        x: root.leftPadding + (root.availableWidth - width) / 2
        y: root.topPadding + (root.visualPosition * (root.availableHeight - height))
        width: height
        height: Style.vspan(1)
        source: Style.gfx2("slider-handle")
    }
}
