/****************************************************************************
**
** Copyright (C) 2017-2018 Pelagicore AG
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
import QtQuick.Layouts 1.2
import Qt.labs.calendar 1.0
import utils 1.0
import controls 1.0
import com.pelagicore.styles.neptune 3.0
import "../controls"

Item {
    id: root

    property alias eventModel: eventList.model

    Component {
        id: delegatedCalendar
        Item {
            width: NeptuneStyle.dp(315)
            height: NeptuneStyle.dp(240)
            ColumnLayout {
                Label {
                    Layout.preferredWidth: NeptuneStyle.dp(270)
                    Layout.maximumWidth: NeptuneStyle.dp(270)
                    Layout.fillHeight: true
                    text: Qt.locale().standaloneMonthName(index) + " " + grid.year
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: NeptuneStyle.fontSizeS
                }
                DayOfWeekRow {
                    locale: Qt.locale(Style.languageLocale)
                    Layout.fillWidth: true
                    Layout.preferredWidth: NeptuneStyle.dp(270)
                    Layout.maximumWidth: NeptuneStyle.dp(270)
                    Layout.maximumHeight: 0.1 * gridView.cellHeight
                    Layout.preferredHeight: 0.1 * gridView.cellHeight
                    spacing: NeptuneStyle.dp(6)
                    topPadding: NeptuneStyle.dp(6)
                    bottomPadding: NeptuneStyle.dp(6)
                    delegate: Text {
                        text: model.shortName
                        font.pixelSize: NeptuneStyle.fontSizeXS
                        font.family: NeptuneStyle.fontFamily
                        color: NeptuneStyle.contrastColor
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
                MonthGrid {
                    id: grid
                    property color labelColor: NeptuneStyle.contrastColor
                    spacing: NeptuneStyle.dp(6)
                    locale: Qt.locale(Style.languageLocale)
                    month: index
                    year: {
                        var d = new Date();
                        return d.getFullYear();
                    }
                    Layout.preferredWidth: NeptuneStyle.dp(270)
                    Layout.maximumWidth: NeptuneStyle.dp(270)
                    Layout.maximumHeight: 0.7 * gridView.cellHeight
                    Layout.preferredHeight: 0.7 * gridView.cellHeight
                    delegate: Label {
                        text: model.day
                        color: grid.labelColor
                        font.pixelSize: NeptuneStyle.fontSizeXS
                        font.family: NeptuneStyle.fontFamily
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        opacity: model.month === grid.month ? 1 : 0
                    }
                }
            }
        }
    }

    RowLayout {
        Layout.alignment: Qt.AlignTop
        GridView {
            id: gridView
            Layout.preferredWidth: NeptuneStyle.dp(315)
            Layout.preferredHeight: root.height
            Layout.alignment: Qt.AlignTop
            clip: true
            model: 12
            delegate: delegatedCalendar
            cellWidth: NeptuneStyle.dp(315)
            cellHeight: NeptuneStyle.dp(240)
            ScrollIndicator.vertical: ScrollIndicator { }
        }

        EventList {
            id: eventList
            Layout.preferredWidth: NeptuneStyle.dp(450)
            Layout.preferredHeight: root.height
            Layout.alignment: Qt.AlignTop
            delegate: EventListItem {
                width: NeptuneStyle.dp(450)
                height: NeptuneStyle.dp(80)
                eventTimeStart: timeStart
                eventTimeEnd: timeEnd
                eventLabel: event
            }
        }
    }
}
