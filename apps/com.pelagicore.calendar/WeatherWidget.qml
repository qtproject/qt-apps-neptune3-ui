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
import QtQuick.Controls 2.2
import utils 1.0
import animations 1.0

import com.pelagicore.styles.triton 1.0

Column {
    id: root
    spacing: Style.vspan(0.5)

    property alias weatherIcon: imgWeather.source
    property string weatherText: ""

    property int temperatureValue: 0
    property bool temperatureVisible: true

    property alias precipitationVisible: precipitationRow.visible
    property alias precipitationIcon: precipitationIcon.source
    property alias precipitationText: precipitationText.text

    Image {
        id: imgWeather
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: Style.vspan(0.1)
        Label {
            id: temperatureLabel
            font.pixelSize: TritonStyle.fontSizeS
            opacity: 0.8
            visible: root.temperatureVisible
            text: root.temperatureValue + "°"
        }
        Label {
            id: weatherLabel
            font.pixelSize: TritonStyle.fontSizeS
            opacity: 0.8
            text: (temperatureVisible ? root.weatherText : root.temperatureValue + "° " + root.weatherText) + (precipitationVisible ? "," : "")
        }
        Row {
            id: precipitationRow
            spacing: Style.hspan(0.3)
            Image {
                id: precipitationIcon
                anchors.verticalCenter: parent.verticalCenter
            }
            Label {
                id: precipitationText
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: TritonStyle.fontSizeS
                opacity: 0.8
            }
        }
    }
}
