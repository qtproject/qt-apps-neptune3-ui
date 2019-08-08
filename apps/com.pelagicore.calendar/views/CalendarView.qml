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
import QtQuick.Layouts 1.3
import Qt.labs.calendar 1.0
import shared.animations 1.0
import shared.controls 1.0
import shared.utils 1.0
import "../stores" 1.0
import "../controls" 1.0
import "../panels" 1.0

import shared.Style 1.0
import shared.Sizes 1.0

Item {
    id: root

    property CalendarStore store
    property bool bottomWidgetHide: false

    CalendarWidgetPanel {
        anchors.fill: parent
        state: root.state
        visible: root.state !== "Maximized"
        opacity: visible ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation { } }

        // Generate random number to get contents from calendar model.
        property int randomIndex: Math.floor((Math.random() * root.store.eventModel.count) + 0)

        eventModel: root.store.eventModel
    }

    // Top content background
    Image {
        id: topContentBg
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: Sizes.dp(436)
        source: Style.image("app-fullscreen-top-bg")
        visible: root.state === "Maximized"
    }

    TopCalendarPanel {
        id: calendarOnTop
        anchors {
            top: topContentBg.top
            topMargin: Sizes.dp(80)
            left: topContentBg.left
            leftMargin: Sizes.dp(135)
            right: topContentBg.right
            rightMargin: Sizes.dp(135)
            bottom: topContentBg.bottom
            bottomMargin: Sizes.dp(40)
        }
        visible: root.state === "Maximized"
    }

    Item {
        id: mainControl
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: calendarOnTop.bottom
        anchors.topMargin: Sizes.dp(64)
        anchors.bottom: root.bottom
        visible: root.state === "Maximized"

        Item {
            anchors.left: parent.left
            width: Sizes.dp(264)
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            ToolsColumn {
                id: toolsColumn
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: Sizes.dp(53)

                translationContext: "CalendarToolsColumn"
                model: ListModel {
                    id: toolsColumnModel
                    ListElement { icon: "ic-calendar"; text: QT_TRANSLATE_NOOP("CalendarToolsColumn", "year"); objectName: "yearViewButton" }
                    ListElement { icon: "ic-calendar"; text: QT_TRANSLATE_NOOP("CalendarToolsColumn", "next"); objectName: "nextViewButton" }
                    ListElement { icon: "ic-calendar"; text: QT_TRANSLATE_NOOP("CalendarToolsColumn", "events"); objectName: "eventsViewButton" }
                }
            }
        }

        StackLayout {
            objectName: "calendarViewContent"
            anchors.top: parent.top
            anchors.topMargin: Sizes.dp(53)
            anchors.right: parent.right
            anchors.rightMargin: Sizes.dp(96)
            anchors.bottom: parent.bottom
            width: Sizes.dp(720)

            currentIndex: toolsColumn.currentIndex

            CalendarGridPanel {
              objectName: "calendarGridPanel"
            }

            NextCalendarPanel {
                objectName: "nextCalendarPanel"
                eventModel: root.store.eventModel
            }

            EventList {
                objectName: "eventList"
                model: root.store.eventModel
            }
        }
    }
}
