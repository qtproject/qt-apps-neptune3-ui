# -*- coding: utf-8 -*-

############################################################################
##
## Copyright (C) 2019 Luxoft Sweden AB
## Contact: https://www.qt.io/licensing/
##
## This file is part of the Neptune 3 UI.
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

import names
import common.app as app

# commonly used
possible_view_buttons = {
    'sources': names.musicView_sources_ToolButton,
    'albums': names.musicView_albums_ToolButton,
    'artists': names.musicView_artists_ToolButton,
    'favorites': names.musicView_favorites_ToolButton
}


@OnFeatureStart
def hook(context):
    start_neptune_ui_app_w_focus("console")


@When("tap music playlist view '|word|' button")
def step(context, button_name):
    if button_name not in possible_view_buttons.keys():
        app.fail("in music view, button '"
                 + button_name
                 + "' is not known!")
        return

    app.switch_to_app('music')
    squish.snooze(0.25)
    button = squish.waitForObject(possible_view_buttons[button_name])
    squish.tapObject(button)


@Then("music list view should change to view '|any|'")
def step(context, view_name):
    if view_name not in possible_view_buttons.keys():
        app.fail("in music view, list view '"
                 + view_name
                 + "' is not known!")
        return

    app.switch_to_app('music')
    squish.snooze(0.25)
    info_ui = squish.waitForObject(names.musicToolsColumn)

    currentView = str(info_ui.currentText)
    app.compare(currentView, view_name,
                "view stored is not what is changed to")
