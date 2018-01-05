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

import QtQuick 2.8
import QtQml 2.2
import QtQuick.Controls 2.2
import utils 1.0

import com.pelagicore.styles.triton 1.0

Item {
    id: root

    property alias eventTimeStart: eventTimeStart.text
    property alias eventName: eventName.text
    property string weatherName
    property string weatherIcon
    property int temp
    property date currentTime: new Date()

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
            break;
        case 1:
            root.weatherName = QT_TR_NOOP("Rain");
            root.weatherIcon = "ic-weather-rain";
            root.temp = 18;
            break;
        case 2:
            root.weatherName = QT_TR_NOOP("Light Snow");
            root.weatherIcon = "ic-weather-snow";
            root.temp = -3;
            break;
        case 3:
            root.weatherName = QT_TR_NOOP("Sunny");
            root.weatherIcon = "ic-weather-sun";
            root.temp = 30;
            break;
        }
    }

    Row {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        spacing: Style.hspan(1.5)

        Image {
            width: Style.hspan(6.2)
            height: width
            source: Style.gfx2("widget-left-section-bg", TritonStyle.theme)
            fillMode: Image.Stretch

            Label {
                id: currentDate
                width: Style.hspan(4.5)
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: Style.vspan(1)
                text: root.currentTime.toLocaleDateString(Qt.locale(Style.languageLocale))
                wrapMode: Text.WordWrap
            }
        }

        Column {
            anchors.top: parent.top
            anchors.topMargin: Style.vspan(1)
            spacing: Style.vspan(0.5)

            Image {
                source: Style.symbol(root.weatherIcon, false, TritonStyle.theme)
            }

            Column {
                spacing: Style.vspan(0.1)

                Label {
                    text: "24° " + qsTr(root.weatherName) + ","
                    opacity: 0.8
                    font.pixelSize: TritonStyle.fontSizeS
                }

                Row {
                    spacing: Style.hspan(0.5)

                    Image {
                        anchors.verticalCenter: parent.verticalCenter
                        source: Style.symbol("ic-rain-amount")
                    }

                    Label {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "0 - 2 mm"
                        opacity: 0.8
                        font.pixelSize: TritonStyle.fontSizeS
                    }
                }
            }
        }

        Row {
            anchors.verticalCenter: parent.verticalCenter
            spacing: Style.hspan(0.3)

            Label {
                id: eventTimeStart
                opacity: 0.5
                font.pixelSize: TritonStyle.fontSizeS
            }

            Label {
                id: eventName
                font.pixelSize: TritonStyle.fontSizeS
            }
        }
    }
}
