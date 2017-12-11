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

import QtQuick 2.8
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

import utils 1.0
import animations 1.0

Rectangle {
    id: root
    width: Style.hspan(4)
    height: Style.vspan(1.8)
    radius: 50
    color: "#ded9d7" // FIXME not in palette

    property alias primaryText: primaryLabel.text
    property alias secondaryText: secondaryLabel.text
    property alias iconSource: img.source

    signal clicked()

    MouseArea {
        id: mouseArea
        enabled: root.enabled
        anchors.fill: parent
        onReleased: root.clicked()
    }

    ColumnLayout {
        id: column
        anchors.centerIn: parent
        visible: root.primaryText

        Label {
            id: primaryLabel
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: Style.fontSizeM
            font.weight: Font.Light
        }

        Label {
            id: secondaryLabel
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: Style.fontSizeXS
            visible: text
            font.weight: Font.Light
        }
    }

    Image {
        id: img
        anchors.centerIn: parent
        visible: root.iconSource
    }

    transformOrigin: Item.Top
    scale: mouseArea.containsPress ? 0.95 : 1.0
    Behavior on scale { DefaultSmoothedAnimation {} }
}
