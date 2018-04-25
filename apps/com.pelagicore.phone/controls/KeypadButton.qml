/****************************************************************************
**
** Copyright (C) 2017-2018 Pelagicore AB
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
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

import utils 1.0
import animations 1.0

import com.pelagicore.styles.neptune 3.0

Item {
    id: root
    width: NeptuneStyle.dp(160)
    height: NeptuneStyle.dp(100)

    property alias primaryText: primaryLabel.text
    property alias secondaryText: secondaryLabel.text
    property alias iconSource: img.source
    property alias backgroundColor: background.color
    property alias backgroundOpacity: background.opacity

    signal clicked()

    Rectangle {
        id: background
        anchors.fill: parent
        radius: height/2
        color: NeptuneStyle.contrastColor
        opacity: 0.06
    }

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
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: NeptuneStyle.fontSizeL
            font.weight: Font.Light
        }

        Label {
            id: secondaryLabel
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: NeptuneStyle.fontSizeS
            visible: text
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
