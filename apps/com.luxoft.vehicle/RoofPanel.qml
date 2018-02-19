/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AB
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Triton IVI UI.
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
import QtQuick.Layouts 1.3

import animations 1.0
import utils 1.0

Item {
    id: root

    property real roofOpenProgress: 0.0

    RoofSlider {
        id: roofSlider

        anchors.top: parent.top
        anchors.topMargin: Style.vspan(2.5)
        anchors.left: parent.left
        width: parent.width - anchors.leftMargin
        onValueChanged: {
            root.roofOpenProgress = value
        }
    }

    VehicleButton {
        id: roofCloseButton

        anchors.top: parent.top
        anchors.topMargin: 500
        anchors.right: parent.right
        state: "REGULAR"
        text: qsTr("Close")
        onClicked: {
            roofSlider.value = 0.0
        }
    }

    VehicleButton {
        id: roofOpenButton

        anchors.top: parent.top
        anchors.topMargin: 500
        anchors.left: parent.left
        state: "REGULAR"
        text: qsTr("Open")
        onClicked: {
            roofSlider.value = 1.0
        }
    }
}

