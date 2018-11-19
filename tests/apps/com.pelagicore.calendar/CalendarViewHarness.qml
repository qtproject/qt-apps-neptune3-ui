/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 Cluster UI.
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
import shared.utils 1.0
import shared.BasicStyle 1.0
import shared.Sizes 1.0

import views 1.0
import stores 1.0

Item {
    id: root

    state: "Maximized"

    width: {
        if (root.state === "Maximized")
            return Sizes.dp(1080)
        else {
            return Sizes.dp(980)
        }
    }
    height: {
        if (root.state === "Maximized")
            return Sizes.dp(1920);
        else if (root.state === "Widget1Row")
            return Sizes.dp(280);
        else if (root.state === "Widget2Rows")
            return Sizes.dp(450);
        else if (root.state === "Widget3Rows")
            return Sizes.dp(800);
    }

    Image {
        anchors.fill: parent
        source: Style.gfx("bg-home", root.BasicStyle.theme)
        fillMode: Image.Stretch
    }

    CalendarView {
        anchors.fill: parent
        state: root.state
        store: CalendarStore { }
    }

    Component.onCompleted: {
        root.BasicStyle.theme = BasicStyle.Light;
    }
}
