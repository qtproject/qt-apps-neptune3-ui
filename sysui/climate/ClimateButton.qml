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

import QtQuick 2.6
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import utils 1.0

import com.pelagicore.styles.neptune 3.0

Button {
    id: root
    checkable: true

    width: Style.hspan(156/45)
    height: Style.vspan(146/80)

    property string icon
    property int textFontSize: NeptuneStyle.fontSizeXS

    background: null

    contentItem: Item {
        Column {
            anchors.centerIn: parent
            spacing: Style.vspan(0.1)
            Image {
                width: NeptuneStyle.dp(sourceSize.width)
                height: NeptuneStyle.dp(sourceSize.height)
                anchors.horizontalCenter: parent.horizontalCenter
                source: Style.symbol(root.icon, NeptuneStyle.theme)
                fillMode: Image.PreserveAspectFit
            }
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
                text: root.text
                font.pixelSize: root.textFontSize
                opacity: root.checked ? NeptuneStyle.fontOpacityHigh : NeptuneStyle.fontOpacityDisabled
                Behavior on opacity { OpacityAnimator {} }
            }
        }
    }
}
