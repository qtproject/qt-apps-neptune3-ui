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
import QtQuick.Controls

import shared.utils
import shared.controls
import shared.animations

import shared.Style
import shared.Sizes

Item {
    id: root

    property alias radioText: actualProgram.text
    property string stationName
    property string stationLogoUrl
    property real frequency
    property int numberOfDecimals: 1

    Item {
        id: logoWrapper
        width: stationLogoShadow.width
        height: stationLogoShadow.height
        anchors.verticalCenter: parent.verticalCenter

        Image {
            id: stationLogoShadow
            width: Sizes.dp(sourceSize.width)
            height: Sizes.dp(sourceSize.height)
            source: Style.image("album-art-shadow")
        }

        Image {
            opacity: (root.stationLogoUrl === "" || stationLogoImg.status === Image.Error) ?
                     1.0 : 0.0
            Behavior on opacity { DefaultNumberAnimation {} }
            visible: opacity > 0.0
            anchors.centerIn: parent
            width: Sizes.dp(180)
            height: width
            source: Style.image("album-art-placeholder")
            fillMode: Image.PreserveAspectCrop
        }

        Image {
            id: stationLogoImg
            anchors.centerIn: parent
            width: Sizes.dp(180)
            height: width
            visible: opacity > 0
            opacity: (root.stationLogoUrl !== "") ? 1.0 : 0.0
            Behavior on opacity {DefaultNumberAnimation {}}
            source: (root.stationLogoUrl !== "") ? root.stationLogoUrl : ""
            fillMode: Image.PreserveAspectCrop
        }
    }

    ColumnLayout {
        anchors.left: logoWrapper.right
        anchors.leftMargin: Sizes.dp(100)
        anchors.verticalCenter: logoWrapper.verticalCenter
        anchors.verticalCenterOffset: Sizes.dp(-4)
        spacing: Sizes.dp(15)

        Label {
            Layout.preferredWidth: root.width
            text: root.stationName + " - " + root.frequency.toLocaleString(Qt.locale(), 'f', root.numberOfDecimals)
            visible: text !== ""
        }

        Label {
            id: actualProgram
            Layout.preferredWidth: root.width
            opacity: Style.opacityMedium
            font.pixelSize: Sizes.fontSizeS
            visible: text !== ""
        }
    }
}
