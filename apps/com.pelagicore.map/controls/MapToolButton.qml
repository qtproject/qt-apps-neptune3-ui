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

import QtQuick 2.8
import QtQuick.Controls 2.2
import shared.utils 1.0
import shared.Style 1.0
import shared.Sizes 1.0

ToolButton {
    id: root
    property alias iconSource: buttonImage.source
    property color labelColor: Style.contrastColor

    property string primaryText

    property string extendedText: ""
    property color extendedTextColor: Style.accentDetailColor
    property int extendedTextFontSize: Sizes.fontSizeS

    property string secondaryText: ""
    property color secondaryTextColor: Style.contrastColor
    property int secondaryTextFontSize: Sizes.fontSizeS

    background: Item {
        Row {
            spacing: Sizes.dp(45 * 0.5)
            anchors.centerIn: parent
            Image {
                id: buttonImage
                anchors.verticalCenter: parent.verticalCenter
                width: Sizes.dp(sourceSize.width)
                height: Sizes.dp(sourceSize.height)
            }
            Column {
                spacing: Sizes.dp(8)
                anchors.verticalCenter: parent.verticalCenter
                Row {
                    spacing: Sizes.dp(45 * 0.3)
                    Label {
                        id: primaryButtonText
                        anchors.verticalCenter: parent.verticalCenter
                        color: root.labelColor
                        text: root.primaryText
                    }
                    Label {
                        id: extendedButtonText
                        anchors.verticalCenter: parent.verticalCenter
                        color: root.extendedTextColor
                        font.pixelSize: root.extendedTextFontSize
                        text: root.extendedText
                    }
                }
                Label {
                    id: secondaryButtonText
                    color: root.secondaryTextColor
                    font.pixelSize: root.secondaryTextFontSize
                    font.weight: Font.Light
                    text: root.secondaryText
                }
            }
        }
    }
}
