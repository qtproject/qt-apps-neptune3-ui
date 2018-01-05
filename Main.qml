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
import instrumentcluster 1.0
import com.pelagicore.settings 1.0

import QtQuick.Window 2.3

import QtApplicationManager 1.0

Window {
    id: root

    title: "Triton UI - Center Console"
    color: Style.colorBlack

    readonly property bool isLandscape: width > height
    readonly property real smallerDimension: isLandscape ? height : width
    readonly property real largerDimension: isLandscape ? width : height

    Display {
        id: display
        width: orientationIsSomePortrait ? root.smallerDimension : root.largerDimension
        height: orientationIsSomePortrait ? root.largerDimension : root.smallerDimension

        readonly property bool orientationIsSomePortrait: orientation === Qt.PortraitOrientation
                                                       || orientation === Qt.InvertedPortraitOrientation

        property int orientation: {
            var value = root.orientationFromString(ApplicationManager.systemProperties.orientation);
            return invertedOrientation ? root.invertOrientation(value) : value;
        }
        property bool invertedOrientation: false

        anchors.centerIn: parent

        settings: uiSettings

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

        UISettings {
            id: uiSettings
            onLanguageChanged: {
                if (language !== Style.languageLocale) {
                    Style.languageLocale = language;
                }
            }
            onThemeChanged: updateTheme()
            Component.onCompleted: updateTheme()
            function updateTheme() {
                var chosenTheme = theme === 0 ? TritonStyle.Light : TritonStyle.Dark;
                root.contentItem.TritonStyle.theme = chosenTheme;
                if (instrumentClusterWindowLoader.item) {
                    instrumentClusterWindowLoader.item.contentItem.TritonStyle.theme = chosenTheme;
                }
            }
        }

        // N.B. need to use a Timer here to "push" the available languages to settings server
        // since it uses QMetaObject::invokeMethod(), possibly running in a different thread
        Timer {
            id: timer
            interval: 100
            onTriggered: uiSettings.languages = Style.translation.availableTranslations;
        }

        Component.onCompleted: {
            timer.start();
        }

        Shortcut {
            sequence: "Ctrl+r"
            context: Qt.ApplicationShortcut
            onActivated: {
                display.invertedOrientation = !display.invertedOrientation
            }
        }
        Shortcut {
            sequence: "Ctrl+t"
            context: Qt.ApplicationShortcut
            onActivated: {
                uiSettings.theme = uiSettings.theme === 0 ? 1 : 0
            }
        }
        Shortcut {
            sequence: "Ctrl+l"
            context: Qt.ApplicationShortcut
            onActivated: {
                const locales = Style.translation.availableTranslations;
                const currentLocale = Style.languageLocale;
                const currentIndex = locales.indexOf(currentLocale);
                var nextIndex = currentIndex === locales.length - 1 ? 0 : currentIndex + 1;
                Style.languageLocale = locales[nextIndex];
            }
        }

        Connections {
            target: WindowManager
            onWindowPropertyChanged: {
                if (name === "requestedLanguage") {
                    Style.languageLocale = value;
                }
            }
        }

        Shortcut {
            sequence: "Ctrl+c"
            context: Qt.ApplicationShortcut
            onActivated: {
                if (instrumentClusterWindowLoader.item)
                    instrumentClusterWindowLoader.item.nextSecondaryWindow();
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
                source: Style.gfx2(TritonStyle.backgroundImage)
                FastBlur {
                    anchors.fill: parent
                    radius: Style.hspan(1)
                    source: display
                }
            }
            z: -2
            onClicked: popupParent.overlayClicked()
        }

        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: popupParent.showModalOverlay ? 0.3 : 0
            Behavior on opacity { DefaultNumberAnimation {}  }
            z: -1
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

    function invertOrientation(orientation) {
        switch (orientation) {
            case Qt.PortraitOrientation:
                return Qt.InvertedPortraitOrientation;
            case Qt.InvertedPortraitOrientation:
                return Qt.PortraitOrientation;
            case Qt.LandscapeOrientation:
                return Qt.InvertedLandscapeOrientation;
            case Qt.InvertedLandscapeOrientation:
                return Qt.LandscapeOrientation;
            default:
                return orientation;
        }
    }

    Loader {
        id: instrumentClusterWindowLoader
        sourceComponent: Component {
            InstrumentClusterWindow {
                applicationModel: display.applicationModel
                Component.onCompleted: uiSettings.updateTheme()
            }
        }

        readonly property bool runningOnSingleScreenEmbedded: !WindowManager.runningOnDesktop
                                                       && (Qt.application.screens.length === 1)

        active: !runningOnSingleScreenEmbedded
    }

    Component.onCompleted: {
        // Don't use bindings for setting up the initial size. Otherwise the binding is revaluated
        // on every language change, which results in resetting the window size to it's initial state
        // and might overwrite the size given by the OS or the user using the WindowManager
        width = Style.screenWidth
        height = Style.screenHeight
    }
}
