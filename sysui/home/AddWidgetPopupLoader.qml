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

import QtQuick 2.10
import QtQml 2.14

/*
    A seamless wrapper for AddWidgetPopup that loads it on demand
 */
Loader {
    id: root
    active: false
    source: "AddWidgetPopup.qml"

    property Item popupParent: root.popupParent
    property Item originItem: addWidgetButton
    property var model

    function open() {
        if (!active) {
            active = true;
        } else if (itemInitialized) {
            item.open();
        }
    }

    signal closed()

    Connections {
        target: item
        function onClosed() {
            root.closed();
        }
    }

    onStatusChanged: {
        if (status === Loader.Ready) {
            loadedTimer.start();
        }
    }

    // FIXME: This whole timer thing is a work around the fact that the final height (and hence y position)
    //        of this popup is not known from the get go as it's derived from the contentHeight of a list view
    //        which is not immediately know, likely due to the animated nature of ListView.
    //        Refactor AddWidgetPopup so that we no longer need to delay opening it
    property bool itemInitialized: false
    onItemInitializedChanged: {
        if (itemInitialized) {
            item.open();
        }
    }

    Timer {
        id: loadedTimer
        interval: 50
        onTriggered: {
            root.itemInitialized = true;
        }
    }

    Binding {
        restoreMode: Binding.RestoreBinding;
        target: root.item; property: "parent"; value: root.popupParent;
    }
    Binding {
        restoreMode: Binding.RestoreBinding;
        target: root.item; property: "originItem"; value: root.originItem;
    }
    Binding {
        restoreMode: Binding.RestoreBinding;
        target: root.item; property: "model"; value: root.model;
    }
}
