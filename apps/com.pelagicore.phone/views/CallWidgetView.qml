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
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import shared.utils 1.0
import shared.animations 1.0
import shared.controls 1.0

import shared.Style 1.0
import shared.Sizes 1.0

import "../controls" 1.0
import "../stores" 1.0

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
                target: contactImage; width: Sizes.dp(200); height: width
            }
            PropertyChanges {
                target: textColumn; anchors.leftMargin: Sizes.dp(32)
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
                target: contactImage; width: Sizes.dp(258); height: width; anchors.topMargin: Sizes.dp(80)
            }
            PropertyChanges {
                target: textColumn; anchors.leftMargin: 0; anchors.topMargin: Sizes.dp(32)
            }
        },
        State {
            name: "Widget3Rows"
            extend: "Widget2Rows"
            PropertyChanges {
                target: contactImage; width: Sizes.dp(413); height: width; anchors.topMargin: Sizes.dp(128)
            }
        },
        State {
            name: "Maximized"
            extend: "Widget2Rows"
            PropertyChanges {
                target: contactImage; width: Sizes.dp(200); height: width; anchors.topMargin: Sizes.dp(24)
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

    Item {
         id: widgetContent
         width: parent.width
         height: Math.min( Sizes.dp(660), parent.height )
         anchors.top: parent.top
         anchors.topMargin: root.state === "Maximized" ? Sizes.dp(200) : 0
         Behavior on anchors.topMargin { DefaultNumberAnimation {} }

         Image {
             id: imgBackground
             anchors.left: parent.left
             anchors.top: parent.top
             anchors.bottom: parent.bottom
             source: Style.image("widget-left-section-bg")
             width: Sizes.dp(sourceSize.width)
             height: Sizes.dp(sourceSize.height)

             opacity: root.state === "Widget1Row" ? 1.0 : 0.0
             visible: opacity > 0
             Behavior on opacity { DefaultNumberAnimation { duration: 50 } }
         }

         RoundImage {
             id: contactImage
             source: root.callerHandle ? "../assets/profile_photos/%1.png".arg(root.callerHandle) : ""
             enableOpacityMasks: store.allowOpenGLContent
         }

         ColumnLayout {
             id: textColumn
             Label {
                 objectName: "callerLabelFullName"
                 Layout.alignment: root.state === "Widget1Row" ? Qt.AlignLeft : Qt.AlignHCenter
                 text: priv.callerName
             }
             Label {
                 Layout.alignment: root.state === "Widget1Row" ? Qt.AlignLeft : Qt.AlignCenter
                 font.pixelSize: Sizes.fontSizeS
                 opacity: Style.opacityMedium
                 text: Qt.formatTime(new Date(store.callDuration * 1000), "m:ss")
             }
         }

         RowLayout {
             id: buttonRow
             spacing: root.state === "Widget1Row" ? Sizes.dp(60) : Sizes.dp(5)
             anchors.rightMargin: root.state === "Widget1Row" ? Sizes.dp(64) : undefined

             ToolButton {
                 objectName: "callerButtonMute"
                 Layout.rightMargin: root.state !== "Widget1Row" ? Sizes.dp(90) : 0
                 icon.name: "ic-mute-ongoing"
             }

             ToolButton {
                 objectName: "callerButtonEndCall"
                 Layout.preferredWidth: Sizes.dp(90)
                 Layout.preferredHeight: Sizes.dp(90)
                 background: Image {
                     anchors.centerIn: parent
                     width: Sizes.dp(sourceSize.width)
                     height: Sizes.dp(sourceSize.height)
                     source: Style.image("ic_button-bg-red")
                 }
                 icon.name: "ic-end-call"
                 icon.color: "white"
                 onClicked: root.callEndRequested(root.callerHandle)
             }

             ToolButton {
                 objectName: "callerButtonUseKeypad"
                 Layout.leftMargin: root.state !== "Widget1Row" ? Sizes.dp(90) : 0
                 icon.name: "ic-keypad-ongoing"
                 //onClicked: root.keypadRequested() // TODO, disabled for now
             }
         }
    }
}
