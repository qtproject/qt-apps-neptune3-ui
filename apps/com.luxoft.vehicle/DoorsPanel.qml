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
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

import animations 1.0
import utils 1.0
import com.pelagicore.styles.triton 1.0

Item {
    id: root

    property alias leftDoorOpen: doorsConfig.leftDoorOpen
    property alias rightDoorOpen: doorsConfig.rightDoorOpen
    property alias trunkOpen: trunkConfig.trunkOpen
    property alias roofOpenProgress: roofConfig.roofOpenProgress

    TabBar {
        id: tabBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: Style.hspan(1.0)
        anchors.right: parent.right

        TabButton {
            text: qsTr("Sun roof")
        }
        TabButton {
            text: qsTr("Doors")
        }
        TabButton {
            text: qsTr("Trunk")
        }
    }

    StackLayout {
        anchors.top: tabBar.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        currentIndex: tabBar.currentIndex
        RoofPanel {
            id: roofConfig
        }
        FrontDoorsPanel {
            id: doorsConfig
        }
        TrunkPanel {
            id: trunkConfig
        }
    }
}

