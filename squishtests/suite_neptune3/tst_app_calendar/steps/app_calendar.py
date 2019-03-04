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


@OnFeatureStart
def hook(context):
    start_neptune_ui_app_w_focus("console")


@Given("tap '|word|' button")
def step(context, view_name):
    if view_name == "events":
        view_object_name = names.events_ToolButton
    elif view_name == "year":
        view_object_name = names.year_ToolButton
    else:
        view_object_name = names.next_ToolButton

    events_button = waitForObject(view_object_name)
    tapObject(events_button)


@Then("calendar view '|word|' should be displayed")
def step(context, view_name):
    view_stack_layout = waitForObject(names.calendarViewContent)
    current_index = view_stack_layout.currentIndex
    if view_name == "events":
        compare_name = qml.calendar_view['events']
    elif view_name == "year":
        compare_name = qml.calendar_view['year']
    else:
        compare_name = qml.calendar_view['next']
    stack_layouts = object.children(view_stack_layout)
    current_name = stack_layouts[current_index].objectName
    test.compare(current_name, compare_name, "calendar views")
