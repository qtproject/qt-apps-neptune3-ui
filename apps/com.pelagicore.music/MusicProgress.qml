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
import utils 1.0
import controls 1.0
import animations 1.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2

Control {
    id: root

    property bool labelOnTop: true

    contentItem: Item {
        anchors.fill: root
        // TODO: USE REAL PROGRESS DATA
        Label {
            id: progressLabel
            anchors.top: parent.top
            anchors.topMargin: root.labelOnTop ? Style.vspan(0.5) : 0
            anchors.left: parent.left
            anchors.leftMargin: Style.hspan(0.6)
            color: Style.colorBlack
            font.pixelSize: Style.fontSizeS

            text: "0:13 / 3:15"
        }

        // TODO: USE QTQUICKCONTROLS2 STYLING
        ProgressBar {
            id: trackProgressBar

            implicitWidth: root.labelOnTop ? parent.width - Style.hspan(1) : parent.width - Style.hspan(5)
            anchors.top: root.labelOnTop ? progressLabel.bottom : undefined
            anchors.topMargin: root.labelOnTop ? Style.vspan(0.15) : 0
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: root.labelOnTop ? 0 : Style.hspan(1.5)
            anchors.verticalCenter: root.labelOnTop ? undefined : parent.verticalCenter
            value: 0.5
            padding: 2

            background: Item {
            }

            contentItem: Rectangle {
                implicitWidth: 250
                implicitHeight: 2
                color: "#828282"
                radius: 1

                Rectangle {
                    width: trackProgressBar.visualPosition * parent.width
                    height: 7
                    anchors.verticalCenter: parent.verticalCenter
                    radius: 7
                    color: "#FA9E54"
                }
            }
        }
    }
}
