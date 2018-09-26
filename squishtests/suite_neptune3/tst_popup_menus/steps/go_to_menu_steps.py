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

@OnFeatureStart
def hook(context):
    start_neptune_ui_app_w_focus("console")

@OnScenarioEnd
#def hook(context):
#    currentApplicationContext().detach()


@When("the volume button is tapped")
def step(context):
    volume_icon = waitForObject(names.neptune_3_UI_Center_Console_volumePopupButton_ToolButton)
    tapObject(volume_icon)

@Then("the volume popup should appear")
def step(context):
    volume_popup = names.neptune_3_UI_Center_Console_volumePopupItem_VolumePopup
    is_enabled = waitForObjectExists(volume_popup).enabled
    is_visible = waitForObjectExists(volume_popup).visible
    test.compare( is_enabled and is_visible, True, "is both enabled and visible")


@Then("the volume popup should not be there after '|integer|' seconds of closing animation")
def step(context,seconds):
    exists = is_squish_object_there(names.neptune_3_UI_Center_Console_volumePopupItem_VolumePopup,seconds)
    if exists:
        test.compare(True,False," volume popup is still there!")
    else:
        test.compare(True,True,"volume popup closed!")


@When("the volume slider is moved 'upwards'")
def step(context):
    if not context.userData:
        context.userData = {}

    volumeSlider = waitForObject(names.neptune_3_UI_Center_Console_volumeSlider_Slider)
    context.userData['VolumeSliderValue'] = volumeSlider.value

    start_point = QPoint(8.13, 55.83)
    movement = QPoint(0, -31)

    ts_point = coord_transform2D(start_point)
    ts_movement = coord_transform2D(movement)

    touchAndDrag(volumeSlider, ts_point.x, ts_point.y, ts_movement.x, ts_movement.y)


@Then("the volume slider value should be '|word|'")
def step(context,change):
    before_value = context.userData['VolumeSliderValue']

    volumeSlider = waitForObject(names.neptune_3_UI_Center_Console_volumeSlider_Slider)
    current_value = volumeSlider.value

    test.log("Before: " + str(before_value) + " now: " + str(current_value))

    is_now_smaller = (current_value < before_value)
    is_equal =  (current_value ==  before_value)

    if change == 'increased':
        test.compare(not is_now_smaller and not is_equal, True, "has greater value")
    else: # decreased
        test.compare(is_now_smaller, True, "has smaller value")
