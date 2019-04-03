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


import math
import os          # needed for app identification path
import __builtin__ as builtins  # python types (not squish)

import common.settings as settings
import common.app as app

# squish dependent
import names
import squish
import test

# waiting time to let all windows to arrange at start-up
STARTUP_ARRANGE_TIME_SEC = 2
END_DEARRANGE_TIME_SEC = 3


@OnFeatureEnd
def hook(context):
    for ctx in applicationContextList():
        ctx.detach()
    squish.snooze(END_DEARRANGE_TIME_SEC)


# clean up a little more
def start_neptune_ui_app_w_focus(window):
    """ Starting hook for all tests to be started. It can be started in 2 modes
    which selects which window of neptune should be focused (for a visible
    experience and double check the tests' effect)

    'console'   : console view focused
    'dashboard' : dashboard view focused
    """

    # check forced single process:
    # it can be used to start in single process though it would normally
    # start in multi-process, this is just passing through of an option
    # which is also defined in starting neptune3-ui executable
    force_single_process = (os.environ.get('SINGLE_PROCESS') == '1')

    # !!! Remember to use ignoredauts.txt feature
    # otherwise this will cause a lot of trouble,
    # with dbus and RemoteSettingsServer !!!
    # Read the documentation:
    # https://doc.qt.io/Neptune3UI/neptune3ui-testing-squish.html#exclude-disruptive-sub-processes
    command_line_options = ("-r"
                          + " --start-session-dbus"
                          + " -c am-config-neptune.yaml"
                          + " -c squish-appman-hook.yaml"
                          + (" --force-single-process" if
                             force_single_process else ""))

    # assemble the line
    command_line = settings.G_AUT_MAIN + " " + command_line_options

    test.log("command_line: " + command_line)

    try:
        # try to start application
        app_context = squish.startApplication(command_line)
    except Exception as e:
        test.fail("direct command line call didn't work:", str(e))
        return False

    test.log("Started applicationContext: '" + app_context.name + "' ("
             + str(app_context.pid) + ", #" + str(app_context.port)
             + ") is running!")

    # this snooze is really needed, VERY IMPORTANT
    squish.snooze(STARTUP_ARRANGE_TIME_SEC)

    # try to register all already connected AUTs
    # especially from appman
    nr_apps = app.update_all_contexts()

    # setting multi process according to how many apps
    # were found
    settings.G_MULTI_PROCESS = (nr_apps > 1)
    test.log("Using " + ("MULTI" if settings.G_MULTI_PROCESS
                        else "SINGLE")
                      + " PROCESS!!")

    # if it is multi process, change search container for
    # all according apps
    if settings.G_MULTI_PROCESS:
        # change for all known apps the search container
        for change_app in names.apps_change_collection:
            change_app(names.multi_process_container)

    # to be able to focus window we need the neptune main app
    app.switch_to_main_app()

    try:
        worked, window_obj = get_focus_window(window)

        if not worked:
            return False
    except Exception as e:
            test.fail("Window not found!! (" + str(e) + ")")
            return False

    # only for console so far
    test.log("Window size is   : " + str(window_obj.width)
             + "x" + str(window_obj.height))
    test.log("Window pos  is   : " + str(window_obj.x)
             + "," + str(window_obj.y))

    # look for center console
    try:
        console_obj = squish.waitForObject(
                        names.neptune_3_UI_Center_Console_centerConsole_CenterConsole,
                        500)
    except Exception:
        test.fail("Could not find console window!!!")
    else:
        # look also into
        # https://doc.froglogic.com/squish/latest/rgs-squish.html#rgss-screen-object
        test.log("----------------------")
        settings.SCREEN_WIDTH = console_obj.width
        settings.SCREEN_HEIGHT = console_obj.height

        settings.SCREEN_LANDSCAPE = console_obj.store.centerConsole.isLandscape

        test.log("Landscape" if settings.SCREEN_LANDSCAPE else "No landscape")

        # I misuse it to distinguish between target and test development
        if settings.SCREEN_LANDSCAPE:
            settings.G_WAIT_SYSTEM_READY_SEC = 3

        test.log("Console size     : " + str(settings.SCREEN_WIDTH)
                  + "x" + str(settings.SCREEN_HEIGHT))
        test.log("Console offset is: " + str(console_obj.x)
                  + "," + str(console_obj.y))

        # from https://kb.froglogic.com/display/KB/Problem+-+Bringing+window+to+foreground+%28Qt%29
        window_obj.show()
        getattr(window_obj, "raise")()


def get_focus_window(window):
    """Return the object to the window according to dashboard/cluster"""
    found = True
    if window == "dashboard":
        obj_name = names.neptune_UI_Instrument_Cluster_QQuickWindowQmlImpl
    elif window == "console":
        obj_name = names.neptune_UI_Center_Console
    else:
        test.fail("The given window '" + window + "' is not known!!")
        obj = None
        found = False
        return found, obj
    try:
        obj = squish.waitForObject(obj_name, 1000)
    except Exception as e:
        test.fail("Could not find window '" + window + "'!!" + str(e))
        obj = None
        found = False
    return found, obj


# todo: move these to another file
def get_middle_of_object(obj):
    try:
        posx = obj.x
        posy = obj.y
    except Exception as e:
        test.fail("Fail due to: " + str(e))
        return False, QPoint(0, 0)
    else:
        return True, QPoint(posx, posy)


def get_info(obj):
    try:
        posx = obj.x
        posy = obj.y
        width = obj.width
        height = obj.height
    except Exception as e:
        test.fail("Fail due to: " + str(e))
    else:
        test.log("(" + str(posx) + "," + str(posy)
                 + ") size ["
                 + str(width) + "," + str(height) + "]")


def get_midth_of_item(itemObjectOrName):
    """Returns (success, QPoint) of the center point of the given object"""
    item = waitForObject(itemObjectOrName)
    if className(item) != "QQuickItem":
        try:
            item = object.convertTo(item, "QQuickItem")
        except Exception as e:
            test.log("Positioning object couldn't be converted to QQuickItem: "
                      + str(e))
            return False, QPoint(0, 0)
    return True, QPoint(item.x + math.floor(item.width / 2), item.y
                               + math.floor(item.height / 2))


def find_object_name_recursively(obj, obj_name, max_depth):
    """Find a given objectName string in the subtree of the given object, up
     to max depth levels"""
    if max_depth > 0:
        deep_children = object.children(obj)
        for dc in deep_children:
            if hasattr(dc, "objectName") and dc.objectName == obj_name:
                return dc
            children_search = find_object_name_recursively(dc,
                                                           obj_name,
                                                           max_depth - 1)
            if children_search:
                return children_search
    else:
        return None


def find_same_prefix_list(obj, list_prefix, max_depth):
    """Find a (child) listlist of object with same prefix,
    which are in same level (siblings)
    to max depth levels of the starting object.
    The staring child 0 has to exist, and also we assume
    that digits for low number don't have 001 or 01."""
    return_obj_list = None
    if max_depth > 0:
        zero_element_name = list_prefix + "0"
        zero_element = find_object_name_recursively(obj, zero_element_name,
                                                    max_depth)
        if zero_element is not None:
            parent = object.parent(zero_element)
            if parent is not None:
                # now check all children for same prefix and add
                chdl = object.children(parent)
                for chd in chdl:
                    if not hasattr(chd, "objectName"):
                        continue
                    full_obj_name = str(chd.objectName)
                    suffix = full_obj_name.replace(list_prefix, "")
                    # test that removing prefix doesn't
                    # do anything
                    if suffix == full_obj_name:
                        continue
                    _try_number = 0
                    try:
                        _try_number = builtins.int(suffix)
                    except ValueError:
                        continue
                    # here it should be ok
                    # one could check, if it is a counting up
                    # number (to before) or if it is +1 always
                    # ... this will be a first cheap version,
                    # taking anything that fits
                    if return_obj_list is None:
                        # first entry
                        return_obj_list = [chd]
                    else:
                        return_obj_list.append(chd)
    return return_obj_list


def get_position_item(itemObjectOrName):
    """Gets the position of the given object in the coordinates of the
     root object"""
    def recursive_go_deep(obj):
        parent = object.parent(obj)
        if parent:
            worked, rel_pos = recursive_go_deep(parent)
            if worked:
                posx = obj.x + rel_pos.x
                posy = obj.y + rel_pos.y
                return True, QPoint(posx, posy)
            else:
                return False, QPoint(0, 0)
        else:
            return True, QPoint(obj.x, obj.y)

    item = waitForObject(itemObjectOrName)
    # from https://kb.froglogic.com/display/KB/Getting+screen+coordinates+of+QGraphicsItem%2C+QGraphicsObject
    if className(item) != "QQuickItem":
        try:
            item = object.convertTo(item, "QQuickItem")
        except Exception as e:
            test.log("Positioning object couldn't be converted to QQuickItem: "
                      + str(e))
            return False, QPoint(0, 0)
    worked, pos = recursive_go_deep(item)
    return worked, pos
