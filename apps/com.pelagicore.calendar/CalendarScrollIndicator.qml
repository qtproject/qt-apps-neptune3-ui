/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
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

import QtQuick 2.8
import QtQuick.Controls 2.2
import animations 1.0
import utils 1.0

import com.pelagicore.styles.neptune 3.0

ScrollIndicator {
    id: root

    background: Item {
        Rectangle {
            implicitWidth: Style.hspan(0.05)
            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            radius: height

            // TODO: Use a named color from NeptuneStyle when available.
            color: "#969494"
            opacity: root.active ? 1.0 : 0.0
            Behavior on opacity { DefaultNumberAnimation { } }
        }
    }

    contentItem: Rectangle {
        implicitWidth: Style.hspan(0.1)
        radius: height
        color: NeptuneStyle.accentColor
        opacity: root.active ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation { } }
    }
}

