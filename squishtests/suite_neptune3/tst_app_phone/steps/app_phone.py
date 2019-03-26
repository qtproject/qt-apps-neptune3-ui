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


@OnFeatureStart
def hook(context):
    start_neptune_ui_app_w_focus("console")


@Then("tap phone '|word|' button")
def step(context, button_name):
    if button_name not in qml.viewPhoneButtons:
        test.fail("in phone the button '" + button_name
                 + "' is not known!!")
        return
    app.switch_to_app('phone')
    start_search = waitForObject(names.phoneViewChangeButtons_ToolsColumn)

    object_name = qml.viewPhoneButton_prefix + button_name
    object_pointer = find_object_name_recursively(start_search, object_name, 4)
    if object_pointer is not None:
        if object_pointer.visible:
            squish.tapObject(object_pointer)
        else:
            app.fail("phone button '" + button_name
                     + "' was found but is not visible!")


@Then("phone view '|word|' should be displayed")
def step(context, view_name):
    if view_name not in qml.viewPhoneButtons:
        app.fail("in phone the view '" + view_name
                 + "' is not known!!")
    # recents and favorites so far not
    has_2_views = [qml.viewPhoneButtons[2:]]

    view_obj_name = None
    if view_name == 'contacts':
        view_obj_name = names.contacts_phoneView_ContactsView
    elif view_name == 'recents':
        view_obj_name = names.recents_phoneView_RecentCallsView
    elif view_name == 'favorites':
        view_obj_name = names.favorites_phoneView_ContactsView
    elif view_name == 'keypad':
        view_obj_name = names.keypad_phoneView_KeypadViewPanel
    else:
        app.fail("this should not happen, this view '"
                 + view_name + "'" is not known)

    view_found = squish.waitForObject(view_obj_name)
    # first test (since it is not the last no "app.compare()"
    test.compare(view_found is not None, True, "view '"
                + view_name + "' found!!")

    if view_name in has_2_views:
        if view_name == 'favorites':
            second_ui_item = names.phonefavoritesView_FavoritesWidgetView
        elif view_name == 'keypad':
            second_ui_item = names.phoneCallView_CallWidgetView
        else:
            app.fail("this should not happen here with '"
                     + view_name + "'!!")
        test_ui = squish.waitForObject(second_ui_item)
        app.compare(test_ui.visible, True, "2nd view item should be visible")

    # switch to main before new command
    app.switch_to_main_app()
    squish.snooze(0.2)


@When("tapping call icon of '|word|' entry '|integer|'")
def step(context, view_name, entry_number):
    if not context.userData:
        context.userData = {}

    natural_number = entry_number - 1
    ui_item = None
    caller_prefix = qml.phone_contactView_prefix
    button_prefix = qml.phone_contactView_button_prefix
    name_prefix = qml.phone_contactView_caller_prefix
    if view_name == 'favorites':
        ui_item = names.favorites_phoneView_ContactsView
    elif view_name == 'contacts':
        ui_item = names.contacts_phoneView_ContactsView
    else:
        app.fail("from this view you cannot call directly: '"
                 + view_name + "'!!")
    # switch to app
    app.switch_to_app('phone')
    caller_view = squish.waitForObject(ui_item)

    if caller_view is not None:
        search_contact_name = caller_prefix + str(natural_number)
        caller_pointer = find_object_name_recursively(caller_view,
                                                      search_contact_name, 4)
        if caller_pointer is not None:
            search_contact_button_name = button_prefix + str(natural_number)
            button_pointer = find_object_name_recursively(caller_pointer,
                                                    search_contact_button_name,
                                                    4)
            if button_pointer is not None:
                # now store the name for comparison
                store_name = name_prefix + str(natural_number)
                name_obj = find_object_name_recursively(caller_pointer,
                                                        store_name,
                                                        4)
                if name_obj is not None:
                    full_name = str(name_obj.text)
                    context.userData['calling'] = full_name
                    # and finally hit 'call'
                    squish.tapObject(button_pointer)
                else:
                    app.fail("name for contact '"
                             + button_prefix
                             + str(natural_number)
                             + "' could not be found")
            else:
                app.fail("button for contact '"
                         + button_prefix
                         + str(natural_number)
                         + "' could not be found")
        else:
            app.fail("stackview item for '"
                     + view_name + str(natural_number)
                     + "' could not be found")
    else:
        app.fail("should not happen here!!!")

    # switch to main before new command
    app.switch_to_main_app()
    squish.snooze(0.2)


@Then("number from entry '|word|' should be called")
def step(context, views):
    if not context.userData:
        context.userData = {}
    calling_name = context.userData['calling']

    # use a natural numbering, so +1 since entry 0 is entry 1
    squish.snooze(0.25)
    # switch and wait a little
    app.switch_to_app('phone')
    squish.snooze(0.25)

    caller_name_obj = squish.waitForObject(names.phoneCallerLabel)

    caller_name = None
    if caller_name_obj is not None:
        caller_name = str(caller_name_obj.text)
    # end call before comparing
    end_call_button = squish.waitForObject(names.phoneCallerEndButton)
    squish.tapObject(end_call_button)

    app.compare(calling_name, caller_name, "calling the right name")

    # switch to main before new command
    app.switch_to_main_app()
    squish.snooze(0.2)
