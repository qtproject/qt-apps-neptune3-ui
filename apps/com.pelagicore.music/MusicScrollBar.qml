/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AG
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
import utils 1.0
import controls 1.0
import animations 1.0
import com.pelagicore.styles.neptune 3.0

// TODO rename and move this to shared controls
Item {
    id: scrollbar

    property var attachTo: null

    anchors.top: attachTo.top
    anchors.left: attachTo.right
    anchors.right: parent.right
    anchors.bottom: attachTo.bottom
    opacity: attachTo.moving ? 1 : 0

    Behavior on opacity {
        SequentialAnimation {
            PauseAnimation { duration: scrollbar.opacity < 0.1 ? 0 : 1000 }
            DefaultNumberAnimation { duration: scrollbar.opacity < 0.1 ? 80 : 500 }
        }
    }
    visible: opacity > 0

    Rectangle {
        id: aboveBar
        width: Style.hspan(5/45)
        anchors.top: scrollbar.top
        anchors.bottom: coloredBar.top
        anchors.bottomMargin: Style.vspan(9/80)
        anchors.horizontalCenter: parent.horizontalCenter
        radius: width/2
        color: NeptuneStyle.contrastColor
        opacity: 0.14
    }

    Rectangle {
        id: coloredBar
        width: Style.hspan(7/45)
        height: attachTo.height/attachTo.contentHeight * scrollbar.height + Style.vspan(7/80)

        anchors.top: parent.top
        //todo: don't overshoot the position of the scrollbar even if the list is overshooting. Or maybe change the height instead, but no overshoot whatsoever :)
        anchors.topMargin: Math.max(-Style.vspan(3.5/80), Math.min(scrollbar.height - coloredBar.height + Style.vspan(3.5/80), attachTo.contentY / attachTo.contentHeight * scrollbar.height - Style.vspan(3.5/80)))
        anchors.horizontalCenter: parent.horizontalCenter

        radius: width/2
        color: NeptuneStyle.accentDetailColor
        opacity: 1
    }

    Rectangle {
        id: belowBar
        width: Style.hspan(5/45)
        anchors.bottom: scrollbar.bottom
        anchors.top: coloredBar.bottom
        anchors.topMargin: Style.vspan(9/80)
        anchors.horizontalCenter: parent.horizontalCenter
        radius: width/2
        color: NeptuneStyle.contrastColor
        opacity: 0.14
    }
}

