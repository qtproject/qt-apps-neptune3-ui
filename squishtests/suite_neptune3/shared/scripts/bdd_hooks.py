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
import __builtin__

import os          # needed for app identification path

import common.settings as settings
import common.app as app

# squish dependent
import names
import squish
import test

# waiting time to let all windows to arrange at start-up
STARTUP_ARRANGE_TIME_SEC = 2
STARTUP_RETRIES = 0
STARTUP_RETRIES_WAIT_SEC = 2
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

    def repeater(tries):
        """ Inside repeater function for de-coupling and allowing retries """

        # DBUS MUST NOT be started from within neptune3ui otherwise
        # squish will not start correctly with the squish attach to subprocess
        # option.
        command_line_options = "-r"
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

        try:
            # update to catch all AUT instances
            app.update_all_contexts()

            app_now = squish.currentApplicationContext()
            test.log("Current app: '" + str(app_now.commandLine) + "'")

            # wait for windows to arrange
            test.log("Started up application with: '" + command_line + "'!")

            # to be able to focus window we need the neptune main app
            app.switch_to_main_app()
            worked, window_obj = get_focus_window(window)

            if not worked:
                return False
        except Exception as e:
            if tries > 0:
                test.log("retrying to start AUT '" + settings.G_AUT_MAIN + "'!")
                squish.snooze(STARTUP_RETRIES_WAIT_SEC)
                return repeater(tries - 1)
            else:
                test.fail("Window not found after " + str(STARTUP_RETRIES)
                          + " retries!!:" + str(e))
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
            return False

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
        #not needed any more??? o.activateWindow()
        return True
    # run here
    test.log("Found dbus environment")
    test.log("DBUS_SESSION_BUS_ADDRESS with '"
             + os.environ.get('DBUS_SESSION_BUS_ADDRESS')
             + "'")
    # start dbus here
    #start_dbus()
    #
    # THERE IS A BIG DBUS issue: if started from IDE, in the
    # shell which started the IDE, a dbus session must be existent
    # beforehand. From inside (maybe it is also a configuration issue on the
    # test computer!) a valid dbus-session could yet not be established.
    #
    # To start a working and then being used dbus session from the
    # test script here would be the best solution but yet
    # it cannot be solved.
    # It's either a test machine issue (configuration, permissions,
    # dbus configuration), or dbus API must be used instead of
    # subprocess python module. For python dbus module API squish must be
    # extended to use not only build-in python scripts but system's
    # python installation.
    test.log("DBUS_SESSION_BUS_ADDRESS now is '"
             + os.environ.get('DBUS_SESSION_BUS_ADDRESS')
             + "'")
    #test.log("DBUS_SESSION_BUS_PID now is '"
    #         + os.environ.get('DBUS_SESSION_BUS_PID')
    #         + "'")

    repeater(STARTUP_RETRIES)
    test.log("leaving start_neptune_ui_app_w_focus")


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


# doesn't work, but I will leave it, maybe something else is terribly wrong
def mouseMoveLinear(obj, x, y, time_sec):
    step_size = 30
    time_p_step = float(time_sec) / float(step_size)

    dx = float(x) / step_size
    dy = float(y) / step_size
    sx = float(0.0)
    sy = float(0.0)

    old_x = __builtin__.int(0)
    old_y = __builtin__.int(0)

    for _ss in range(step_size):
        draw_x = __builtin__.int(sx)
        draw_y = __builtin__.int(sy)

        step_x = draw_x - old_x
        step_y = draw_y - old_y

        if step_x != 0 or step_y != 0:
            mouseMove(step_x, step_y)

        #test.log(" (" + str(draw_x) + ":" + str(draw_y) + ")    "
        #         + str(step_x) + ":" + str(step_y))

        old_x = __builtin__.int(draw_x)
        old_y = __builtin__.int(draw_y)

        sx += dx
        sy += dy
        # wait milliseconds
        snooze(time_p_step)
