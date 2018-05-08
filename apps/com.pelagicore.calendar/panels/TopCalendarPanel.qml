/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AG
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

import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.2
import Qt.labs.calendar 1.0
import utils 1.0
import controls 1.0
import com.pelagicore.styles.neptune 3.0

RowLayout {
    id: root

    spacing: NeptuneStyle.dp(135)

    ColumnLayout {
        DayOfWeekRow {
            Layout.preferredWidth: shadow.width
            Layout.maximumWidth: shadow.width
            Layout.preferredHeight: root.height / 8
            Layout.maximumHeight: root.height / 8
            spacing: NeptuneStyle.dp(6)
            topPadding: NeptuneStyle.dp(6)
            bottomPadding: NeptuneStyle.dp(6)
            locale: grid.locale
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

            locale: Qt.locale(Style.languageLocale)
            Layout.preferredWidth: shadow.width
            Layout.maximumWidth: shadow.width
            Layout.preferredHeight: 0.6 * root.height
            Layout.maximumHeight: 0.6 * root.height

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
        Image {
            id: shadow
            Layout.preferredWidth: NeptuneStyle.dp(sourceSize.width)
            Layout.maximumWidth: NeptuneStyle.dp(sourceSize.width)
            Layout.preferredHeight: NeptuneStyle.dp(sourceSize.height)
            Layout.maximumHeight: NeptuneStyle.dp(sourceSize.height)
            source: Style.gfx("album-art-shadow-widget")
            fillMode: Image.PreserveAspectFit
        }
    }

    RowLayout {
        Layout.alignment: Qt.AlignVCenter
        Layout.bottomMargin: NeptuneStyle.dp(45)
        ToolButton {
            Layout.alignment: Qt.AlignVCenter
            icon.name: "ic_skipprevious"
            onClicked: {
                if (grid.month === 0) {
                    grid.month = 11;
                    grid.year -= 1;
                } else {
                    grid.month -= 1
                }
            }
        }
        Label {
            Layout.preferredWidth: NeptuneStyle.dp(270)
            text: Qt.locale().standaloneMonthName(grid.month) + " " + grid.year
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: NeptuneStyle.fontSizeM
            font.weight: Font.Light
        }
        ToolButton {
            Layout.alignment: Qt.AlignVCenter
            icon.name: "ic_skipnext"
            onClicked: {
                if (grid.month === 11) {
                    grid.month = 0;
                    grid.year += 1;
                } else {
                    grid.month += 1
                }
            }
        }
    }
}
