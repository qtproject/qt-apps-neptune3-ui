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

pragma Singleton
import QtQuick 2.6

import shared.Style 1.0
import shared.com.pelagicore.translation 1.0

QtObject {
    id: root

    readonly property int instrumentClusterWidth: 1920
    readonly property int instrumentClusterHeight: 1080
    readonly property real instrumentClusterUIAspectRatio: 1920 / 720

    readonly property int bottomBarHeight: 120
    readonly property int centerConsoleWidth: 1080
    readonly property int centerConsoleHeight: 1920
    readonly property real centerConsoleAspectRatio: centerConsoleWidth / centerConsoleHeight

    readonly property int hudWidth: 480
    readonly property int hudHeight: 240
    readonly property real hudAspectRatio: hudWidth / hudHeight

    readonly property real statusBarHeight: 80
    readonly property real launcherHeight: 104

    readonly property string assetPath: Qt.resolvedUrl("../../assets/")

    property bool rtlMode: false
    property bool showCursorSpots: false

    //The Cursor loader source
    property bool enableCursorManagement: false
    onEnableCursorManagementChanged: {
        if (enableCursorManagement) {
            cursorLoader.source = Qt.resolvedUrl("./CursorManagement.qml");
        } else {
            cursorLoader.source = Qt.resolvedUrl("./CursorManagementDummy.qml");
        }
        root.cursorLoaderSource = cursorLoader.source;
    }
    property int cursorAngleOffset: 0
    property string cursorLoaderSource: ""
    //"Guinea pig" loader.This is to prevent the endless warnings for
    //CursorNavigation plugin not installed when this is not available. Here is
    //loaded once on start up and the "healthy" files' source is saved and
    //maintained during the complete session in the cursorLoaderSource property.
    property Loader cursorLoader: Loader {
        //if cursor support in center console is enabled, try loading CursorManagement.qml
        source: root.enableCursorManagement ? Qt.resolvedUrl("./CursorManagement.qml")
                : Qt.resolvedUrl("./CursorManagementDummy.qml")
        onStatusChanged: {
        //if cursor plugin is not available load CursorManagementDummy.qml
            if (status === Loader.Error) {
                source = Qt.resolvedUrl("./CursorManagementDummy.qml");
                console.warn("The cursor management plugin is not installed,
                thus no cursor support will be available on this instance.");
                console.warn("For more details and installation visit:
                https://codereview.qt-project.org/admin/repos/qt-labs/cursormanagement");
            }
        }
        Component.onCompleted: {
            root.cursorLoaderSource = cursorLoader.source;
        }
    }

    property alias languageLocale: translation.languageLocale
    readonly property var translation: Translation {
        id: translation
        path: root.assetPath + "translations/"
        Component.onCompleted: {
            Qt.callLater( function() { //not to have binding loop warning "QML ApplicationModel: Binding loop detected for property "localeCode"
                languageLocale = Qt.locale().name;
            })
        }
    }

    function _initAccentColors(value) {
        var arrDark = [{ color: "#b75034", value: 5, selected: false },
                       { color: "#916755", value: 5, selected: false },
                       { color: "#977b35", value: 5, selected: false },
                       { color: "#698563", value: 5, selected: false },
                       { color: "#087559", value: 5, selected: false },
                       { color: "#4c878b", value: 5, selected: false },
                       { color: "#417eb6", value: 5, selected: false },
                       { color: "#4f4c4a", value: 5, selected: false }
                ]

        var arrLight = [{ color: "#d35756", value: 5, selected: false },
                        { color: "#fba054", value: 5, selected: false },
                        { color: "#9eae83", value: 5, selected: false },
                        { color: "#78887b", value: 5, selected: false },
                        { color: "#7ba2a5", value: 5, selected: false },
                        { color: "#51a7f4", value: 5, selected: false },
                        { color: "#535258", value: 5, selected: false },
                        { color: "#db3b9f", value: 5, selected: false }
                ]

        return (value === 1) ? arrDark : arrLight;
    }
}
