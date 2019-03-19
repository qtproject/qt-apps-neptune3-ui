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
import QtQuick.Shapes 1.12
import shared.Sizes 1.0
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.2

/*!
    A lucee component for selected mode and range it provides
*/

Item {
    id: root

    /*!
        Range text value
    */
    property alias range: rangeLabel.value
    /*!
        Units text value
    */
    property alias units: rangeLabel.units
    /*!
        Driving mode according to int index in ClusterStore store 0 .. 2
    */
    property int   mode: 0
    property color penColor: "#5e5d5d"

    anchors.verticalCenter: parent.verticalCenter
    x: Sizes.dp(475)
    width: labelRect.width + modeRect.width
    height: modeRect.height
    layer.enabled: true //for opacity applied to whole object, not per item
    LayoutMirroring.onEnabledChanged: {
        fadeAnimattion.restart()
    }

    QtObject {
        id: d
        /*
            Defines list of modes according to int index from store
        */
        readonly property var modes: [qsTr("NORMAL"), qsTr("ECO"), qsTr("SPORT")]
    }

    SequentialAnimation{
        id: fadeAnimattion
        NumberAnimation {
            target: root
            property: "opacity"
            easing.type: Easing.InOutQuad
            from: 0.0; to: 1.0; duration: 2000
        }
    }

    /*!
        Side rect holding range
    */
    Rectangle{
        id: labelRect

        width: Sizes.dp(140)
        height: Sizes.dp(60)
        color: "white"
        radius: height / 2.2
        anchors.verticalCenter: modeRect.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: Sizes.dp(45)
        border.color: root.penColor
        border.width: Sizes.dp(2)

        ClusterUnitsLabel{
            id: rangeLabel
            anchors.right: parent.right
            anchors.rightMargin: Sizes.dp(10)
            anchors.verticalCenter: parent.verticalCenter
            value: root.valueText
            units: root.valueUnits
            pixelSize: Sizes.dp(23)
            fontColor: "black"
        }
    }

    /*!
        Central circle holding mode name text
    */
    Rectangle{
        id: modeRect

        width: Sizes.dp(81); height: width
        color: root.penColor
        radius: width / 2
        anchors.left: root.left

        Label {
            anchors.centerIn: parent
            color: "white"
            font.weight: Font.Normal
            font.pixelSize: Sizes.dp(17)
            text: d.modes[root.mode]
        }
    }
}






