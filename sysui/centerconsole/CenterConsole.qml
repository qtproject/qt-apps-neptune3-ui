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
import QtQml
import QtQuick.Controls

import shared.controls
import shared.utils
import shared.animations
import about
import centerconsole
import volume
import statusbar
import stores
import system.controls

import shared.Style
import shared.Sizes

AbstractCenterConsole {
    id: root

    ToolButton {
        id: leftIcon
        objectName: "volumePopupButton"
        width: Sizes.dp(90)
        height: width
        anchors.verticalCenter: bottomBar.verticalCenter
        anchors.left: bottomBar.left
        anchors.leftMargin: Sizes.dp(27)
        icon.name: root.store.volumeStore.volumeIcon
        onClicked: volumePopup.open()
        enabled: mainContentArea.item && !mainContentArea.item.launcherOpen
        opacity: enabled ? 1.0 : 0.6
    }

    ToolButton {
        id: rightIcon
        width: Sizes.dp(90)
        height: width
        anchors.verticalCenter: bottomBar.verticalCenter
        anchors.right: bottomBar.right
        anchors.rightMargin: Sizes.dp(27)
        icon.name: "qt-badge"
        onClicked: about.open()
        enabled: mainContentArea.item && !mainContentArea.item.launcherOpen
        opacity: enabled ? 1.0 : 0.6
    }

    PopupItemLoader {
        id: volumePopup
        source: "../volume/VolumePopup.qml"
        popupParent: root.popupParent
        popupX: originItem.mapToItem(parent, 0, 0).x + (LayoutMirroring.enabled ? -width + leftIcon.width: 0)
        originItem: leftIcon
        Binding {
            restoreMode: Binding.RestoreBinding;
            target: volumePopup.item; property: "model"; value: root.store.volumeStore;
        }
        onClosed: { leftIcon.forceActiveFocus(); }
    }

    About {
        id: about
        popupParent: root.popupParent
        originItem: rightIcon
        applicationModel: root.store.applicationModel
        systemModel: root.store.systemStore
        sysInfo: root.store.sysInfo
        onClosed: { rightIcon.forceActiveFocus(); }
    }
}
