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
import QtQuick.Controls 2.2

AppUIScreen {
    id: root
    property string title: "Triton Calendar"

    // Temporary rect until the correct graphic is delivered
    Rectangle {
        id: bg
        color: "#F1EFED"
        radius: 30
        anchors.fill: parent
    }

    // Temporary rect until the correct graphic is delivered
    Rectangle {
        id: appToolbar
        color: "#FA9E54"
        height: parent.height
        width: Style.vspan(0.7)
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        radius: 30

        Rectangle {
          id: squareRect

          color: appToolbar.color
          width: appToolbar.radius
          anchors.top: appToolbar.top
          anchors.bottom: appToolbar.bottom
          anchors.right: appToolbar.right
        }

        Image {
            width: parent.width
            source: "icon.png"
            fillMode: Image.Pad
            anchors.top: parent.top
            anchors.margins: 25
        }
    }

    Rectangle {
        color: touchPoint1.pressed ? "blue" : "green"
        height: parent.height - 20
        width: parent.width * 0.6
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 60
        Label { text: root.title }
    }

    MultiPointTouchArea {
        anchors.fill: parent
        touchPoints: [ TouchPoint { id: touchPoint1 } ]

        property int count: 0
        onReleased: {
            count += 1;
            root.setWindowProperty("activationCount", count);
        }
    }
}

