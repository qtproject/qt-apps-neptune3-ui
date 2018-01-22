/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AG
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

import QtQuick 2.8
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.2

import utils 1.0
import controls 1.0
import com.pelagicore.styles.triton 1.0

Item {
    id: root
    property real value
    property real minimum: 0
    property real maximum: 1
    property int length: width - handle.width
    property int animationDuration: 250
    property bool useAnimation: false
    property alias dragging: area.pressed
    property int numberOfDecimals: 1

    property real activeValue

    Behavior on value {
        enabled: useAnimation && !area.drag.active
        NumberAnimation { duration: animationDuration}
    }

    Rectangle {
        id: background
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: 4
        radius: 4
        border.color: Qt.lighter(color, 1.1)
        color: "#999"
        opacity: 0.25
    }

    ColumnLayout {
        anchors.bottom: background.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottomMargin: markers.markerWidth
        spacing: 0

        Item {
            anchors.left: parent.left
            anchors.right: parent.right
            height: Style.vspan(0.7)

            Label {
                width: contentWidth
                anchors.horizontalCenter: parent.left
                anchors.bottom: parent.bottom
                text: minimum.toLocaleString(Qt.locale(), 'f', root.numberOfDecimals)
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: TritonStyle.fontSizeS
            }

            Label {
                width: contentWidth
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: Style.paddingXS
                text: ((minimum + maximum) / 2).toLocaleString(Qt.locale(), 'f', root.numberOfDecimals)
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: TritonStyle.fontSizeM
            }

            Label {
                width: contentWidth
                anchors.horizontalCenter: parent.right
                anchors.bottom: parent.bottom
                text: maximum.toLocaleString(Qt.locale(), 'f', root.numberOfDecimals)
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: TritonStyle.fontSizeS
            }
        }

        Item {
            id: markers
            height: Style.vspan(0.5)
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            readonly property int markerWidth: 2
            readonly property int markerCount: 41

            Row {
                anchors.fill: parent
                spacing: (parent.width - (markers.markerCount * markers.markerWidth)) / (markers.markerCount - 1)
                Repeater {
                    model: markers.markerCount
                    delegate: Rectangle {
                        Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                        transformOrigin: Item.Bottom
                        height: Style.vspan(0.5)
                        width: markers.markerWidth
                        radius: markers.markerWidth
                        opacity: index % 10 ? 0.25 : 0.5
                        scale: index % 10 ? 0.7 : 1
                        color: "#999"
                    }
                }
            }
        }
    }

    Rectangle {
        id: handle
        width: 26
        height: width; radius: width/2
        y: (root.height - height)/2
        x: (root.value - root.minimum) * root.length / (root.maximum - root.minimum)

        border.color: Qt.lighter(color, 1.1)
        color: '#fff'
        smooth: true

        Rectangle {
            width: 2
            height: Style.vspan(0.4)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.top

            color: TritonStyle.accentColor
            radius: width
        }

        MouseArea {
            id: area
            width: Style.hspan(2)
            height: width
            anchors.centerIn: parent
            hoverEnabled: false
            drag.target: root.dragging ? parent : undefined
            drag.axis: Drag.XAxis; drag.minimumX: 0; drag.maximumX: root.length
            onPositionChanged: {
                root.activeValue = root.minimum + (root.maximum - root.minimum) * handle.x / root.length
            }
        }
    }
}
