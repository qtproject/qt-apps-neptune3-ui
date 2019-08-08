# -*- coding: utf-8 -*-

############################################################################
##
## Copyright (C) 2019 Luxoft Sweden AB
## Contact: https://www.qt.io/licensing/
##
## This file is part of the Neptune 3 UI.
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

import squish
import names

import common.app as app


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
