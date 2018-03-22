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

pragma Singleton
import QtQuick 2.6

import com.pelagicore.styles.neptune 3.0
import com.pelagicore.translation 1.0
import com.pelagicore.settings 1.0

QtObject {
    id: root

    property int instrumentClusterWidth: 1920
    property int instrumentClusterHeight: 1080
    property real instrumentClusterUIAspectRatio: 1920 / 720

    readonly property int centerConsoleWidth: 1080
    readonly property int centerConsoleHeight: 1920
    readonly property real centerConsoleAspectRatio: centerConsoleWidth / centerConsoleHeight

    property int cellWidth
    property int cellHeight
    property real fontWeight: Font.Light

    //StatusBar config
    property real statusBarHeight: 80

    property real launcherHeight: 104

    property string assetPath: Qt.resolvedUrl("../../assets/")
    property url symbolUrl: Qt.resolvedUrl(root.assetPath + 'icons')
    property url gfxUrl: Qt.resolvedUrl(root.assetPath + 'gfx/')

    readonly property var uiSettings: UISettings {}

    property alias languageLocale: translation.languageLocale
    readonly property var translation: Translation {
        id: translation
        Component.onCompleted: translation.setPath(root.assetPath + "translations/");
    }

    Component.onCompleted: {
        Qt.callLater(function() {
            if (uiSettings.language) {
                languageLocale = uiSettings.language;
            } else {
                languageLocale = Qt.locale().name;
            }
        });
    }

    function symbol(name, theme) {
        var themeStr = theme === NeptuneStyle.Dark ? "-dark" : "";
        return symbolUrl + '/' + name + themeStr + '.png';
    }

    function gfx2(name, theme) {
        var themeStr = theme === NeptuneStyle.Dark ? "-dark" : "";
        return gfxUrl + name + themeStr + '.png'
    }

    function icon(name) {
        return drawableUrl + '/' + name + '.png';
    }

    function hspan(value) {
        return Math.round(cellWidth * value)
    }

    function vspan(value) {
        return Math.round(cellHeight * value)
    }
}
