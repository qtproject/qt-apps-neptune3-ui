/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Copyright (C) 2018 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 UI.
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
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0

import shared.utils 1.0
import shared.controls 1.0
import shared.Style 1.0
import shared.Style 1.0
import shared.Sizes 1.0

Slider {
    //TODO adapt it to AM band frequencies

    id: root
    height: handle.height + valueLabel.contentHeight
    anchors.bottom: parent.bottom
    live: true

    property alias stationIndicatorComponent: stationIndicatorComponent
    property int numberOfDecimals: 1

    Component {
        id: stationIndicatorComponent
        Rectangle {
            anchors.bottom: markers.top
            width: Sizes.dp(18)
            height: Sizes.dp(18)
            opacity: root.opacity
            color: Style.accentColor
            radius: 20
            onOpacityChanged: {
                if (opacity === 0.0) {
                    //destroy indicators so that they can be created again
                    //with possible new positions
                    this.destroy();
                }
            }
        }
    }

    background: Item {
        id: markers
        height: Sizes.dp(100)
        width: parent.width
        anchors.verticalCenter: handle.verticalCenter

        readonly property int markerWidth: 2
        readonly property int markerCount: 36
        Row {
            anchors.fill: parent
            Repeater {
                model: markers.markerCount
                delegate: Item {
                    width: Sizes.dp(30)
                    height: Sizes.dp(100) + markersTextLabel.contentHeight
                    Rectangle {
                        id: marker
                        width: Sizes.dp(markers.markerWidth)
                        height: (index === 3 || index === 8 || index === 13 || index === 18 || index === 23 || index === 28 || index === 33)
                                ? Sizes.dp(100) : Sizes.dp(60)
                        anchors.top: parent.top
                        anchors.topMargin: Sizes.dp(12)
                        anchors.horizontalCenter: parent.horizontalCenter
                        radius: markers.markerWidth
                        opacity: height === Sizes.dp(100) ? 0.6 : 0.2
                        color: Style.contrastColor
                        LinearGradient {
                            id: gradient
                            anchors.fill: parent
                            visible: height === Sizes.dp(100)
                            start: Qt.point(0, 0)
                            end: Qt.point(0, Sizes.dp(100))
                            gradient: Gradient {
                                GradientStop { position: 0.4; color: "white" }
                                GradientStop { position: 1.0; color: Style.contrastColor }
                            }
                        }
                        Label {
                            id: markersTextLabel
                            anchors.top: marker.bottom
                            anchors.horizontalCenter: marker.horizontalCenter
                            visible: gradient.visible
                            text: 90 + (index - 3)
                            font.pixelSize: Sizes.fontSizeS
                        }
                    }
                }
            }
        }
    }

    Label {
        id: valueLabel
        anchors.top: parent.top
        anchors.horizontalCenter: handle.horizontalCenter
        x: handle.x
        text: value.toFixed(numberOfDecimals)
        //custom label
        font.pixelSize: Sizes.dp(42)
    }

    handle: Item {
        id: handle
        anchors.top: valueLabel.bottom
        width: Sizes.dp(10)
        height: Sizes.dp(300)
        x: root.leftPadding + root.visualPosition * (root.availableWidth - width)
        z: 100000
        Rectangle {
            id: pin
            width: Sizes.dp(1)
            height: Sizes.dp(300)
            anchors.horizontalCenter: parent.horizontalCenter
            color: Style.contrastColor
        }
    }
}
