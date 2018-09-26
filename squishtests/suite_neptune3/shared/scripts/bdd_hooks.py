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


# This file contains hook functions to run as the .feature file is executed.
#
# A common use-case is to use the OnScenarioStart/OnScenarioEnd hooks to
# start and stop an AUT, e.g.
#
# @OnScenarioStart
# def hook(context):
#     startApplication("addressbook")
#
# @OnScenarioEnd
# def hook(context):
#     currentApplicationContext().detach()
#
# See the section 'Performing Actions During Test Execution Via Hooks' in the Squish
# manual for a complete reference of the available API.

import names

# waiting time to let all windows to arrange at start-up
STARTUP_ARRANGE_TIME_SEC = 1
STARTUP_RETRIES = 0
STARTUP_RETRIES_WAIT_SEC = 2
END_DEARRANGE_TIME_SEC = 3


@OnFeatureEnd
def hook(context):
    for ctx in applicationContextList():
        ctx.detach()
    snooze(END_DEARRANGE_TIME_SEC)


# unfortunately not readable by the AUT given in the project's test config of squish, those variable are not usable within the test
AUT="neptune3-ui"

# clean up a little more
def start_neptune_ui_app_w_focus(window):
    def repeater(tries):
        global SCREEN_HEIGHT
        global SCREEN_WIDTH
        global SCREEN_LANDSCAPE

        try:
            appman = {"type":"QtAM::ApplicationManagerWindow"}
            #obj = waitForObject(appman,1000)
        except Exception as e:
            test.fail("Appman not found!!:" + str(e))
        else:
            #command_line_options = "--start-session-dbus --r"

            #command_line_options = "--start-session-dbus -platform eglfs -plugin evdevkeyboard:grab=1"

            #command_line_options = "-r -c am-config.yaml --start-session-dbus -platform eglfs -plugin evdevkeyboard:grab=1 --logging-rule \"*=true\" --logging-rule \"Qt3D.*.debug=false\" --logging-rule=\"qt.*.debug=false\""
            command_line_options = "-r --start-session-dbus"

            command_line = AUT + " " + command_line_options
            try:
                startApplication(command_line)
                # wait for windows to arrange
                test.log("Start up application with: '" + command_line + "'!")
                snooze(STARTUP_ARRANGE_TIME_SEC)

                worked, window_obj = get_focus_window(window)
                if not worked:
                    return False
            except Exception as e:
                if tries > 0:
                    test.log("retrying to start AUT '" + AUT + "'!")
                    snooze(STARTUP_RETRIES_WAIT_SEC)
                    return repeater(tries-1)
                else:
                    test.fail("Window not found after " + str(STARTUP_RETRIES) + " retries!!:" + str(e))
                    return False
            else:
                # only for console so far

                test.log("Window size is   : " + str(window_obj.width) + "," + str(window_obj.height))
                test.log("Window pos  is   : " + str(window_obj.x) + "," + str(window_obj.y))
                try:
                    console_inside = waitForObject(names.neptune_3_UI_Center_Console_centerConsole_CenterConsole,500)
                except Exception:
                    pass
                else:
                    test.log("----------------------")
                    SCREEN_WIDTH = console_inside.width
                    SCREEN_HEIGHT = console_inside.height
                    SCREEN_LANDSCAPE = True
                    test.log("Console size     : " + str(SCREEN_WIDTH) + "," + str(SCREEN_HEIGHT))
                    test.log("Console offset is: " + str(console_inside.x) + "," + str(console_inside.y))


                # from https://kb.froglogic.com/display/KB/Problem+-+Bringing+window+to+foreground+%28Qt%29
                window_obj.show()
                getattr(window_obj, "raise")()
                #not needed any more??? o.activateWindow()
            return True
    # run here
    repeater(STARTUP_RETRIES)

def get_focus_window(window):
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
            obj = waitForObject(obj_name,1000)
        except Exception as e:
            test.fail("Could not find window '" + window + "'!!" + str(e))
            obj = None
            found = False

        return found, obj


#    pos = QCursor.pos()
#    test.log("Local Position is: " + str(pos.x) + "/" + str(pos.y))


def get_middle_of_object(obj):
    try:
        posx = obj.x
        posy = obj.y
    except Exception as e:
        test.fail("Fail due to: " + str(e))
        return False, QPoint(0,0)
    else:
        return True, QPoint(posx,posy)

def get_info(obj):
    try:
        posx = obj.x
        posy = obj.y
        width = obj.width
        height = obj.height
    except Exception as e:
        test.fail("Fail due to: " + str(e))
    else:
        test.log("(" + str(posx) + "," + str(posy) + ") size [" + str(width) + "," + str(height) + "]")



#helper
def get_midth_of_item(itemObjectOrName):
    item = waitForObject(itemObjectOrName)
    if className(item) != "QQuickItem":
        try:
            item = object.convertTo(item, "QQuickItem")
        except Exception as e:
            test.log("Positioning object could not be converted to QQuickItem:  " + str(e))
            return False, QPoint(0,0)
    return True, QPoint(item.x + math.floor(item.width/2),item.y + math.floor(item.height/2))


def get_position_item(itemObjectOrName):
    def recursive_go_deep(obj):
        parent = object.parent(obj)
        if parent:
            worked, rel_pos = recursive_go_deep(parent)
            if worked:
                posx = obj.x + rel_pos.x
                posy = obj.y + rel_pos.y
                return True, QPoint(posx,posy)
            else:
                return False, QPoint(0,0)
        else:
            return True, QPoint(obj.x,obj.y)

    item = waitForObject(itemObjectOrName)
    if className(item) != "QQuickItem":
        try:
            item = object.convertTo(item, "QQuickItem")
        except Exception as e:
            test.log("Positioning object could not be converted to QQuickItem:  " + str(e))
            return False, QPoint(0,0)
    worked, pos = recursive_go_deep(item)
    return worked, pos


# from https://kb.froglogic.com/display/KB/Getting+screen+coordinates+of+QGraphicsItem%2C+QGraphicsObject
