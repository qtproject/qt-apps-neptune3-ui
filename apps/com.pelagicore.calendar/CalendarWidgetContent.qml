/****************************************************************************
**
** Copyright (C) 2017-2018 Pelagicore AG
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
import QtQml 2.2
import QtQuick.Controls 2.2
import utils 1.0
import animations 1.0

import com.pelagicore.styles.neptune 3.0

Item {
    id: root

    property string precipitationIcon: Style.symbol("ic-rain-amount")
    property string precipitationText: "0 - 2 mm"
    property string weatherName
    property string weatherIcon
    property int temp

    property date currentTime: new Date()
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
        source: Style.gfx2("widget-left-section-bg", NeptuneStyle.theme)
        fillMode: Image.TileVertically

        Item {
            id: leftContentBox
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.leftMargin: Style.hspan(1)
            anchors.right: parent.right
            anchors.rightMargin: Style.hspan(30/45)

            Label {
                id: firstRowOfText
                anchors.baseline: parent.top
                anchors.baselineOffset: Style.vspan(87/80)
                anchors.left: parent.left
                anchors.right: parent.right
                elide: Text.ElideRight
                font.weight: Font.Light
                text: root.currentTime.toLocaleDateString(Qt.locale(Style.languageLocale), "dddd") + ","
            }

            Label {
                anchors.baseline: parent.top
                anchors.baselineOffset: Style.vspan(120/80)
                anchors.left: parent.left
                anchors.right: parent.right
                elide: Text.ElideRight
                font.weight: Font.Light
                text: Qt.locale(Style.languageLocale).standaloneMonthName(root.currentTime.getMonth(), Locale.LongFormat)
                                                                          + " " + root.currentTime.getDate()
            }

            WeatherWidget {
                // weather info when in left area (size 2 & 3)
                anchors.top: parent.top
                anchors.topMargin: Style.vspan(252/80)
                anchors.left: parent.left
                width: Style.hspan(175/45)

                opacity: calendarEvents.isMultiLineWidget ? 1 : 0
                Behavior on opacity { DefaultNumberAnimation { } }
                visible: opacity > 0

                weatherIcon: Style.symbol(root.weatherIcon, NeptuneStyle.theme)
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
        //weather info when in right area (size 1)
        id: weatherColumn
        anchors.left: leftColoredArea.right
        anchors.leftMargin: Style.hspan(59/45)
        width: Style.hspan(175/45)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Style.vspan(1)
        opacity: !calendarEvents.isMultiLineWidget
        Behavior on opacity { DefaultNumberAnimation { } }
        visible: opacity > 0

        weatherIcon: Style.symbol(root.weatherIcon, NeptuneStyle.theme)
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
        readonly property real rowHeight: Style.vspan(38/80)

        anchors.bottom: parent.bottom
        anchors.bottomMargin: isMultiLineWidget ? Style.vspan(77/80) : Style.vspan(75/80)
        anchors.left: leftColoredArea.right
        anchors.leftMargin: isMultiLineWidget ? Style.hspan(45/45) : Style.hspan(340/45)
        anchors.right: parent.right
        anchors.rightMargin: Style.hspan(45/45)

        readonly property real _height: root.height < Style.vspan(300/80) ? rowHeight : root.height < Style.vspan(680/80) ? parent.height - Style.vspan(2) : parent.height - weatherGraphPlaceholder.height - Style.vspan(1.6)
        height: Math.min(eventList.count * rowHeight, _height - (_height % rowHeight))

        Behavior on anchors.bottomMargin { DefaultNumberAnimation {} }
        Behavior on anchors.leftMargin { DefaultNumberAnimation {} }

        ListView {
            id: eventList
            anchors.fill: parent
            clip: true

            model: {
                if (eventModel.count === 0) {
                    return 0
                } else if (root.height < Style.vspan(300/80)) {
                    return 1
                } else {
                    return eventModel.count
                }
            }

            delegate: Item {
                width: parent.width
                height: calendarEvents.rowHeight

                Label {
                    id: eventTimeStart
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    width: Style.hspan(68/45)
                    height: Style.vspan(33/80)
                    horizontalAlignment: Text.AlignRight
                    opacity: 0.5    //todo: connect to style or similar
                    font.pixelSize: NeptuneStyle.fontSizeS
                    font.weight: Font.Light
                    text: eventModel.get(index).timeStart
                }
                Label {
                    id: eventName
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    width: calendarEvents.width - eventTimeStart.width - Style.hspan(26/45)
                    height: Style.vspan(33/80)
                    font.pixelSize: NeptuneStyle.fontSizeS
                    font.weight: Font.Light
                    elide: Text.ElideRight
                    text: eventModel.get(index).event
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
