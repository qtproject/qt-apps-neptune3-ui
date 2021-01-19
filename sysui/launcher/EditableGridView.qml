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

import QtQuick 2.13
import QtQuick.Controls 2.2
import QtQml.Models 2.1
import QtQuick.Layouts 1.0
import shared.controls 1.0
import shared.utils 1.0
import shared.animations 1.0
import shared.Sizes 1.0

Item {
    id: root

    height: (cellHeight * Math.ceil(grid.count/root.numIconsPerRow))

    property var model
    property var exclusiveButtonGroup
    readonly property int numIconsPerRow: 4
    property bool editMode: false
    readonly property alias cellWidth: grid.cellWidth
    readonly property alias cellHeight: grid.cellHeight

    property bool gridOpen: false
    property bool showDevApps: false
    property bool showSystemApps: false

    onGridOpenChanged: {
        if (!root.gridOpen) {
            root.editMode = false;
        }
    }

    onModelChanged: {
        if (root.model) {
            visualModel.model = root.model;
            visualModel.refreshItems();
            visualModel.modelItemsCount = Qt.binding( function() { return root.model.count; } );
        }
    }

    signal appButtonClicked(var applicationId)

    DelegateModel {
        id: visualModel

        //binded property for model root.model
        property int modelItemsCount

        onModelItemsCountChanged: {
            visualModel.refreshItems();
        }

        function refreshItems() {
            for (var i = 0; i < root.model.count; ++i) {
                var appInfo = root.model.get(i).appInfo;

                var systemApp = appInfo.isSystemApp;
                var devApp = appInfo.categories.indexOf("dev") >= 0;
                var hideForced = "showInLauncher" in appInfo.application.applicationProperties
                        ? !appInfo.application.applicationProperties["showInLauncher"]
                        : false;

                visualModel.items.removeGroups(i, 1, ["show"]);
                if (!hideForced) {
                    if (systemApp && showSystemApps && devApp && showDevApps
                            || systemApp && showSystemApps && !devApp
                            || devApp && showDevApps && !systemApp
                            || !devApp && !systemApp)
                    {
                        visualModel.items.addGroups(i, 1, ["show"]);
                    }
                }
            }

            visualModel.filterOnGroup = "show";
        }

        groups: [
            DelegateModelGroup { name: "show"; includeByDefault: false }
        ]

        delegate: Item {
            id: delegateRoot
            objectName: "gridDelegate_" + (model.appInfo ? model.appInfo.id : "none")

            property int visualIndex: DelegateModel.itemsIndex

            width: grid.cellWidth
            height: grid.cellHeight

            //disable mouse interaction for invisible items when only top row is shown
            enabled: opacity > 0.0
            opacity: {
                if (!root.gridOpen && DelegateModel.showIndex >= root.numIconsPerRow)
                    return 0.0

                return 1.0
            }
            Behavior on opacity { DefaultNumberAnimation { } }

            DragHandler {
                id: handler
                target: appButton
                enabled: root.editMode
                xAxis.minimum: 0
                xAxis.maximum: grid.width - grid.cellWidth
                xAxis.enabled: true

                yAxis.minimum: 0
                yAxis.maximum: grid.height - grid.cellHeight
                yAxis.enabled: true

                onActiveChanged: {
                    if (!active) {
                        //when it's dragged, it stops being the item that
                        //currently has the cursor and so the item's release
                        //signal is not emitted. 'Release' here instead.
                        appButton.released();
                    }
                }
            }

            AppButton {
                id: appButton

                ButtonGroup.group: root.exclusiveButtonGroup

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -Sizes.dp(10)

                property int dragIndex: delegateRoot.visualIndex

                Connections {
                    target: model.appInfo
                    function onActiveChanged() {
                        if (model.appInfo.active) {
                            appButton.checked = true;
                        } else {
                            appButton.checked = false;
                        }
                    }
                }

                editModeBgOpacity: handler.active ? 0.8 : root.editMode ? 0.2 : 0.0
                editModeBgColor: handler.active ? "#404142" : "#F1EFED"
                icon.name: model.appInfo ? model.appInfo.icon : ""
                text: model.appInfo ? model.appInfo.name : null
                gridOpen: root.gridOpen

                Drag.active: handler.active
                Drag.source: handler
                Drag.hotSpot.x: width / 2
                Drag.hotSpot.y: height / 2

                states: [
                    State {
                        when: handler.active
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

                onClicked: {
                    if (!root.editMode) {
                        root.appButtonClicked(model.applicationId);
                        model.appInfo.start();
                    }
                }

                onPressAndHold: {
                    // pressed and held -> start user arrange
                    // don't update if it's already in editMode
                    if (root.gridOpen && !root.editMode) {
                        root.editMode = true;
                    }
                }
            }

            DropArea {
                anchors { centerIn: parent; }
                width: parent.width * 0.9
                height: parent.height * 0.9
                onEntered: {
                    grid.model.items.move(drag.source.target.dragIndex, delegateRoot.visualIndex);
                }
            }

            state: root.editMode ? "editing" : "normal"
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
        opacity: root.editMode ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation { } }
        visible: opacity > 0

        text: qsTr("Finish Editing")
        onClicked: root.editMode = false
    }
}
