/****************************************************************************
**
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


import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import utils 1.0
import com.pelagicore.styles.neptune 3.0

/*
 * ListItemBasic provides a basic type of a list item with an indicator as an icon or an image and text with subtest following by the indicator.
 *
 * Properties:
 *  - icon.name - This property holds the name of an icon to be displayed on a list item.
 *  - icon.source - This property holds a path to an icon or an image to be displayed on a list item. In case the property takes an image which color is
 *                  not intented to be altered, icon.color has to be set transparent
 *  - icon.color - This property holds the color of an icon or and image to be displayed on a list item.
 *  - subText - holds text in the second line on a list item.
 *  - dividerVisible - defines if there is a divider on a list item. Default value is true.
 *  - accessoryDelegateComponent1 - a component at the right side of list item.
 *  - accessoryDelegateComponent2 - a component at the right side of list item next to accessoryDelegateComponent1 if it's defined.
 *  - accessoryButton - a button with text at the right side of the list item.
 *  - accessoryBottomDelegateComponent - some list items require an element at the bottom of list item.
 *  - rightSpacerUsed - In some cases it will be necessary to have a margin between the right side of list item and the last element at the right side. The default value is false.
 *  - middleSpacerUsed - It's a margin between the left and the right parts of a ListItem. The default value is false.
 */

ItemDelegate {
    id: root

    property alias subText: subtitle.text
    property alias dividerVisible: dividerImage.visible

    property Component accessoryDelegateComponent1: null
    property Component accessoryDelegateComponent2: null
    property Component accessoryButton: null
    property Component accessoryBottomDelegateComponent: null

    property bool rightSpacerUsed: false
    property bool middleSpacerUsed: false

    leftPadding: 0
    rightPadding: 0
    bottomPadding: 0
    topPadding: 0
    opacity: enabled ? root.opacity : NeptuneStyle.defaultDisabledOpacity
    icon.color: NeptuneStyle.contrastColor

    contentItem: Item {
        implicitHeight: NeptuneStyle.dp(75)
        NeptuneIconLabel {
            id: iconItem
            width: {
                if (root.icon.source.toString() === "" && root.icon.name === "") {
                    return NeptuneStyle.dp(22)
                } else {
                    return NeptuneStyle.dp(100)
                }
            }
            height: parent.height
            opacity: NeptuneStyle.opacityHigh
            iconScale: NeptuneStyle.scale
            spacing: root.spacing
            mirrored: root.mirrored
            display: root.display
            icon: root.icon
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: iconItem.width + root.spacing
            ColumnLayout {
                Layout.fillWidth: true
                Label {
                    Layout.fillWidth: true
                    text: root.text
                    font: root.font
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    opacity: NeptuneStyle.opacityHigh
                    visible: root.text
                    color: NeptuneStyle.contrastColor
                }

                Label {
                    id: subtitle
                    Layout.fillWidth: true
                    rightPadding: iconItem ? iconItem.width + root.spacing : 0
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: NeptuneStyle.fontSizeS
                    visible: text
                    opacity: NeptuneStyle.opacityMedium
                }
            }
            Item {
                id: spacer
                Layout.minimumWidth: NeptuneStyle.dp(22)
                Layout.maximumWidth: NeptuneStyle.dp(22)
                Layout.maximumHeight: parent.height
                visible: middleSpacerUsed
            }
            Loader {
                id: accessoryItem1
                visible: root.accessoryDelegateComponent1 !== null
                active: root.accessoryDelegateComponent1 !== null
                sourceComponent: root.accessoryDelegateComponent1
            }
            Loader {
                id: accessoryItem2
                visible: root.accessoryDelegateComponent2 !== null
                active: root.accessoryDelegateComponent2 !== null
                sourceComponent: root.accessoryDelegateComponent2
            }
            Loader {
                id: accessoryButtonItem
                visible: root.accessoryButton !== null
                active: root.accessoryButton !== null
                sourceComponent: root.accessoryButton
            }
            Item {
                id: spacerRight
                Layout.minimumWidth: NeptuneStyle.dp(22)
                Layout.maximumWidth: NeptuneStyle.dp(22)
                Layout.maximumHeight: parent.height
                visible: rightSpacerUsed
            }
        }
        Loader {
            id: accessoryBottomItem
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            visible: root.accessoryBottomDelegateComponent !== null
            active: root.accessoryBottomDelegateComponent !== null
            sourceComponent: root.accessoryBottomDelegateComponent
        }
        Image {
            id: dividerImage
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            source: Style.gfx("list-divider", NeptuneStyle.theme)
        }
    }
}
