/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AB
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
import animations 1.0

import com.pelagicore.styles.triton 1.0

Item {
    id: root

    property int destinationButtonrowHeight: 0
    property bool navigationMode: false
    property bool guidanceMode: false
    height: destinationButtonsPanel.visible ? destinationButtonsPanel.sourceSize.height : searchPanel.height

    BorderImage {
        id: outerShadow
        anchors.top: destinationButtonsPanel.top
        anchors.topMargin: -40
        anchors.left: destinationButtonsPanel.left
        anchors.right: destinationButtonsPanel.right
        anchors.rightMargin: -Style.vspan(.5)
        height: root.navigationMode && !root.guidanceMode ? sourceSize.height - root.destinationButtonrowHeight : sourceSize.height
        source: TritonStyle.theme === TritonStyle.Light ? Qt.resolvedUrl("assets/panel-shadow.png")
                                                        : Qt.resolvedUrl("assets/panel-shadow-dark.png")
        border {
            left: 0
            top: 101
            right: 101
            bottom: 106
        }
    }

    BorderImage {
        id: destinationButtonsPanel
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: -Style.vspan(1)
        source: TritonStyle.theme === TritonStyle.Light ? Qt.resolvedUrl("assets/panel-more-contrast-background.png")
                                                        : Qt.resolvedUrl("assets/panel-more-contrast-background-dark.png")
        visible: !root.navigationMode || root.guidanceMode
        border {
            left: 0
            top: 20
            right: 32
            bottom: 22
        }
    }

    Image {
        id: innerShadow
        anchors.top: searchPanel.bottom
        anchors.right: searchPanel.right
        anchors.left: searchPanel.left
        width: searchPanel.width
        source: Style.gfx2("panel-inner-shadow", TritonStyle.theme)
    }

    BorderImage {
        id: searchPanel
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: -Style.vspan(1)
        height: root.guidanceMode ? sourceSize.height : destinationButtonsPanel.sourceSize.height - root.destinationButtonrowHeight
        source: TritonStyle.theme === TritonStyle.Light ? Qt.resolvedUrl("assets/panel-background.png")
                                                        : Qt.resolvedUrl("assets/panel-background-dark.png")
        border {
            left: 0
            top: 20
            right: 22
            bottom: 0
        }
    }
}
