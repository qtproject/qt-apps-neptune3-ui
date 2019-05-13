/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Copyright (C) 2018 Pelagicore AG
** Copyright (C) 2017 The Qt Company Ltd.
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

import QtQuick 2.0
import QtQuick.Layouts 1.3
import "../controls" 1.0
import "../helpers" 1.0
import shared.Sizes 1.0

Item {
    id: root
    width: Sizes.dp(444)
    height: Sizes.dp(58)

    //public
    property bool lowBeamHeadLightOn: true
    property bool highBeamHeadLightOn: true
    property bool fogLightOn: true
    property bool stabilityControlOn: true
    property bool seatBeltFastenOn: true
    property bool leftTurnOn: true
    property bool blinker: false

    Row {
        //place row inside item and stick to the right [  xxxx<]
        anchors.right: root.right
        height: root.height
        spacing: root.width * 0.05
        LayoutMirroring.enabled: false


        Image {
            width: Sizes.dp(42)
            height: Sizes.dp(32)
            opacity: root.lowBeamHeadLightOn ? 1 : 0
            fillMode: Image.PreserveAspectFit
            source: Utils.localAsset("/telltales/ic-low-beam")
            anchors.verticalCenter: parent.verticalCenter
        }

        Image {
            width: Sizes.dp(42)
            height: Sizes.dp(27)
            opacity: root.highBeamHeadLightOn ? 1 : 0
            fillMode: Image.PreserveAspectFit
            source: Utils.localAsset("/telltales/ic-high-beam")
            anchors.verticalCenter: parent.verticalCenter
        }

        Image {
            width: Sizes.dp(34)
            height: Sizes.dp(34)
            opacity: root.fogLightOn ? 1 : 0
            fillMode: Image.PreserveAspectFit
            source: Utils.localAsset("/telltales/ic-fog-lights")
            anchors.verticalCenter: parent.verticalCenter
        }

        Image {
            width: Sizes.dp(30)
            height: Sizes.dp(33)
            opacity: root.stabilityControlOn ? 1 : 0
            fillMode: Image.PreserveAspectFit
            source: Utils.localAsset("/telltales/ic-stability-control")
            anchors.verticalCenter: parent.verticalCenter
        }

        Image {
            width: Sizes.dp(25)
            height: Sizes.dp(35)
            opacity: root.seatBeltFastenOn ? 1 : 0
            fillMode: Image.PreserveAspectFit
            source: Utils.localAsset("/telltales/ic-seat-belt")
            anchors.verticalCenter: parent.verticalCenter
        }

        Image {
            width: Sizes.dp(53)
            height: Sizes.dp(48)
            opacity: root.blinker && root.leftTurnOn ? 1 : 0
            fillMode: Image.PreserveAspectFit
            source: Utils.localAsset("/telltales/ic-left-turn")
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
