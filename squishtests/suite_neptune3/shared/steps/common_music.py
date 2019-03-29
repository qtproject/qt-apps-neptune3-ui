# -*- coding: utf-8 -*-

############################################################################
##
## Copyright (C) 2019 Luxoft Sweden AB
## Contact: https://www.qt.io/licensing/
##
## This file is part of the Neptune 3 IVI UI.
##
## $QT_BEGIN_LICENSE:GPL-QTAS$
## Commercial License Usage
## Licensees holding valid commercial Qt Automotive Suite licenses may use
## this file in accordance with the commercial license agreement provided
## with the Software or, alternatively, in accordance with the terms
## contained in a written agreement between you and The Qt Company.  For
## licensing terms and conditions see https://www.qt.io/terms-conditions.
## For further information use the contact form at https://www.qt.io/contact-us.
##
## GNU General Public License Usage
## Alternatively, this file may be used under the terms of the GNU
## General Public License version 3 or (at your option) any later version
## approved by the KDE Free Qt Foundation. The licenses are as published by
## the Free Software Foundation and appearing in the file LICENSE.GPL3
## included in the packaging of this file. Please review the following
## information to ensure the GNU General Public License requirements will
## be met: https://www.gnu.org/licenses/gpl-3.0.html.
##
## $QT_END_LICENSE$
##
## SPDX-License-Identifier: GPL-3.0
##
############################################################################

# squish dependent
import names
import common.app as app


@Given("tap music widget '|word|' button, '|integer|' time(s)")
def step(context, button_name, number_taps):
    ui_buttons = {
                   'next': names.musicSongNext_ToolButton,
                   'previous': names.musicSongPrevious_ToolButton,
                   'play': names.musicSongPlayPause_ToolButton,
                   'pause': names.musicSongPlayPause_ToolButton,
                   'repeat': names.repeatMusicButton_ToolButton,
                   'shuffle': names.shuffleMusicButton_ToolButton
                   }

    if button_name not in ui_buttons.keys():
        app.fail("The music button '" + button_name + "' is not known!")
        return

    app.switch_to_app('music')
    for _i in range(number_taps):
        squish.snooze(0.25)
        squish.tapObject(ui_buttons[button_name])


@Given("remember current playlist")
def step(context):
    if not context.userData:
        context.userData = {}
    # yes, only in music context
    app.switch_to_app('music')

    ui_info_playlist = squish.waitForObject(names.musicAppContent_MusicView)
    ui_info_element = squish.waitForObject(names.musicPlayer)

    play_current_index = ui_info_element.currentIndex
    playlist_music_count = ui_info_playlist.store.musicCount

    context.userData['index'] = play_current_index
    context.userData['count'] = playlist_music_count


@Then("the '|integer|' distance song will be displayed")
def step(context, distance_index):
    if not context.userData:
        context.userData = {}

    old_index = context.userData['index']
    count = context.userData['count']

    # switch context
    app.switch_to_app('music')
    ui_info_element = squish.waitForObject(names.musicPlayer)

    play_current_index = ui_info_element.currentIndex
    app.compare((old_index + distance_index) % count,
                  play_current_index,
                  "index should be according song skipping")
