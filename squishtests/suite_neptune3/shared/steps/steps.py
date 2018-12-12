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

# A quick introduction to implementing scripts for BDD tests:
#
# This file contains snippets of script code to be executed as the .feature
# file is processed. See the section 'Behavior Driven Testing' in the 'API
# Reference Manual' chapter of the Squish manual for a comprehensive reference:
#
#   https://doc.froglogic.com/squish/latest/api.bdt.functions.html
#
# The decorators Given/When/Then/Step can be used to associate a script snippet
# with a pattern which is matched against the steps being executed. Optional
# table/multi-line string arguments of the step are passed via a mandatory
# 'context' parameter:
#
#   @When("I enter the text")
#   def whenTextEntered(context):
#       <code here>
#
# The pattern is a plain string without the leading keyword ("Given",
# "When", "Then", etc.).
#
# Inside of the pattern the following placeholders are supported:
#
#   |any|
#   |word|
#   |integer|
#
# These placeholders can be used to extract arbitrary, alphanumeric and
# integer values resp. from the pattern; the extracted values are passed
# as additional arguments to the step implementation function:
#
#   @Then("I get |integer| different names")
#   def namesReceived(context, numNames):
#       <code here>
#
# Instead of using a string with placeholders, a regular expression can be
# specified. In that case, make sure to set the (optional) 'regexp' argument
# to True:
#
#   @Then("I get (\d+) different names", regexp=True)
#   def namesReceived(context, numNames):
#       <code here>
