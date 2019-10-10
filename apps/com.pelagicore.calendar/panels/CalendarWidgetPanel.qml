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

import shared.utils 1.0
import shared.animations 1.0
import "../controls" 1.0
import shared.Style 1.0
import shared.Sizes 1.0

Item {
    id: root

    property string precipitationText: "0 - 2 mm"
    property string weatherName: QT_TR_NOOP("Partly cloudy");
    property string weatherIcon: "weather-cloudy"
    property int temp: 22

    property date currentTime: new Date()
    property ListModel eventModel

    readonly property bool _isMultiLineWidget: root.height > Sizes.dp(330)
    readonly property int _visibleEvents: {
        var n = Math.floor( (root.height - Sizes.dp(100)) / Sizes.dp(48) );
        var n_max = Math.min( (Sizes.dp(652) - weatherGraphPlaceholder.height) / Sizes.dp(48), eventModel.count );

        if (n < n_max) {
            if (n < 0)
                n = 0;
            return n;
        } else {
            if (n_max < 0)
                n_max = 0;
            return n_max;
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
        anchors.bottomMargin: -Sizes.dp(50)
        source: Style.image("widget-left-section-bg")
        fillMode: Image.TileVertically
        width: Sizes.dp(260)

        Item {
            id: leftContentBox
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.leftMargin: Sizes.dp(40)
            anchors.right: parent.right
            anchors.rightMargin: Sizes.dp(40)

            Label {
                id: firstRowOfText
                anchors.baseline: parent.top
                anchors.baselineOffset: Sizes.dp(84)
                anchors.left: parent.left
                anchors.right: parent.right
                elide: Text.ElideRight
                font.weight: Font.Light
                text: root.currentTime.toLocaleDateString(Qt.locale(Config.languageLocale), "dddd") + ",\n" +
                      Qt.locale(Config.languageLocale).standaloneMonthName(root.currentTime.getMonth(), Locale.LongFormat) +
                      " " + root.currentTime.getDate()
            }

            WeatherWidget {
                id: weatherWidget
                y: (root.height - weatherWidget.height - Sizes.dp(64)) < (Sizes.dp(476) - weatherWidget.height) ?
                       root.height - weatherWidget.height - Sizes.dp(64) :
                       (Sizes.dp(476) - weatherWidget.height)
                width: Sizes.dp(220)

                opacity: _isMultiLineWidget ? 1 : 0
                Behavior on opacity { DefaultNumberAnimation {} }
                visible: opacity > 0

                weatherIcon: Style.image(root.weatherIcon)
                weatherText: qsTr(root.weatherName)
                temperatureValue: root.temp
                precipitationText: root.precipitationText
                precipitationVisible: precipitationText !== ""
            }
        }
    }

    Item {
        id: calendarEvents

        anchors.bottom: parent.bottom
        anchors.bottomMargin: Sizes.dp(64)
        anchors.left: leftColoredArea.right
        anchors.leftMargin: Sizes.dp(40)
        width: _isMultiLineWidget ? Sizes.dp(620) : Sizes.dp(320)
        height: eventList.count * Sizes.dp(48)
        Behavior on width {
            SequentialAnimation {
                PauseAnimation { duration: _isMultiLineWidget ? 0 : 100 }
                DefaultNumberAnimation { duration: 100 }
            }
        }

        ListView {
            id: eventList
            anchors.fill: parent

            model: {
                if (eventModel.count === 0) {
                    return 0;
                } else if (_isMultiLineWidget) {
                    return _visibleEvents;
                } else {
                    return 1;
                }
            }

            delegate: RowLayout {
                width: parent.width - Sizes.dp(16)
                height: Sizes.dp(48)

                Label {
                    id: eventTimeStart
                    Layout.alignment: Qt.AlignBottom
                    Layout.preferredWidth: Sizes.dp(74)
                    Layout.preferredHeight: parent.height
                    opacity: Sizes.fontSizeS
                    font.pixelSize: Sizes.fontSizeS
                    font.weight: Font.Light
                    text: eventModel.get(index).timeStart
                }
                Label {
                    id: eventName
                    Layout.alignment: Qt.AlignBottom
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height
                    font.pixelSize: Sizes.fontSizeS
                    font.weight: Font.Light
                    elide: Text.ElideRight
                    text: eventModel.get(index).event
                }
            }
        }
    }

    WeatherWidget {
        id: weatherColumn
        anchors.left: calendarEvents.right
        anchors.rightMargin: Sizes.dp(40)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Sizes.dp(64)
        width: Sizes.dp(220)
        opacity: _isMultiLineWidget ? 0 : 1
        Behavior on opacity {
            SequentialAnimation {
                PauseAnimation { duration: _isMultiLineWidget ? 100 : 0 }
                DefaultNumberAnimation { duration: 100 }
            }
        }

        visible: opacity > 0
        weatherIcon: Style.image(root.weatherIcon)
        weatherText: qsTr(root.weatherName)
        temperatureValue: root.temp
        precipitationText: root.precipitationText
        precipitationVisible: precipitationText !== ""
    }


    Image {
        id: weatherGraphPlaceholder
        readonly property bool graphActive: root.height >= Sizes.dp(780)
        anchors.top: parent.top
        anchors.topMargin: graphActive ? Sizes.dp(84) : Sizes.dp(74)
        anchors.right: parent.right
        anchors.left: leftColoredArea.right
        anchors.leftMargin: Sizes.dp(40)
        fillMode: Image.PreserveAspectFit
        opacity: graphActive ? 1 : 0
        visible: opacity > 0
        Behavior on opacity { DefaultNumberAnimation { duration: 600 } }
        Behavior on anchors.topMargin { DefaultNumberAnimation { duration: 600 } }
        source: Qt.resolvedUrl("../assets/weather-graph" +
                              ((Style.theme === Style.Dark) ? "-dark.png" : ".png"))
    }
}
