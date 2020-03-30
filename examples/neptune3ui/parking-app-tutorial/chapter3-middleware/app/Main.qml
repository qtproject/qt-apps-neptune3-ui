/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Contact: https://www.qt.io/licensing/
**
** This file is part of the QtAuto Extra Apps.
**
** $QT_BEGIN_LICENSE:BSD-QTAS$
** Commercial License Usage
** Licensees holding valid commercial Qt Automotive Suite licenses may use
** this file in accordance with the commercial license agreement provided
** with the Software or, alternatively, in accordance with the terms
** contained in a written agreement between you and The Qt Company.  For
** licensing terms and conditions see https://www.qt.io/terms-conditions.
** For further information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
** SPDX-License-Identifier: BSD-3-Clause
**
****************************************************************************/

import QtQuick 2.8
import shared.utils 1.0
import shared.animations 1.0
import QtQuick.Controls 2.2
import QtApplicationManager 2.0

import application.windows 1.0
import shared.Sizes 1.0
import shared.Style 1.0
import shared.controls 1.0

import Example.Parking 1.0

ApplicationCCWindow {
    id: root

    property bool parkingStarted: false

    Item {
        x: root.exposedRect.x
        y: root.exposedRect.y
        width: root.exposedRect.width
        height: root.exposedRect.height

        Image {
            id: topContent
            width: parent.width
            height: Sizes.dp(500)
            source: Style.image("app-fullscreen-top-bg", Style.theme)

            Label {
                text: qsTr("No active parking tickets")
                anchors.centerIn: parent
                font.weight: Font.Light
                opacity: !root.parkingStarted ? 1.0 : 0.0
                Behavior on opacity { DefaultNumberAnimation {} }
            }

            Image {
                width: root.width * 0.8
                height: topContent.height
                source: "assets/ticket_bg.png"
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.rightMargin: root.parkingStarted ? 0 : - width * 0.85
                Behavior on anchors.rightMargin { DefaultNumberAnimation {} }

                Column {
                    anchors.left: parent.left
                    anchors.leftMargin: Sizes.dp(130)
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: Sizes.dp(80)
                    opacity: root.parkingStarted ? 1.0 : 0.0
                    Behavior on opacity { DefaultNumberAnimation {} }

                    Label {
                        text: qsTr("Zone \nParking Olympia")
                        font.weight: Font.Light
                        color: "black"
                    }

                    Label {
                        text: "1275"
                        opacity: Style.opacityLow
                        font.weight: Font.Bold
                        font.pixelSize: Sizes.fontSizeXXL
                        color: "black"
                    }
                }

                Rectangle {
                    id: ticketContent
                    property date currentTime: new Date()

                    width: parent.width / 2
                    height: Sizes.dp(425)
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: Sizes.dp(-12)
                    color: Style.accentColor
                    opacity: root.parkingStarted ? 1.0 : 0.0
                    Behavior on opacity { DefaultNumberAnimation {} }

                    onOpacityChanged: {
                        if (opacity === 1.0) {
                            ticketContent.currentTime = new Date()
                        }
                    }

                    Column {
                        anchors.left: parent.left
                        anchors.leftMargin: Sizes.dp(60)
                        anchors.top: parent.top
                        anchors.topMargin: Sizes.dp(80)
                        spacing: Sizes.dp(45)

                        Label {

                            text: "Started: \ntoday " + Qt.formatDateTime(ticketContent.currentTime, "hh:mm")
                            font.weight: Font.Light
                            opacity: Style.opacityHigh
                            color: "black"
                        }

                        Label {
                            text: qsTr("2h, 14 minutes")
                            font.weight: Font.Light
                            opacity: Style.opacityHigh
                            color: "black"
                        }

                        Label {
                            text: "2.29 $"
                            font.weight: Font.Light
                            opacity: Style.opacityHigh
                            color: "black"
                        }
                    }
                }
            }
        }

        Timer {
            interval: 10000; running: root.parkingStarted;
            onTriggered: {
                   root.parkingStarted = false;
                   parkingNotification.show();
            }
        }

        Notification {
            id: parkingNotification
            summary: qsTr("Your parking period is about to end")
            body: qsTr("Your parking period will be ended in 5 minutes.
                         Please extend your parking ticket or move your car.")
            sticky: true
        }

        ParkingInfo {
            id: parkingInfo
        }

        Item {
            width: parent.width
            height: parent.height - topContent.height
            anchors.top: topContent.bottom

            Row {
                anchors.top: parent.top
                anchors.topMargin: Sizes.dp(60)
                anchors.left: parent.left
                anchors.leftMargin: Sizes.dp(50)
                spacing: Sizes.dp(200)

                Column {
                    spacing: Sizes.dp(50)

                    Label {
                        text: qsTr("Zone")
                        font.weight: Font.Light
                        opacity: Style.opacityMedium
                        font.pixelSize: Sizes.fontSizeL
                    }

                    Row {
                        spacing: Sizes.dp(60)

                        Column {
                            Label {
                                text: qsTr("Every day 12 - 22")
                                font.weight: Font.Light
                                font.pixelSize: Sizes.fontSizeS
                                opacity: Style.opacityMedium
                            }

                            Label {
                                text: qsTr("Other times")
                                font.weight: Font.Light
                                font.pixelSize: Sizes.fontSizeS
                                opacity: Style.opacityMedium
                            }

                            Label {
                                text: qsTr("Service fee")
                                font.weight: Font.Light
                                font.pixelSize: Sizes.fontSizeS
                                opacity: Style.opacityMedium
                            }
                        }

                        Column {
                            Label {
                                text: qsTr("1.5 $ / started hour")
                                font.weight: Font.Light
                                font.pixelSize: Sizes.fontSizeS
                                opacity: Style.opacityMedium
                            }

                            Label {
                                text: qsTr("1 $ / started hour")
                                font.weight: Font.Light
                                font.pixelSize: Sizes.fontSizeS
                                opacity: Style.opacityMedium
                            }

                            Label {
                                text: "0.29 $"
                                font.weight: Font.Light
                                font.pixelSize: Sizes.fontSizeS
                                opacity: Style.opacityMedium
                            }
                        }
                    }
                }

                Column {
                    spacing: Sizes.dp(250)

                    Label {
                        anchors.right: parent.right
                        text: parkingInfo.freeLots + qsTr(", Parking Olympia")
                        font.weight: Font.Light
                        opacity: Style.opacityMedium
                    }

                    Button {
                        id: startButton
                        implicitWidth: Sizes.dp(250)
                        implicitHeight: Sizes.dp(70)
                        font.pixelSize: Sizes.fontSizeM
                        checkable: true
                        checked: root.parkingStarted
                        text: !root.parkingStarted ? qsTr("Start") : qsTr("End (2.29 $)")

                        background: Rectangle {
                            color: {
                                if (startButton.checked) {
                                    return "red";
                                } else {
                                    return "green";
                                }
                            }
                            opacity: {
                                if (startButton.pressed) {
                                    return 0.1;
                                } else if (startButton.checked) {
                                    return 0.3;
                                } else {
                                    return 0.3;
                                }
                            }
                            Behavior on opacity { DefaultNumberAnimation {} }
                            Behavior on color { ColorAnimation { duration: 200 } }

                            radius: width / 2
                        }

                        onClicked: root.parkingStarted = !root.parkingStarted
                    }
                }
            }

            Button {
                implicitWidth: Sizes.dp(250)
                implicitHeight: Sizes.dp(70)

                anchors.left: parent.left
                anchors.leftMargin: Sizes.dp(100)
                anchors.top: parent.top
                anchors.topMargin: Sizes.dp(340)

                font.pixelSize: Sizes.fontSizeM
                text: qsTr("Call for support")

                onClicked: sendIntent();

                function sendIntent() {
                    var appId = "com.pelagicore.phone";
                    var request = IntentClient.sendIntentRequest("call-support", appId, {});
                    request.onReplyReceived.connect(function() {
                        if (request.succeeded) {
                            var result = request.result
                            console.log(Logging.apps, "Intent result: " + result.done)
                        } else {
                            console.log(Logging.apps, "Intent request failed: " + request.errorMessage)
                        }
                    });
                }
            }

        }
    }
}
