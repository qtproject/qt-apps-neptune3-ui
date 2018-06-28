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

/*!
    \qmltype ApplicationPopup
    \inherits PopupItem
    \since 5.11
    \brief A components used as the delegate of PopupWindow.

    The ApplicationPopup is used as the parent of the PopupWindow. It inherits PopupItem preserving
    the graphics and animations of it.
*/

import QtQuick 2.7
import sysui.controls 1.0
import QtApplicationManager 1.0

import com.pelagicore.styles.neptune 3.0

// TODO this will be refactored in 5.12 following the API changes
// of the appman. See PopupWindow.qml for further explanations.

PopupItem {
    id: root

    property alias window: windowItem.window

    /*!
        \qmlproperty var ApplicationPopup::appInfo

        This property holds the applicationInfo of the current displayed popup.

    */
    property var appInfo

    /*!
        \qmlproperty int ApplicationPopup::popupWindowWidth

        This property holds the initial value for the popup width as it's set from the application.

    */
    property int popupWindowWidth: 910

    /*!
        \qmlproperty int ApplicationPopup::popupWindowHeight

        This property holds the initial value for the popup height as it's set from the application.

    */
    property int popupWindowHeight: 700

    width: NeptuneStyle.dp(popupWindowWidth)

    height: NeptuneStyle.dp(popupWindowHeight)

    onClosing: {
        if (root.appInfo) {
            root.appInfo.openPopup = false;
        }
    }

    WindowItem {
        id: windowItem
        anchors.fill: parent

        property real neptuneScale: NeptuneStyle.scale
        onNeptuneScaleChanged: forwardNeptuneScale()
        onWindowChanged: forwardNeptuneScale()
        function forwardNeptuneScale() {
            if (window)
                window.setWindowProperty("neptuneScale", neptuneScale);
        }
    }
}
