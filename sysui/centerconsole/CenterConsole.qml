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

import QtQuick 2.7
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0

import shared.controls 1.0
import shared.utils 1.0
import shared.animations 1.0
import about 1.0
import centerconsole 1.0
import volume 1.0
import statusbar 1.0
import stores 1.0
import system.controls 1.0

import shared.com.pelagicore.styles.neptune 3.0

Item {
    id: root

    property Item popupParent
    property RootStore store
    property alias mainContentArea: mainContentArea

    rotation: store.centerConsole.rotation

    // If the Window aspect ratio differs from Style.centerConsoleAspectRatio the Center Console item will be
    // letterboxed so that a Style.centerConsoleAspectRatio is preserved.
    states: [
        State {
            name: "constrainWidth"
            when: root.store.centerConsole.availableAspectRatio > Style.centerConsoleAspectRatio
            PropertyChanges { target: root
                width: Math.round(root.height * Style.centerConsoleAspectRatio)
                height: root.store.centerConsole.availableHeight
            }
        },
        State {
            name: "constrainHeight"
            when: root.store.centerConsole.availableAspectRatio <= Style.centerConsoleAspectRatio
            PropertyChanges { target: root
                width: root.store.centerConsole.availableWidth
                height: Math.round(root.width / Style.centerConsoleAspectRatio)
            }
        }
    ]

    Component.onCompleted: {
        // N.B. need to use a Timer here to "push" the available languages to settings server
        // since it uses QMetaObject::invokeMethod(), possibly running in a different thread
        root.store.languageTimer.start();
    }

    Binding { target: root.store.systemStore; property: "activeAppInfo"; value: root.store.applicationModel.activeAppInfo }
    Binding { target: root.store.systemStore; property: "monitorEnabled"; value: about.state === "open" && about.currentTabName === "system" }

    Image {
        anchors.fill: parent
        source: Style.gfx(NeptuneStyle.backgroundImage)
        opacity: mainContentArea.item && mainContentArea.item.launcherOpen && NeptuneStyle.theme === NeptuneStyle.Light ? 0.7 : 1
        Behavior on opacity { DefaultNumberAnimation {} }
    }

    // Content Elements
    StageLoader {
        id: mainContentArea
        source: "MainContentArea.qml"
        anchors.fill: parent

        Binding { target: mainContentArea.item; property: "applicationModel"; value: root.store.applicationModel }
        Binding { target: mainContentArea.item; property: "launcherY"; value: statusBar.y + statusBar.height }
        Binding { target: mainContentArea.item; property: "homeBottomMargin"; value: bottomBar.height }
        Binding { target: mainContentArea.item; property: "popupParent"; value: root.popupParent }
        Binding { target: mainContentArea.item; property: "virtualKeyboard"; value: virtualKeyboard.item }
    }

    StatusBar {
        id: statusBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: NeptuneStyle.dp(20)
        anchors.right: parent.right
        anchors.rightMargin: NeptuneStyle.dp(20)
        uiSettings: root.store.uiSettings
        z: 1
        model: root.store.statusBarStore
        onScreenshotRequested: root.store.generateScreenshotAndInfo()
    }

     NeptuneWindowItem {
        id: bottomBar
        width: root.width
        height: NeptuneStyle.dp(120)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        window: root.store.applicationModel.bottomBarAppInfo.window
    }

    ToolButton {
        id: leftIcon
        width: NeptuneStyle.dp(90)
        height: width
        anchors.verticalCenter: bottomBar.verticalCenter
        anchors.left: bottomBar.left
        anchors.leftMargin: NeptuneStyle.dp(27)
        icon.name: root.store.volumeStore.volumeIcon
        onClicked: volumePopup.open()
    }

    ToolButton {
        id: rightIcon
        width: NeptuneStyle.dp(90)
        height: width
        anchors.verticalCenter: bottomBar.verticalCenter
        anchors.right: bottomBar.right
        anchors.rightMargin: NeptuneStyle.dp(27)
        icon.name: "qt-badge"
        onClicked: about.open()
    }

    PopupItemLoader {
        id: volumePopup
        source: "../volume/VolumePopup.qml"
        popupParent: root.popupParent
        popupX: originItem.mapToItem(parent, 0, 0).x + (LayoutMirroring.enabled ? -item.width + leftIcon.width: 0)
        originItem: leftIcon
        Binding { target: volumePopup.item; property: "model"; value: root.store.volumeStore }
    }

    About {
        id: about
        popupParent: root.popupParent
        originItem: rightIcon
        applicationModel: root.store.applicationModel
        systemModel: root.store.systemStore
        sysInfo: root.store.sysInfo
    }

    ApplicationPopups {
        anchors.fill: parent
        popupParent: root.popupParent
        store: root.store.applicationPopupsStore
    }

    Loader {
        id: virtualKeyboard
        source: "VirtualKeyboard.qml"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }

    UIShortcuts {
        onCtrlRPressed: {
            root.store.centerConsole.inverted = !root.store.centerConsole.inverted;
        }
        onCtrlShiftRPressed: {
            root.store.clusterStore.invertedCluster = !root.store.clusterStore.invertedCluster;
        }
        onCtrlTPressed: {
            root.store.uiSettings.theme = root.store.uiSettings.theme === 0 ? 1 : 0;
        }
        onCtrlLPressed: {
            const locales = Style.translation.availableTranslations;
            const currentLocale = Style.languageLocale;
            const currentIndex = locales.indexOf(currentLocale);
            var nextIndex = currentIndex === locales.length - 1 ? 0 : currentIndex + 1;
            root.store.uiSettings.language = locales[nextIndex];
        }
        onCtrlBPressed: {
            root.store.applicationModel.goBack();
        }
        onCtrlPPressed: {
            root.store.generateScreenshotAndInfo();
        }
    }
}
