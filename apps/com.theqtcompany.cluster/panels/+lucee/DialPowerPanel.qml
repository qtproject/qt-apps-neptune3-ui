/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 Cluster UI.
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

import QtQuick 2.12
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Shapes 1.12
import shared.controls 1.0
import "../helpers" 1.0
import shared.Style 1.0
import shared.Sizes 1.0

/*
    Holds lucee style Battery gauge, current gear indicator, outside temperature
*/

Item {
    id: root

    property int ePower
    property int driveTrainState
    property var outsideTemperature

    /*
        Defines current state of right-to-left
    */
    property bool rtlMode: false
    /*
        Defines labels text color inside speed panel
    */
    property color fontColor: "#545454"

    width: Sizes.dp(560)
    height: width

    //private
    QtObject {
        id: d
        /*
            Defines list of gear labels according to int index from store
        */
        readonly property var gears: ["P", "N", "D", "R"]
    }

    /*
        battery gauge
    */
    DonutGauge{
        width: Sizes.dp(70)
        height: Sizes.dp(360)
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: Sizes.dp(124)
        anchors.left: parent.left
        value: root.ePower * 0.01
        isLeft: !root.rtlMode
        valueText: root.ePower
        valueUnits: "%"
        icon: Utils.localAsset("ic-battery", Style.theme)
    }

    /*
        current gear indicator
    */
    Label {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: Sizes.dp(40)
        anchors.bottomMargin: Sizes.dp(40)
        text: d.gears[root.driveTrainState]
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignHCenter
        font.weight: Font.Normal
        font.pixelSize: Sizes.dp(40)
        color: root.fontColor
    }

    /*
        outside temperature
    */
    ClusterTemperatureLabel {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: Sizes.dp(40)
        anchors.topMargin: Sizes.dp(20)
        pixelSize: Sizes.dp(30)
        temperatureObject: root.outsideTemperature
        fontColor: root.fontColor
    }
}
