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
############################################################################

import common.qml_names as qml

# squish dependent
import names


@OnFeatureStart
def hook(context):
    start_neptune_ui_app_w_focus("console")


@Given("'|word|' app from launcher tapped")
def step(context, app_name):
    if not context.userData:
        context.userData = {}

    found, app_idname = app.get_app_id(app_name)

    if found:
        object_name = qml.grid_delegate + app_idname
        grid_view = waitForObject(
                               names.neptune_UI_Center_Console_grid_GridView)

        app_pointer = find_object_name_recursively(grid_view, object_name, 3)

        if app_pointer:
            if app_pointer.visible:
                tapObject(app_pointer)
            else:
                test.fail("'" + app_name + "' is there but not visible.")
        else:
            test.fail("'" + app_name + "' could not be found!")


@Then("wait '|integer|' seconds and '|word|' app is active")
def step(context, wait_sec, app_name):
    if not context.userData:
        context.userData = {}

    # MUST switch to main app
    app.switch_to_main_app()

    # wait a small while to let it open
    snooze(wait_sec)

    found, app_idname = app.get_app_id(app_name)

    if found:
        object_name = qml.current_inFrame_Application + app_idname
        active_app_slot = waitForObject(
                names.neptune_3_UI_Center_Console_activeApplicationSlot_Item)

        # 1st: look for "inFrameApplication"
        app_pointer = find_object_name_recursively(active_app_slot,
                                                   object_name, 3)
        if app_pointer is not None:
            my_numnber = app_pointer.children.count
            test.log("-_" + str(my_numnber))
            test.compare(True, app_pointer.visible, "should be visible!")
        else:
            #  2nd try: look for "application_widget"
            test.log("'" + app_idname + "' as inFrameApp not found,"
                     + " trying as applicationWidget")
            object_name = qml.application_widget + app_idname
            app_pointer = find_object_name_recursively(active_app_slot,
                                                       object_name, 3)
            if app_pointer is not None:
                test.compare(True, app_pointer.visible, " should be visible!")
            else:
                test.fail("'" + app_name + "' app is not known!!")
    else:
        test.fail("'" + app_name + "' app is not known!!")
