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
import utils 1.0
import controls 1.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2

ColumnLayout {
    id: root

    property int currentTool: 0
    signal toolClicked(var contentType)

    property ListModel model: ListModel {
        ListElement {
            icon: "ic-calendar"
            label: QT_TR_NOOP("year")
        }

        ListElement {
            icon: "ic-calendar"
            label: QT_TR_NOOP("next")
        }

        ListElement {
            icon: "ic-calendar"
            label: QT_TR_NOOP("events")
        }
    }

    ButtonGroup { id: buttonGroup }

    Repeater {
        model: root.model

        Tool {
            anchors.horizontalCenter: parent.horizontalCenter
            baselineOffset: 0
            checkable: true
            checked: root.currentTool === index
            symbol: icon ? Style.symbol(buttonGroup.checkedButton === this ? icon + "_ON" : icon + "_OFF") : ""
            text: qsTr(label)
            font.pixelSize: Style.fontSizeXS
            symbolOnTop: true
            onClicked: {
                root.toolClicked(label);
                root.currentTool = index;
            }
            ButtonGroup.group: buttonGroup
        }
    }
}

