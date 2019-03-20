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

import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import "../helpers" 1.0
import shared.Style 1.0
import shared.Sizes 1.0

/*
    A lucee component for showing temperature in Cluster
    Is mesuarement system aware (C,F)
*/

Item{
    id: root

    /*
        temperature according to ClusterStore::outsideTemp object
    */
    property var temperatureObject
    /*
        Temperature number font size, F or C units size scaled down by 0.5
    */
    property int pixelSize
    /*
        Label font color
    */
    property color fontColor: "#5e5d5d"

    width: row.width
    height: row.height

    Row{
        id: row

        LayoutMirroring.enabled: false //disabled, no need C, F in front of number
        anchors.centerIn: parent
        /*
            Numbers
        */
        Label {
            id: numberValue
            /*
                Temperature value parts
            */
            readonly property int integers: root.temperatureObject ? Math.floor(root.temperatureObject.localizedValue) : 0
            readonly property int decimals: root.temperatureObject ? (root.temperatureObject.localizedValue
                                                                      - Math.floor(root.temperatureObject.localizedValue)) * 10 : 0
            Layout.fillHeight: true
            textFormat: Text.RichText
            text: integers + "<font size=\""+Sizes.dp(40)+"px\">" + Qt.locale().decimalPoint + decimals + "</font>"
            padding: 0
            verticalAlignment: Text.AlignBottom
            font.pixelSize: root.pixelSize
            font.weight: Font.Light
            color: root.fontColor
        }
        /*
            Units
        */
        Label {
            anchors.baseline: numberValue.baseline
            text: {
                if (root.temperatureObject) {
                    return root.temperatureObject.localizedUnits
                } else {
                    return ""
                }
            }
            font.pixelSize: pixelSize * 0.5
            font.weight: Font.Normal
            color: root.fontColor
        }
    }
}
