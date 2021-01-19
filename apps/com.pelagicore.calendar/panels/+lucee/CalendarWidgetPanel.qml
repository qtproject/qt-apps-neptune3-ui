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
import QtQml 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.calendar 1.0
import shared.utils 1.0
import shared.animations 1.0
import "../controls" 1.0
import shared.Style 1.0
import shared.Sizes 1.0

Item {
    id: root

    property var store
    signal dateClicked()

    Item {
        anchors.left: parent.left
        anchors.leftMargin: root.state !== "Widget3Rows" ? Sizes.dp(77) : Sizes.dp(700)
        Behavior on anchors.leftMargin { DefaultNumberAnimation {} }
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: root.state !== "Widget3Rows" ? 0 : - Sizes.dp(230)
        Behavior on anchors.verticalCenterOffset { DefaultNumberAnimation {} }
        width: Sizes.dp(250)
        height: root.height
        Behavior on height { DefaultNumberAnimation {} }
        Image {
            id: dummyWeatherImg
            anchors.verticalCenter: parent.verticalCenter
            height: root.state === "Widget1Row" ? Sizes.dp(180) : Sizes.dp(199)
            Behavior on height { DefaultNumberAnimation {} }
            width: height
            source: Qt.resolvedUrl("../assets/dummy-weather.png")
        }

        Label {
            anchors.horizontalCenter: dummyWeatherImg.horizontalCenter
            anchors.top: dummyWeatherImg.bottom
            anchors.topMargin: Sizes.dp(37)
            text: qsTr("Partly sunny, 21°C")
            font.pixelSize: Sizes.dp(26)
            font.weight: Font.Normal
            visible: root.state !== "Widget1Row"
            opacity: visible ? 1.0 : 0.0
            Behavior on opacity { DefaultNumberAnimation { } }
        }

        Label {
            anchors.left: dummyWeatherImg.right
            anchors.leftMargin: Sizes.dp(10)
            anchors.top: dummyWeatherImg.top
            anchors.topMargin: Sizes.dp(10)
            text: Qt.locale(Config.languageLocale).standaloneMonthName(root.store.currentTime.getMonth(), Locale.LongFormat) +
                  " " + root.store.currentTime.getDate() // "June 21, 2019"
            font.pixelSize: Sizes.dp(20)
            font.weight: Font.Normal
            visible: opacity > 0.0
            opacity: root.state === "Widget1Row" ? 1.0 : 0.0
            Behavior on opacity { DefaultNumberAnimation { } }
        }

        Label {
            anchors.left: dummyWeatherImg.right
            anchors.leftMargin: Sizes.dp(10)
            anchors.bottom: dummyWeatherImg.bottom
            anchors.bottomMargin: Sizes.dp(10)
            text: qsTr("21°C")
            font.pixelSize: Sizes.dp(26)
            font.weight: Font.Normal
            visible: opacity > 0.0
            opacity: root.state === "Widget1Row" ? 1.0 : 0.0
            Behavior on opacity { DefaultNumberAnimation { } }
        }
    }

    Column {
        anchors.left: parent.left
        anchors.leftMargin: Sizes.dp(59)
        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(62)

        spacing: Sizes.dp(10)
        visible: root.state === "Widget2Rows"
        opacity: visible ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation { } }

        Label {
            text: Qt.locale(Config.languageLocale).standaloneMonthName(root.store.currentTime.getMonth(), Locale.LongFormat) +
                  " " + root.store.currentTime.getDate() + ", " + Qt.formatDate(root.store.currentTime, "yyyy") // "June 21, 2019"
            font.pixelSize: Sizes.dp(20)
            font.weight: Font.Normal
        }

        Label {
            text: Qt.formatDateTime(root.store.currentTime, "hh:mm") //"12:34"
            font.pixelSize: Sizes.dp(20)
            font.weight: Font.Normal
        }
    }

    Item {
        width: Sizes.dp(80)
        height: Sizes.dp(400)
        visible: root.state !== "Widget1Row"
        opacity: visible ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation { } }
        anchors.right: eventList.left
        anchors.verticalCenter: eventList.verticalCenter
        anchors.verticalCenterOffset: Sizes.dp(10)

        Column {
            Repeater {
                model: 5
                Image {
                    id: weatherIcon
                    width: Sizes.dp(80)
                    height: Sizes.dp(80)
                    fillMode: Image.PreserveAspectFit

                    Connections {
                        target: root
                        function onDateClicked() {
                            weatherIcon.randomIndex = Math.floor((Math.random() * (3)) + 0);
                        }
                    }

                    property int randomIndex: Math.floor((Math.random() * (3)) + 0)
                    source: {
                        switch (randomIndex) {
                        case 0:
                            return Qt.resolvedUrl("../assets/icon_sunny_cloudy_green.png")
                        case 1:
                            return Qt.resolvedUrl("../assets/icon_cloudy.png")
                        case 2:
                            return Qt.resolvedUrl("../assets/icon_sunny_cloudy.png")
                        default:
                            return Qt.resolvedUrl("../assets/icon_sunny_cloudy_green.png")
                        }
                    }
                }
            }
        }
    }

    EventList {
        id: eventList
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: root.state !== "Widget3Rows" ? 0 : Sizes.dp(180)
        Behavior on anchors.verticalCenterOffset { DefaultNumberAnimation {} }
        anchors.right: parent.right
        anchors.rightMargin: root.state !== "Widget3Rows" ? Sizes.dp(15) : Sizes.dp(250)
        Behavior on anchors.rightMargin { DefaultNumberAnimation {} }
        width: Sizes.dp(600)
        height: root.state === "Widget1Row" ? Sizes.dp(150) : Sizes.dp(375)
        Behavior on height { DefaultNumberAnimation {} }
        model: root.state === "Widget1Row" ? 2 : 5
        delegatedItemWidth: width
        interactive: false
        delegate: EventListItem {
            property int randomIndex: Math.floor((Math.random() * (8)) + 0)
            width: eventList.delegatedItemWidth
            height: eventList.delegatedItemHeight
            eventTimeStart: root.store.eventModel.get(index + 2).timeStart
            eventTimeEnd: root.store.eventModel.get(index + 2).timeEnd
            eventLabel: root.store.eventModel.get(index + 2).event
        }
    }

    ColumnLayout {
        anchors.left: parent.left
        anchors.leftMargin: Sizes.dp(144)
        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(45)

        visible: root.state === "Widget3Rows"
        opacity: visible ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation { } }

        DayOfWeekRow {
            Layout.preferredWidth: Sizes.dp(320)
            Layout.maximumWidth: Sizes.dp(320)
            Layout.preferredHeight: Sizes.dp(40)
            Layout.maximumHeight: Sizes.dp(40)
            spacing: Sizes.dp(4)
            topPadding: Sizes.dp(4)
            bottomPadding: Sizes.dp(4)
            locale: grid.locale
            delegate: Label {
                text: model.shortName
                font.pixelSize: Sizes.dp(20)
                font.capitalization: Font.AllUppercase
                color: Style.contrastColor
                horizontalAlignment: Text.AlignHCenter
            }
        }
        MonthGrid {
            id: grid
            locale: Qt.locale(Config.languageLocale)
            Layout.preferredWidth: Sizes.dp(350)
            Layout.maximumWidth: Sizes.dp(350)
            Layout.preferredHeight: Sizes.dp(320)
            Layout.maximumHeight: Sizes.dp(320)

            property string currentDate: Qt.formatDate(root.store.currentTime, "d")

            delegate: Item {
                width: Sizes.dp(40)
                height: width
                opacity: model.month === grid.month ? 1 : 0

                Rectangle {
                    anchors.centerIn: parent
                    width: Sizes.dp(38)
                    height: width
                    radius: width / 2
                    color: dateLabel.text === grid.currentDate ?
                               Style.accentColor : "transparent"
                }
                Label {
                    id: dateLabel
                    anchors.centerIn: parent
                    text: model.day
                    color: dateLabel.text === grid.currentDate ?
                                "white" : Style.contrastColor
                    font.pixelSize: Sizes.dp(20)
                    horizontalAlignment: Text.AlignHCenter
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        grid.currentDate = dateLabel.text
                        root.dateClicked()
                    }
                }
            }
        }
    }

    Label {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(200)
        visible: root.state === "Widget3Rows"
        opacity: visible ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation { } }

        font.pixelSize: Sizes.dp(26)
        font.weight: Font.Normal
        text: Qt.locale().standaloneMonthName(grid.month) + " " + grid.year
        rotation: 270
    }
}
