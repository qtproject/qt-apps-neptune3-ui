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

import names

# coordinate
from math import sin,cos,floor


G_WAIT_FOR_INEXISTANCE_MS = 1000
# waiting time for system to get ready between test scenarios todo: change somehow and distinguish between scenario and test, since no instance will appear
G_WAIT_SYSTEM_READY_SEC = 1

SCREEN_WIDTH  = 1920
SCREEN_HEIGHT = 1080
# Landscape is ambigous: can be either rotation of 90 (pi) or 270 (3/4 pi) degrees
# rotation yet unclear, what will be the reference system (test in portrait I'd suggest)
SCREEN_LANDSCAPE = False

SCREEN_ROTATION   = 0.0 # from 0 to 2pi is clockwise
SCREEN_SHIFT_X_px = 0
SCREEN_SHIFT_Y_px = 0


def coord_transform2D(src_point):
    global G_WAIT_SYSTEM_READY_SEC # todo: put somewhere else
    ti = QPoint(0,0)

    rotation = float(0)
    if not SCREEN_LANDSCAPE:
            rotation = Math.pi * 0.75
            # I misuse it to distinguish between target and test development
            G_WAIT_SYSTEM_READY_SEC = 3

    scale_x = float(SCREEN_WIDTH * 0.01)
    scale_y = float(SCREEN_HEIGHT * 0.01)

    r_sin_rho = sin(rotation)
    r_cos_rho = cos(rotation)

    # not fully tested!!!!
    tx = float((r_cos_rho * src_point.x * scale_x) - (r_sin_rho * src_point.y * scale_y))
    ty = float((r_sin_rho * src_point.x * scale_x) + (r_cos_rho * src_point.y * scale_y))

    # do a geometric translation (after so no rotation in a point)
    ti.x = floor(tx) + SCREEN_SHIFT_X_px
    ti.y = floor(ty) + SCREEN_SHIFT_Y_px
    return ti


@Given("main menu is open")
def step(context):
    snooze(G_WAIT_SYSTEM_READY_SEC)
    test.compare(True,True)

@Given("main menu is focused")
def step(context):
    worked, _obj = focus_window("console")
    test.compare(True, worked)

# a dummy
@When("nothing")
def step(context):
    test.compare(True,True)

# a dummy
@Given("nothing")
def step(context):
    pass

# a dummy
@Then("nothing")
def step(context):
    pass

@Then("after some '|integer|' seconds")
def step(context,seconds):
    snooze(seconds)

@When("after some '|integer|' seconds")
def step(context,seconds):
    snooze(seconds)


# --------------------- specific not yet clear, where to put it
@When("the popup close button is clicked")
def step(context):
    popup_close_button = waitForObject(names.neptune_3_UI_Center_Console_popupClose_ToolButton)
    mouseClick(popup_close_button)

def is_squish_object_there(squish_object,seconds):
    snooze(seconds)
    try:
        waitForObjectExists(squish_object,G_WAIT_FOR_INEXISTANCE_MS)
    except Exception:
        return False
    else:
        return True

# -------------------------------------------------------
