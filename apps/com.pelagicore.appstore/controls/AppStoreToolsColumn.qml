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

import QtQuick 2.10
import QtQuick.Controls 2.3
import utils 1.0
import com.pelagicore.styles.neptune 3.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2

// FIXME: Delete this in favor of ToolsColumn from controls module
ColumnLayout {
    id: root

    property alias model: toolsRepeater.model
    property string currentTool: "installed"
    signal toolClicked(var storeType, var index)

    ButtonGroup { id: buttonGroup }

    Repeater {
        id: toolsRepeater
        Layout.alignment: Qt.AlignHCenter

        ToolButton {
            Layout.alignment: Qt.AlignHCenter
            baselineOffset: 0
            checkable: true
            checked: root.currentTool === model.name
            icon.name: model.name ? (checked ? "ic-" + model.name.toLowerCase() + "_ON" : "ic-" + model.name.toLowerCase() + "_OFF") : ""
            display: AbstractButton.TextUnderIcon
            text: qsTr(model.name)
            font.pixelSize: NeptuneStyle.fontSizeXS
            onClicked: {
                root.toolClicked(model.name, index);
                root.currentTool = model.name;
            }
            ButtonGroup.group: buttonGroup
        }
    }
}
