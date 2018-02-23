/****************************************************************************
**
** Copyright (C) 2017, 2018 Pelagicore AG
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

pragma Singleton
import QtQuick 2.6

import com.pelagicore.styles.triton 1.0
import com.pelagicore.translation 1.0
import com.pelagicore.settings 1.0

QtObject {
    id: root

    property int paddingXL: 16

    property int instrumentClusterWidth: 1920
    property int instrumentClusterHeight: 1080
    property real instrumentClusterUIAspectRatio: 1920 / 720
    property int cellWidth
    property int cellHeight
    property real fontWeight: Font.Light
    property int fontSizeXS: TritonStyle.fontSizeXS
    property int fontSizeS: TritonStyle.fontSizeS
    property int fontSizeM: TritonStyle.fontSizeM
    property int fontSizeL: TritonStyle.fontSizeL
    property int fontSizeXL: TritonStyle.fontSizeXL
    property int fontSizeXXL: TritonStyle.fontSizeXXL

    //StatusBar config
    property real statusBarHeight: vspan(1)

    property real launcherWidth: hspan(20)
    property real launcherHeight: vspan(1.3)

    property string assetPath: Qt.resolvedUrl("../../assets/")
    property url drawableUrl: Qt.resolvedUrl(root.assetPath + 'drawable-ldpi')
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
        var themeStr = theme === TritonStyle.Dark ? "-dark" : "";
        return symbolUrl + '/' + name + themeStr + '.png';
    }

    function gfx2(name, theme) {
        var themeStr = theme === TritonStyle.Dark ? "-dark" : "";
        return gfxUrl + name + themeStr + '.png'
    }

    function gfx2Dynamic(name, size) {
        return gfxUrl + name + '@' + size + 'x.png'
    }

    function icon(name) {
        return drawableUrl + '/' + name + '.png';
    }

    function gfx(name) {
        return drawableUrl + '/' + name + '.png';
    }

    function hspan(value) {
        return Math.round(cellWidth * value)
    }

    function vspan(value) {
        return Math.round(cellHeight * value)
    }

    function asset(name) {
        return Qt.resolvedUrl(root.assetPath + name)
    }
}
