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
            width: Style.hspan(7)
            height: Style.vspan(3)
            ColumnLayout {
                Label {
                    Layout.preferredWidth: Style.hspan(6)
                    text: Qt.locale().standaloneMonthName(index) + " " + grid.year
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: NeptuneStyle.fontSizeS
                }
                DayOfWeekRow {
                    locale: Qt.locale(Style.languageLocale)
                    Layout.fillWidth: true
                    delegate: Text {
                        text: model.shortName
                        font.pixelSize: NeptuneStyle.fontSizeXS
                        font.family: NeptuneStyle.fontFamily
                        color: NeptuneStyle.primaryTextColor
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
                MonthGrid {
                    id: grid
                    property color labelColor: NeptuneStyle.primaryTextColor
                    locale: Qt.locale(Style.languageLocale)
                    month: index
                    year: {
                        var d = new Date();
                        return d.getFullYear();
                    }
                    Layout.fillWidth: true
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
        anchors.top: parent.top
        GridView {
            id: gridView
            Layout.preferredWidth: Style.hspan(7)
            Layout.preferredHeight: root.height
            anchors.top: parent.top
            clip: true
            model: 12
            delegate: delegatedCalendar
            cellWidth: Style.hspan(7)
            cellHeight: Style.vspan(3)
            ScrollIndicator.vertical: ScrollIndicator {
                parent: gridView.parent
                anchors.top: gridView.top
                anchors.left: gridView.right
                anchors.bottom: gridView.bottom
            }
        }

        EventList {
            id: eventList
            Layout.preferredWidth: Style.hspan(10)
            Layout.preferredHeight: root.height
            anchors.top: parent.top
            delegate: EventListItem {
                width: Style.hspan(10)
                height: Style.vspan(1)
                eventTimeStart: timeStart
                eventTimeEnd: timeEnd
                eventLabel: event
            }
        }
    }
}
