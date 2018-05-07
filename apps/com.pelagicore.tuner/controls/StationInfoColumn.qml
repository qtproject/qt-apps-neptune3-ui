/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AG
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
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0

import utils 1.0
import controls 1.0
import animations 1.0

import com.pelagicore.styles.neptune 3.0

Item {
    id: root

    property alias radioText: actualProgram.text
    property bool tuningMode: false
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
            width: NeptuneStyle.dp(sourceSize.width)
            height: NeptuneStyle.dp(sourceSize.height)
            source: Style.gfx("album-art-shadow")
        }

        Image {
            opacity: (root.stationLogoUrl === "" || stationLogoImg.status === Image.Error) ?
                     1.0 : 0.0
            Behavior on opacity { DefaultNumberAnimation {} }
            visible: opacity > 0.0
            anchors.centerIn: parent
            width: NeptuneStyle.dp(180)
            height: width
            source: Style.gfx("album-art-placeholder")
            fillMode: Image.PreserveAspectCrop
        }

        Image {
            id: stationLogoImg
            anchors.centerIn: parent
            width: NeptuneStyle.dp(180)
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
        anchors.leftMargin: NeptuneStyle.dp(100)
        anchors.verticalCenter: logoWrapper.verticalCenter
        anchors.verticalCenterOffset: NeptuneStyle.dp(-4)
        spacing: NeptuneStyle.dp(15)

        Label {
            Layout.preferredWidth: root.width
            text: root.stationName + " - " + root.frequency.toLocaleString(Qt.locale(), 'f', root.numberOfDecimals)
            visible: text !== ""
        }

        Label {
            id: actualProgram
            Layout.preferredWidth: root.width
            opacity: NeptuneStyle.opacityMedium
            font.pixelSize: NeptuneStyle.fontSizeS
            visible: text !== ""
        }
    }
}
