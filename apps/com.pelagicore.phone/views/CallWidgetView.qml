/****************************************************************************
**
** Copyright (C) 2017-2018 Pelagicore AB
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 IVI UI.
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
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import utils 1.0
import animations 1.0
import controls 1.0

import com.pelagicore.styles.neptune 3.0

import "../controls"
import "../stores"

Item {
    id: root

    property PhoneStore store
    property bool ongoingCall: false
    property string callerHandle: store.callerHandle

    signal callEndRequested(string handle)
    signal keypadRequested()

    QtObject {
        id: priv
        property string callerName
    }

    onOngoingCallChanged: {
        if (root.ongoingCall) {
            var person = root.store.findPerson(callerHandle);
            priv.callerName = person.firstName + " " + person.surname;
        } else {
            priv.callerName = "";
        }
    }

    states: [
        State {
            name: "Widget1Row"
            AnchorChanges {
                target: contactImage; anchors.horizontalCenter: imgBackground.horizontalCenter;
                anchors.verticalCenter: imgBackground.verticalCenter
            }
            AnchorChanges {
                target: textColumn; anchors.left: imgBackground.right; anchors.verticalCenter: parent.verticalCenter
            }
            AnchorChanges {
                target: buttonRow; anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
            }
            PropertyChanges {
                target: contactImage; width: Style.hspan(200/45); height: width
            }
            PropertyChanges {
                target: textColumn; anchors.leftMargin: Style.hspan(.7)
            }
        },
        State {
            name: "Widget2Rows"
            AnchorChanges {
                target: contactImage; anchors.top: parent.top; anchors.horizontalCenter: parent.horizontalCenter
            }
            AnchorChanges {
                target: textColumn; anchors.horizontalCenter: parent.horizontalCenter; anchors.top: buttonRow.bottom;
            }
            AnchorChanges {
                target: buttonRow; anchors.horizontalCenter: contactImage.horizontalCenter;
                anchors.verticalCenter: contactImage.bottom
            }
            PropertyChanges {
                target: contactImage; width: 258; height: width; anchors.topMargin: Style.vspan(1)
            }
            PropertyChanges {
                target: textColumn; anchors.leftMargin: 0
            }
        },
        State {
            name: "Widget3Rows"
            extend: "Widget2Rows"
            PropertyChanges {
                target: contactImage; width: 413; height: width; anchors.topMargin: Style.vspan(1.6)
            }
        },
        State {
            name: "Maximized"
            extend: "Widget2Rows"
            PropertyChanges {
                target: buttonRow; scale: .8
            }
            PropertyChanges {
                target: contactImage; width: Style.hspan(200/45); height: width; anchors.topMargin: Style.vspan(0.3)
            }
        }
    ]

    transitions: [
        Transition {
            SequentialAnimation {
                PropertyAction { targets: [textColumn, buttonRow]; property: "visible"; value: false }
                ParallelAnimation {
                    AnchorAnimation { targets: contactImage; duration: 270; easing.type: Easing.InOutQuad }
                    DefaultNumberAnimation { target: contactImage; properties: "width,height,anchors.topMargin" }
                }
                PropertyAction { targets: [textColumn, buttonRow]; property: "visible"; value: true }
            }
        }
    ]

    Image {
        id: imgBackground
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        source: Style.gfx2("widget-left-section-bg", NeptuneStyle.theme)

        opacity: root.state == "Widget1Row" ? 1.0 : 0.0
        visible: opacity > 0
        Behavior on opacity { DefaultNumberAnimation { duration: 50 } }
    }

    RoundImage {
        id: contactImage
        source: root.callerHandle ? "../assets/profile_photos/%1.jpg".arg(root.callerHandle) : ""
    }

    ColumnLayout {
        id: textColumn
        Label {
            anchors.left: root.state == "Widget1Row" ? parent.left : undefined
            anchors.horizontalCenter: root.state !== "Widget1Row" ? parent.horizontalCenter : undefined
            text: priv.callerName
        }
        Label {
            anchors.left: parent.left
            anchors.right: parent.right
            horizontalAlignment: root.state == "Widget1Row" ? Qt.AlignLeft : Qt.AlignHCenter
            font.pixelSize: NeptuneStyle.fontSizeS
            opacity: NeptuneStyle.fontOpacityMedium
            text: Qt.formatTime(new Date(store.callDuration * 1000), "m:ss")
        }
    }

    RowLayout {
        id: buttonRow

        Tool {
            Layout.rightMargin: root.state !== "Widget1Row" ? Style.hspan(2) : 0
            symbol: Style.symbol("ic-mute-ongoing")
        }

        Tool {
            background: Image {
                anchors.centerIn: parent
                fillMode: Image.Pad
                source: Style.symbol("ic_button-bg-red")
            }
            symbol: Style.symbol("ic-end-call")
            onClicked: root.callEndRequested(root.callerHandle)
        }

        Tool {
            Layout.leftMargin: root.state !== "Widget1Row" ? Style.hspan(2) : 0
            symbol: Style.symbol("ic-keypad-ongoing")
            //onClicked: root.keypadRequested() // TODO, disabled for now
        }
    }
}
