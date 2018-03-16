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

import QtQuick 2.8
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import controls 1.0 as NeptuneControls
import utils 1.0
import com.pelagicore.styles.neptune 3.0

Row {
    id: root

    property bool guidanceMode: false
    property string destination: ""
    property string routeDistance: ""
    property string routeTime: ""

    signal startNavigation()
    signal stopNavigation()

    spacing: Style.hspan(.5)

    NeptuneControls.Tool {
        width: Style.hspan(.9)
        height: width
        visible: root.guidanceMode
        symbol: Qt.resolvedUrl("assets/ic-end-route.png")
        onClicked: root.stopNavigation()
    }

    RowLayout {
        width: root.guidanceMode ? parent.width : parent.width / 2
        anchors.verticalCenter: parent.verticalCenter
        spacing: Style.hspan(.7)

        NeptuneControls.Tool {
            Layout.leftMargin: parent.spacing
            width: Style.hspan(1)
            height: width
            enabled: visible
            visible: !root.guidanceMode
            symbol: Style.symbol("ic_back")
            onClicked: root.stopNavigation()
        }

        Column {
            Layout.fillWidth: true
            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                font.pixelSize: NeptuneStyle.fontSizeS
                text: destination
            }
            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                font.pixelSize: NeptuneStyle.fontSizeXS
                text: "%1 · %2".arg(routeDistance).arg(routeTime)
            }
        }
    }

    Button {
        id: startNavigationButton
        width: parent.width / 3
        height: Style.vspan(1)
        anchors.verticalCenter: parent.verticalCenter
        scale: pressed ? 1.1 : 1.0
        visible: !root.guidanceMode
        Behavior on scale { NumberAnimation { duration: 50 } }

        contentItem: Item {
            Row {
                anchors.centerIn: parent
                spacing: Style.hspan(0.3)
                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.Pad
                    source: Style.localAsset("ic-start-navigation", NeptuneStyle.theme)
                    opacity: startNavigationButton.enabled ? NeptuneStyle.fontOpacityHigh : NeptuneStyle.fontOpacityDisabled
                }
                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("Start Navigation")
                    font.pixelSize: NeptuneStyle.fontSizeS
                }
            }
        }
        onClicked: root.startNavigation()
    }
}
