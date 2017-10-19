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

import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1

BaseBoard {
    id: root

    description: "Pane provides a background color that matches with the application style" +
                 " and theme. Pane does not provide a layout of its own, but requires you to" +
                 " position its contents, for instance by creating a RowLayout or a ColumnLayout."

    Pane {
        anchors.top: parent.top
        anchors.topMargin: 150
        anchors.horizontalCenter: parent.horizontalCenter
        ColumnLayout {
            anchors.fill: parent
            CheckBox {
                id: checkBox1
                text: qsTr("E-mail");
                font.pixelSize: 20;
                contentItem: Label {
                    text: checkBox1.text
                    font: checkBox1.font
                    opacity: enabled ? 1.0 : 0.3
                    color: checkBox1.down ? "#9e6a22" : "#db9432"
                    horizontalAlignment: Label.AlignHCenter
                    verticalAlignment: Label.AlignVCenter
                    leftPadding: checkBox1.indicator.width + checkBox1.spacing
                }
            }

            CheckBox {
                id: checkBox2
                text: qsTr("Calendar");
                font.pixelSize: 20;
                contentItem: Label {
                    text: checkBox2.text
                    font: checkBox2.font
                    opacity: enabled ? 1.0 : 0.3
                    color: checkBox2.down ? "#9e6a22" : "#db9432"
                    horizontalAlignment: Label.AlignHCenter
                    verticalAlignment: Label.AlignVCenter
                    leftPadding: checkBox2.indicator.width + checkBox2.spacing
                }
            }

            CheckBox {
                id: checkBox3
                text: qsTr("Contacts");
                font.pixelSize: 20;
                contentItem: Label {
                    text: checkBox3.text
                    font: checkBox3.font
                    opacity: enabled ? 1.0 : 0.3
                    color: checkBox3.down ? "#9e6a22" : "#db9432"
                    horizontalAlignment: Label.AlignHCenter
                    verticalAlignment: Label.AlignVCenter
                    leftPadding: checkBox3.indicator.width + checkBox3.spacing
                }
            }
        }
    }
}
