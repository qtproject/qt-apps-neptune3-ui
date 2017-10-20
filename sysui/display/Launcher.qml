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

import QtQuick 2.6
import QtQuick.Controls 2.3
import utils 1.0
import QtApplicationManager 1.0
import QtQuick.Layouts 1.0

import models.application 1.0

RowLayout {
    id: root

    width: Style.launcherWidth
    height: gridButton.checked ? expandedHeight : Style.launcherHeight

    readonly property real expandedHeight: Style.vspan(10)
    readonly property bool open: gridButton.checked

    function goHome() {
        homeButton.checked = true;
        homeButton.clicked();
    }

    Behavior on height {
        SmoothedAnimation {
            easing.type: Easing.InOutQuad
            duration: 270
        }
    }

    ButtonGroup {
        id: buttonGroup
        buttons: [homeButton]
    }

    ToolButton {
        id: homeButton

        width: grid.cellWidth
        height: grid.cellHeight
        Layout.alignment: Qt.AlignTop

        // TODO: replace this with the correct asset when available
        //icon.source: ""
        text: "Home"

        checked: true
        onClicked: {
            gridButton.checked = false;
            ApplicationManagerModel.goHome()
        }

        Tracer {
            visible: true
        }
    }

    GridView {
        id: grid
        Layout.alignment: Qt.AlignTop
        Layout.fillWidth: true
        Layout.fillHeight: true
        interactive: false
        clip: true
        model: ApplicationManager
        cellWidth: width / 4
        cellHeight: Style.vspan(1)
        delegate: ToolButton {
            id: appButton
            width: grid.cellWidth
            height: grid.cellHeight
            icon.source: model.icon
            checkable: true
            onClicked: {
                gridButton.checked = false;
                ApplicationManager.startApplication(model.applicationId)
            }
            Component.onCompleted: buttonGroup.addButton(appButton)
            Component.onDestruction: buttonGroup.removeButton(appButton)

            property var appInfo: ApplicationManagerModel.application(model.applicationId)
            Connections {
                target: appInfo
                onActiveChanged: {
                    if (appInfo.active) {
                        appButton.checked = true;
                    }
                }
            }

            Tracer {
                visible: true
            }
        }
    }

    ToolButton {
        id: gridButton

        width: grid.cellWidth
        height: grid.cellHeight
        Layout.alignment: Qt.AlignTop

        // TODO: replace this with the correct asset when available
        //icon.source: ""

        text: "Apps"
        checkable: true

        Tracer {
            visible: true
        }
    }
}
