/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Copyright (C) 2018 Pelagicore AG
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

import QtQuick 2.6
import QtQuick.Controls 2.2
import QtQml.Models 2.1
import QtQuick.Layouts 1.0
import shared.controls 1.0
import shared.utils 1.0
import shared.animations 1.0
import shared.Sizes 1.0

Item {
    id: root

    height: cellHeight * Math.ceil(grid.count/root.numIconsPerRow)

    property alias gridEditMode: grid.editMode
    property var model
    readonly property int numIconsPerRow: 4
    property var exclusiveButtonGroup
    readonly property alias cellWidth: grid.cellWidth
    readonly property alias cellHeight: grid.cellHeight

    property bool showDevApps: false
    property bool showSystemApps: false
    property bool gridOpen: false

    onGridOpenChanged: {
        if (!root.gridOpen) {
            grid.editMode = false
        }
    }

    onModelChanged: {
        if (root.model) {
            visualModel.model = root.model;
            visualModel.refreshItems()
            visualModel.modelItemsCount = Qt.binding( function() { return root.model.count; } )
        }
    }

    signal appButtonClicked(var applicationId)

    DelegateModel {
        id: visualModel

        //binded property for model root.model
        property int modelItemsCount

        onModelItemsCountChanged: {
            visualModel.refreshItems()
        }

        function refreshItems() {
            var modelCount = root.model.count;

            for (var i = 0; i < modelCount; i++) {
                var item = root.model.get(i);
                var groups = ["items"]
                //not a system app
                if (!item.appInfo.isSystemApp) {
                    groups = ["items", "noSystem"]
                }
                //not system and not dev
                if (!item.appInfo.isSystemApp && (item.appInfo.categories.indexOf("dev") < 0)) {
                    groups = ["items", "noSystemNoDev", "noSystem"]
                }
                visualModel.items.setGroups(i, 1, groups)
            }

            if (!showSystemApps)
                visualModel.filterOnGroup = "noSystem"

            if (!showDevApps)
                visualModel.filterOnGroup = "noSystemNoDev"
        }

        groups: [
            DelegateModelGroup { name: "noSystem"; includeByDefault: false },
            DelegateModelGroup { name: "noSystemNoDev"; includeByDefault: false }
        ]
        delegate: MouseArea {
            id: delegateRoot
            objectName: "gridDelegate_" + (model.appInfo ? model.appInfo.id : "none")

            property int visualIndex: visualModel.filterOnGroup === ""
                            ? model.index
                            : visualModel.items.get(model.index)[visualModel.filterOnGroup + "Index"]

            width: grid.cellWidth
            height: grid.cellHeight

            //disable mouse interaction for invisible items when only top row is shown
            enabled: opacity > 0.0
            opacity: {
                if (delegateRoot.visualIndex > (root.numIconsPerRow - 1)) {
                    if (root.gridOpen) {
                        return 1.0
                    } else {
                        return 0.0
                    }
                }
                return 1.0
            }
            Behavior on opacity { DefaultNumberAnimation { } }

            AppButton {
                id: appButton

                ButtonGroup.group: root.exclusiveButtonGroup

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -Sizes.dp(10)

                Connections {
                    target: model.appInfo
                    onActiveChanged: {
                        if (model.appInfo.active) {
                            appButton.checked = true;
                        } else {
                            appButton.checked = false;
                        }
                    }
                }

                editModeBgOpacity: Drag.active ? 0.8 : grid.editMode ? 0.2 : 0.0
                editModeBgColor: Drag.active ? "#404142" : "#F1EFED"

                iconSource: model.appInfo ? model.appInfo.icon : null
                labelText: model.appInfo ? model.appInfo.name : null
                gridOpen: root.gridOpen

                Drag.active: delegateRoot.drag.active
                Drag.source: delegateRoot
                Drag.hotSpot.x: width / 2
                Drag.hotSpot.y: height / 2

                states: [
                    State {
                        when: appButton.Drag.active
                        ParentChange {
                            target: appButton
                            parent: grid
                        }

                        AnchorChanges {
                            target: appButton;
                            anchors.horizontalCenter: undefined;
                            anchors.verticalCenter: undefined
                        }
                    }
                ]
            }

            DropArea {
                anchors { fill: parent; }
                onEntered: visualModel.items.move(drag.source.visualIndex, delegateRoot.visualIndex)
            }

            onClicked: {
                if (!grid.editMode) {
                    root.appButtonClicked(model.applicationId);
                    model.appInfo.start();
                }
            }

            onPressed: {
                if (grid.editMode) {
                    drag.target = appButton;
                }
            }

            onPressAndHold: {
                if (root.gridOpen) {
                    grid.editMode = true;
                    drag.target = appButton;
                }
            }
            onReleased: {
                drag.target = undefined;
            }

            state: grid.editMode ? "editing" : "normal"
            states: [
                State {
                    name: "normal"
                    PropertyChanges {
                        target: appButton
                        width: grid.cellWidth
                        height: grid.cellHeight
                    }
                },
                State {
                    name: "editing"
                    PropertyChanges {
                        target: appButton
                        width: Sizes.dp(172)
                        height: Sizes.dp(172)
                    }
                }
            ]
            transitions: Transition {
                DefaultNumberAnimation { properties: "width, height" }
            }
        }
    }

    GridView {
        id: grid
        property bool editMode: false
        LayoutMirroring.enabled: false

        Layout.alignment: Qt.AlignTop
        anchors.fill: parent
        interactive: false
        model: visualModel
        cellWidth: width / root.numIconsPerRow
        cellHeight: cellWidth

        displaced: Transition {
            DefaultNumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
        }
    }

    Button {
        id: exitEditMode
        anchors.top: grid.bottom
        anchors.topMargin: Sizes.dp(16)
        anchors.horizontalCenter: parent.horizontalCenter
        width: root.width/2
        height: Sizes.dp(80)
        opacity: grid.editMode ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation { } }
        visible: opacity > 0

        text: qsTr("Finish Editing")
        onClicked: grid.editMode = false
    }
}
