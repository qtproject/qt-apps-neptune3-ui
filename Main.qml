/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Triton IVI UI.
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

import animations 1.0
import com.pelagicore.styles.triton 1.0
import display 1.0
import utils 1.0

import QtQuick.Window 2.3

import QtApplicationManager 1.0

Window {
    id: root

    width: Style.screenWidth
    height: Style.screenHeight

    title: "Triton UI - Center Console"

    readonly property bool isLandscape: width > height
    readonly property real smallerDimension: isLandscape ? height : width
    readonly property real largerDimension: isLandscape ? width : height

    Display {
        id: display
        width: orientationIsSomePortrait ? root.smallerDimension : root.largerDimension
        height: orientationIsSomePortrait ? root.largerDimension : root.smallerDimension

        readonly property bool orientationIsSomePortrait: orientation === Qt.PortraitOrientation
                                                       || orientation === Qt.InvertedPortraitOrientation

        property int orientation: root.orientationFromString(ApplicationManager.systemProperties.orientation)

        // have the center of Display and root match
        x: (root.width - width) / 2
        y: (root.height - height) / 2

        rotation: {
            if (root.isLandscape) {
                switch (orientation) {
                    case Qt.PortraitOrientation:
                        return 90;
                    case Qt.LandscapeOrientation:
                        return 0;
                    case Qt.InvertedPortraitOrientation:
                        return -90;
                    case Qt.InvertedLandscapeOrientation:
                        return 180;
                    default:
                        return 0;
                }
            } else {
                switch (orientation) {
                    case Qt.PortraitOrientation:
                        return 0;
                    case Qt.LandscapeOrientation:
                        return -90;
                    case Qt.InvertedPortraitOrientation:
                        return 180;
                    case Qt.InvertedLandscapeOrientation:
                        return 90;
                    default:
                        return 0;
                }
            }
        }

        popupParent: popupParent

        focus: true
        Shortcut {
            sequence: "t"
            onActivated: {
                // TODO: Also change the instrument cluster theme
                root.contentItem.TritonStyle.theme = root.contentItem.TritonStyle.theme == TritonStyle.Light
                        ? TritonStyle.Dark : TritonStyle.Light
            }
        }

    }

    // We can't use Popup from QtQuick.Controls as it doesn't support a rotated scene,
    // hence the implementation of our own modal overlay scheme
    Item {
        id: popupParent
        anchors.fill: display
        rotation: display.rotation

        property bool showModalOverlay
        signal overlayClicked()

        // TODO: Load only when needed
        MouseArea {
            anchors.fill: parent
            visible: opacity > 0
            opacity: popupParent.showModalOverlay ? 1 : 0
            Behavior on opacity { DefaultNumberAnimation {}  }
            Image {
                anchors.fill: parent
                source: Style.gfx2(Style.displayBackground)
                FastBlur {
                    anchors.fill: parent
                    radius: Style.hspan(1)
                    source: display
                }
            }
            z: -1
            onClicked: popupParent.overlayClicked()
        }
    }

    Binding { target: Style; property: "cellWidth"; value: display.width / 24 }
    Binding { target: Style; property: "cellHeight"; value: display.height / 24 }

    function orientationFromString(str) {
        str = str.trim().toLowerCase().replace('-','').replace('_','').replace('orientation','')

        if (str === "portrait") {
            return Qt.PortraitOrientation;
        } else if (str === "invertedportrait") {
            return Qt.InvertedPortraitOrientation;
        } else if (str === "landscape") {
            return Qt.LandscapeOrientation;
        } else if (str === "invertedlandscape") {
            return Qt.InvertedLandscapeOrientation;
        } else {
            // default to portrait
            return Qt.PortraitOrientation;
        }
    }

    Window {
        id: instrumentClusterWindow
        width: Style.instrumentClusterWidth
        height: Style.instrumentClusterHeight
        title: "Triton UI - Instrument Cluster"

        Component.onCompleted: {
            WindowManager.registerCompositorView(instrumentClusterWindow)
        }

        property var window: display.applicationModel.instrumentClusterAppInfo
                ? display.applicationModel.instrumentClusterAppInfo.window : null

        Binding {
            target: instrumentClusterWindow.window; property: "width"; value: instrumentClusterWindow.width
        }
        Binding {
            target: instrumentClusterWindow.window; property: "height"; value: instrumentClusterWindow.height
        }
        Binding {
            target: instrumentClusterWindow.window; property: "parent"; value: instrumentClusterWindow.contentItem
        }

        // lazy way of putting the instrument cluster in a separate screen, if available
        screen: Qt.application.screens[Qt.application.screens.length - 1]

        visible: (window != null) && ApplicationManager.systemProperties.showCluster
    }
}
