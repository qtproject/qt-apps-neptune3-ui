/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Copyright (C) 2018 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 UI.
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

pragma Singleton
import QtQuick
import QtApplicationManager

QtObject {
    id: root
    property int count: ApplicationManager.count
    property var surfaceItems: []
    property Connections conn: Connections {
        target: ApplicationManager
        function onEmitSurface(index, item) {
            surfaceItems[index] = item
            root.surfaceItemReady(index, item)
        }
    }

    signal surfaceItemReady(int index, Item item)
    signal surfaceItemClosing()
    signal surfaceItemLost()
    signal raiseApplicationWindow()
    signal surfaceWindowPropertyChanged(Item surfaceItem, string name, var value)
    signal windowReady(int index, Item item)
    signal windowLost(int index, Item item)
    signal windowPropertyChanged(Item window, string name, var value)

    function setSurfaceWindowProperty(appItem, type, status) {
        appItem.windowPropertyChanged(type, status)
    }

    function surfaceWindowProperty(item, type) {
        return false
    }

    function get(index) {
        var entry = ApplicationManager.get(index)
        entry.surfaceItem = surfaceItems[index]
        return entry
    }

    Component.onCompleted: {
        for (var i = 0; i < root.count; i++) {
            surfaceItems.push(null)
        }
    }

}
