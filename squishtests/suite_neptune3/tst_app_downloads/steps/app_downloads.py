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

import names
import common.app as app
import common.qml_names as qml

# commonly used
possible_ui_elements = {
    'Games': names.downloadAppViewButton_Games,
    'Business': names.downloadAppViewButton_Business,
    'Entertainment': names.downloadAppViewButton_Entertainment
}


@OnFeatureStart
def hook(context):
    start_neptune_ui_app_w_focus("console")


@When("tap download app view '|word|' button")
def step(context, button_name):
    if button_name not in possible_ui_elements.keys():
        app.fail("in downloads app view, button '"
                 + button_name
                 + "' is not known!")
        return

    #app.switch_to_app('downloads')
    squish.snooze(0.25)
    button = squish.waitForObject(possible_ui_elements[button_name])
    squish.tapObject(button)


@Then("current download view is '|word|'")
def step(context, view_name):
    if view_name not in possible_ui_elements.keys():
        app.fail("in downloads app, view '"
                 + view_name
                 + "' is not known!")
        return

    #app.switch_to_app('downloads')
    squish.snooze(0.25)
    info_ui = squish.waitForObject(names.downloadsToolsColumn)

    currentView = str(info_ui.currentTool)
    app.compare(currentView, view_name,
                "view stored is not what is changed to")


@When("tap and '|word|' all available apps")
def step(context, command):
    possible_options = ['install', 'deinstall']
    if command not in possible_options:
        app.fail("in downloads, the command '"
                  + command + "' is not known!")
        return
    # what to do
    install = (command == possible_options[0])

    #app.switch_to_app('downloads')
    squish.snooze(0.25)
    app_list = squish.waitForObject(names.downloadAppList_DownloadAppList)
    number_of_app_in_view = app_list.count

    # store installable apps here
    just_changed_installation_apps = []

    for i in range(number_of_app_in_view):
        # this is a little bit old school without objectName
        # actually objectName is used to achieve
        # app information aka model.id
        # here we use index to find the item
        download_app_struct = {
                        "container": names.downloadAppList_DownloadAppList,
                        "index": i,
                        "type": "ListItemProgress",
                        "visible": True}
        model_ToolButton_ui = {"container": download_app_struct,
                                "type": "ToolButton",
                                "visible": True}
        test.log("download app index " + str(i)
                 + " was found! Trying ...")
        download_app = squish.waitForObject(download_app_struct)
        app_objectName = str(download_app.objectName)

        model_text = str(download_app.text)

        # delete prefix, if this works, string must be different
        model_name = app_objectName.replace(qml.app_downloads_prefix, "")
        if model_name != model_text:
            installed = download_app.isInstalled

            if install is not installed:
                test.log("Found: (" + str(i) + ") " + model_text + " as '"
                         + model_name + "' "
                         + ("installed" if installed
                                       else "not installed")
                         + "!")
                install_button = squish.waitForObject(model_ToolButton_ui)
                squish.tapObject(install_button)

                # wait a little and hope it installs during that time
                just_changed_installation_apps.append(model_name)
                squish.snooze(2)
            else:
                test.log("app '" + model_name + "' is already "
                        + ("installed" if not install else "not installed")
                        + "!")
        else:
            test.fail("in download test, a problem with model.id occurred.")

    # wait for last toast message to disappear
    squish.snooze(0.5)
    # now check in grid if just installed apps exist
    grid_view = squish.waitForObject(
                              names.neptune_UI_Center_Console_grid_GridView)
    launcher_bar = squish.waitForObject(
                    names.neptune_3_UI_Center_Console_gridButton_ToolButton)
    squish.tapObject(launcher_bar)

    if len(just_changed_installation_apps) == 0:
        test.passes("good, no apps to " +
                     ("install" if install else "uninstall")
                     + "!")
    else:
        for el in just_changed_installation_apps:
            object_name = qml.grid_delegate + el
            app_pointer = find_object_name_recursively(grid_view,
                                                       object_name,
                                                       3)
            # python .......
            found = (app_pointer is not None)
            app.compare(found, install,
                        ("app '" + str(el) + "' exists"))
    # tap again to close
    squish.tapObject(launcher_bar)
    # wait for toast message to disappear
    squish.snooze(0.5)
