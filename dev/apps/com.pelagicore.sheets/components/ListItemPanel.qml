/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AG
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
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import controls 1.0
import utils 1.0

Item {
    id: root
    anchors.horizontalCenter: parent ? parent.horizontalCenter : null
    anchors.top: parent ? parent.top : null
    anchors.topMargin: Style.vspan(1)
    anchors.bottom: parent ? parent.bottom : null

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        width: Style.hspan(17)
        spacing: Style.vspan(0.05)

        ListItem {
            implicitWidth: Style.hspan(17)
            implicitHeight: Style.vspan(1.3)
            text: "Basic ListItem"
        }

        ListItem {
            implicitWidth: Style.hspan(17)
            implicitHeight: Style.vspan(1.3)
            text: "ListItem Text"
            subText: "ListItem Subtext"
        }

        ListItem {
            implicitWidth: Style.hspan(17)
            implicitHeight: Style.vspan(1.3)
            symbol: Style.symbol("ic-update")
            text: "ListItem with Icon"
        }

        ListItem {
            implicitWidth: Style.hspan(17)
            implicitHeight: Style.vspan(1.3)
            symbol: Style.symbol("ic-update")
            text: "ListItem with Secondary Text"
            secondaryText: "Company"
        }

        ListItem {
            implicitWidth: Style.hspan(17)
            implicitHeight: Style.vspan(1.3)
            symbol: Style.symbol("ic-update")
            rightToolSymbol: Style.symbol("ic-close")
            text: "ListItem with Secondary Text"
            secondaryText: "68% of 14 MB"
        }

        ListItem {
            implicitWidth: Style.hspan(17)
            implicitHeight: Style.vspan(1.3)
            symbol: Style.symbol("ic-update")
            rightToolSymbol: Style.symbol("ic-close")
            text: "ListItem with Looooooooooonnngggg Text"
            secondaryText: "Loooooooong Secondary Text"
        }
    }
}

