/****************************************************************************
**
** Copyright (C) 2017-2018 Pelagicore AG
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
import QtQml 2.2
import QtQuick.Controls 2.2
import utils 1.0
import animations 1.0

import com.pelagicore.styles.triton 1.0

Item {
    id: root

    property string precipitationIcon: Style.symbol("ic-rain-amount")
    property string precipitationText: "0 - 2 mm"
    property string weatherName
    property string weatherIcon
    property int temp

    property date currentTime: new Date()
    readonly property var monthNames: [
        qsTr("January"), qsTr("February"), qsTr("March"),
        qsTr("April"), qsTr("May"), qsTr("June"),
        qsTr("July"), qsTr("August"), qsTr("September"),
        qsTr("October"), qsTr("November"), qsTr("December")
    ]
    property ListModel eventModel

    Component.onCompleted: {
        root.generateWeather();
    }

    function generateWeather() {
        var randNum = Math.floor((Math.random() * 3 + 0));
        switch (randNum) {
        case 0:
            root.weatherName = QT_TR_NOOP("Partly rain");
            root.weatherIcon = "ic-weather-partly-rain";
            root.temp = 20;
            root.precipitationText = "0 - 2 mm"
            root.precipitationIcon = Style.symbol("ic-rain-amount")
            break;
        case 1:
            root.weatherName = QT_TR_NOOP("Rain");
            root.weatherIcon = "ic-weather-rain";
            root.temp = 18;
            root.precipitationText = "4.5 - 6 mm"
            root.precipitationIcon = Style.symbol("ic-rain-amount")
            break;
        case 2:
            root.weatherName = QT_TR_NOOP("Light Snow");
            root.weatherIcon = "ic-weather-snow";
            root.temp = -3;
            root.precipitationText = "1 - 3 mm"
            root.precipitationIcon = Style.symbol("ic-rain-amount")
            break;
        case 3:
            root.weatherName = QT_TR_NOOP("Sunny");
            root.weatherIcon = "ic-weather-sun";
            root.precipitationText = ""
            root.precipitationIcon = ""
            root.temp = 30;
            break;
        }
    }

    Timer {
        running: true
        interval: 60000
        repeat: true
        onTriggered: currentTime = new Date()
    }

    Image {
        id: leftColoredArea
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        source: Style.gfx2("widget-left-section-bg", TritonStyle.theme)
        fillMode: Image.TileVertically

        Column {
            id: currentDate
            anchors.left: parent.left
            anchors.leftMargin: Style.hspan(0.7)
            anchors.right: parent.right
            anchors.rightMargin: Style.hspan(0.3)
            anchors.top: parent.top
            anchors.topMargin: Style.vspan(1)
            Label {
                width: parent.width
                elide: Text.ElideRight
                text: root.currentTime.toLocaleDateString(Qt.locale(Style.languageLocale), "dddd")
            }
            Label {
                width: parent.width
                elide: Text.ElideRight
                text: monthNames[root.currentTime.getMonth()] + ", " + root.currentTime.getDate()
            }

            Item {
                width: parent.width
                height: Style.vspan(1.2)
                opacity: calendarEvents.isMultiLineWidget ? 1 : 0
                Behavior on opacity { DefaultNumberAnimation { } }
                visible: opacity > 0
            }

            WeatherWidget {
                opacity: calendarEvents.isMultiLineWidget ? 1 : 0
                Behavior on opacity { DefaultNumberAnimation { } }
                visible: opacity > 0

                weatherIcon: Style.symbol(root.weatherIcon, TritonStyle.theme)
                weatherText: qsTr(root.weatherName)

                temperatureValue: root.temp
                temperatureVisible: true

                precipitationIcon: root.precipitationIcon
                precipitationText: root.precipitationText
                precipitationVisible: precipitationText !== ""
            }
        }
    }

    WeatherWidget {
        id: weatherColumn
        anchors.left: leftColoredArea.right
        anchors.leftMargin: Style.vspan(0.5)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Style.hspan(0.6)
        opacity: !calendarEvents.isMultiLineWidget
        Behavior on opacity { DefaultNumberAnimation { } }
        visible: opacity > 0

        weatherIcon: Style.symbol(root.weatherIcon, TritonStyle.theme)
        weatherText: qsTr(root.weatherName)

        temperatureValue: root.temp
        temperatureVisible: false

        precipitationIcon: root.precipitationIcon
        precipitationText: root.precipitationText
        precipitationVisible: precipitationText !== ""
    }

    Item {
        id: calendarEvents
        readonly property bool isMultiLineWidget: root.height > Style.hspan(6)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Style.hspan(0.3)
        anchors.left: leftColoredArea.right
        anchors.leftMargin: calendarEvents.isMultiLineWidget ? Style.hspan(1) : weatherColumn.width + Style.hspan(1.5)
        anchors.right: parent.right
        anchors.rightMargin: Style.hspan(1)
        height: calendarEvents.isMultiLineWidget ? Style.hspan(4.5) : Style.hspan(1.5)

        Behavior on anchors.bottomMargin { DefaultNumberAnimation {} }
        Behavior on anchors.leftMargin { DefaultNumberAnimation {} }
        Behavior on height { DefaultNumberAnimation {} }

        Column {
            width: parent.width
            spacing: Style.hspan(0.3)
            Repeater {
                model: {
                    if ( (!calendarEvents.isMultiLineWidget)&&(eventModel.count > 0)) {
                        return 1
                    } else if (eventModel.count > 0) {
                        var numOfItems = Math.floor(calendarEvents.height/(Style.hspan(0.8)))
                        return eventModel.count >= numOfItems ? numOfItems : eventModel.count
                    } else {
                        return 0
                    }
                }

                delegate: Row {
                    id: rowEvent
                    width: parent.width
                    height: Style.hspan(0.5)
                    spacing: Style.hspan(0.3)
                    Label {
                        id: eventTimeStart
                        anchors.verticalCenter: parent.verticalCenter
                        width: Style.hspan(2)
                        opacity: 0.5
                        font.pixelSize: TritonStyle.fontSizeS
                        text: eventModel.get(index).timeStart
                    }
                    Label {
                        id: eventName
                        anchors.verticalCenter: parent.verticalCenter
                        width: calendarEvents.width - eventTimeStart.width - rowEvent.spacing
                        font.pixelSize: TritonStyle.fontSizeS
                        elide: Text.ElideRight
                        text: eventModel.get(index).event
                    }
                }
            }
        }
    }

    Image {
        id: weatherGraphPlaceholder
        readonly property bool graphActive: (root.height > (sourceSize.height + calendarEvents.height + Style.hspan(1))) && (root.state === "Widget3Rows")
        anchors.top: parent.top
        anchors.topMargin: graphActive ? 0 : -Style.vspan(0.5)
        anchors.left: leftColoredArea.right
        opacity: graphActive ? 1 : 0
        visible: opacity > 0
        Behavior on opacity { DefaultNumberAnimation { duration: 600 } }
        Behavior on anchors.topMargin { DefaultNumberAnimation { duration: 600 } }
        source: Qt.resolvedUrl("./assets/weather-graph.png")
    }
}
