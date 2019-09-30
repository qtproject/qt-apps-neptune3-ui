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
import QtApplicationManager.SystemUI 2.0
import shared.utils 1.0

import "../helper/utils.js" as Utils

Store {
    id: root

    // Whether the Center Console UI should be shown "upside down" relative to its natural window orientation
    property bool inverted: false

    // Required input: width and height of the Center Console window
    property real windowWidth
    property real windowHeight

    readonly property string title: "Neptune 3 UI - Center Console"

    readonly property int orientation: {
        var value = Utils.orientationFromString(ApplicationManager.systemProperties.orientation);
        return inverted ? Utils.invertOrientation(value) : value;
    }

    readonly property real rotation: Utils.rotateDisplay(orientation, isLandscape)
    readonly property bool isLandscape: windowWidth > windowHeight
    readonly property real smallerDimension: isLandscape ? windowHeight : windowWidth
    readonly property real largerDimension: isLandscape ? windowWidth : windowHeight
    readonly property real availableAspectRatio: availableWidth / availableHeight
    readonly property real availableWidth: orientationIsSomePortrait ? smallerDimension : largerDimension
    readonly property real availableHeight: orientationIsSomePortrait ? largerDimension : smallerDimension
    readonly property bool orientationIsSomePortrait: orientation === Qt.PortraitOrientation
                                                   || orientation === Qt.InvertedPortraitOrientation

    readonly property var centerConsoleScreen: Qt.application.screens[0]

    readonly property bool runningOnDesktop: WindowManager.runningOnDesktop
    readonly property bool adjustSizesForScreen: {
        ApplicationManager.systemProperties.adjustSizesForScreen
    }
    property int desktopWidth
    property int desktopHeight

    onCenterConsoleScreenChanged: {
        if (!adjustSizesForScreen) {
            desktopWidth = Config.centerConsoleWidth;
            desktopHeight = Config.centerConsoleHeight;
        } else {
            var tempHeight = Math.ceil(centerConsoleScreen.height * 0.9);
            desktopHeight = tempHeight > Config.centerConsoleHeight
                    ? Config.centerConsoleHeight
                    : tempHeight;
            desktopWidth = Math.ceil(desktopHeight * Config.centerConsoleAspectRatio);
        }
    }
}
