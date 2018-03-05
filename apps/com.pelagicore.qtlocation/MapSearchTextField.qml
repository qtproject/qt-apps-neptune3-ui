/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AG
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

import QtQuick 2.6
import QtQuick.Controls 2.0
import utils 1.0
import com.pelagicore.styles.neptune 3.0

TextField {
    id: root

    property alias busy: searchBusyIndicator.running

    font.family: NeptuneStyle.fontFamily
    font.pixelSize: NeptuneStyle.fontSizeM
    color: NeptuneStyle.primaryTextColor
    selectedTextColor: NeptuneStyle.highlightedTextColor
    leftPadding: Style.hspan(0.4)
    rightPadding: Style.hspan(1.4)
    horizontalAlignment: TextInput.AlignLeft

    background: Rectangle {
        border.color: NeptuneStyle.buttonColor
        border.width: 1
        color: "transparent"
        radius: height/2
        Item {
            anchors.fill: parent
            Image {
                id: iconSearch
                anchors.right: parent.right
                anchors.rightMargin: Style.hspan(0.4)
                anchors.verticalCenter: parent.verticalCenter
                source: Style.localAsset("ic-search", NeptuneStyle.theme)
                visible: !searchBusyIndicator.visible
            }
            BusyIndicator {
                id: searchBusyIndicator
                anchors.right: parent.right
                anchors.rightMargin: Style.hspan(0.4)
                anchors.verticalCenter: parent.verticalCenter
                visible: running
            }
        }
    }
}
