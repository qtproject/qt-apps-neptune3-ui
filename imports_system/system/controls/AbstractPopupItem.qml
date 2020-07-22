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

import QtQuick 2.6
import QtQuick.Controls 2.2

import shared.Style 1.0
import shared.Sizes 1.0
import shared.utils 1.0
import shared.animations 1.0

// NB: We can't use Popup from QtQuick.Controls as it doesn't support a rotated scene
Control {
    id: root

    width: Sizes.dp(800)

    Keys.onEscapePressed: { root.closeHandler(); }

    // X and Y position of the popup when open.
    // By default you have it horizontally centered and vertically aligned to the bottom
    property real popupX: Math.round((root.parent.width - root.width) / 2)
    property real popupY: root.parent.height - root.height - Sizes.dp(90)

    Cursor { trapsCursor: true }

    property bool headerBackgroundVisible: false
    property int headerBackgroundHeight: 0
    property Item originItem
    property real originItemX
    property real originItemY
    property real _openFromX
    property real _openFromY
    readonly property int minHeight: Sizes.dp(548)

    /*
        Called whenever a user action is requesting the Popup to be closed. The default behavior
        simply accepts it and calls close().
        Reimplement to override this behavior.
     */
    property var closeHandler: function () { close(); }

    /*
        Emitted after the close animation has finished.
     */
    signal closed();

    function updateOpenFromPosition() {
        if (originItem) {
            var originPos = originItem.mapToItem(root.parent, originItem.width/2, originItem.height/2)
            _openFromX = originPos.x - (root.width / 2);
            _openFromY = originPos.y - root.height;
        } else {
            _openFromX = originItemX - (root.width / 2);
            _openFromY = originItemY - root.height;
        }
    }

    function open() {
        updateOpenFromPosition();
        state = "open";
    }

    function close() {
        if (state !== "closed") {
            updateOpenFromPosition();
            state = "closed";
        }
    }

    Connections {
        target: parent ? parent : null
        ignoreUnknownSignals: true
        function onOverlayClicked() {
            root.closeHandler()
        }
    }

    state: "closed"
    states: [
        State {
            name: "open"
            PropertyChanges {
                target: root
                visible: true
                x: root.popupX
                y: root.popupY
            }
            PropertyChanges {
                target: root.parent
                showModalOverlay: true
            }
        },
        State {
            name: "closed"
            PropertyChanges {
                target: root
                x: root._openFromX
                y: root._openFromY
                visible: false
            }
        }
    ]

    transitions: [
        Transition {
            to: "open"
            SequentialAnimation {
                PropertyAction { target: root; property: "visible"; value: true }
                PropertyAction { target: root; property: "transformOrigin"; value: Popup.Bottom }
                ParallelAnimation {
                    DefaultNumberAnimation { target: root; property: "opacity"; from: 0.25; to: 1.0}
                    DefaultNumberAnimation { target: root; property: "scale"; from: 0.25; to: 1}
                    DefaultNumberAnimation { target: root; properties: "x,y" }
                }
                PropertyAction { target: root; property: "transformOrigin"; value: Popup.Center }
            }
        },
        Transition {
            from: "open"; to: "closed"
            SequentialAnimation {
                PropertyAction { target: root; property: "visible"; value: true }
                PropertyAction { target: root; property: "transformOrigin"; value: Popup.Bottom }
                ParallelAnimation {
                    DefaultNumberAnimation { target: root; property: "opacity"; to: 0.25 }
                    DefaultNumberAnimation { target: root; property: "scale"; to: 0.25 }
                    DefaultNumberAnimation { target: root; properties: "x,y" }
                }
                PropertyAction { target: root; property: "transformOrigin"; value: Popup.Center }
                ScriptAction { script: { root.closed(); } }
            }
        }
    ]
}

