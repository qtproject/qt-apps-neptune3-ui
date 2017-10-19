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
    id: root

    description: " The push button is perhaps the most commonly used widget in any" +
                 " graphical user interface. Pushing (or clicking) a button commands the computer" +
                 " to perform some action or answer a question. Common examples of buttons are OK," +
                 " Apply, Cancel, Close, Yes, No, and Help buttons."

    Flickable {
        id: scrollView
        anchors.fill: parent

        flickableDirection: Flickable.VerticalFlick
        contentWidth: layout.width; contentHeight: layout.height

        GridLayout {
            id: layout

            width: parent.width

            rowSpacing: Style.paddingXL
            columnSpacing: Style.padding

            columns: 2

            Label { width: Style.hspan(8); text: "No Text, No Icon, grid 2x2" }
            Button {
                Layout.preferredWidth: Style.hspan(2)
                Layout.preferredHeight: Style.vspan(2)
                width: Style.hspan(2); height: Style.vspan(2)

                Marker { anchors.fill: parent; visible: parent.pressed }
                Tracer { visible: true }
            }

            Label { width: Style.hspan(8); text: "Only text, grid 2x1" }
            Button {
                Layout.preferredWidth: Style.hspan(2)
                Layout.preferredHeight: Style.vspan(1)
                width: Style.hspan(2); height: Style.vspan(1)
                text: "Press me"

                Marker { anchors.fill: parent; visible: parent.pressed }
            }

            Label { width: Style.hspan(8); text: "Only icon, grid 1x2" }
            Button {
                Layout.preferredWidth: Style.hspan(1)
                Layout.preferredHeight: Style.vspan(2)
                width: Style.hspan(1); height: Style.vspan(2)

                Marker { anchors.fill: parent; visible: parent.pressed }
            }

            Label { width: Style.hspan(8);  text: "Text & Icon, grid 3x3" }
            Button {
                Layout.preferredWidth: Style.hspan(3)
                Layout.preferredHeight: Style.vspan(3)

                width: Style.hspan(3); height: Style.vspan(3)
                text: "Hello World"

                Marker { anchors.fill: parent; visible: parent.pressed }
            }

            Label { width: Style.hspan(8);  text: "Regular Button" }
            Button {
                id: buttonControl
                text: qsTr("Button")
                width: Style.hspan(3)

                onClicked: console.log(Logging.apps, "Button Clicked!");

                contentItem: Label {
                    text: buttonControl.text
                    font: buttonControl.font
                    opacity: enabled ? 1.0 : 0.3
                    color: buttonControl.down ? "#db9432" : "#ffffff"
                    horizontalAlignment: Label.AlignHCenter
                    verticalAlignment: Label.AlignVCenter
                    elide: Label.ElideRight
                }
            }
        }
    }
}
