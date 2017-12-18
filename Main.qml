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

        anchors.centerIn: parent

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
            onThemeChanged: root.contentItem.TritonStyle.theme = theme == 0
                            ? TritonStyle.Light : TritonStyle.Dark
        }

        // N.B. need to use a Timer here to "push" the available languages to settings server
        // since it uses QMetaObject::invokeMethod(), possibly running in a different thread
        Timer {
            interval: 1
            running: true
            repeat: false
            onTriggered: {
                uiSettings.languages = Style.translation.availableTranslations;
            }
        }

        Shortcut {
            sequence: "t"
            context: Qt.ApplicationShortcut
            onActivated: {
                // TODO: Also change the instrument cluster theme
                root.contentItem.TritonStyle.theme = root.contentItem.TritonStyle.theme == TritonStyle.Light
                        ? TritonStyle.Dark : TritonStyle.Light
                uiSettings.theme =
                        root.contentItem.TritonStyle.theme == TritonStyle.Light ?
                            0 : 1
            }
        }
        Shortcut {
            sequence: "l"
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
            sequence: "c"
            context: Qt.ApplicationShortcut
            onActivated: {
                instrumentClusterWindow.nextSecondaryWindow();
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

    InstrumentClusterWindow {
        id: instrumentClusterWindow
        applicationModel: display.applicationModel
    }
}
