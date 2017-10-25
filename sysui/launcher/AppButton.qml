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
import QtQuick.Controls 2.2
import utils 1.0

Item {
    id: root

    property bool checked: false
    property bool gridOpen: false
    property alias editModeBgOpacity: editModeBg.opacity
    property alias iconSource: icon.source
    property alias labelText: appLabel.text

    Rectangle {
        id: editModeBg
        anchors.fill: parent
        color: "white"
        Behavior on opacity {
            NumberAnimation {
                duration: 200
            }
        }
    }

    Image {
        id: icon
        width: parent.width
        height: Style.vspan(1)
        anchors.top: parent.top
        anchors.topMargin: 15
        fillMode: Image.PreserveAspectFit
    }

    Label {
        id: appLabel
        anchors.top: icon.bottom
        anchors.topMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: Style.fontSizeXS
        opacity: root.gridOpen ? 1.0 : 0.0
        Behavior on opacity {
            NumberAnimation {
                duration: 200
            }
        }
    }

    // TODO: Replace this with the correct visualization
    Rectangle {
        id: dummyChecked

        implicitWidth: Style.hspan(2.3)
        implicitHeight: Style.vspan(1.6)

        anchors.top: parent.top
        anchors.topMargin: -4
        anchors.horizontalCenter: parent.horizontalCenter
        color: "transparent"
        border.color: root.checked && !root.gridOpen ? "red" : "transparent"
        border.width: 2
    }
}
