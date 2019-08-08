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


G_WAIT_FOR_INEXISTANCE_MS = 1000

G_WAIT_SYSTEM_READY_SEC = 1
G_WAIT_SOME_STEPS_SEC = 1
G_WAIT_SWITCH_APP_CONTEXT = 1

G_AUT_MAIN = "neptune3-ui"
G_AUT_REMOTE = "remotesettings-server"
G_AUT_APPMAN = "appman-launcher-qml"

G_MULTI_PROCESS = None

G_HOST = "localhost"

# ToDo: put all this into a class in app.py
G_NAME_ID = [['vehicle', 'com.luxoft.vehicle'],
              ['map', 'com.pelagicore.map'],
              ['tuner', 'com.pelagicore.tuner'],
              ['hud', 'com.pelagicore.hud'],
              ['settings', 'com.pelagicore.apps.settings'],
              ['music', 'com.pelagicore.music'],
              ['cluster', 'com.theqtcompany.cluster'],
              ['downloads', 'com.pelagicore.downloads'],
              ['phone', 'com.pelagicore.phone'],
              ['calendar', 'com.pelagicore.calendar'],
              ['climate', 'com.pelagicore.climate'],
              ['sheets', 'com.pelagicore.sheets']]

G_APP_MAIN = None
G_APP_HANDLE = {'vehicle': None,
              'map': None,
              'tuner': None,
              'hud': None,
              'settings': None,
              'music': None,
              'cluster': None,
              'downloads': None,
              'phone': None,
              'calendar': None,
              'climate': None,
              'sheets': None}

SCREEN_WIDTH = 1920
SCREEN_HEIGHT = 1080

# Landscape is ambigous: can be either rotation of
#  90 (pi) or 270 (3/4 pi) degrees
SCREEN_LANDSCAPE = False

# rotation yet unclear, what will be the reference system
# (test in portrait I'd suggest)
SCREEN_ROTATION = 0.0  # from 0 to 2pi is clockwise
SCREEN_SHIFT_X_px = 0
SCREEN_SHIFT_Y_px = 0
