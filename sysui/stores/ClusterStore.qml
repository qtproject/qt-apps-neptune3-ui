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

import QtQuick 2.8
import QtQml 2.14
import QtApplicationManager.SystemUI 2.0
import shared.com.pelagicore.remotesettings 1.0
import shared.com.pelagicore.drivedata 1.0
import shared.utils 1.0

QtObject {
    id: root

    readonly property InstrumentCluster clusterSettings: InstrumentCluster { id: clusterSettings }
    readonly property string clusterTitle: "Neptune 3 UI - Instrument Cluster"
    readonly property bool showCluster: ApplicationManager.systemProperties.showCluster
    property bool clusterAvailable
    property bool invertedCluster: false
    readonly property bool qsrEnabled: ApplicationManager.systemProperties["qsrEnabled"]
    readonly property var clusterScreen: Qt.application.screens.length > 1
            ? Qt.application.screens[1] : Qt.application.screens[0]
    readonly property var _clusterAvailableBinding: Binding {
        restoreMode: Binding.RestoreBinding
        target: clusterSettings
        when: clusterSettings.isInitialized
        property: "available"
        value: root.clusterAvailable
    }
    readonly property bool runningOnDesktop: WindowManager.runningOnDesktop
    readonly property bool adjustSizesForScreen: {
        ApplicationManager.systemProperties.adjustSizesForScreen
    }
    property int desktopWidth
    property int desktopHeight

    property int clusterPosition: 1 // 0: top 1: center 2: bottom

    onClusterScreenChanged: {
        if (adjustSizesForScreen) {
            var tempWidth = Math.ceil(clusterScreen.width * 0.9);
            desktopWidth = tempWidth > Config.instrumentClusterWidth
                    ? Config.instrumentClusterWidth
                    : tempWidth;
            if (qsrEnabled) {
                // Desktop demo case: make window 20% higher than cluster panel, so qsr
                // window will not overlap cluster window title bar
                desktopHeight = Math.ceil(desktopWidth / Config.instrumentClusterUIAspectRatio
                                          * 1.2);
            } else {
                desktopHeight = Math.ceil(desktopWidth / Config.instrumentClusterUIAspectRatio);
            }
        } else {
            desktopWidth = Config.instrumentClusterWidth;
            desktopHeight = Config.instrumentClusterHeight;
        }
    }
}
