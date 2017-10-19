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

pragma Singleton
import QtQuick 2.0
import QtApplicationManager 1.0

QtObject {
    id: root

    property string defaultMusicApp: "com.pelagicore.music"
    property var musicProvider: musicControl

    property var currentTrack: musicProvider.currentTrack
    property bool playing: musicProvider.playing
    property string currentTime: musicProvider.currentTime
    property string durationTime: musicProvider.durationTime

    property QtObject musicControl: ApplicationIPCInterface {

        property var currentTrack: {}
        property string currentTime: "00:00"
        property string durationTime: "00:00"
        property bool playing: false

        signal previous()
        signal next()
        signal play()
        signal pause()

        Component.onCompleted: {
            ApplicationIPCManager.registerInterface(musicControl, "com.pelagicore.music.control", {})
        }
    }

    function play() {
        musicProvider.play()
    }

    function pause() {
        musicProvider.pause()
    }

    function togglePlay() {
        if (playing) {
            pause()
        } else {
            play()
        }
    }

    function nextTrack() {
        if (root.musicProvider)
            root.musicProvider.next()
    }

    function previousTrack() {
        if (root.musicProvider)
            root.musicProvider.previous()
    }

    function startMusicApp() {
        ApplicationManager.startApplication(root.defaultMusicApp)
    }
}
