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

import QtQuick
import QtQuick.Layouts
import QtPositioning

import shared.animations
import shared.utils
import shared.Style
import shared.Sizes
import "../controls"
import "../helpers"

Item {
    id: root

    property bool offlineMapsEnabled: false

    property var homeAddressData
    property var workAddressData

    property string homeRouteTime: ""
    property string workRouteTime: ""

    signal showDestinationPoint(var destCoord, string description)

    RowLayout {
        anchors.fill: parent
        MapToolButton {
            id: buttonGoHome
            Layout.fillHeight: true
            Layout.preferredWidth: root.width/2
            enabled: !root.offlineMapsEnabled
            Layout.alignment: Qt.AlignVCenter
            iconSource: Helper.localAsset("ic-home", Style.theme)
            primaryText: qsTr("Home")
            extendedText: homeRouteTime
            //TODO: add properties to the root object to access this externally
            secondaryText: qsTr("Welandergatan 29")
            onClicked: root.showDestinationPoint(root.homeAddressData, secondaryText)
        }
        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: Sizes.dp(1)
            opacity: Style.defaultDisabledOpacity
            color: Style.contrastColor
        }
        MapToolButton {
            id: buttonGoWork
            Layout.fillHeight: true
            Layout.preferredWidth: root.width/2
            enabled: !root.offlineMapsEnabled
            Layout.alignment: Qt.AlignVCenter
            iconSource: Helper.localAsset("ic-work", Style.theme)
            primaryText: qsTr("Work")
            extendedText: workRouteTime
            //TODO: add properties to the root object to access this externally
            secondaryText: qsTr("Östra Hamngatan 16")
            onClicked: root.showDestinationPoint(root.workAddressData, secondaryText)
        }
    }
}
