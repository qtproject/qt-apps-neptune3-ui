/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Copyright (C) 2018 Pelagicore AG
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
    id: root
    width: 444
    height: 58
    clip: true

    //public
    property int margin: 25

    property bool controlBitLowBeamHeadLight: true
    property bool controlBitHighBeamHeadLight: true
    property bool controlBitFogLight: true
    property bool controlBitStabilityControl: true
    property bool controlBitSeatBeltFasten: true
    property bool controlBitLeftTurn: true

    //private
    QtObject {
        id: d
        property real scaleRatio: root.height / 58
    }

    // Uncomment below to render BG when safe renderer is in use
//    Image {
//        id: bg
//        anchors.fill: parent
//        source: "./img/telltales/telltale-bg-left.png"
//    }

    Image {
        id: lowBeamHeadLight
        anchors.left: parent.left
        anchors.leftMargin: margin * d.scaleRatio
        anchors.verticalCenter: parent.verticalCenter
        width: 42 * d.scaleRatio
        height: 32 * d.scaleRatio
        visible: controlBitLowBeamHeadLight
        source: "./img/telltales/ic-low-beam.png"
    }

    Image {
        id: highBeamHeadLight
        anchors.left: lowBeamHeadLight.right
        anchors.leftMargin: margin * d.scaleRatio
        anchors.verticalCenter: parent.verticalCenter
        width: 42 * d.scaleRatio
        height: 27 * d.scaleRatio
        visible: controlBitHighBeamHeadLight
        source: "./img/telltales/ic-high-beam.png"
    }

    Image {
        id: fogLight
        anchors.left: highBeamHeadLight.right
        anchors.leftMargin: margin * d.scaleRatio
        anchors.verticalCenter: parent.verticalCenter
        width: 34 * d.scaleRatio
        height: 34 * d.scaleRatio
        visible: controlBitFogLight
        source: "./img/telltales/ic-fog-lights.png"
    }

    Image {
        id: stabilityControl
        anchors.left: fogLight.right
        anchors.leftMargin: margin * d.scaleRatio
        anchors.verticalCenter: parent.verticalCenter
        width: 30 * d.scaleRatio
        height: 33 * d.scaleRatio
        visible: controlBitStabilityControl
        source: "./img/telltales/ic-stability-control.png"
    }

    Image {
        id: seatBeltFasten
        anchors.left: stabilityControl.right
        anchors.leftMargin: margin * d.scaleRatio
        anchors.verticalCenter: parent.verticalCenter
        width: 25 * d.scaleRatio
        height: 35 * d.scaleRatio
        visible: controlBitSeatBeltFasten
        source: "./img/telltales/ic-seat-belt.png"
    }

    Image {
        id: leftTurn
        anchors.left: seatBeltFasten.right
        anchors.leftMargin: margin * d.scaleRatio
        anchors.verticalCenter: parent.verticalCenter
        width: 53 * d.scaleRatio
        height: 48 * d.scaleRatio
        visible: blinker.lit
        fillMode: Image.PreserveAspectFit
        source: "./img/telltales/ic-left-turn.png"
    }

    Blinker {
        id: blinker
        running: controlBitLeftTurn
    }
}
