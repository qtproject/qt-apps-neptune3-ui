/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Copyright (C) 2018 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 UI.
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
import QtGraphicalEffects 1.0

import "../helpers" 1.0
import shared.animations 1.0
import shared.utils 1.0
import shared.Style 1.0
import shared.Style 1.0
import shared.Sizes 1.0

Item {
    id: root

    width: Sizes.dp(550)
    height: Sizes.dp(400)

    property var store
    property bool autoMode: false

    Tumbler {
        id: tumblerFanSpeed
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: Sizes.dp(32)
        model: 7
        height: Sizes.dp(300)
        width: Sizes.dp(100)
        clip: true
        visibleItemCount: 3
        wrap: false
        visible: opacity > 0
        opacity: autoMode ? 0 : 1
        Behavior on opacity { DefaultNumberAnimation {} }
        delegate: Item {
            width: Sizes.dp(100)
            height: Sizes.dp(100)
            Image {
                anchors.centerIn: parent
                width: Sizes.dp(sourceSize.width)
                height: Sizes.dp(sourceSize.height)
                source: Utils.localGfx("fan-speed-background", Style.theme)
                fillMode: Image.PreserveAspectFit
            }
            Image {
                id: tumblerImage
                anchors.centerIn: parent
                width: Sizes.dp(sourceSize.width)
                height: Sizes.dp(sourceSize.height)
                source: Utils.localGfx(("fan-speed-"+index), Style.theme)
                opacity: index === Tumbler.tumbler.currentIndex ? 1 : 0.2
                fillMode: Image.PreserveAspectFit
                layer.enabled: true
                layer.effect: ColorOverlay {
                    source: tumblerImage
                    color: Style.accentColor
                }
            }
        }
        currentIndex: root.store ? root.store.ventilationLevels : -1
        onCurrentIndexChanged: {
            if (tumblerFanSpeed.moving) {
                root.store.setVentilation(tumblerFanSpeed.currentIndex)
            }
        }
    }

    Item {
        anchors.centerIn: parent
        width: Math.max(airFlowTop.width, airFlowMiddle.width, airFlowDown.width) + Sizes.dp(70)
        height: airFlowTop.height + airFlowMiddle.height + airFlowDown.height - Sizes.dp(60)
        Image {
            id: seatImage
            width: Sizes.dp(sourceSize.width)
            height: Sizes.dp(sourceSize.height)
            source: Utils.localGfx("seat", Style.theme)
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: Sizes.dp(-10)
            fillMode: Image.PreserveAspectFit
        }
        Image {
            id: airFlowTop
            anchors.left: parent.left
            anchors.top: parent.top
            width: Sizes.dp(sourceSize.width)
            height: Sizes.dp(sourceSize.height)
            source: root.store ? root.store.airflow.windshield ? Utils.localGfx("air-flow-top-active", Style.theme)
                                                  : Utils.localGfx("air-flow-top", Style.theme) : ""
            fillMode: Image.PreserveAspectFit
            layer.enabled: true
            layer.effect: ColorOverlay {
                source: airFlowTop
                color: Style.accentColor
            }
            MouseArea {
                anchors.fill: parent
                enabled: !autoMode
                onClicked: root.store.airflow.windshield = !root.store.airflow.windshield;
            }
        }
        Image {
            id: airFlowMiddle
            anchors.left: parent.left
            anchors.top: airFlowTop.bottom
            anchors.topMargin: Sizes.dp(-40)
            width: Sizes.dp(sourceSize.width)
            height: Sizes.dp(sourceSize.height)
            source: root.store ? root.store.airflow.dashboard ? Utils.localGfx("air-flow-middle-active", Style.theme)
                                                 : Utils.localGfx("air-flow-middle", Style.theme) : ""
            fillMode: Image.PreserveAspectFit
            layer.enabled: true
            layer.effect: ColorOverlay {
                source: airFlowMiddle
                color: Style.accentColor
            }
            MouseArea {
                anchors.fill: parent
                enabled: !autoMode
                onClicked: root.store.airflow.dashboard = !root.store.airflow.dashboard
            }
        }
        Image {
            id: airFlowDown
            anchors.left: parent.left
            anchors.top: airFlowMiddle.bottom
            anchors.topMargin: Sizes.dp(20)
            width: Sizes.dp(sourceSize.width)
            height: Sizes.dp(sourceSize.height)
            source: root.store ? root.store.airflow.floor ? Utils.localGfx("air-flow-bottom-active", Style.theme)
                                             : Utils.localGfx("air-flow-bottom", Style.theme) : ""
            fillMode: Image.PreserveAspectFit
            layer.enabled: true
            layer.effect: ColorOverlay {
                source: airFlowDown
                color: Style.accentColor
            }
            MouseArea {
                anchors.fill: parent
                enabled: !autoMode
                onClicked: root.store.airflow.floor = !root.store.airflow.floor
            }
        }
        MouseArea {
            anchors.left: parent.left
            anchors.bottom: airFlowTop.bottom
            width: Sizes.dp(120)
            height: Sizes.dp(40)
            enabled: !autoMode
            onClicked: root.store.airflow.windshield = !root.store.airflow.windshield;
        }
    }
}
