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

import shared.com.pelagicore.styles.neptune 3.0
import shared.com.pelagicore.translation 1.0

QtObject {
    id: root

    readonly property int instrumentClusterWidth: 1920
    readonly property int instrumentClusterHeight: 1080
    readonly property real instrumentClusterUIAspectRatio: 1920 / 720

    readonly property int centerConsoleWidth: 1080
    readonly property int centerConsoleHeight: 1920
    readonly property real centerConsoleAspectRatio: centerConsoleWidth / centerConsoleHeight

    readonly property real fontWeight: Font.Light
    readonly property real statusBarHeight: 80
    readonly property real launcherHeight: 104

    readonly property string assetPath: Qt.resolvedUrl("../../assets/")
    readonly property url symbolUrl: Qt.resolvedUrl(root.assetPath + 'icons')
    readonly property url gfxUrl: Qt.resolvedUrl(root.assetPath + 'gfx/')

    property alias languageLocale: translation.languageLocale
    readonly property var translation: Translation {
        id: translation
        Component.onCompleted: {
            translation.setPath(root.assetPath + "translations/");
            languageLocale = Qt.locale().name;
        }
    }

    function symbol(name, theme) {
        var themeStr = theme === NeptuneStyle.Dark ? "-dark" : "";
        return symbolUrl + '/' + name + themeStr + '.png';
    }

    function gfx(name, theme) {
        var themeStr = theme === NeptuneStyle.Dark ? "-dark" : "";
        return gfxUrl + name + themeStr + '.png'
    }

    function icon(name) {
        return drawableUrl + '/' + name + '.png';
    }
}
