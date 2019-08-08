# -*- coding: utf-8 -*-

############################################################################
##
## Copyright (C) 2019 Luxoft Sweden AB
## Copyright (C) 2018 Pelagicore AG
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
#############################################################################


import os       # for path handling
import settings  # for global vars

# squish dependent
import test
import squish


def register_main(app):
    """Register the main app, to be available from other python modules."""
    if app is not None:
        settings.G_APP_MAIN = app
    else:
        test.fail("Main app is empty!!!")


def register_app(app):
    """Registers an app into settings.G_APP_HANDLE, if this app is known."""
    good = False

    app_url = os.path.basename(os.path.normpath(app.cwd))
    app_array = filter(lambda x, app_url=app_url: x[1] == app_url,
                       settings.G_NAME_ID)
    app_name = None
    if len(app_array) != 0:
        app_name = app_array[0][0]

    if app_name is not None and app_name in settings.G_APP_HANDLE.keys():
        good = True
        if settings.G_APP_HANDLE[app_name] is None:
            settings.G_APP_HANDLE[app_name] = app
            test.log("Registered the new app '"
                     + app_name
                     + "' to be usable in squish!")
        else:
            test.log("App '" + app_name + "' is already registered!")
    else:
        test.fail("The app with path '" + app.cwd + "' is not known!")
    return good


def switch_to_main_app():
    """Switch context to main app, to act in its process."""
    # in case of multi process not needed
    if not settings.G_MULTI_PROCESS:
        return True

    good = False
    if settings.G_APP_MAIN is not None:
        squish.snooze(settings.G_WAIT_SWITCH_APP_CONTEXT)
        squish.setApplicationContext(settings.G_APP_MAIN)
        good = True
    else:
        test.fail("Main app is not registered yet!!!")
    return good


def switch_to_app(app_name):
    """Switch context to the given app, to act in its process."""
    # in case of multi process not needed
    if not settings.G_MULTI_PROCESS:
        return True

    # do this always upfront, because an app
    # might have been connected in the meanwhile
    # and must be updated before trying to possibly
    # change to it.
    update_all_contexts()

    good = False
    if app_name in settings.G_APP_HANDLE.keys():
        switch_to_app = settings.G_APP_HANDLE[app_name]
        if switch_to_app is not None:
            test.log("Trying to switch to registered app '"
                     + app_name + "'!")
            squish.snooze(settings.G_WAIT_SWITCH_APP_CONTEXT)
            squish.setApplicationContext(switch_to_app)
            test.log("Switched to registered app '" + app_name + "'!")
            good = True
        else:
            test.fail("App '" + app_name + "' is known but yet not registered")
    else:
        test.fail("App '" + app_name + "' is not known!")
    return good


def get_app_id(app_name):
    """Get (found,app_id) from the app list"""
    for name, value in settings.G_NAME_ID:
        if name == app_name:
            return True, value
    return False, ""


def register(app):
    """
    Register an app or main app (input: by instance)
    to known apps.
    """
    worked = True

    app_name = str(app)
    if app_name == settings.G_AUT_MAIN:
        register_main(app)
    elif app_name == settings.G_AUT_APPMAN:
        register_app(app)
    elif app_name == settings.G_AUT_REMOTE:
        test.log("app '" + app_name + "' is found, all right!")
    else:
        test.warning("app '" + app_name + "' with path '"
                     + a.cwd + "' is yet not known!")
        worked = False
    return worked


def update_all_contexts():
    """Update application contexts, each possible app has to be registered
    before using!"""
    app_list = squish.applicationContextList()
    for a in app_list:
        register(a)
    return len(app_list)


def compare(condition1, condition2, text):
    """ calls Squish's compare but switch back
    to main app.
    See "fail" in this class, since compare's
    fail behavior is problematic and explained
    there.
    """
    switch_to_main_app()
    test.compare(condition1, condition2, text)


def fail(text):
    """ calls Squish's fail but switch back
    to main app before.
    The problem is when Squish fails, that if
    not done manually before in the according fail
    branch of the compare, any later switch_to_main_app()
    will not happen. This is a thin wrapper, that does it.
    """
    switch_to_main_app()
    test.fail(text)
