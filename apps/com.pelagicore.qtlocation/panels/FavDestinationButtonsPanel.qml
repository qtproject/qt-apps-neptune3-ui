/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AB
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
import QtQuick.Layouts 1.3
import QtPositioning 5.9

import animations 1.0
import utils 1.0
import com.pelagicore.styles.neptune 3.0
import "../controls"
import "../helpers"

Item {
    id: root

    property var homeAddressData
    property var workAddressData

    property string homeRouteTime: ""
    property string workRouteTime: ""

    property Helper helper: Helper {}

    signal showRoute(var destCoord, string description)

    RowLayout {
        anchors.fill: parent
        MapToolButton {
            id: buttonGoHome
            Layout.preferredWidth: root.width/2
            anchors.verticalCenter: parent.verticalCenter
            iconSource: helper.localAsset("ic-home", NeptuneStyle.theme)
            primaryText: qsTr("Home")
            extendedText: homeRouteTime
            //TODO: add properties to the root object to access this externally
            secondaryText: "Welandergatan 29"
            onClicked: root.showRoute(root.homeAddressData, secondaryText)
        }
        Rectangle {
            width: 1
            height: parent.height
            opacity: NeptuneStyle.fontOpacityDisabled
            color: NeptuneStyle.primaryTextColor
        }
        MapToolButton {
            id: buttonGoWork
            Layout.preferredWidth: root.width/2
            anchors.verticalCenter: parent.verticalCenter
            iconSource: helper.localAsset("ic-work", NeptuneStyle.theme)
            primaryText: qsTr("Work")
            extendedText: workRouteTime
            //TODO: add properties to the root object to access this externally
            secondaryText: "Östra Hamngatan 16"
            onClicked: root.showRoute(root.workAddressData, secondaryText)
        }
    }
}
