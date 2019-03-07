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
import common.qml_names as qml


# number of themes, currently only light/dark
NR_THEMES = 2


@OnFeatureStart
def hook(context):
    start_neptune_ui_app_w_focus("console")


@Given("tap '|word|' button")
def step(context, view_name):
    app.switch_to_app('settings')
    squish.snooze(0.2)
    if view_name == "language":
        view_object_name = names.languageViewButton_ToolButton
    elif view_name == "date":
        view_object_name = names.dateViewButton_ToolButton
    elif view_name == "themes":
        view_object_name = names.themesViewButton_ToolButton
    else:  # view_name == "color":
        view_object_name = names.colorsViewButton_ToolButton

    events_button = squish.waitForObject(view_object_name)
    squish.tapObject(events_button)


@Then("settings view '|word|' should be displayed")
def step(context, view_name):
    if view_name == "language":
        visible_object = names.languagePanel_LanguagePanel
    elif view_name == "date":
        visible_object = names.datePanel_DateTimePanel
    elif view_name == "themes":
        visible_object = names.themesPanel_ThemesPanel
    else:  # color
        visible_object = names.colorsPanel_ColorsPanel
    test_object = squish.waitForObject(visible_object)
    test.compare(test_object.visible, True, "settings views")


@When("remember date format and tap date switch")
def step(context):
    if not context.userData:
        context.userData = {}

    squish.snooze(0.25)
    app.switch_to_main_app()
    date_object = squish.waitForObject(names.dateAndTime)
    test_text = str(date_object.text)
    # cheap comparison, only text and searching for 'm'
    # whether 'am' or 'pm'
    is_24h_format = not ('m' in test_text)
    context.userData['isDateFormat24h'] = is_24h_format

    test.log("'" + test_text + "' was " + ("24h" if is_24h_format
                                            else "am/pm"))

    app.switch_to_app('settings')
    squish.snooze(0.25)
    switch = squish.waitForObject(names.dateTimeSwitch_SwitchDelegate)
    squish.tapObject(switch)


@Then("home screen should show have toggled date format")
def step(context):
    if not context.userData:
        context.userData = {}

    was_24h_format = context.userData['isDateFormat24h']
    squish.snooze(0.5)
    app.switch_to_main_app()
    squish.snooze(0.5)
    date_object = squish.waitForObject(names.dateAndTime)
    test_text = str(date_object.text)
    squish.snooze(0.5)
    app.switch_to_app('settings')
    squish.snooze(0.5)

    # search for 'm' is a cheap test, and
    # should be replaced. 'm' because 'am' and
    # 'pm' both contain 'm'
    is_now_24h_format = not ("m" in test_text)
    test.log("'" + test_text + "' is " + ("24h" if is_now_24h_format
                                           else "am/pm"))

    test.compare(was_24h_format, not is_now_24h_format, "date format")

    # switch back
    app.switch_to_main_app()


@When("tap language '|word|' button")
def step(context, language):
    squish.snooze(0.5)
    app.switch_to_app('settings')
    squish.snooze(0.5)

    test.log("1")
    language_name = qml.prefix_language + language
    language_panel = squish.waitForObject(names.languagePanel_LanguagePanel)
    language_item = find_object_name_recursively(
                                 language_panel,
                                 language_name, 5)
    if language_item is None:
        test.fail("The language abbreviation '"
                  + language + "'"
                  + ' is not known!!')
    else:
        ui_item = squish.waitForObject(language_item)
        squish.tapObject(ui_item)
        squish.snooze(1.1)


@Then("language should switch to '|word|'")
def step(context, language_abbr):
    squish.snooze(0.5)
    app.switch_to_main_app()
    squish.snooze(0.5)
    centerc_object = squish.waitForObject(names.neptune_UI_Center_Console)
    current_lang_abbr = str(centerc_object.store.uiSettings.language)
    test.compare(language_abbr, current_lang_abbr,
                 "current and wanted language abbreviation")


@When("remember current theme and tap non-selected")
def step(context, ):
    if not context.userData:
        context.userData = {}
    # store current / soon "old" theme
    theme_panel = squish.waitForObject(names.themesPanel_ThemesPanel)
    current_theme = theme_panel.currentTheme
    context.userData['old_theme'] = current_theme

    # tap on next theme
    tap_theme_index = (current_theme + 1) % NR_THEMES
    tap_theme_name = qml.prefix_themes + str(tap_theme_index)
    tap_theme_ui = find_object_name_recursively(theme_panel,
                                                tap_theme_name,
                                                5)
    if tap_theme_ui is not None:
        ui_theme = squish.waitForObject(tap_theme_ui)
        squish.tapObject(ui_theme)
    else:
        test.fail("toggle theme ui object not found!")


@Then("theme should have toggled")
def step(context):
    # get current theme
    theme_panel = squish.waitForObject(names.themesPanel_ThemesPanel)
    current_theme = theme_panel.currentTheme
    old_theme = context.userData['old_theme']
    test.compare(old_theme, (current_theme - 1) % NR_THEMES,
                   "should be the previous theme")
    # switch back to main context
    app.switch_to_main_app()
