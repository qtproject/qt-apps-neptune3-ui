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


import names
import common.app as app
import common.qml_names as qml


@OnFeatureStart
def hook(context):
    start_neptune_ui_app_w_focus("console")


@Given("call '|word|' '|word|' on the phone widget short list")
def step(context, firstname, lastname):
    if not context.userData:
        context.userData = {}

    app.switch_to_app('phone')

    # concat names
    name = firstname + " " + lastname

    start_search = squish.waitForObject(
                            names.phonefavoritesView_FavoritesWidgetView)
    short_list = find_same_prefix_list(start_search,
                                       qml.phone_shortcall_prefix,
                                       4)
    success = False
    if short_list is not None:
        for item in short_list:
            name_obj = find_object_name_recursively(item,
                                                    qml.phone_shortcall_name,
                                                    5)
            if name_obj is not None:
                full_name = str(name_obj.text)
                if full_name == name:
                    # after name has matched, search the button
                    # and call
                    call_button = find_object_name_recursively(
                                                 item,
                                                 qml.phone_shortcall_button,
                                                 5)
                    if call_button is not None:
                        squish.tapObject(call_button)
                        success = True
                        context.userData['calling'] = name
                        break
                    else:
                        test.fail("name '"
                                  + name
                                  + "' found but not the button")
            else:
                test.fail("listitem's descendant must contain '"
                          + qml.phone_shortcall_name
                          + "'!")
    else:
        test.fail("should not happen: '"
                  + qml.phone_shortcall_prefix
                  + "' list in phone not found!")
    # check if a correct item was found
    app.compare(success, True, "name " + name
                + (" was found!" if success else " was not found!"))
    # back to main
    app.switch_to_main_app()
