/****************************************************************************
**
** Copyright (C) 2017, 2018 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 IVI UI.
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

import animations 1.0
import utils 1.0

Item {
    id: root
    property var applicationModel

    function next() {
        if ( selectedIndex + 1 < secondaryWindowList.count) {
            selectedIndex++;
        } else {
            selectedIndex = 0;
        }
    }

    property int selectedIndex: 0
    readonly property string selectedApplicationId: selectedIndex < secondaryWindowList.count
                                                        ? secondaryWindowList.get(selectedIndex).applicationId
                                                        : ""
    readonly property bool empty: secondaryWindowList.count === 0

    Instantiator {
        model: root.applicationModel
        delegate: QtObject {
            property var con: Connections {
                target: model.appInfo
                onSecondaryWindowChanged: {
                    if (model.appInfo.secondaryWindow) {
                        secondaryWindowList.append({"applicationId" : model.applicationId,
                                                     "secondaryWindow": model.appInfo.secondaryWindow});
                    } else {
                        secondaryWindowList.removeWithAppId(model.applicationId);
                    }
                }
            }
        }
    }

    ListModel {
        id: secondaryWindowList
        function removeWithAppId(appId) {
            var i;
            for (i = 0; i < count; i++) {
                var item = get(i);
                if (item.applicationId === appId) {
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
        model: secondaryWindowList
        delegate: Item {
            id: secondaryWindowSlot
            anchors.fill: root
            opacity: model.index === root.selectedIndex ? 1 : 0

            // Don't make it invisible as it will also block the redraw (on buffer swap?) of the
            // primary window of that application
            // TODO: Investigate
            //visible: opacity > 0

            Behavior on opacity { DefaultNumberAnimation {}  }
            Binding { target: model.secondaryWindow; property: "width"; value: secondaryWindowSlot.width }
            Binding { target: model.secondaryWindow; property: "height"; value: secondaryWindowSlot.height }
            Binding { target: model.secondaryWindow; property: "parent"; value: secondaryWindowSlot }
        }
    }
}
