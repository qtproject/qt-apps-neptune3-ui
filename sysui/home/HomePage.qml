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

import shared.controls 1.0
import shared.utils 1.0
import shared.animations 1.0

import shared.com.pelagicore.styles.neptune 3.0

Item {
    id: root

    property var applicationModel
    property Item popupParent

    property alias activeApplicationParent: widgetGrid.activeApplicationParent
    property alias moveBottomWidgetToDrawer: widgetGrid.moveBottomWidgetToDrawer
    property alias widgetDrawer: widgetGrid.widgetDrawer
    property alias exposedRectTopMargin: widgetGrid.exposedRectTopMargin
    property alias exposedRectBottomMargin: widgetGrid.exposedRectBottomMargin

    readonly property real widgetWidth: widgetGrid.width
    readonly property real rowHeight: widgetGrid.rowHeight - widgetGrid.resizerHandleHeight

    WidgetGrid {
        id: widgetGrid

        anchors.top: parent.top
        anchors.topMargin: NeptuneStyle.dp(76)
        anchors.bottom: addWidgetButton.top
        anchors.bottomMargin: NeptuneStyle.dp(5)
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: NeptuneStyle.dp(40)
        anchors.rightMargin: NeptuneStyle.dp(40)

        applicationModel: root.applicationModel
    }

    ToolButton {
        id: addWidgetButton
        anchors.bottom: parent.bottom
        anchors.bottomMargin: NeptuneStyle.dp(40)
        anchors.horizontalCenter: parent.horizontalCenter
        width: NeptuneStyle.dp(45)
        height: width
        icon.name: "ic-addwidget-plus"
        onClicked: popup.open()
        visible: widgetGrid.widgetCount < widgetGrid.maxWidgetCount && opacity > 0
        opacity: root.applicationModel.activeAppInfo ? 0 : 1
        Behavior on opacity { DefaultNumberAnimation{} }
    }

    AddWidgetPopupLoader {
        id: popup
        popupParent: root.popupParent
        originItem: addWidgetButton
        model: root.applicationModel
    }
}
