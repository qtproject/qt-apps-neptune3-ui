/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
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
import utils 1.0
import com.pelagicore.styles.neptune 3.0

ToolButton {
    id: root
    property string symbol
    property color labelColor: NeptuneStyle.primaryTextColor
    property real labelOpacity: 1
    property bool symbolOnTop: false

    contentItem: Label {
        text: root.text
        font: root.font
        color: root.labelColor
        opacity: root.labelOpacity
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: root.symbolOnTop ? Style.vspan(0.2) : 0
        horizontalAlignment: Text.AlignHCenter
    }

    indicator: Image {
        width: Style.hspan(1.3)
        height: Style.vspan(0.8)
        anchors.horizontalCenter: {
            if (!root.symbolOnTop) {
                if (root.text !== "") {
                    return undefined
                } else {
                    return parent.horizontalCenter
                }
            } else {
                return parent.horizontalCenter
            }
        }
        anchors.right: {
            if (!root.symbolOnTop) {
                if (root.text !== "") {
                    return parent.right
                } else {
                    return undefined
                }
            } else {
                return undefined
            }
        }
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: root.symbolOnTop ? - Style.vspan(0.2) : 0

        fillMode: Image.Pad
        source: root.symbol ? (NeptuneStyle.theme === NeptuneStyle.Dark ? root.symbol.replace("\.png","-dark\.png")
                                                                      : root.symbol)
                            : ""
    }
}
