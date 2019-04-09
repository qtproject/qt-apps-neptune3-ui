# -*- coding: utf-8 -*-

############################################################################
##
## Copyright (C) 2019 Luxoft Sweden AB
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

# squish dependent
import names
import common.qml_names as qml
import common.app as app


# commonly used
possible_views = {
    'doors': names.vehicleDoorsPanel_DoorsPanel,
    'support': names.vehicleSupportPanel_ListView,
    'energy': names.vehicleEnergyPanel_Item,
    'tires': names.vehicleTiresPanel_Item
}

possible_doors_ui_items = {
   'roof': {
        'button': names.subViewButton_roof_TabButton,
        'roof': {
                'open': names.roofOpenButton_ToolButton,
                'close': names.roofCloseButton_ToolButton
               }},
   'doors': {
             'button': names.subViewButton_doors_TabButton,
             'left':
               {
                'open': names.vehicleDoorLeft_OpenCloseButton_ToolButton,
                'close': names.vehicleDoorLeft_OpenCloseButton_ToolButton
               },
             'right':
               {
                'open': names.vehicleDoorRight_OpenCloseButton_ToolButton,
                'close': names.vehicleDoorRight_OpenCloseButton_ToolButton
             }},
   'trunk': {
             'button': names.subViewButton_trunk_TabButton,
             'trunk': {
                'open': names.trunk_OpenCloseButton_ToolButton,
                'close': names.trunk_OpenCloseButton_ToolButton
            }}
}


@OnFeatureStart
def hook(context):
    start_neptune_ui_app_w_focus("console")


@Then("tap vehicle view '|word|' button")
def step(context, button_name):
    if button_name not in possible_views.keys():
        app.fail("in vehicle view the button '" + button_name
                 + "' is not known!!")
        return
    app.switch_to_app('vehicle')
    start_search = waitForObject(names.vehicleViewToolsColumn)

    object_name = qml.vehicle_view_button_prefix + button_name
    object_pointer = find_object_name_recursively(start_search, object_name, 3)
    if object_pointer is not None:
        if object_pointer.visible:
            squish.tapObject(object_pointer)
        else:
            app.fail("vehicle view button '" + button_name
                     + "' was found but is not visible!")
    else:
        app.fail("vehicle list view button '" + button_name
                 + "' could not be found!")


@Then("vehicle view '|word|' should be displayed")
def step(context, view_name):
    if view_name not in possible_views:
        app.fail("in phone the view '" + view_name
                 + "' is not known!!")

    view_obj_name = possible_views[view_name]
    # switch to app
    app.switch_to_app('vehicle')
    view_found = squish.waitForObject(view_obj_name)

    test.compare(view_found is not None, True, "view '"
                + view_name + "' in vehicle found")


@Then("tap all support feature buttons, delaying '|integer|' mseconds")
def step(context, delay_time_ms):
    app.switch_to_app('vehicle')
    container_item = squish.waitForObject(names.vehicleSupportPanel_ListView)

    item_list = find_same_prefix_list(container_item,
                                      qml.vehicle_support_list_prefix, 4)

    if item_list is not None:
        for index, ui_item in enumerate(item_list):
            test.log(" trying %d)" % index)
            model_switch = find_object_name_recursively(ui_item,
                                            qml.vehicle_list_switch_name,
                                            6)
            if model_switch is not None:
                squish.snooze(delay_time_ms / 1000)
                squish.tapObject(model_switch)
            else:
                app.fail("'%s' not found", qml.vehicle_list_switch_name)
    else:
        app.fail("no list of '" + qml.vehicle_support_list_prefix
                   + "' found!")


@Then("tap doors view '|word|' and open '|word|' and close after '|integer|' msec")
def step(context, subview, element, delay_msec):
    if subview not in possible_doors_ui_items.keys():
        app.fail("in vehicle doors view the subview '" + subview
                 + "' is not known!!")
        return

    # change context
    app.switch_to_app('vehicle')
    subview_bt_name = possible_doors_ui_items[subview]['button']
    subview_button = squish.waitForObject(subview_bt_name)
    squish.tapObject(subview_button)

    # now all subelementes
    for item_name in possible_doors_ui_items[subview].keys():
        # not interested in button or later view to check
        if item_name in ['button']:
            continue

        if item_name == element:
            item = possible_doors_ui_items[subview][item_name]
            # open now
            open_btn_name = item['open']
            close_btn_name = item['close']
            open_button = squish.waitForObject(open_btn_name)
            squish.tapObject(open_button)
            # wait given time
            squish.snooze(delay_msec / 1000)
            close_button = squish.waitForObject(close_btn_name)
            squish.tapObject(close_button)
            # wait same time for closing
            squish.snooze(delay_msec / 1000)
