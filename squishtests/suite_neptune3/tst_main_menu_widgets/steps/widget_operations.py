# -*- coding: utf-8 -*-

############################################################################
##
## Copyright (C) 2018 Luxoft GmbH
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
## For further information use the contact form at
## https://www.qt.io/contact-us.
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
#############################################################################


import common.settings as settings
import common.app as app
import common.qml_names as qml

# squish dependent
import names


@OnFeatureStart
def hook(context):
    start_neptune_ui_app_w_focus("console")


def find_homeWidgetGrid_app(app_name):
    """helper function"""
    good = False
    result = None

    found, app_idname = app.get_app_id(app_name)

    if found:
        object_name = qml.home_widget + app_idname
        grid_view = waitForObject(
            names.neptune_3_UI_Center_Console_widgetGrid_homepage_WidgetGrid)

        grid_entry = find_object_name_recursively(grid_view, object_name, 3)

        if grid_entry is not None:
            good = True
            result = grid_entry
    return good, (result, app_idname)


@Then("add widget was tapped")
def step(context):
    tapObject(waitForObject(names.neptune_3_UI_Center_Console_addWidgetButton_ToolButton))


@Then("the new widget dialogue appeared")
def step(context):
    test.compare(waitForObjectExists(names.neptune_3_UI_Center_Console_addWidgetPopupItem_AddWidgetPopup).enabled, True)
    test.compare(waitForObjectExists(names.neptune_3_UI_Center_Console_addWidgetPopupItem_AddWidgetPopup).visible, True)


@Then("the add widget popup should not be there after '|integer|' seconds of closing animation")
def step(context, seconds):
    snooze(seconds)
    addWidget_popup = names.neptune_3_UI_Center_Console_addWidgetPopupItem_AddWidgetPopup
    # test.compare(volume_popup.exists) something funny??
    try:
        waitForObjectExists(addWidget_popup, settings.G_WAIT_FOR_INEXISTANCE_MS)
    except Exception:
        test.compare(True, True, "add widget popup closed!")
    else:
        test.compare(True, False, "add widget popup is still there!")


@Then("the '|word|' widget is visible in the home screen")
def step(context, app_name):
    good, result = find_homeWidgetGrid_app(app_name)
    if good:
        widget, _id = result
        test.compare(widget.enabled, True)
        test.compare(widget.visible, True)
    else:
        test.fail("grid widget item of '" + app_name + "' not found!")


@When("add map is tapped")
def step(context):
    addWidgetItem_maps = waitForObject(names.widgetList_AddWidgets_Maps)
    tapObject(addWidgetItem_maps)


@Then("tapping close '|word|' widget")
def step(context, app_name):
    # update context, because map is now if not before loaded
    squish.snooze(1)
    app.update_all_contexts()

    # must switch to main_app
    app.switch_to_main_app()

    found, result = find_homeWidgetGrid_app(app_name)
    if found:
        grid_entry, app_idname = result
        close_name = qml.app_widget_close + app_idname
        close_obj = find_object_name_recursively(grid_entry, close_name, 3)

        if close_obj is not None and close_obj.visible:
            tapObject(close_obj)


@Then("the '|word|' widget disappeared in the home screen after '|integer|' seconds of animation")
def step(context, app_name, seconds):
    squish.snooze(seconds)
    found, result = find_homeWidgetGrid_app(app_name)
    if found:
        grid_entry, _id = result
        try:
            is_enabled = grid_entry.enabled
            is_visible = grid_entry.visible
        except Exception as e:
            test.fail("Something strange with the grid object: " + str(e))
        else:
            test.compare(False, not is_enabled or not is_visible,
                         "'" + app_name + "' widget not enabled or visible!")
    else:
        test.compare(True, True,
                     "'" + app_name + "' widget closed!")
