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
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import com.pelagicore.styles.triton 1.0
import controls 1.0
import utils 1.0
import animations 1.0

// NB: We can't use Popup from QtQuick.Controls as it doesn't support a rotated scene
Control {
    id: root

    width: 800
    focus: visible

    property bool headerBackgroundVisible: false
    property int headerBackgroundHeight: 0
    property Item originItem
    property real _openFromX
    property real _openFromY
    readonly property int minHeight: 548

    BorderImage {
        anchors.top: parent.top
        width: parent.width
        height: root.headerBackgroundHeight
        visible: root.headerBackgroundVisible
        source: Style.gfx2("floating-panel-top-bg")
        border {
            left: 20
            top: 30
            right: 20
            bottom: 0
        }
    }
    background: BorderImage {
        anchors.fill: root
        source: Style.gfx2("popup-background-9patch", TritonStyle.theme)
        anchors.leftMargin: -40
        anchors.rightMargin: -40
        anchors.topMargin: -28
        anchors.bottomMargin: -52
        border.left: 70
        border.right: 70
        border.top: 50
        border.bottom: 90

        // click eater
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.AllButtons
            onWheel: wheel.accepted = true;
        }
    }

    Tool {
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: 10
        anchors.horizontalCenter: parent.right
        anchors.horizontalCenterOffset: -10
        width: bg.sourceSize.width
        height: width
        onClicked: close()
        symbol: Style.symbol("ic-close")
        background: Image {
            id: bg
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 6
            source: Style.gfx2("popup-close-button-bg", TritonStyle.theme)
        }
    }

    Keys.onEscapePressed: close()

    function open() {
        var originPos = originItem.mapToItem(root.parent, originItem.width/2, originItem.height/2)
        _openFromX = originPos.x - (root.width / 2);
        _openFromY = originPos.y - root.height;
        state = "open";
    }

    function openLeft() {
        var originPos = originItem.mapToItem(root.parent, originItem.width/2, originItem.height/2)
        _openFromX = originPos.x - (root.width / 2);
        _openFromY = originPos.y - root.height;
        state = "open_left";
    }

    function close() {
        state = "closed";
    }

    Connections {
        target: parent ? parent : null
        onOverlayClicked: close()
    }

    state: "closed"
    states: [
        State {
            name: "open"
            PropertyChanges {
                target: root
                visible: true
                x: (root.parent.width - root.width) / 2
                y: (root.parent.height - root.height) / 2
            }
            PropertyChanges {
                target: root.parent
                showModalOverlay: true
            }
        },
        State {
            name: "open_left"
            extend: "open"
            PropertyChanges {
                target: root
                visible: true
                x: Style.hspan(1.5)
                y: (root.parent.height - root.height) / 2
            }
        },
        State {
            name: "closed"
            PropertyChanges {
                target: root
                visible: false
                x: (root.parent.width - root.width) / 2
                y: (root.parent.height - root.height) / 2
            }
            PropertyChanges {
                target: root.parent
                showModalOverlay: false
            }
        }
    ]

    transitions: [
        Transition {
            to: "open,open_left"
            SequentialAnimation {
                PropertyAction { target: root; property: "visible"; value: true }
                PropertyAction { target: root; property: "transformOrigin"; value: Popup.Bottom }
                ParallelAnimation {
                    DefaultNumberAnimation { target: root; property: "opacity"; from: 0.25; to: 1.0}
                    DefaultNumberAnimation { target: root; property: "scale"; from: 0.25; to: 1}
                    DefaultNumberAnimation { target: root; property: "x"; from: root._openFromX }
                    DefaultNumberAnimation { target: root; property: "y"; from: root._openFromY }
                }
                PropertyAction { target: root; property: "transformOrigin"; value: Popup.Center }
            }
        },
        Transition {
            from: "open,open_left"; to: "closed"
            SequentialAnimation {
                PropertyAction { target: root; property: "visible"; value: true }
                PropertyAction { target: root; property: "transformOrigin"; value: Popup.Bottom }
                ParallelAnimation {
                    DefaultNumberAnimation { target: root; property: "opacity"; to: 0.25 }
                    DefaultNumberAnimation { target: root; property: "scale"; to: 0.25 }
                    DefaultNumberAnimation { target: root; property: "x"; to: root._openFromX }
                    DefaultNumberAnimation { target: root; property: "y"; to: root._openFromY }
                }
                PropertyAction { target: root; property: "transformOrigin"; value: Popup.Center }
            }
        }
    ]
}
