/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AG
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
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.2

import controls 1.0
import utils 1.0
import com.pelagicore.styles.triton 1.0

Button {
    id: root

    checkable: true
    background: Rectangle {
        opacity: 0.2
        color: "black"
        border.width: root.pressed ? 2 : 1
        border.color: "#888"
        radius: 4
        // TODO: Later check with designer, which color / asset should be used.
        gradient: Gradient {
            GradientStop { position: 0 ; color: root.pressed ? "#ccc" : root.checked ? "#fcd699" : "#eee" }
            GradientStop { position: 1 ; color: root.pressed ? "#aaa" : "#ccc" }
        }
    }

    contentItem: Label {
        width: Style.hspan(3.5)
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: TritonStyle.fontSizeS
        text: root.text
    }
}
