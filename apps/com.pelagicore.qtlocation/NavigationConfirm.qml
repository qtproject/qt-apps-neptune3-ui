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

import QtQuick 2.8
import QtQuick.Controls 2.2

import controls 1.0 as TritonControls
import utils 1.0
import com.pelagicore.styles.triton 1.0

Row {
    id: root

    property bool guidanceMode: false
    property string destination: ""
    property string routeDistance: ""
    property string routeTime: ""

    signal startNavigation()
    signal stopNavigation()

    spacing: Style.hspan(.5)

    TritonControls.Tool {
        id: cancelNavButton

        width: Style.vspan(.9)
        height: width

        symbol: Qt.resolvedUrl("assets/ic-end-route.png")
        onClicked: root.stopNavigation()
    }

    Column {
        width: root.guidanceMode ? parent.width : parent.width / 2
        anchors.verticalCenter: parent.verticalCenter
        spacing: Style.vspan(.7)

        Label {
            width: parent.width
            wrapMode: Text.WordWrap
            font.pixelSize: Style.fontSizeS
            text: destination
        }
        Label {
            width: parent.width
            wrapMode: Text.WordWrap
            font.pixelSize: Style.fontSizeXS
            text: "%1 · %2".arg(routeDistance).arg(routeTime)
        }
    }

    Button {
        id: startNavigationButton
        width: parent.width / 3
        height: Style.vspan(1)
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: Style.vspan(.5)
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
                    source: TritonStyle.theme === TritonStyle.Light ? Qt.resolvedUrl("assets/ic-start-navigation.png")
                                                                    : Qt.resolvedUrl("assets/ic-start-navigation-dark.png")
                    opacity: startNavigationButton.enabled ? 1.0 : 0.3
                }
                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("Start Navigation")
                    font.pixelSize: Style.fontSizeS
                }
            }
        }
        onClicked: root.startNavigation()
    }
}
