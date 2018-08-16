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
import QtApplicationManager 1.0

import about 1.0
import climate 1.0
import controls 1.0
import display 1.0
import utils 1.0
import animations 1.0
import volume 1.0
import statusbar 1.0
import ipc 1.0

import models.application 1.0
import models.climate 1.0
import models.settings 1.0
import models.volume 1.0
import models.statusbar 1.0

import sysui.controls 1.0

import QtGraphicalEffects 1.0

import com.pelagicore.systeminfo 1.0
import com.pelagicore.styles.neptune 3.0

Item {
    id: root

    /*
        The UI is loaded in two steps
        This is done in order to ensure that something is rendered on the screen as
        soon as possible during start up.

        Only the lightest elements are present upon creation of this component.
        They are the ones that will be present on the very first rendered frame.

        Others, which are more complex and thus take more time to load, will be
        loaded afterwards, once this function is called.
     */
    function loadUI() {
        applicationModel.populate(settingsModel.widgetStates);
        mainContentArea.active = true;
    }

    property Item popupParent
    property var settings

    property SystemInfo sysInfo: SystemInfo {
        id: sysInfo
    }

    property var systemModel

    property var applicationModel: ApplicationModel {
        id: applicationModel
        localeCode: Style.languageLocale

        // Store widget states when the UI is shutting down
        onShuttingDown: settingsModel.widgetStates = applicationModel.serializeWidgetsState();
    }

    property var musicAppRequestsIPC: MusicAppRequestsIPC  { }

    signal screenshotRequested()

    Image {
        anchors.fill: parent
        source: Style.gfx(NeptuneStyle.backgroundImage)
        opacity: mainContentArea.item && mainContentArea.item.launcherOpen && NeptuneStyle.theme === NeptuneStyle.Light ? 0.7 : 1
        Behavior on opacity { DefaultNumberAnimation {} }
    }

    ClimateModel {
        id: climateModel
        measurementSystem: settingsModel.measurementSystem
    }

    SettingsModel {
        id: settingsModel
    }

    VolumeModel {
        id: volumeModel
    }

    // Content Elements

    StageLoader {
        id: mainContentArea
        source: "MainContentArea.qml"
        anchors.fill: parent

        Binding { target: mainContentArea.item; property: "applicationModel"; value: root.applicationModel }
        Binding { target: mainContentArea.item; property: "launcherY"; value: statusBar.y + statusBar.height }
        Binding { target: mainContentArea.item; property: "homeBottomMargin"; value: climateBar.height }
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
        uiSettings: settings
        z: 1
        model: StatusBarModel {
            isOnline: sysInfo.online
        }
        onScreenshotRequested: root.screenshotRequested()
    }

    ClimateBar {
        id: climateBar
        width: root.width
        height: NeptuneStyle.dp(120)
        anchors.bottom: parent.bottom
        popupParent: root.popupParent
        model: climateModel

        ToolButton {
            id: leftIcon
            width: climateBar.toolWidth
            height: width
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: climateBar.lateralMargin
            icon.name: {
                if (volumeModel.muted) {
                    return "ic-volume-0"
                } else if (volumeModel.volume <= 0.33) {
                    return "ic-volume-1"
                } else if (volumeModel.volume <= 0.66) {
                    return "ic-volume-2"
                } else {
                    return "ic-volume-3"
                }
            }
            onClicked: volumePopup.open()
        }

        ToolButton {
            id: rightIcon
            width: climateBar.toolWidth
            height: width
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: climateBar.lateralMargin
            icon.name: "qt-badge"
            onClicked: about.open()
        }
    }

    Binding { target: root.systemModel; property: "activeAppInfo"; value: applicationModel.activeAppInfo }
    Binding { target: root.systemModel; property: "monitorEnabled"; value: about.state === "open" && about.currentTabName === "system" }

    PopupItemLoader {
        id: volumePopup
        source: "../volume/VolumePopup.qml"
        popupParent: root.popupParent
        popupX: originItem.mapToItem(parent, 0, 0).x + (LayoutMirroring.enabled ? -item.width + leftIcon.width: 0)
        originItem: leftIcon
        Binding { target: volumePopup.item; property: "model"; value: volumeModel }
    }

    About {
        id: about
        popupParent: root.popupParent
        originItem: rightIcon
        applicationModel: root.applicationModel
        systemModel: root.systemModel
        sysInfo: root.sysInfo
    }

    ApplicationPopups {
        anchors.fill: parent
        popupParent: root.popupParent
    }

    Loader {
        id: virtualKeyboard
        source: "VirtualKeyboard.qml"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }
}
