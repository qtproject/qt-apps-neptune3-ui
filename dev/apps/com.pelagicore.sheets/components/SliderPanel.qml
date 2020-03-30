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
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import shared.utils 1.0

import shared.Sizes 1.0

Item {
    Column {
        id: columnContent
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: Sizes.dp(10)
        Label {
            text: qsTr("Vertical / Horizontal sliders")
        }
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: Sizes.dp(50)
            Slider {
                anchors.verticalCenter: parent.verticalCenter
                height: Sizes.dp(500)
                from: 0
                to: 100
                value: 35
                orientation: Qt.Vertical
            }
            Slider {
                anchors.verticalCenter: parent.verticalCenter
                width: Sizes.dp(700)
                from: 0
                to: 100
                value: 35
                orientation: Qt.Horizontal
            }
        }
        Label {
            text: qsTr("Vertical / Horizontal stepper sliders")
        }
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: Sizes.dp(50)
            Slider {
                anchors.verticalCenter: parent.verticalCenter
                height: Sizes.dp(500)
                from: 0
                to: 100
                value: 40
                stepSize: 20
                orientation: Qt.Vertical
            }
            Slider {
                anchors.verticalCenter: parent.verticalCenter
                width: Sizes.dp(700)
                from: 0
                to: 100
                value: 30
                stepSize: 10
                orientation: Qt.Horizontal
            }
        }
    }
}
