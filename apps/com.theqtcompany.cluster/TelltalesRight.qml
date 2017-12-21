/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Triton Cluster UI.
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
import QtQuick.Extras 1.4
//import Qt.SafeRenderer 1.0

Item {
    width: 444
    height: 58
    clip: true

    //public
    property int margin: 25

    property bool controlBitRightTurn: true
    property bool controlBitAbsFailure: true
    property bool controlBitParkBrake: true
    property bool controlBitTyrePressLow: true
    property bool controlBitBrakeFailure: true
    property bool controlBitAirbagFailure: true

    //private
    Item {
        id: d
        property real scaleRatio: parent.height / 58
    }

    Image {
        id: bg
        anchors.fill: parent
        source: "./img/telltales/telltale-bg-right.png"
    }

    Image {
        id: rightTurn
        anchors.left: parent.left
        anchors.leftMargin: margin * d.scaleRatio
        anchors.verticalCenter: parent.verticalCenter
        width: 53 * d.scaleRatio
        height: 48 * d.scaleRatio
        visible: controlBitRightTurn
        fillMode: Image.PreserveAspectFit
        source: "./img/telltales/ic-right-turn.png"
    }

    Image {
        id: absFailure
        anchors.left: rightTurn.right
        anchors.leftMargin: margin * d.scaleRatio
        anchors.verticalCenter: parent.verticalCenter
        width: 40 * d.scaleRatio
        height: 30 * d.scaleRatio
        visible: controlBitAbsFailure
        source: "./img/telltales/ic-abs-fault.png"
    }

    Image {
        id: parkBrake
        anchors.left: absFailure.right
        anchors.leftMargin: margin * d.scaleRatio
        anchors.verticalCenter: parent.verticalCenter
        width: 40 * d.scaleRatio
        height: 30 * d.scaleRatio
        visible: controlBitParkBrake
        source: "./img/telltales/ic-parking-brake.png"
    }

    Image {
        id: tyrePressLow
        anchors.left: parkBrake.right
        anchors.leftMargin: margin * d.scaleRatio
        anchors.verticalCenter: parent.verticalCenter
        width: 34 * d.scaleRatio
        height: 30 * d.scaleRatio
        visible: controlBitTyrePressLow
        source: "./img/telltales/ic-tire-pressure.png"
    }

    Image {
        id: brakeFailure
        anchors.left: tyrePressLow.right
        anchors.leftMargin: margin * d.scaleRatio
        anchors.verticalCenter: parent.verticalCenter
        width: 40 * d.scaleRatio
        height: 30 * d.scaleRatio
        visible: controlBitBrakeFailure
        source: "./img/telltales/ic-brake-fault.png"
    }

    Image {
        id: airbagFailure
        anchors.left: brakeFailure.right
        anchors.leftMargin: margin * d.scaleRatio
        anchors.verticalCenter: parent.verticalCenter
        width: 35 * d.scaleRatio
        height: 34 * d.scaleRatio
        visible: controlBitAirbagFailure
        source: "./img/telltales/ic-airbag.png"
    }
}
