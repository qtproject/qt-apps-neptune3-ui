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


@Then("add widget was tapped")
def step(context):
    tapObject(waitForObject(names.neptune_3_UI_Center_Console_addWidgetButton_ToolButton))

@Then("the new widget dialogue appeared")
def step(context):
    test.compare(waitForObjectExists(names.neptune_3_UI_Center_Console_addWidgetPopupItem_AddWidgetPopup).enabled, True)
    test.compare(waitForObjectExists(names.neptune_3_UI_Center_Console_addWidgetPopupItem_AddWidgetPopup).visible, True)

@Then("the add widget popup should not be there after '|integer|' seconds of closing animation")
def step(context,seconds):
    snooze(seconds)
    addWidget_popup = names.neptune_3_UI_Center_Console_addWidgetPopupItem_AddWidgetPopup
    # test.compare(volume_popup.exists) something funny??
    try:
        waitForObjectExists(addWidget_popup,G_WAIT_FOR_INEXISTANCE_MS)
    except Exception:
        test.compare(True,True,"add widget popup closed!")
    else:
        test.compare(True,False," add widget popup is still there!")

@Then("the maps widget is visible in the home screen")
def step(context):
    test.compare(waitForObjectExists(names.neptune_3_UI_Center_Console_homeWidget_Maps_Column).enabled, True)
    test.compare(waitForObjectExists(names.neptune_3_UI_Center_Console_homeWidget_Maps_Column).visible, True)

@When("add map is tapped")
def step(context):
    addWidgetItem_maps = waitForObject(names.widgetList_AddWidgets_Maps)
    tapObject(addWidgetItem_maps)

@When("tapping to remove the map widget")
def step(context):
    closeWidgetItem_maps = waitForObject(names.good_appMainMenu_WidgetClose_Map_MouseArea)
    tapObject(closeWidgetItem_maps)

@Then("the maps widget disappeared in the home screen after '|integer|' seconds of animation")
def step(context,seconds):
    exists = is_squish_object_there(names.neptune_3_UI_Center_Console_homeWidget_Maps_Column,seconds)
    if exists:
        test.compare(True,False," volume popup is still there!")
    else:
        test.compare(True,True,"volume popup closed!")
