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

import QtQuick 2.7
import QtQml 2.14
import shared.utils 1.0
import stores 1.0
import QtQuick.Window 2.3

import shared.Sizes 1.0

Window {
    id: root

    property alias popupParent: popupParent
    property alias mainCenterConsole: mainCenterConsole
    property RootStore store

    signal nextICAppIsRequested()

    Binding {
        restoreMode: Binding.RestoreBinding;
        target: root.store.centerConsole; property: "windowWidth"; value: root.width;
    }
    Binding {
        restoreMode: Binding.RestoreBinding;
        target: root.store.centerConsole; property: "windowHeight"; value: root.height;
    }

    title: store.centerConsole.title
    color: "black"
    LayoutMirroring.enabled: root.store.layoutMirroringEnabled
    LayoutMirroring.childrenInherit: root.store.layoutMirroringChildreninherit
    screen: store.centerConsole.centerConsoleScreen
    visible: true

    Component.onCompleted: {
        // Don't use bindings for setting up the initial size. Otherwise the binding is revaluated
        // on every language change, which results in resetting the window size to it's initial state
        // and might overwrite the size given by the OS or the user using the WindowManager
        if (!root.store.centerConsole.runningOnDesktop) {
            root.width = Config.centerConsoleWidth;
            root.height = Config.centerConsoleHeight;
        } else {
            root.height = root.store.centerConsole.desktopHeight;
            root.width = root.store.centerConsole.desktopWidth;
        }
    }

    // Load the full UI once a first frame has been drawn with the ligth UI version
    // FIXME: Find a better way of finding out when the first proper frame has been
    //       rendered (scene no longer dirty. render thread idle)
    Connections {
        id: windowConns
        target: root
        readonly property string widgetStates: root.store.settingsStore.value("widgetStates"
                , root.store.settingsStore.defaultWidgetStates)
        readonly property string autostartApps: root.store.settingsStore.value("autostartApps"
                , root.store.settingsStore.defaultAutostartApps)
        readonly property string autorecoverApps: root.store.settingsStore.value("autorecoverApps"
                , root.store.settingsStore.defaultAutorecoverApps)
        function onFrameSwapped() {
            /*
                The UI is loaded in two steps
                This is done in order to ensure that something is rendered on the screen as
                soon as possible during start up.

                Only the lightest elements are present upon creation of this component.
                They are the ones that will be present on the very first rendered frame.

                Others, which are more complex and thus take more time to load, will be
                loaded afterwards, once this function is called.
             */
            if (root.store.applicationModel.count > 0) {
                root.store.applicationModel.populate(
                            widgetStates, autostartApps, autorecoverApps);
                centerConsole.mainContentArea.active = true;
                notificationLoader.active = true;
                windowConns.enabled = false;
            }
        }
    }

    /*
                By default, Neptune 3 consists of two windows, the center console window and the
                instrument cluster window. Below, the definition of the center console window content
                and the loading of the instrument cluster window is done. However on a device, the
                instrument cluster window will only be shown if there are two screens connected. There
                is also the possibility to configure whether it should be shown or not through the main
                yaml file, default is 'yes'.

                If additional windows shall be added, this can be done in the same way as the
                instrument cluster window is added in Neptune 3

                For more detail information, please visit Neptune 3 documentation page.
                (TODO: add the link here once we have the documentation)
             */
    Item {
        id: mainCenterConsole
        anchors.fill: parent

        Loader {
            sourceComponent: Component {
                GamePadController {
                    onButtonBPressed: root.nextICAppIsRequested();
                    onButtonR1Pressed: root.store.musicStore.sendIntent("next");
                    onButtonL1Pressed: root.store.musicStore.sendIntent("prev");
                }
            }
            active: root.store.enableCursorManagement
        }

        CenterConsole {
            id: centerConsole
            anchors.centerIn: parent
            store: root.store
            popupParent: popupParent
            focus: true

            onWidthChanged: {
                root.contentItem.Sizes.scale = centerConsole.width / Config.centerConsoleWidth;
            }
        }

        ModalOverlay {
            id: popupParent
            anchors.fill: centerConsole
            target: centerConsole
            onOverlayTopRightPressedAndHeld: root.store.generateScreenshotAndInfo()
        }

        StageLoader {
            id: notificationLoader
            anchors.fill: centerConsole
            source: "../notification/NotificationContent.qml"

            Binding {
                restoreMode: Binding.RestoreBinding;
                target: notificationLoader.item; property: "target";
                value: popupParent.showModalOverlay ? popupParent : centerConsole;
            }
        }

        CenterConsoleMonitorOverlay {
            anchors.fill: centerConsole
            rotation: centerConsole.rotation
            model: root.store.systemStore
            fpsVisible: root.store.systemStore.centerConsolePerfOverlayEnabled
            activeAppId: root.store.applicationModel.activeAppInfo ? root.store.applicationModel.activeAppInfo.id : ""
            window: root
        }
    }
}
