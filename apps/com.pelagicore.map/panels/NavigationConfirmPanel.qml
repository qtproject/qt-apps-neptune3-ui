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

import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

import shared.utils 1.0
import shared.Style 1.0
import shared.Sizes 1.0
import "../helpers" 1.0

RowLayout {
    id: root

    property string neptuneWindowState

    property string destination: ""
    property string routeDistance: ""
    property string routeTime: ""

    signal showRoute()
    signal startNavigation()
    signal stopNavigation()

    spacing: Sizes.dp(45 * .5)

    RowLayout {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignVCenter
        spacing: Sizes.dp(45 * .7)
        width: parent.width / 2

        ToolButton {
            Layout.leftMargin: parent.spacing
            width: Sizes.dp(45)
            height: width
            enabled: visible
            visible: root.state === "route_selection"
                     || root.state === "destination_selection"
                     || root.state === "demo_driving"
            icon.name: root.state === "demo_driving"
                       ? "" : LayoutMirroring.enabled ? "ic_forward" : "ic_back"
            icon.source: root.state === "demo_driving"
                        ? Qt.resolvedUrl("../assets/ic-end-route.png") : ""
            onClicked: root.stopNavigation()
        }

        Column {
            Layout.fillWidth: true
            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                font.pixelSize: Sizes.fontSizeS
                text: destination
            }
            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                font.pixelSize: Sizes.fontSizeXS
                text: "%1 · %2".arg(routeDistance).arg(routeTime)
            }
        }
    }

    Button {
        id: startNavigationButton
        width: parent.width / 3
        height: Sizes.dp(80)
        Layout.alignment: Qt.AlignVCenter
        scale: pressed ? 1.1 : 1.0
        visible: root.state === "destination_selection"
                 || root.state === "route_selection"
        Behavior on scale { NumberAnimation { duration: 50 } }
        Behavior on opacity { NumberAnimation { duration: 150 } }

        contentItem: Item {
            Row {
                anchors.centerIn: parent
                spacing: Sizes.dp(45 * 0.3)
                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.PreserveAspectFit
                    source: Helper.localAsset("ic-start-navigation", Style.theme)
                    opacity: startNavigationButton.enabled
                             ? Style.opacityHigh
                             : Style.defaultDisabledOpacity
                    width: Sizes.dp(sourceSize.width)
                    height: Sizes.dp(sourceSize.height)
                }
                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.state === "destination_selection"
                          ? qsTr("Directions")
                          : qsTr("Start")
                    font.pixelSize: Sizes.fontSizeS
                }
            }
        }

        onClicked: {
            if (root.state === "destination_selection") {
                startNavigationButton.enabled = false;
                startNavigationButton.opacity = 0.0
                root.showRoute();
                mDirtyHackTemporaryTimer.start();
            } else if (root.state === "route_selection") {
                root.startNavigation();
            }
        }

    }

    Timer {
        id:mDirtyHackTemporaryTimer
        interval: 2500
        onTriggered: {
            startNavigationButton.opacity = 1.0
            startNavigationButton.enabled = true;
        }
    }
}
