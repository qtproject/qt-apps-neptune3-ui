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



def get_left_temperature_slider_Value():
    return waitForObjectExists(names.neptune_UI_Center_Console_leftTempSlider_TemperatureSlider).value

def get_right_temperature_slider_Value():
    return waitForObjectExists(names.neptune_UI_Center_Console_rightTempSlider_TemperatureSlider).value


@Given("the climate area is tapped")
def step(context):
    climateMouseArea = waitForObjectExists(names.neptune_3_UI_Center_Console_squish_climateBarMouseArea_MouseArea)
    tapObject(climateMouseArea)



@When("the left climate slider is moved downwards")
def step(context):
    if not context.userData:
        context.userData = {}
    context.userData['leftSliderValue'] = get_left_temperature_slider_Value()
    toggle_left = waitForObject(names.neptune_UI_Center_Console_handle_Image)

    good, midth = get_middle_of_object(toggle_left)
    if good:
        downwards_delta = QPoint(3, -235)
        touchAndDrag(toggle_left, midth.x, midth.y, downwards_delta.x, downwards_delta.y)


@When("the right climate slider is moved upwards")
def step(context):
    if not context.userData:
        context.userData = {}

    context.userData['rightSliderValue'] = get_right_temperature_slider_Value()
    toggle_right = waitForObject(names.neptune_UI_Center_Console_handle_Image_3)
    good, midth = get_middle_of_object(toggle_right)

    if good:
        upwards_delta = QPoint(0, -300)
        touchAndDrag(toggle_right, midth.x, midth.y, upwards_delta.x, upwards_delta.y)


@Then("the climate slider value on the '|word|' should '|word|'")
def step(context,leftRight,change):
    if leftRight == 'left':
        before_value = context.userData['leftSliderValue']
        current_value = get_left_temperature_slider_Value()
    else:
        before_value = context.userData['rightSliderValue']
        current_value = get_right_temperature_slider_Value()

    test.log("Before: " + str(before_value) + " now: " + str(current_value))

    is_now_smaller = (current_value < before_value)
    is_equal =  (current_value ==  before_value)

    if change == 'increase':
        test.compare(not is_now_smaller and not is_equal, True, "has greater value")
    else: # decreased
        test.compare(is_now_smaller, True, "has smaller value")
