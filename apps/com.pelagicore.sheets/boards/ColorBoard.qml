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

import QtQuick 2.5
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls.impl 2.1

BaseBoard {
    id: root

    description: "Colors used in UI"

    property var colors: [
        { name: "background", color: Default.backgroundColor },
        { name: "overlayModal", color: Default.overlayModalColor },
        { name: "overlayDim", color: Default.overlayDimColor },
        { name: "text", color: Default.textColor },
        { name: "textDark", color: Default.textDarkColor },
        { name: "textLight", color: Default.textLightColor },
        { name: "textLink", color: Default.textLinkColor },
        { name: "textSelection", color: Default.textSelectionColor },
        { name: "textDisabled", color: Default.textDisabledColor },
        { name: "textDisabledLight", color: Default.textDisabledLightColor },
        { name: "focus", color: Default.focusColor },
        { name: "focusLight", color: Default.focusLightColor },
        { name: "focusPressed", color: Default.focusPressedColor },
        { name: "button", color: Default.buttonColor },
        { name: "buttonPressed", color: Default.buttonPressedColor },
        { name: "buttonChecked", color: Default.buttonCheckedColor },
        { name: "buttonCheckedPressed", color: Default.buttonCheckedPressedColor },
        { name: "buttonCheckedFocus", color: Default.buttonCheckedFocusColor },
        { name: "toolButton", color: Default.toolButtonColor },
        { name: "tabButton", color: Default.tabButtonColor },
        { name: "tabButtonPressed", color: Default.tabButtonPressedColor },
        { name: "tabButtonCheckedPressed", color: Default.tabButtonCheckedPressedColor },
        { name: "delegate", color: Default.delegateColor },
        { name: "delegatePressed", color: Default.delegatePressedColor },
        { name: "delegateFocus", color: Default.delegateFocusColor },
        { name: "indicatorPressed", color: Default.indicatorPressedColor },
        { name: "indicatorDisabled", color: Default.indicatorDisabledColor },
        { name: "indicatorFrame", color: Default.indicatorFrameColor },
        { name: "indicatorFramePressed", color: Default.indicatorFramePressedColor },
        { name: "indicatorFrameDisabled", color: Default.indicatorFrameDisabledColor },
        { name: "frameDark", color: Default.frameDarkColor },
        { name: "frameLight", color: Default.frameLightColor },
        { name: "scrollBar", color: Default.scrollBarColor },
        { name: "scrollBarPressed", color: Default.scrollBarPressedColor },
        { name: "progressBar", color: Default.progressBarColor },
        { name: "pageIndicator", color: Default.pageIndicatorColor },
        { name: "separator", color: Default.separatorColor },
        { name: "disabledDark", color: Default.disabledDarkColor },
        { name: "disabledLight", color: Default.disabledLightColor },
    ]

    GridView {
        id: view
        width: parent.width
        height: 48 * 13
        anchors.top: parent.top
        anchors.topMargin: 50
        cellWidth: root.width/3
        cellHeight: 48
        model: root.colors
        delegate: ColorButton {
            width: GridView.view.cellWidth-2
            height: GridView.view.cellHeight-2
            text: modelData.name
            color: modelData.color
        }
    }
}
