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
import QtQuick.Layouts 1.0
import utils 1.0
import controls 1.0

Control {
    id: root

    implicitWidth: Style.hspan(2)
    implicitHeight: Style.vspan(8)

    readonly property int roundingModeWhole: 1
    readonly property int roundingModeHalf: 2

    property bool mirrorSlider: false

    property real from: 0
    property real to: 1
    property real value: 0.2
    property int roundingMode: roundingModeWhole
    property real stepSize: 0.1

    onValueChanged: {
        if ((root.value >= root.from) && (root.value <= root.to) && !touchArea.isTouchPressed)
            slider.handlerPosition = (root.value - root.from) / (root.to - root.from)
    }

    transform: Rotation {
        angle: mirrorSlider ? 180 : 0
        axis { x: 0; y: 1; z: 0 }
        origin { x: root.width/2; y: root.height/2 }
    }

    ColumnLayout {
        id: barRow

        spacing: 0
        width: parent.width
        height: parent.height

        Label {
            Layout.fillWidth: true
            Layout.preferredHeight: Style.vspan(2)

            font.family: Style.fontFamily
            font.pixelSize: Style.fontSizeXL

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: "+"
            color: Style.colorWhite

            MouseArea {
                anchors.fill: parent
                onClicked: slider.increase()
            }
        }

        Item {
            id: slider
            Layout.fillHeight: true
            Layout.fillWidth: true

            property real handlerPosition: (root.value >= root.from && root.value <= root.to) ?
                                               (root.value - root.from) / (root.to - root.from) : 0

            function increase() {
                if (root.value < root.to)
                    root.value = root.value + root.stepSize
            }

            function decrease() {
                if (root.value > root.from)
                    root.value = root.value - root.stepSize
            }

            Column {
                id: viewContainer

                Repeater {
                    id: view

                    model: modelCount
                    property int modelCount: (slider.height - Style.vspan(1))/itemHeight
                    property int itemHeight: 7
                    property real deltaRed: (0xa6 - 0xf0) / modelCount
                    property real deltaGreen: (0xd5 - 0x7d) / modelCount
                    property real deltaBlue: (0xda - 0x0) / modelCount
                    property int currentIndex: slider.handlerPosition * modelCount //- 2

                    function calcRed(index) { return (deltaRed * (modelCount-index) + 0xf0) / 255 }
                    function calcGreen(index) { return (deltaGreen * (modelCount-index) + 0x7d) / 255 }
                    function calcBlue(index) { return (deltaBlue * (modelCount-index) + 0x0) / 255 }

                    delegate: Item {
                        width: slider.width
                        height: view.itemHeight
                        property int entry: index

                        Rectangle {
                            id: stripe

                            property bool bottomPart: index >= (view.modelCount - view.currentIndex)

                            antialiasing: true
                            anchors.right: parent.right
                            width: parent.width - Style.hspan(1)
                            height: parent.height - 3
                            border.color: Qt.darker(color, 1.5)
                            border.width: 1
                            color: Qt.rgba(view.calcRed(index), view.calcGreen(index), view.calcBlue(index))
                            scale: bottomPart ? 1.0 : 0.96
                            transformOrigin: Item.Left
                            Behavior on scale { NumberAnimation { easing.type: Easing.OutQuad } }
                            opacity: bottomPart ? 1.0 : 0.6
                            Behavior on opacity { NumberAnimation {} }
                        }
                    }
                }
            }

            Symbol {
                id: handler
                y: (1 - slider.handlerPosition)*viewContainer.height - height/2
                implicitWidth: Style.hspan(1)
                implicitHeight: Style.vspan(1)
                width: slider.width
                height: implicitHeight

                property real position: 1 - y/viewContainer.height

                transform: Rotation {
                    angle: 180
                    axis { x: 0; y: 1; z: 0 }
                    origin { x: width/2; y: height/2 }
                }

                Symbol {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    opacity: 0.4
                    name: "slider_marker"
                    height: Style.vspan(1)
                }
            }

            MultiPointTouchArea {
                id: touchArea

                anchors.fill: parent

                property alias isTouchPressed: mainTouchPoint.pressed

                touchPoints: [
                    TouchPoint {
                        id: mainTouchPoint

                        onYChanged: {
                            if (y >= viewContainer.height) {
                                root.value = root.from
                            } else if (y <= 0) {
                                root.value = root.to
                            } else {
                                slider.handlerPosition = 1 - y/viewContainer.height
                                var tempValue = slider.handlerPosition * (root.to - root.from)
                                tempValue = tempValue + root.from

                                var difference = tempValue - root.value
                                if (Math.abs(difference) > root.stepSize) {
                                    var increaseTimes = Math.floor(difference/root.stepSize)
                                    root.value = root.value + increaseTimes * root.stepSize
                                }
                            }
                        }
                    }
                ]
            }
        }

        Label {
            Layout.fillWidth: true
            Layout.preferredHeight: Style.vspan(2)

            font.family: Style.fontFamily
            font.pixelSize: Style.fontSizeXL

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: "-"
            color: Style.colorWhite

            MouseArea {
                anchors.fill: parent
                onClicked: slider.decrease()
            }
        }
    }
}
