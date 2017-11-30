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

import controls 1.0
import utils 1.0
import animations 1.0

// NB: We can't use Popup from QtQuick.Controls as it doesn't support a rotated scene
Rectangle {
    id: root

    property alias model: listView.model
    property Item originItem

    anchors.horizontalCenter: parent.horizontalCenter

    width: Style.hspan(16)
    height: Style.vspan(14)

    radius: Style.hspan(0.7)

    function open() {
        _openFromY = originItem.mapToItem(root.parent, originItem.width/2, originItem.height/2).y - root.height;
        state = "open";
    }

    Binding { target: parent ? parent : null; property: "showModalOverlay"; value: root.state === "open" }
    Connections {
        target: parent ? parent : null
        onOverlayClicked: root.state = "closed"
    }

    state: "closed"
    states: [
        State {
            name: "open"
            PropertyChanges {
                target: root
                visible: true
                y: (root.parent.height - root.height) / 2
            }
        },
        State {
            name: "closed"
            PropertyChanges {
                target: root
                visible: false
                y: (root.parent.height - root.height) / 2
            }
        }
    ]

    property real _openFromY
    transitions: [
        Transition {
            to: "open"
            SequentialAnimation {
                PropertyAction { target: root; property: "visible"; value: true }
                PropertyAction { target: root; property: "transformOrigin"; value: Popup.Bottom }
                ParallelAnimation {
                    DefaultNumberAnimation { target: root; property: "opacity"; from: 0.25; to: 1.0}
                    DefaultNumberAnimation { target: root; property: "scale"; from: 0.25; to: 1}
                    DefaultNumberAnimation { target: root; property: "y"; from: root._openFromY }
                }
                PropertyAction { target: root; property: "transformOrigin"; value: Popup.Center }
            }
        },
        Transition {
            from: "open"; to: "closed"
            SequentialAnimation {
                PropertyAction { target: root; property: "visible"; value: true }
                ParallelAnimation {
                    DefaultNumberAnimation { target: root; property: "opacity"; to: 0.25 }
                    DefaultNumberAnimation { target: root; property: "scale"; to: 0.75 }
                }
            }
        }
    ]

    MouseArea {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: Style.hspan(1)
        width: Style.hspan(1)
        height: width
        Label {
            anchors.centerIn: parent
            text: "❌"
        }
        onClicked: root.state = "closed"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.hspan(1)
        Label {
            id: header
            text: qsTr("Add widget")
            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
            Layout.preferredHeight: Style.vspan(1)
        }
        ListView {
            id: listView
            width: parent.width
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            delegate: MouseArea {
                width: parent.width
                height: Style.vspan(1)
                enabled: !model.appInfo.asWidget
                Label {
                    anchors.fill: parent
                    text: model.name
                    enabled: parent.enabled // doesn't seem to be propagating, so making it explicit
                }
                onClicked: {
                    model.appInfo.asWidget = true
                    root.state = "closed"
                }
            }
        }
    }
}
