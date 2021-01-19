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

import QtQuick 2.7
import QtQml.Models 2.2
import system.controls 1.0
import shared.animations 1.0
import shared.Style 1.0
import shared.utils 1.0

Item {
    id: root
    property var applicationModel

    function next() {
        // go to the next app. If last, set index out of list to make
        // selectedApplicationId change to "" -> show "no app" in cluster
        if ( selectedIndex + 1 <= applicationICWindowList.count) {
            selectedIndex++;
        } else {
            selectedIndex = 0;
        }
    }

    property int selectedIndex: 0
    readonly property string selectedApplicationId: selectedIndex < applicationICWindowList.count
                                                        ? applicationICWindowList.get(selectedIndex).appInfo.id
                                                        : ""
    readonly property bool empty: applicationICWindowList.count === 0

    Instantiator {
        model: root.applicationModel
        delegate: QtObject {
            property var con: Connections {
                target: model.appInfo
                function onIcWindowChanged() {
                    if (model.appInfo.icWindow) {
                        var appInList = false;
                        for (var i = 0; i < applicationICWindowList.count; i++) {
                            if (applicationICWindowList.get(i).appInfo.id === model.appInfo.id) {
                                appInList = true;
                                break;
                            }
                        }
                        if (!appInList) {
                            applicationICWindowList.append({"appInfo" : model.appInfo});
                        }
                    } else {
                        applicationICWindowList.removeWithAppId(model.appInfo.id);
                    }
                }
            }
        }
    }

    ListModel {
        id: applicationICWindowList
        function removeWithAppId(appId) {
            var i;
            for (i = 0; i < count; i++) {
                var item = get(i);
                if (item.appInfo.id === appId) {
                    remove(i, 1);
                    break;
                }
            }
        }
        onCountChanged: {
            // reset selectedIndex if it's invalid, likely because a secondary
            // window vanished
            if (root.selectedIndex >= count) {
                root.selectedIndex = 0;
            }
        }
    }

    Repeater {
        model: applicationICWindowList
        delegate: ApplicationICWindowItem {
            id: applicationICWindowSlot
            anchors.fill: root
            opacity: model.index === root.selectedIndex ? 1 : 0

            // Don't make it invisible as it will also block the redraw (on buffer swap?) of the
            // primary window of that application
            // TODO: Investigate
            //visible: opacity > 0

            appInfo: model.appInfo

            Behavior on opacity { DefaultNumberAnimation {} }
        }
    }
}
