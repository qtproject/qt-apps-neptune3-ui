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

import QtQuick 2.8
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import utils 1.0

import com.pelagicore.styles.triton 1.0

ItemDelegate {
    id: root

    property string eventTimeStart
    property string eventTimeEnd
    property alias eventLabel: event.text

    highlighted: false
    background: null

    contentItem: Item {
        anchors.fill: root
        RowLayout {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: Style.hspan(1)
            spacing: Style.hspan(1)

            ColumnLayout {
                Layout.preferredWidth: Style.hspan(1)
                Label {
                    text: root.eventTimeStart
                    font.pixelSize: Style.fontSizeXS
                }
                Label {
                    visible: root.eventTimeStart !== root.eventTimeEnd
                    text: root.eventTimeEnd
                    font.pixelSize: Style.fontSizeXS
                    opacity: 0.6
                }
            }

            Label {
                id: event
                visible: text !== ""
                font.pixelSize: Style.fontSizeS
            }
        }

        Image {
            width: parent.width
            height: 5
            anchors.bottom: parent.bottom
            source: Style.gfx2("divider", TritonStyle.theme)
        }
    }
}
