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
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.0

import controls 1.0
import utils 1.0

ColumnLayout {
    id: root

    property alias updatesListView: updatesList
    property alias latestUpdateListView: latestUpdateList
    signal updateClicked(var index)

    ColumnLayout {
        Label {
            Layout.preferredHeight: Style.vspan(1)
            text: qsTr("Updates")
            // TODO: Check with Johan, which color should be used.
            color: "grey"
            font.pixelSize: Style.fontSizeM
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignTop
        }

        ListView {
            id: updatesList
            Layout.preferredWidth: Style.hspan(15)
            Layout.preferredHeight: Style.vspan(2)
            delegate: ItemDelegate {
                Layout.preferredWidth: Style.hspan(15)
                Layout.preferredHeight: Style.vspan(1)
                background: null
                contentItem: RowLayout {
                    spacing: Style.hspan(0.8)

                    Image {
                        Layout.preferredWidth: iconSource ? Style.hspan(1) : 0
                        fillMode: Image.Pad
                        source: iconSource ? Style.symbol(iconSource) : ""
                    }

                    Label {
                        Layout.preferredHeight: Style.vspan(0.5)
                        Layout.preferredWidth: iconSource ? Style.hspan(8) : Style.hspan(9.8)
                        text: appName
                        // TODO: Check with Johan, which color should be used.
                        color: "grey"
                        font.pixelSize: Style.fontSizeS
                        horizontalAlignment: Text.AlignLeft
                    }

                    Label {
                        Layout.preferredWidth: Style.hspan(2)
                        text: size
                        // TODO: Check with Johan, which color should be used.
                        color: "grey"
                        font.pixelSize: Style.fontSizeS
                        horizontalAlignment: Text.AlignLeft
                    }

                    Tool {
                        Layout.preferredWidth: Style.hspan(1)
                        Layout.preferredHeight: Style.vspan(0.5)
                        symbol: Style.symbol("ic-update")
                        onClicked: root.updateClicked(index)
                    }
                }

                Rectangle {
                    width: Style.hspan(15)
                    height: Style.hspan(0.05)
                    anchors.bottom: parent.bottom
                    // TODO: Check with Johan, which color should be used.
                    color: "#BCBCBC"
                }
            }
        }
    }

    ColumnLayout {
        Label {
            Layout.preferredHeight: Style.vspan(1.5)
            text: qsTr("Latest Version")
            // TODO: Check with Johan, which color should be used.
            color: "grey"
            font.pixelSize: Style.fontSizeM
            horizontalAlignment: Text.AlignLeft
        }

        ListView {
            id: latestUpdateList
            Layout.preferredWidth: Style.hspan(15)
            Layout.preferredHeight: Style.vspan(4)
            delegate: ItemDelegate {
                Layout.preferredWidth: Style.hspan(15)
                Layout.preferredHeight: Style.vspan(1)
                background: null
                contentItem: RowLayout {
                    spacing: Style.hspan(0.8)

                    Image {
                        Layout.preferredWidth: iconSource ? Style.hspan(1) : 0
                        fillMode: Image.Pad
                        source: iconSource ? Style.symbol(iconSource) : ""
                    }

                    Label {
                        Layout.preferredHeight: Style.vspan(0.5)
                        Layout.preferredWidth: iconSource ? Style.hspan(10) : Style.hspan(11.8)
                        text: appName
                        // TODO: Check with Johan, which color should be used.
                        color: "grey"
                        font.pixelSize: Style.fontSizeS
                        horizontalAlignment: Text.AlignLeft
                    }

                    Label {
                        Layout.preferredWidth: Style.hspan(2)
                        text: size
                        // TODO: Check with Johan, which color should be used.
                        color: "grey"
                        font.pixelSize: Style.fontSizeS
                        horizontalAlignment: Text.AlignLeft
                    }
                }

                Rectangle {
                    width: Style.hspan(15)
                    height: Style.hspan(0.05)
                    anchors.bottom: parent.bottom
                    // TODO: Check with Johan, which color should be used.
                    color: "#BCBCBC"
                }
            }
        }
    }
}


