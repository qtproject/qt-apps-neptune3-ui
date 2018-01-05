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
import animations 1.0

Item {
    id: root

    Item {
        anchors.fill: parent
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: Style.hspan(0.2)

        Image {
            id: widgetMockup
            anchors.centerIn: root.state !== "Maximized" ? parent : undefined
            anchors.top: root.state === "Maximized" ? parent.top : undefined
            source: "assets/navigation-widget-map.png"
            scale: root.state !== "Maximized" ? 0.7 : 1.0
            opacity: visible ? 1.0 : 0.0
            fillMode: Image.PreserveAspectCrop
            Behavior on opacity { DefaultNumberAnimation { } }
        }

        Image {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            source: "assets/navigation-widget-search.png"
            opacity: widgetMockup.opacity ? 1.0 : 0.0
            Behavior on opacity { DefaultNumberAnimation { } }
        }
    }
}

