/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Copyright (C) 2018 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 UI.
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

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import shared.controls
import shared.utils

import "../popups"

import shared.Sizes

Item {
    id: root
    anchors.horizontalCenter: parent ? parent.horizontalCenter : null
    anchors.top: parent ? parent.top : null
    anchors.topMargin: Sizes.dp(40)
    anchors.bottom: parent ? parent.bottom : null

    Button {
        id: button
        width: Sizes.dp(300)
        height: Sizes.dp(200)
        anchors.centerIn: parent
        text: qsTr("ListView Popup")
        onClicked: {
            popupWithList.width = Qt.binding(() => Sizes.dp(910))
            popupWithList.height = Qt.binding(() => Sizes.dp(450))

            popupWithList.originItemX = Qt.binding(() => Sizes.dp(Config.centerConsoleWidth / 2));
            popupWithList.originItemY = Qt.binding(() => Sizes.dp(Config.centerConsoleHeight / 2));

            popupWithList.popupY = Qt.binding(() => {
                return Sizes.dp(Config.centerConsoleHeight / 2) - popupWithList.height / 2;
            });

            popupWithList.visible = true;
        }
    }

    PopupWithList {
        id: popupWithList

        // have to forward scale from root item as PopupWithList is a Window, not an Item,
        // so value propagation doesn't quite apply
        Sizes.scale: root.Sizes.scale
    }
}

