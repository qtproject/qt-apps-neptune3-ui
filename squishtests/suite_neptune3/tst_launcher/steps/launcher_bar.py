# -*- coding: utf-8 -*-

############################################################################
##
## Copyright (C) 2019 Luxoft Sweden AB
## Copyright (C) 2018 Pelagicore AG
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
#############################################################################

import common.app as app  # find id, get context
import common.settings as settings  # settings
import common.qml_names as qml

import names
import __builtin__


@OnFeatureStart
def hook(context):
    start_neptune_ui_app_w_focus("console")


@Given("the launcher bar is shown")
def step(context):
    test.compare(waitForObjectExists(names.neptune_3_UI_Center_Console_launcherCenterConsole_Launcher).enabled
                 , True, "launcher bar exists")
    test.compare(waitForObjectExists(names.neptune_3_UI_Center_Console_launcherCenterConsole_Launcher).visible
                 , True, "launcher bar is visible")


@Then("the grid should be '|word|'")
def step(context, string_open):
    open_status = string_open == 'opened'
    test.compare(waitForObjectExists(names.neptune_3_UI_Center_Console_editableLauncher_EditableGridView).gridOpen
                 , open_status
                 , "open status shall be open" if open_status else "open status shall be closed")


@When("the launcher icon '|word|' is tapped")
def step(context, app_name):
    found, app_idname = app.get_app_id(app_name)

    if found:
        object_name = qml.grid_delegate + app_idname
        grid_view = waitForObject(names.neptune_UI_Center_Console_grid_GridView)

        object_pointer = find_object_name_recursively(grid_view, object_name, 3)

        if object_pointer is not None:
            if object_pointer.visible:
                pass
                squish.tapObject(object_pointer)


@When("grid item '|word|' is tabbed and move index '|integer|' up and '|integer|' right")
def step(context, app_name, delta_up, delta_right):
    if not context.userData:
        context.userData = {}

    found, app_idname = app.get_app_id(app_name)

    if found:
        object_name = qml.grid_delegate + app_idname
        grid_view = waitForObject(names.neptune_UI_Center_Console_grid_GridView)

        object_pointer = find_object_name_recursively(grid_view, object_name, 3)

        if object_pointer is not None:
            if object_pointer.visible:
                grid_index = object_pointer.visualIndex

                grid_width = __builtin__.int(object_pointer.width)
                grid_height = __builtin__.int(object_pointer.height)

                # 0.8 is because of better grab/press of a tile
                delta_int_up = __builtin__.int(delta_up) * 0.8
                delta_int_right = __builtin__.int(delta_right) * 0.8

                test.log("found '" + app_idname + "' at index: " + str(grid_index))
                test.log("is landscape" if settings.SCREEN_LANDSCAPE else "is not landscape")
                app_index_string = 'launcher_grid_visible_"' + app_name + '_index'
                context.userData[app_index_string] = grid_index

                mid_x = __builtin__.int(grid_width * 0.5)
                mid_y = __builtin__.int(grid_height * 0.5)
                mousePress(object_pointer, mid_x, mid_y, MouseButton.LeftButton)

                _good, sp = get_position_item(object_pointer)
                test.log("Midth of it   : " + str(sp.x) + "," + str(sp.y))

                # wait for long press
                snooze(3.5)

                # in real coordinates, up right is different
                coord_move_up = __builtin__.int(grid_height * delta_int_up)  # coord_up_px(grid_height * delta_int_up)
                coord_move_right = __builtin__.int(grid_width * delta_int_right)  # coord_right_px(grid_width * delta_int_right)
                #coord_move = coord_addQPoints(coord_move_up,coord_move_right)

                #test.log("coord up   : " + str(coord_move_up.x) + "," +str(-coord_move_up.y))
                #test.log("coord right: " + str(coord_move_right.x) + "," +str(-coord_move_right.y))

                # sorry, squish has a very uncommon coordinate system

                mouseMove(object_pointer, -coord_move_right, coord_move_up)

                #test.log("coord: " + str(-coord_move.x) + "," + str(-coord_move.y))

                mouseRelease(object_pointer)
                snooze(5)
            else:
                test.fail("'" + object_name + "' found but not visible!")
        else:
            test.log("could not find object '" + object_name + "' in grid!!!")
    else:
        test.fail("that app is not known")


@When("the '|word|' app index has increased by '|integer|'")
def step(context, app_name, index_diff):
    if not context.userData:
        context.userData = {}
    found, app_idname = app.get_app_id(app_name)

    if found:
        object_name = qml.grid_delegate + app_idname
        grid_view = waitForObject(names.neptune_UI_Center_Console_grid_GridView)

        object_pointer = find_object_name_recursively(grid_view, object_name, 3)

        if object_pointer:
            app_index_string = 'launcher_grid_visible_"' + app_name + '_index'
            old_index = context.userData[app_index_string]
            ## if
            new_index = object_pointer.visualIndex
            test.compare(new_index, old_index + index_diff, "index from '"
                         + app_name + "' should change by "
                         + str(index_diff) + " from " + str(old_index)
                         + " to " + str(old_index + index_diff)
                         + ", it is " + str(new_index))
        else:
            test.fail("'" + app_name + "' app is known but could not be found!")
    else:
        test.fail("'" + app_name + "' app is not known!")


@Given("memorize visible launchers index")
def step(context):
    if not context.userData:
        context.userData = {}

    # search in grid
    grid_view = waitForObject(names.neptune_UI_Center_Console_grid_GridView)

    for name, value in settings.G_NAME_ID:
        object_name = qml.grid_delegate + value

        check_app = find_object_name_recursively(grid_view, object_name, 3)
        if check_app is not None:
            found_idx = check_app.visualIndex
            app_index_string = 'launcher_grid_visible_"' + name + '_index'
            context.userData[app_index_string] = found_idx


@Then("visible launcher of '|word|' should have changed to index '|integer|'")
def step(context, app_name, index):
    if not context.userData:
        context.userData = {}

    app_index_string = 'launcher_grid_visible_"' + app_name + '_index'
    app_idx = context.userData[app_index_string]

    # search in grid
    grid_view = waitForObject(names.neptune_UI_Center_Console_grid_GridView)

    found, app_idname = app.get_app_id(app_name)
    object_name = qml.grid_delegate + app_idname
    if found:
        check_app = find_object_name_recursively(grid_view, object_name, 3)
        if check_app is not None:
            found_idx = check_app.visualIndex
            test.compare(found_idx, index, "shall have same index, had " + str(app_idx) + ".")
    else:
        test.fail("'" + app_idname + "' not found!!")
