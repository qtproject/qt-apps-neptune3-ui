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
    width: 460
    height: 35
    clip: true

    //public
    property int margin: 25

    property bool controlBitLowBeanHeadLight: true
    property bool controlBitHighBeanHeadLight: true
    property bool controlBitFogLight: true
    property bool controlBitStabilityControl: true
    property bool controlBitSeatBeltFasten: true
    property bool controlBitLeftTurn: true

    //private
    Item {
        id: d
        property real scaleRatio: parent.height / 35
    }

    Picture {
        id: lowBeanHeadLight
        anchors.left: parent.left
        anchors.leftMargin: margin * d.scaleRatio
        height: parent.height
        width: parent.height
        visible: controlBitLowBeanHeadLight
        color: "#447191"
        source: "./iso-icons/iso_grs_7000_4_0083.dat"
    }

    Picture {
        id: highBeanHeadLight
        anchors.left: lowBeanHeadLight.right
        anchors.leftMargin: margin * d.scaleRatio
        height: parent.height
        width: parent.height
        visible: controlBitHighBeanHeadLight
        color: "#447191"
        source: "./iso-icons/iso_grs_7000_4_0082.dat"
    }

    Picture {
        id: fogLight
        anchors.left: highBeanHeadLight.right
        anchors.leftMargin: margin * d.scaleRatio
        height: parent.height
        width: parent.height
        visible: controlBitFogLight
        color: "#447191"
        source: "./iso-icons/iso_grs_7000_4_0634.dat"
    }

    Picture {
        id: stabilityControl
        anchors.left: fogLight.right
        anchors.leftMargin: margin * d.scaleRatio
        height: parent.height
        width: parent.height
        visible: controlBitStabilityControl
        color: "#447191"
        source: "./iso-icons/iso_grs_7000_4_2630.dat"
    }

    Picture {
        id: seatBeltFasten
        anchors.left: stabilityControl.right
        anchors.leftMargin: margin * d.scaleRatio
        height: parent.height
        width: parent.height
        visible: controlBitSeatBeltFasten
        color: "#447191"
        source: "./iso-icons/iso_grs_7000_4_1702.dat"
    }

    Image {
        id: leftTurn
        anchors.left: seatBeltFasten.right
        anchors.leftMargin: margin * d.scaleRatio
        height: parent.height
        width: parent.height
        visible: controlBitLeftTurn
        fillMode: Image.PreserveAspectFit
        source: "./img/icon_turnsignal_on.png"
    }
}
