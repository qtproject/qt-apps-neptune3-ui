/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
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

import QtQuick 2.6
import QtQuick.Controls 2.0
import controls 1.0
import utils 1.0

import QtQuick.Layouts 1.3

Item {
    id: root

    property Item popupParent
    property var model

    property real lateralMargin: Style.hspan(0.6)
    property real toolWidth: Style.hspan(2)

    Tool {
        id: leftIcon
        width: root.toolWidth
        height: width
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: root.lateralMargin
        symbol: Style.symbol("volume-status-3")
    }

    MouseArea {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: leftIcon.right
        anchors.right: parent.right
        anchors.rightMargin: root.toolWidth + root.lateralMargin
        onClicked: popup.open()
    }

    RowLayout {
        anchors.centerIn: parent

        height: Style.vspan(1)
        spacing: Style.hspan(0.2)

        Image {
            anchors.verticalCenter: parent.verticalCenter
            source: Style.symbol("ic-seat-heat-status", false /* active */)
            fillMode: Image.Pad
            visible: model.leftSeat.heat
        }
        Label {
            Layout.leftMargin: Style.hspan(.8)
            Layout.rightMargin: Style.hspan(.8)
            text: root.model ? root.model.leftSeat.valueString : ""
            horizontalAlignment: Text.AlignHCenter
            opacity: 0.6
        }
        Image {
            anchors.verticalCenter: parent.verticalCenter
            source: Style.symbol("ic-rear-defrost-status", false /* active */)
            fillMode: Image.Pad
            visible: model.rearHeat.enabled
        }

        Image {
            anchors.verticalCenter: parent.verticalCenter
            source: Style.symbol("ic-front-defrost-status", false /* active */)
            fillMode: Image.Pad
            visible: model.frontHeat.enabled
        }
        Label {
            Layout.leftMargin: Style.hspan(.8)
            Layout.rightMargin: Style.hspan(.8)
            text: root.model ? root.model.rightSeat.valueString : ""
            horizontalAlignment: Text.AlignHCenter
            opacity: 0.6
        }
        Image {
            anchors.verticalCenter: parent.verticalCenter
            source: Style.symbol("ic-seat-heat-status", false /* active */)
            fillMode: Image.Pad
            visible: model.rightSeat.heat
        }
    }

    ClimatePopup {
        id: popup
        parent: root.popupParent
        originItem: root
        model: root.model
    }
}
