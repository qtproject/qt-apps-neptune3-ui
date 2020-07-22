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
import Qt.labs.calendar 1.0
import shared.animations 1.0
import shared.controls 1.0
import shared.utils 1.0
import "../stores" 1.0
import "../controls" 1.0
import "../panels" 1.0

import shared.Style 1.0
import shared.Sizes 1.0

Item {
    id: root

    property CalendarStore store

    signal dateClicked()

    QtObject {
        id: d
        property var locale: Qt.locale()
        property string dateTimeString: "Tue 2013-09-17 10:56:06"

        Component.onCompleted: {
            print(Date.fromLocaleString(locale, dateTimeString, "ddd yyyy-MM-dd hh:mm:ss"));
        }
    }

    Item {
        id: currentMonthContainer
        width: parent.width
        height: Sizes.dp(150)

        Label {
            anchors.left: parent.left
            anchors.leftMargin: Sizes.dp(99)
            anchors.verticalCenter: parent.verticalCenter
            text: Qt.locale().standaloneMonthName(grid.month) + " " + grid.year
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Sizes.dp(37)
            font.weight: Font.Normal
        }
    }

    Item {
        id: weatherContainer
        anchors.top: currentMonthContainer.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: Sizes.dp(700)
        height: Sizes.dp(300)

        Row {
            anchors.verticalCenter: parent.verticalCenter
            spacing: Sizes.dp(100)
            Image {
                height: Sizes.dp(225)
                width: height
                source: Qt.resolvedUrl("../assets/dummy-weather.png")
            }

            Column {
                spacing: Sizes.dp(20)
                Label {
                    text: qsTr("Partly sunny, 21°C")
                    font.pixelSize: Sizes.dp(27)
                }

                Label {
                    text: qsTr("Today: Mostly sunny,\nthe highest temperature will be 26°.")
                    font.pixelSize: Sizes.dp(18)
                }

                Label {
                    text: qsTr("Tonight: Mostly cloudy with light rain,\ntemperatures between 14° and 18°.")
                    font.pixelSize: Sizes.dp(18)
                }
            }
        }
    }

    RowLayout {
        id: calendarRow
        anchors.top: weatherContainer.bottom
        anchors.left: parent.left
        anchors.leftMargin: Sizes.dp(70)
        spacing: Sizes.dp(50)

        ToolButton {
            Layout.alignment: Qt.AlignVCenter
            icon.name: LayoutMirroring.enabled ? "ic_skipnext" : "ic_skipprevious"
            onClicked: {
                if (grid.month === 0) {
                    grid.month = 11;
                    grid.year -= 1;
                } else {
                    grid.month -= 1
                }
            }
        }

        ColumnLayout {
            DayOfWeekRow {
                Layout.preferredWidth: Sizes.dp(700)
                Layout.maximumWidth: Sizes.dp(700)
                Layout.preferredHeight: Sizes.dp(80)
                Layout.maximumHeight: Sizes.dp(80)
                spacing: Sizes.dp(6)
                topPadding: Sizes.dp(6)
                bottomPadding: Sizes.dp(6)
                locale: grid.locale
                delegate: Label {
                    text: model.shortName
                    font.pixelSize: Sizes.dp(30)
                    font.capitalization: Font.AllUppercase
                    color: Style.contrastColor
                    horizontalAlignment: Text.AlignHCenter
                }
            }
            MonthGrid {
                id: grid
                locale: Qt.locale(Config.languageLocale)
                Layout.preferredWidth: Sizes.dp(700)
                Layout.maximumWidth: Sizes.dp(700)
                Layout.preferredHeight: Sizes.dp(420)
                Layout.maximumHeight: Sizes.dp(420)

                property string currentDate: Qt.formatDate(root.store.currentTime, "d")

                delegate: Item {
                    width: Sizes.dp(92)
                    height: width
                    opacity: model.month === grid.month ? 1 : 0

                    Rectangle {
                        anchors.centerIn: parent
                        width: Sizes.dp(67)
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
                        font.pixelSize: Sizes.dp(30)
                        horizontalAlignment: Text.AlignHCenter
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            root.dateClicked()
                            grid.currentDate = dateLabel.text
                        }
                    }
                }
            }
        }

        ToolButton {
            Layout.alignment: Qt.AlignVCenter
            icon.name: LayoutMirroring.enabled ? "ic_skipprevious" : "ic_skipnext"
            onClicked: {
                if (grid.month === 11) {
                    grid.month = 0;
                    grid.year += 1;
                } else {
                    grid.month += 1
                }
            }
        }
    }

    Row {
        anchors.top: calendarRow.bottom
        anchors.topMargin: Sizes.dp(175)
        anchors.left: parent.left
        anchors.leftMargin: Sizes.dp(125)
        spacing: Sizes.dp(15)

        Column {
            Repeater {
                model: 4
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

        EventList {
            id: eventList
            width: Sizes.dp(700)
            height: Sizes.dp(300)
            model: 4
            delegatedItemWidth: eventList.width
            interactive: false
            delegate: EventListItem {
                id: item

                property int randomIndex: Math.floor((Math.random() * (8)) + 0)

                Connections {
                    target: root
                    function onDateClicked() {
                        item.randomIndex = Math.floor((Math.random() * (8)) + 0);
                    }
                }

                width: eventList.delegatedItemWidth
                height: eventList.delegatedItemHeight
                eventTimeStart: root.store.eventModel.get(randomIndex).timeStart
                eventTimeEnd: root.store.eventModel.get(randomIndex).timeEnd
                eventLabel: root.store.eventModel.get(randomIndex).event
            }
        }
    }
}
