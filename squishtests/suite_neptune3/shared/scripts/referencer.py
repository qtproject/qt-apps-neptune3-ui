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
#############################################################################

class Referencer:
    """Referencer gives the opportunity change a value wrapping it, and using
       getter and setter. You register a getter, setter and an identifier, that
       by calling e.g. the setter, to change a value.

    r = Referencer(identifier, getter, setter)

    Set parameter value:
    p(value)
    p.value = value
    p.set(value)

    Get parameter value:
    p()
    p.val
    p.get()
    """
    def __init__(self, identifier, getter, setter):
        """Create a referencer

        identifier : identifier as string, it will give the setter and getter
                     opportunities to use an identifier to map / store the
                     values depending on that identifier. Hence the getter
                     and setter needs to use the identifier in their
                     function signature.
        getter     : called with no arguments, retrieves the parameter value.
        setter     : called with value, sets the parameter.
        """
        self._get = getter
        self._set = setter
        self._identifier = identifier

    def __call__(self, value=None):
        if value is not None:
            self._set(value, self._identifier)
        return self._get(self._identifier)

    def get(self):
        return self._get(self._identifier)

    def set(self, value):
        self._set(value, self._identifier)

    @property
    def value(self):
        return self._get(self._identifier)

    @value.setter
    def value(self, value):
        self._set(value, self._identifier)
