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

import QtQuick 2.9
import QtQuick.Window 2.3

import utils 1.0
import com.pelagicore.styles.triton 1.0

Window {
    id: root
    width: 1080
    height: 1920

    color: root.contentItem.TritonStyle.theme === TritonStyle.Dark ? "black" : "white"

    Binding { target: Style; property: "cellWidth"; value: root.width / 24 }
    Binding { target: Style; property: "cellHeight"; value: root.height / 24 }
    Binding { target: Style; property: "assetPath"; value: Qt.resolvedUrl("/opt/triton/imports/assets/") }

    Shortcut {
        sequence: "Ctrl+t"
        context: Qt.ApplicationShortcut
        onActivated: {
            var otherTheme = root.contentItem.TritonStyle.theme === TritonStyle.Dark ? TritonStyle.Light
                                                                                     : TritonStyle.Dark;
            root.contentItem.TritonStyle.theme = otherTheme;
        }
    }

    Maps {
        anchors.fill: parent
        state: "Maximized"
    }
}
