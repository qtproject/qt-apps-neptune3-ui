/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AB
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 IVI UI.
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
import shared.BasicStyle 1.0
import shared.Sizes 1.0
import "../helpers"

Row {
    id: root

    property bool guidanceMode: false
    property string destination: ""
    property string routeDistance: ""
    property string routeTime: ""
    property Helper helper: Helper {}

    signal startNavigation()
    signal stopNavigation()

    spacing: Sizes.dp(45 * .5)

    ToolButton {
        width: Sizes.dp(45 * .9)
        height: width
        visible: root.guidanceMode
        icon.source: Qt.resolvedUrl("../assets/ic-end-route.png")
        onClicked: root.stopNavigation()
    }

    RowLayout {
        width: root.guidanceMode ? parent.width : parent.width / 2
        anchors.verticalCenter: parent.verticalCenter
        spacing: Sizes.dp(45 * .7)

        ToolButton {
            Layout.leftMargin: parent.spacing
            width: Sizes.dp(45)
            height: width
            enabled: visible
            visible: !root.guidanceMode
            icon.name: LayoutMirroring.enabled ? "ic_forward" : "ic_back"
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
        anchors.verticalCenter: parent.verticalCenter
        scale: pressed ? 1.1 : 1.0
        visible: !root.guidanceMode
        Behavior on scale { NumberAnimation { duration: 50 } }

        contentItem: Item {
            Row {
                anchors.centerIn: parent
                spacing: Sizes.dp(45 * 0.3)
                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.PreserveAspectFit
                    source: helper.localAsset("ic-start-navigation", BasicStyle.theme)
                    opacity: startNavigationButton.enabled ? BasicStyle.opacityHigh : BasicStyle.defaultDisabledOpacity
                    width: Sizes.dp(sourceSize.width)
                    height: Sizes.dp(sourceSize.height)
                }
                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("Start Navigation")
                    font.pixelSize: Sizes.fontSizeS
                }
            }
        }
        onClicked: root.startNavigation()
    }
}
