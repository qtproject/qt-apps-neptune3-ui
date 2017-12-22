/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AB
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
import QtQuick 2.0

Item {
    id: root

    width: vehicleWidgetGridView.cellWidth * 4
    clip: true

    states: [
        State {
           name: "Widget1Row"
           PropertyChanges {
               target: root
               height: vehicleWidgetGridView.cellHeight * 1
           }
        },
        State {
            name: "Widget2Rows"
            PropertyChanges {
                target: root
                height: vehicleWidgetGridView.cellHeight * 2
            }
        },
        State {
            name: "Widget3Rows"
            PropertyChanges {
                target: root
                height: vehicleWidgetGridView.cellHeight * 3
            }
        }
    ]
    state: "Widget3Rows"

    GridView {
        id: vehicleWidgetGridView

        anchors.fill: parent
        cellWidth: 200
        cellHeight: 200

        model: VehicleWidgetModel
        delegate: Rectangle {
            width: vehicleWidgetGridView.cellWidth
            height: vehicleWidgetGridView.cellHeight
            color: active ? "#cb7733" : "#a19d9b"
            radius: 4
            border.width: 1
            border.color: "grey"

            Text {
                text: qsTranslate("VehicleWidgetModel", name)
                anchors.verticalCenter: parent.verticalCenter
            }

            MouseArea {
                anchors.fill: parent
                onClicked: active = !active
            }
        }
    }
}
