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

import QtQuick 2.0
import QtQuick.Controls 2.1

import controls 1.0
import utils 1.0
import "."

import QtIvi.Media 1.0

Rectangle {
    width: Style.vspan(10)
    height: Style.hspan(1)

    color: "black"
    opacity: indexerControl.state === MediaIndexerControl.Active ? 0.4 : 0
    Behavior on opacity {
        NumberAnimation { duration: 800 }
    }

    MediaIndexerControl {
        id: indexerControl
    }

    Column {
        anchors.fill: parent
        spacing: 2

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Indexing..."
        }

        Item {
            anchors.horizontalCenter: parent.horizontalCenter
            width: Style.vspan(8)
            height: 4

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                width: parent.width
                height: 4
                radius: 4
                border.color: Qt.lighter(color, 1.1)
                color: "#999"
                opacity: 0.25
            }

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                width: parent.width * indexerControl.progress
                height: 4
                radius: 4
                color: "white"
                opacity: 0.25
            }
        }
    }
}
