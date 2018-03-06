/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AB
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

import QtQuick 2.9
import QtQuick.Controls 2.2

import com.pelagicore.styles.neptune 3.0

ToolButton {
    id: root

    state: "FAT"
    property string iconSource: ""

    states: [
        State {
            name: "FAT"
            PropertyChanges {
                target: backgroundItem
                minWidth: 220
                implicitHeight: 100
                sideMargins: 58
            }
            PropertyChanges {
                target: contentText
                font.pixelSize: root.NeptuneStyle.fontSizeM
            }
        },
        State {
            name: "REGULAR"
            PropertyChanges {
                target: backgroundItem
                minWidth: 0
                implicitHeight: 100
                iconMargin: 0
                sideMargins: 42
            }
            PropertyChanges {
                target: contentText
                font.pixelSize: root.NeptuneStyle.fontSizeS
            }
        },
        State {
            name: "SMALL"
            PropertyChanges {
                target: backgroundItem
                minWidth: 0
                implicitHeight: 52
                sideMargins: 22
            }
            PropertyChanges {
                target: contentText
                font.pixelSize: root.NeptuneStyle.fontSizeS
            }
        }
    ]

    contentItem: Label {
        id: contentText

        verticalAlignment: Text.AlignVCenter
        anchors.left: parent.left
        anchors.leftMargin: backgroundItem.contentMargin

        text: root.text
        font.weight: Font.Light
        color: root.down ? "#41403f" : NeptuneStyle.primaryTextColor
    }

    background: Rectangle {
        id: backgroundItem

        implicitWidth: defaultWidth < minWidth ? minWidth : defaultWidth
        implicitHeight: 100

        radius: height / 2
        color: NeptuneStyle.buttonColor

        readonly property int defaultWidth: sideMargins + contentMargin + contentText.contentWidth
        property int minWidth: 220
        property int sideMargins: 58
        property int iconMargin: 10
        property int contentMargin: sideMargins + iconImage.width + iconMargin

        Image {
            id: iconImage

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: backgroundItem.sideMargins
            source: root.iconSource
        }
    }
}
