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

import os
import sys


@OnFeatureStart
def hook(context):
    pass


@Then("return python info")
def step(context):
    test.log("Python Version is "
             + str(sys.version_info.major) + "."
             + str(sys.version_info.minor) + "."
             + str(sys.version_info.micro) + " ("
             + str(sys.version_info.releaselevel) + ")!")
    #test.log("Python pathVersion is :"+ str(sys.path))
    test.log("Python's 'exec_prefix' is            :" + str(sys.exec_prefix))
    test.log("         'sys.prefix' is             :" + str(sys.prefix))
    test.log("         'sys.platform' is           :" + str(sys.platform))
    test.log("         'sys.api_version' is        :" + str(sys.api_version))

    test.log("         'sys.path' is:")
    for el in sys.path:
        test.log("           '" + str(el) + "'")

    test.log("         'sys.path_importer_cache' is:")
    for el in sys.path_importer_cache:
        test.log("           '" + str(el) + "'")

    test.log("         'sys.path_hooks' are:")
    for el in sys.path_hooks:
        try:
            test.log("           '" + str(el) + "'")
        except ImportError as e:
            test.log(str(e))


'''
 Reads the given environment variable provided.
 If the 2nd argument is
  'set' this must be empty or it will fail
  'empty' this var must be empty or it will fail
  'info'  this will just print out the var
  any var will be checked that 1st argument var matches 2nd argument

  https://stackoverflow.com/questions/4906977/how-do-i-access-environment-variables-from-python
'''
@Given("show the environment var '|word|' which might be '|word|'")
def step(context, path, state):
    try:
        os_path = os.environ.get(path)
        #os_path = os.getenv(path)
    except KeyError as e:
        test.fail(str(e) + " but needs to be in the list here: "
                  + str(os.environ))
    else:
        if state == 'set':
            if os_path:
                test.log("Good '" + path + "' it is '" + str(os_path) + "'!")
            else:
                test.fail("Bad '" + path + "' it is not set!")
        elif state == 'empty':
            if os_path:
                test.fail("Bad '" + path + "' is '" + str(os_path)
                          + "' but should not be empty!")
            else:
                test.log("Good '" + path + "' is not set!")
        elif state == 'info':
                test.log("Info: '" + path + "'  is '" + str(os_path) + "'!")
        else:
            if os_path == state:
                test.log("Good '" + path + "' it is '" + str(os_path) + "'!")
            else:
                test.fail("Bad '" + path + "' it is '" + str(os_path)
                          + "' instead of '" + state + "'!")
