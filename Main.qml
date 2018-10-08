/****************************************************************************
**
** Copyright (C) 2017, 2018 Pelagicore AG
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
import QtQuick.Controls 2.2
import QtQuick.Window 2.3

import centerconsole 1.0
import notification 1.0
import instrumentcluster 1.0
import stores 1.0

import shared.com.pelagicore.styles.neptune 3.0

QtObject {
    id: root

    readonly property RootStore store: RootStore {
        clusterAvailable: instrumentClusterWindowLoader.item && instrumentClusterWindowLoader.item.visible

        onAccentColorChanged: {
            centerConsoleWindow.contentItem.NeptuneStyle.accentColor = newAccentColor;
        }

        onGrabImageRequested: {
            centerConsoleWindow.centerConsole.grabToImage(function(result) {
                var ret = result.saveToFile(screenshotUrl);
                console.info("Screenshot was", ret ? "" : "NOT", "saved to file", screenshotUrl);
            });
        }

        onUpdateThemeRequested: {
            var chosenTheme = currentTheme === 0 ? NeptuneStyle.Light : NeptuneStyle.Dark;
            if (centerConsoleWindow.popupParent.visible) {
                centerConsoleWindow.popupParent.updateOverlay();
            }
            centerConsoleWindow.contentItem.NeptuneStyle.theme = chosenTheme;
            if (instrumentClusterWindowLoader.item) {
                instrumentClusterWindowLoader.item.contentItem.NeptuneStyle.theme = chosenTheme;
            }
        }

        onApplicationICWindowSwitchCountChanged: {
            if (instrumentClusterWindowLoader.active) {
                instrumentClusterWindowLoader.item.nextApplicationICWindow();
            }
        }
    }

    readonly property CenterConsoleWindow centerConsoleWindow: CenterConsoleWindow {
        store: root.store
    }

    readonly property Loader instrumentClusterWindowLoader: Loader {
        id: instrumentClusterWindowLoader

        sourceComponent: Component {
            InstrumentClusterWindow {
                applicationModel: root.store.applicationModel
                clusterStore: root.store.clusterStore
                performanceOverlayVisible: root.store.systemStore.instrumentClusterPerfOverlayEnabled
                Component.onCompleted: root.store.updateThemeRequested(root.store.uiSettings.theme)
            }
        }
        active: !root.store.runningOnSingleScreenEmbedded && root.store.clusterStore.showCluster
    }
}
