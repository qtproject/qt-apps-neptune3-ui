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
import QtQuick.Controls 2.2
import utils 1.0
import animations 1.0

import com.pelagicore.styles.neptune 3.0

Item {
    id: root

    property alias weatherIcon: imgWeather.source
    property string weatherText: ""

    property int temperatureValue: 0
    property bool temperatureVisible: true  //temperature on own row or not

    property alias precipitationVisible: precipitationRow.visible
    property alias precipitationIcon: precipitationIcon.source
    property alias precipitationText: precipitationText.text

    height: childrenRect.height

    Image {
        id: imgWeather
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: Style.vspan(66/80)//Style.vspan(66/80)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: Style.hspan(-61/45)
        fillMode: Image.Pad
    }

    Column {
        id: textColumn
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: Style.vspan(120/80)//Style.vspan(140/80)

        Label {
            id: temperatureLabel
            height: Style.vspan(33/80)
            anchors.left: parent.left
            anchors.right: parent.right
            font.pixelSize: NeptuneStyle.fontSizeS
            font.weight: Font.Light
            opacity: NeptuneStyle.fontOpacityMedium
            visible: root.temperatureVisible
            text: root.temperatureValue + "°"
        }
        Label {
            id: weatherLabel
            height: Style.vspan(33/80)
            anchors.left: parent.left
            anchors.right: parent.right
            font.pixelSize: NeptuneStyle.fontSizeS //Todo: font size in the plugin is not correct.
            font.weight: Font.Light
            opacity: NeptuneStyle.fontOpacityMedium
            text: (temperatureVisible ? root.weatherText : root.temperatureValue + "° " + root.weatherText) + (precipitationVisible ? "," : "")
        }
        Item {
            id: precipitationRow
            anchors.left: parent.left
            anchors.right: parent.right
            height: precipitationText.height

            Image {
                id: precipitationIcon
                anchors.bottom: parent.bottom
                anchors.left: parent.left
            }

            Label {
                id: precipitationText
                height: Style.vspan(33/80)
                anchors.left: precipitationIcon.right
                anchors.leftMargin: Style.hspan(13/45)
                anchors.right: parent.right
                font.pixelSize: NeptuneStyle.fontSizeS
                font.weight: Font.Light
                opacity: NeptuneStyle.fontOpacityMedium
            }
        }
    }
}
