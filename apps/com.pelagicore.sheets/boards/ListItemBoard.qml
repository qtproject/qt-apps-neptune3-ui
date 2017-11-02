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
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import controls 1.0
import utils 1.0

BaseBoard {
    width: 800

    description: "List Items"

    Flickable {
        id: scrollView
        anchors.fill: parent

        flickableDirection: Flickable.VerticalFlick
        contentWidth: layout.width;
        contentHeight: layout.height

        ColumnLayout {
            id: layout
            anchors.horizontalCenter: parent.horizontalCenter

            ListViewManager {
                id: categoryListView
                width: Style.hspan(6)
                height: Style.vspan(8)
                model: 5
                header: Label {
                    width: parent.width
                    text: "Category List Item"
                }

                delegate: CategoryListItem {
                    width: Style.hspan(6)
                    height: Style.vspan(3)

                    text: "CATEGORY ITEM #" + (index + 1)
                    symbol: "tire_pressure"
                    onClicked: categoryListView.currentIndex = index
                }

            }

            ListViewManager {
                id: settingsListView
                width: Style.hspan(6)
                height: Style.vspan(8)
                model: 6
                header: Label {
                    width: parent.width
                    text: "Settings List Item"
                }

                delegate: SettingsItemDelegate {
                    width: Style.hspan(6)
                    height: Style.vspan(2)
                    checkable: index%2 === 0 ? true : false
                    text: index%2 === 0 ? "Settings item with check option": "Settings item without check option"
                    icon: "tire_pressure"
                }

            }

            ListViewManager {
                id: listView
                width: Style.hspan(11)
                height: Style.vspan(8)
                model: ListModel {
                    ListElement {
                        text: "Normal List Item"
                    }
                    ListElement {
                        text: "Normal List Item"
                    }
                    ListElement {
                        text: "Normal List Item"
                    }
                    ListElement {
                        text: "Normal List Item"
                    }
                    ListElement {
                        text: "Normal List Item"
                    }
                }

                header: Label {
                    width: parent.width
                    text: "Settings List Item"
                }

                delegate: ListItem {
                    width: Style.hspan(11)
                    height: Style.vspan(2)

                    titleText: "Normal List Item"
                    iconName: Style.symbol("tire_pressure", false)
                }

            }

            ListView {
                model: 10
                width: Style.hspan(11)
                height: Style.vspan(8)

                delegate: ItemDelegate {
                    font.pixelSize: 20
                    text: modelData
                    highlighted: ListView.isCurrentItem
                    onClicked: currentIndex = index
                }
            }
        }
    }

}
