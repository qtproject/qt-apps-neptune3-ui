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

import shared.utils 1.0

/*
    Holds lucee style Speed, Time, Mileage, Route progress
*/

Item {
    id: root

    /*
        Holds point where speed rect will be placed
    */
    property point screenCenter: Qt.point(0,0)

    property real navigationProgressPercents
    property real navigationRouteDistance
    property date currentDate
    property bool twentyFourHourTimeFormat
    property real speed
    property string speedUnits
    property real mileage
    property string mileageUnits

    /*!
        Defines current state of right-to-left
    */
    property bool rtlMode: false
    /*
        Defines labels text color inside speed panel
    */
    property color textColor: "#545454"

    width: Sizes.dp(560)
    height: width

    /*
        speed rect source for shadow
    */
    Rectangle{
        id: speedRectangle
        x: root.screenCenter.x - width / 2
        y: root.screenCenter.y - height / 2
        visible: false
        color: "white"
        radius: Sizes.dp(50)
        width: Sizes.dp(404)
        height: Sizes.dp(219)
    }

    /*
        actual rect showing
    */
    DropShadow{
        id: speedRectangleShadow
        anchors.fill: speedRectangle
        horizontalOffset: 0
        verticalOffset: 0
        radius: Sizes.dp(10)
        samples: 10
        color: "gray"
        source: speedRectangle
        opacity: 0.7
    }

    /*
        speed label
    */
    Label {
        id: speedLabel
        anchors.baseline: speedRectangle.baseline
        anchors.baselineOffset: Sizes.dp(150)
        anchors.horizontalCenter: speedRectangle.horizontalCenter
        text: root.speed

        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: Sizes.dp(150)
    }

    /*
        speed units label
    */
    Label {
        id: unitsLabel
        anchors.horizontalCenter: speedRectangle.horizontalCenter
        anchors.bottom: speedRectangle.bottom
        anchors.bottomMargin: Sizes.dp(20)
        text: root.speedUnits
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: Sizes.dp(25)
        color: root.textColor
    }

    /*
        top right corner time
    */
    Label {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: Sizes.dp(40)
        anchors.topMargin: Sizes.dp(20)
        text: Config.translation.formatTime(root.currentDate, root.twentyFourHourTimeFormat)
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignHCenter
        font.weight: Font.Light
        font.pixelSize: Sizes.dp(30)
        color: root.textColor
    }

    /*
        lower right corner mileage label
    */
    ClusterUnitsLabel{
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: Sizes.dp(40)
        anchors.bottomMargin: Sizes.dp(20)
        value: root.mileage.toFixed(1)
        units: root.mileageUnits
        pixelSize: Sizes.dp(30)
        fontColor: root.textColor
    }

    /*
        route precent completed gauge
    */
    DonutGauge{
        width: Sizes.dp(70)
        height: Sizes.dp(360)
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: Sizes.dp(124)
        anchors.right: parent.right
        value: root.navigationProgressPercents
        isLeft: root.rtlMode
        valueText: root.navigationRouteDistance.toFixed(1)
        valueUnits: root.mileageUnits
        icon: Utils.localAsset("ic-distance", Style.theme)
    }

    state: "speed_center"
    states: [
        State {
            // "Cluster with app" mode, turn on when app is shown in the cluster
            name: "speed_right"
            PropertyChanges { target: speedRectangle;
                x: rtlMode ? root.screenCenter.x - speedRectangle.width / 2 - Sizes.dp(485) :
                       root.screenCenter.x - speedRectangle.width / 2 + Sizes.dp(485);
                width: Sizes.dp(300); height: Sizes.dp(150); radius: Sizes.dp(37) }
            PropertyChanges { target: speedLabel; font.pixelSize: Sizes.dp(100);
                        anchors.baselineOffset: Sizes.dp(100) }
            PropertyChanges { target: unitsLabel; font.pixelSize: Sizes.dp(20);
                        anchors.bottomMargin: Sizes.dp(15) }
            PropertyChanges { target: speedRectangleShadow; opacity: 0.8 }
        }
    ]

    transitions: Transition {
        NumberAnimation {
            properties: "x,y,width,height,font.pixelSize,anchors.baselineOffset,radius,anchors.bottomMargin,opacity";
            duration: 500; easing.type: Easing.InOutQuad }
    }
}
