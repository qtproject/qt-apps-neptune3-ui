/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AG
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
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import animations 1.0
import utils 1.0
import com.pelagicore.styles.triton 1.0

Item {
    id: root

    width: Style.hspan(550/45)
    height: Style.vspan(400/80)

    property var model
    property bool autoMode: false

    Tumbler {
        id: tumblerFanSpeed
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        model: 9
        height: 300
        width: 100
        clip: true
        visibleItemCount: 3
        wrap: false
        visible: opacity > 0
        opacity: autoMode ? 0 : 1
        Behavior on opacity { DefaultNumberAnimation {} }
        delegate: Item {
            width: 100
            height: 100
            Image {
                anchors.centerIn: parent
                source: Style.gfx2(("fan-speed-"+index), TritonStyle.theme)
                opacity: index === Tumbler.tumbler.currentIndex ? 1 : 0.2
            }
        }
        currentIndex: root.model.ventilationLevels
        onCurrentIndexChanged: {
            if (tumblerFanSpeed.moving) {
                root.model.setVentilation(tumblerFanSpeed.currentIndex)
            }
        }
    }

    Item {
        anchors.centerIn: parent
        width: Math.max(airFlowTop.sourceSize.width, airFlowMiddle.sourceSize.width, airFlowDown.sourceSize.width) + 70
        height: airFlowTop.sourceSize.height + airFlowMiddle.sourceSize.height + airFlowDown.sourceSize.height - 40 + 20
        Image {
            id: seatImage
            source: Style.gfx2("seat", TritonStyle.theme)
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -10
        }
        Image {
            id: airFlowTop
            anchors.left: parent.left
            anchors.top: parent.top
            source: root.model.airflow.windshield ? Style.gfx2("air-flow-top-active", TritonStyle.theme)
                                                  : Style.gfx2("air-flow-top", TritonStyle.theme)
            MouseArea {
                anchors.fill: parent
                enabled: !autoMode
                onClicked: root.model.airflow.windshield = !root.model.airflow.windshield;
            }
        }
        Image {
            id: airFlowMiddle
            anchors.left: parent.left
            anchors.top: airFlowTop.bottom
            anchors.topMargin: -40
            source: root.model.airflow.dashboard ? Style.gfx2("air-flow-middle-active", TritonStyle.theme)
                                                 : Style.gfx2("air-flow-middle", TritonStyle.theme)
            MouseArea {
                anchors.fill: parent
                enabled: !autoMode
                onClicked: root.model.airflow.dashboard = !root.model.airflow.dashboard
            }
        }
        Image {
            id: airFlowDown
            anchors.left: parent.left
            anchors.top: airFlowMiddle.bottom
            anchors.topMargin: 20
            source: root.model.airflow.floor ? Style.gfx2("air-flow-bottom-active", TritonStyle.theme)
                                             : Style.gfx2("air-flow-bottom", TritonStyle.theme)
            MouseArea {
                anchors.fill: parent
                enabled: !autoMode
                onClicked: root.model.airflow.floor = !root.model.airflow.floor
            }
        }
        MouseArea {
            anchors.left: parent.left
            anchors.bottom: airFlowTop.bottom
            width: 120
            height: 40
            enabled: !autoMode
            onClicked: root.model.airflow.windshield = !root.model.airflow.windshield;
        }
    }
}
