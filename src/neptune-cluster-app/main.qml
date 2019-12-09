/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
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

import QtQuick 2.12
import QtQuick.Window 2.12

import shared.Style 1.0
import shared.Sizes 1.0
import "../apps/com.theqtcompany.cluster/stores" 1.0
import "../apps/com.theqtcompany.cluster/views" 1.0

Window {
    id: root
    visible: true
    width: 1920
    height: 1080
    title: qsTr("Cluster")
    color: "black"


    readonly property real scaleRatio: Math.min(root.width / 1920, root.height / 1080)
    onScaleRatioChanged: {
        root.Sizes.scale = scaleRatio
    }

    Component.onCompleted: {
        root.Style.theme = Style.Dark;
    }

    ClusterRootStore {
        id:clrst
        devMode: true
    }

    Connections {
        target: clrst.uiSettings
        onThemeChanged: root.Style.theme = clrst.uiSettings.theme
        onAccentColorChanged: root.Style.accentColor = clrst.uiSettings.accentColor
    }

    MockedWindows {
        clip: true
        id: mockedWindows
        width: height * (1920 / 720)
        height: Sizes.dp(720)
        anchors.centerIn: parent

        ClusterView {
            rtlMode: clrst.uiSettings.rtlMode
            anchors.fill: parent
            store: clrst;
        }

        Image {
            z: -1
            anchors.fill: parent
            source: Style.image("instrument-cluster-bg")
            fillMode: Image.Stretch
        }
    }

    Launcher {
        id:lnch
        z: 2
        anchors.top: mockedWindows.top
        anchors.horizontalCenter: mockedWindows.horizontalCenter
        onAppClicked: mockedWindows.runApp(appUrl)
    }
}
