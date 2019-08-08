/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Copyright (C) 2018 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 UI.
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
import Qt.labs.calendar 1.0
import shared.utils 1.0
import shared.Style 1.0
import shared.Sizes 1.0

Item {
    id: root

    readonly property int currentYear: new Date().getFullYear()

    Component {
        id: delegatedCalendar
        Item {
            width: Sizes.dp(315)
            height: Sizes.dp(240)

            ColumnLayout {
                Label {
                    Layout.preferredWidth: Sizes.dp(270)
                    Layout.maximumWidth: Sizes.dp(270)
                    Layout.fillHeight: true
                    text: Qt.locale().standaloneMonthName(index) + " " + grid.year
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: Sizes.fontSizeS
                }
                DayOfWeekRow {
                    locale: Qt.locale(Config.languageLocale)
                    Layout.preferredWidth: Sizes.dp(270)
                    Layout.maximumWidth: Sizes.dp(270)
                    Layout.preferredHeight: 0.1 * gridView.cellHeight
                    Layout.maximumHeight: 0.1 * gridView.cellHeight
                    spacing: Sizes.dp(6)
                    topPadding: Sizes.dp(6)
                    bottomPadding: Sizes.dp(6)
                    delegate: Label {
                        text: model.shortName
                        font.pixelSize: Sizes.fontSizeXS
                        color: Style.contrastColor
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
                MonthGrid {
                    id: grid

                    locale: Qt.locale(Config.languageLocale)
                    month: index
                    year: root.currentYear
                    Layout.preferredWidth: Sizes.dp(270)
                    Layout.maximumWidth: Sizes.dp(270)
                    Layout.preferredHeight: 0.7 * gridView.cellHeight
                    Layout.maximumHeight: 0.7 * gridView.cellHeight
                    spacing: Sizes.dp(6)
                    delegate: Label {
                        text: model.day
                        color: Style.contrastColor
                        font.pixelSize: Sizes.fontSizeXS
                        horizontalAlignment: Text.AlignHCenter
                        opacity: model.month === grid.month ? 1 : 0
                    }
                }
            }
        }
    }

    GridView {
        id: gridView
        anchors.fill: parent
        clip: true
        model: 12
        delegate: delegatedCalendar
        cellWidth: Sizes.dp(315)
        cellHeight: Sizes.dp(240)
        ScrollIndicator.vertical: ScrollIndicator {
            parent: gridView.parent
            anchors.top: gridView.top
            anchors.left: gridView.right
            anchors.bottom: gridView.bottom
        }
    }
}
