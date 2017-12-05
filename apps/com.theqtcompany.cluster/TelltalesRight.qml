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

Item {
    width: 460
    height: 35
    clip: true

    //public
    property int margin: 25
    //private
    Item {
        id: d
        property real scaleRatio: parent.height / 35
    }

    Image {
        id: rightTurn
        anchors.left: parent.left
        anchors.leftMargin: margin * d.scaleRatio
        height: parent.height
        width: height
        rotation: 180
        fillMode: Image.PreserveAspectFit
        source: "./img/icon_turnsignal_on.png"
    }

    Picture {
        id: absFailure
        anchors.left: rightTurn.right
        anchors.leftMargin: margin * d.scaleRatio
        height: parent.height
        width: height
        color: "#447191"
        source: "./iso-icons/iso_grs_7000_4_1407.dat"
    }

    Picture {
        id: parkBrake
        anchors.left: absFailure.right
        anchors.leftMargin: margin * d.scaleRatio
        height: parent.height
        width: height
        color: "#447191"
        source: "./iso-icons/iso_grs_7000_4_0238.dat"
    }

    Picture {
        id: tyrePressLow
        anchors.left: parkBrake.right
        anchors.leftMargin: margin * d.scaleRatio
        height: parent.height
        width: height
        color: "#447191"
        source: "./iso-icons/iso_grs_7000_4_1435.dat"
    }

    Picture {
        id: brakeFailure
        anchors.left: tyrePressLow.right
        anchors.leftMargin: margin * d.scaleRatio
        height: parent.height
        width: height
        color: "#447191"
        source: "./iso-icons/iso_grs_7000_4_0239.dat"
    }

    Picture {
        id: airbagFailure
        anchors.left: brakeFailure.right
        anchors.leftMargin: margin * d.scaleRatio
        height: parent.height
        width: height
        color: "#447191"
        source: "./iso-icons/iso_grs_7000_4_2108.dat"
    }
}
