/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
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

import QtQuick 2.10
import QtQuick.Controls 2.3
import shared.utils 1.0
import shared.controls 1.0
import shared.Style 1.0
import shared.Sizes 1.0

import "../helpers" 1.0

Item {
    id: root

    Component {
        id: stackRecipeComponent

        Image {
            source: Utils.localAsset("recipe_asset")
            MouseArea {
                id: selectItem
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                width: Sizes.dp(400)
                height: Sizes.dp(750)
                onClicked: stack.push(stackRecipeSelectedComponent)
            }
            MouseArea {
                anchors.top: selectItem.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width: Sizes.dp(400)
                height: Sizes.dp(300)
                onClicked: stack.push(stackFridgeComponent)
            }
        }
    }

    Component {
        id: stackFridgeComponent

        Image {
            source: Utils.localAsset("fridge_asset")
        }
    }

    Component {
        id: stackRecipeSelectedComponent

        Image {
            source: Utils.localAsset("recipe_selected_asset")
        }
    }


    ToolButton {
        anchors.bottom: stack.top
        anchors.left: parent.left
        anchors.leftMargin: Sizes.dp(36)
        visible: stack.depth >= 2
        baselineOffset: 0
        icon.name: LayoutMirroring.enabled ? "ic_forward" : "ic_back"
        text: qsTr("Back")
        font.pixelSize: Sizes.fontSizeS
        onClicked: stack.pop()
    }

    StackView {
        id: stack
        width: root.width
        height: root.height
        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(20)
        clip: true
        initialItem: stackRecipeComponent
        pushEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 200
            }
        }

        pushExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 200
            }
        }

        popEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 200
            }
        }

        popExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 200
            }
        }
    }
}
