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

import QtQuick 2.6
import QtQml 2.14
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

import shared.utils 1.0
import shared.controls 1.0
import volume 1.0

import shared.Sizes 1.0
import system.controls 1.0

Item {
    id: root

    property var uiSettings
    property var model
    property Item popupParent
    property var popupLoader: PopupItemLoader {
        id: volumePopup
        source: "../volume/VolumePopup.qml"
        popupParent: root.popupParent
        property var originPos: originItem.mapToItem(root.parent, originItem.width/2, originItem.height/2)
        popupX: (root.LayoutMirroring.enabled ? root.parent.width - width - Sizes.dp(5) : Sizes.dp(5))
        popupY: originPos.y
        originItem: volumeIcon
        Binding {
            restoreMode: Binding.RestoreBinding
            target: volumePopup.item; property: "model"; value: root.model.volumeStore;
        }
    }
    property var voiceAssitantWindow

    signal screenshotRequested()

    implicitHeight: Sizes.dp(Config.statusBarHeight)

    RowLayout {
        anchors.fill: parent
        spacing: Sizes.dp(5)

        ToolButton {
            padding: 0
            Layout.preferredWidth: Sizes.dp(64)
            Layout.fillHeight: true
            id: volumeIcon
            objectName: "volumePopupButton"
            anchors.leftMargin: Sizes.dp(27)
            icon.name: root.model.volumeStore.volumeIcon
            onClicked: volumePopup.open()
        }

        NeptuneWindowItem {
            window: voiceAssitantWindow
        }

        Item {
            Layout.fillWidth: true
        }

        IndicatorTray {
            Layout.fillHeight: true
            store: root.model.statusBarStore
        }

        DateAndTime {
            Layout.fillHeight: true
            currentDate: root.model.statusBarStore.currentDate
            uiSettings: root.uiSettings

            MouseArea {
                anchors.fill: parent
                onPressAndHold: {
                    root.screenshotRequested();
                    mouse.accepted = true;
                }
            }
        }
    }


}
