/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AB
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
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.2

import controls 1.0
import utils 1.0

Item {
    id: root

    property alias leftDoorOpen: doorsItem.leftDoorOpen
    property alias rightDoorOpen: doorsItem.rightDoorOpen
    property alias trunkOpen: doorsItem.trunkOpen
    property alias roofOpenProgress: doorsItem.roofOpenProgress

    ToolsColumn {
        id: toolsColumn
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 70
        width: 100
        height: 460

        translationContext: "VehicleToolsColumn"
        model: ListModel {
            ListElement { icon: "ic-driving-support"; text: QT_TRANSLATE_NOOP("VehicleToolsColumn", "support") }
            ListElement { icon: "ic-energy"; text: QT_TRANSLATE_NOOP("VehicleToolsColumn", "energy") }
            ListElement { icon: "ic-doors"; text: QT_TRANSLATE_NOOP("VehicleToolsColumn", "doors") }
            ListElement { icon: "ic-tires"; text: QT_TRANSLATE_NOOP("VehicleToolsColumn", "tires") }
        }
    }

    StackLayout {
        anchors.left: toolsColumn.right
        anchors.leftMargin: Style.hspan(1.2)
        anchors.right: parent.right
        anchors.rightMargin: Style.hspan(1.4)
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        currentIndex: toolsColumn.currentIndex

        SupportPanel {}
        EnergyPanel {}
        DoorsPanel { id: doorsItem }
        TiresPanel {}
    }
}
