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

import QtQuick 2.5
import QtGraphicalEffects 1.0

import QtQuick.Controls 2.1
import controls 1.0
import utils 1.0
import models.settings 1.0
import models.system 1.0

/*
   A window stack with the home page at the bottom and at most an application window on top of it
*/
StackView {
    id: root

    property var applicationModel
    property alias widgetListModel: homePage.widgetsList

    property alias homePageBottomApplicationWidget: homePage.bottomApplicationWidget
    property alias homePageWidgetWidth: homePage.widgetWidth
    property alias homePageRowHeight: homePage.rowHeight

    readonly property bool showingHomePage: depth == 1

    initialItem: HomePage {
        id: homePage
        opacity: 0

        OpacityAnimator {
            target: homePage;
            from: 0;
            to: 1;
            duration: 1000
            running: true
        }
    }

    focus: true

    /*
    pushEnter: windowTransitions ? windowTransitions.pushEnter : null
    pushExit: windowTransitions ? windowTransitions.pushExit : null
    popEnter: windowTransitions ? windowTransitions.popEnter : null
    popExit: windowTransitions ? windowTransitions.popExit : null
    replaceEnter: pushEnter
    replaceExit: pushExit
    */

    /*
    Loader {
        id: windowTransitionsLoader
        source: "windowtransitions/" + SettingsModel.windowTransitions.get(SettingsModel.windowTransitionsIndex).name + ".qml"
        Binding {
            target: windowTransitionsLoader.item
            property: "itemWidth"
            value: root.itemWidth
        }
    }
    property alias windowTransitions: windowTransitionsLoader.item
    */

    Item {
        id: dummyitem
        anchors.fill: parent
        //visible: false
    }

    Shortcut {
        context: Qt.ApplicationShortcut
        sequence: StandardKey.Cancel
        onActivated: { root.pop(); }
    }

    Connections {
        // Might look redundant, but it saves us from getting "QML Connections: Cannot assign to non-existent property"
        // while root.applicationModel hasn't been initialized yet
        target: root.applicationModel ? root.applicationModel : null

        onActiveAppIdChanged: {
            if (root.applicationModel.activeAppId === "" && root.depth > 1) {
                // go back to the home screen
                root.pop();
            }
        }

        onApplicationSurfaceReady: {
            if (appInfo.asWidget) {
                // leave it alone. Widgets are displayed by their own separate components elsewhere.
                return;
            }

            if (root.currentItem === item) {
                // NOOP
                return;
            }

            item.width = Qt.binding(function() { return root.width; });
            item.height = Qt.binding(function() { return root.height; });
            if (root.depth === 1) {
                root.push(item)
            } else if (root.depth > 1) {
                root.replace(item)
            }
        }

        /*
        onReleaseApplicationSurface: {
            if (root.currentItem === item) {
                root.pop()
            }
        }
        */
    }
}
