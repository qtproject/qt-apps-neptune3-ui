/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Triton IVI UI.
**
** $QT_BEGIN_LICENSE:GPL-QTAS$
** Commercial License Usage
** Licensees holding valid commercial Qt Automotive Suite licenses may use
** this file in accordance with the commercial license agreement provided
** with the Software or, alternatively, in accordance with the terms
** contained in a written agreement between you and The Qt Company.  For
** licensing terms and conditions see https://www.qt.io/terms-conditions.
** For further information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 or (at your option) any later version
** approved by the KDE Free Qt Foundation. The licenses are as published by
** the Free Software Foundation and appearing in the file LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
** SPDX-License-Identifier: GPL-3.0
**
****************************************************************************/

import QtQuick 2.7
import QtApplicationManager 1.0

/*
   A wrapper for AppMan Application that adds some more goodies

   Maybe some of those extra bits could be put into Application itself to reduce or even
   eliminate the need for this wrapper.
 */
QtObject {
    // the AppMan Application object
    property var application

    // whether the application is active (on foreground / fullscreen)
    // false means it's either invisible, minimized, reduced to a widget geometry
    // or might not even be running at all
    property bool active: false

    // If false, Application.activated signals won't cause the application to be the active one
    property bool canBeActive: true

    //  the main window of this application, if any
    // TODO: try to get rid of this (ie, find a better solution)
    property var window

    // Whether the application window should be shown as a widget
    property bool asWidget: false

    // Widget geometry. Ignored if asWidget === false
    property int heightRows: 1
    property int minHeightRows: 1

    function start() {
        ApplicationManager.startApplication(application.id);
    }
}
