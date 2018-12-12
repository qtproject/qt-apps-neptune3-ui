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

import common.app as app  # to switch context
import common.settings as settings  # waiting duration

# squish
import names


@OnFeatureStart
def hook(context):
    start_neptune_ui_app_w_focus("console")


@Given("the climate area is tapped")
def step(context):
    app.switch_to_app('climate')
    climateMouseArea = squish.waitForObjectExists(
                                 names.climateAreaMouseArea_MouseArea)
    squish.tapObject(climateMouseArea)


@When("the '|word|' climate slider is moved '|word|'")
def step(context, leftRight, change):
    if not context.userData:
        context.userData = {}

    climate_slider_handle = {}
    if leftRight == 'left':
        climate_slider_left = squish.waitForObjectExists(
                                      names.leftTempSlider_TemperatureSlider)
        context.userData['leftSliderValue'] = climate_slider_left.value
        climate_slider_handle = squish.waitForObjectExists(
                                       names.leftTempSlider_TemperatureSlider)
    else:
        climate_slider_right = squish.waitForObjectExists(
                                       names.rightTempSlider_TemperatureSlider)
        context.userData['rightSliderValue'] = climate_slider_right.value
        climate_slider_handle = squish.waitForObjectExists(
                                       names.rightTempSlider_TemperatureSlider)

    mousePress(climate_slider_handle, Qt.LeftButton)
    squish.snooze(settings.G_WAIT_SOME_STEPS_SEC)
    move = QPoint(0, 0)
    if change == 'upwards':
        move = QPoint(0, -40)
    else:
        move = QPoint(0, 40)
    ts_movement = coord_transform2D(move)

    mouseMove(climate_slider_handle, ts_movement.x, ts_movement.y)
    snooze(settings.G_WAIT_SOME_STEPS_SEC)
    mouseRelease(Qt.LeftButton)


@Then("the climate slider value on the '|word|' should '|word|'")
def step(context, leftRight, change):
    if not context.userData:
        context.userData = {}

    before_value = 0
    current_value = 0
    if leftRight == 'left':
        before_value = context.userData['leftSliderValue']
        climate_slider_left = squish.waitForObjectExists(
                                        names.leftTempSlider_TemperatureSlider)
        current_value = climate_slider_left.value
    else:
        before_value = context.userData['rightSliderValue']
        climate_slider_right = squish.waitForObjectExists(
                                       names.rightTempSlider_TemperatureSlider)
        current_value = climate_slider_right.value

    test.log("Before: " + str(before_value) + " now: " + str(current_value))

    is_now_smaller = (current_value < before_value)
    is_equal = (current_value == before_value)

    if change == 'increase':
        test.compare(not is_now_smaller and not is_equal, True,
                     "has greater value")
        test.compare(not is_now_smaller and not is_equal, True,
                     "has greater value")
    else:  # decreased
        test.compare(is_now_smaller, True,
                    "has smaller value")
