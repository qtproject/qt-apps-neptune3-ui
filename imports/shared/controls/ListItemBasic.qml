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
 *  - symbol - This property holds a path to an icon to be displayed on a list item.
 *  - imageSource - This property holds a path to an image to be displayed on a list item.
 *  - subText - holds text in the second line on a list item.
 *  - dividerVisible - defines if there is a divider on a list item. Default value is true.
 *  - accessoryDelegateComponent1 - a component at the right side of list item.
 *  - accessoryDelegateComponent2 - a component at the right side of list item next to accessoryDelegateComponent1 if it's defined.
 *  - accessoryBottomDelegateComponent - some list items require an element at the bottom of list item.
 *  - rightSpacerUsed - In some cases it will be necessary to have a margin between the right side of list item and the last element at the right side. The default value is false.
 *  - middleSpacerUsed - It's a margin between the left and the right parts of a ListItem. The default value is false.
 */

ItemDelegate {
    id: root

    // TODO: use icon.source / icon.name
    property string symbol: ""
    property string imageSource: ""

    property alias subText: subtitle.text
    property alias dividerVisible: dividerImage.visible

    property Component accessoryDelegateComponent1: null
    property Component accessoryDelegateComponent2: null
    property Component accessoryBottomDelegateComponent: null

    property bool rightSpacerUsed: false
    property bool middleSpacerUsed: false

    leftPadding: 0
    rightPadding: 0
    bottomPadding: 0
    topPadding: 0

    indicator: Item {
        implicitWidth: {
            if ((root.symbol === "")&&(root.imageSource === "")) {
                return Style.hspan(22/45)
            } else if ((root.symbol !== "")&&(root.imageSource === "")) {
                return Style.hspan(100/45)
            } else {
                return Style.hspan(122/45)
            }
        }

        implicitHeight: root.symbol || root.imageSource ? root.height : 0
        opacity: root.enabled ? NeptuneStyle.fontOpacityHigh : NeptuneStyle.fontOpacityDisabled
        Item {
            id: colorOverlaySource
            anchors.fill: parent
            visible: false
            Image {
                id: imageSymbol
                anchors.centerIn: parent
                source: root.symbol
                visible: root.symbol !== ""
            }
        }
        ColorOverlay {
            anchors.fill: parent
            source: colorOverlaySource
            color: NeptuneStyle.contrastColor
            visible: root.symbol !== ""
        }
        Image {
            id: imageSymbolSource
            anchors.centerIn: parent
            source: root.imageSource
            visible: root.imageSource !== ""
        }
    }

    contentItem: Item {
        implicitHeight: Style.vspan(75/80)
        RowLayout {
            anchors.fill: parent
            ColumnLayout {
                Layout.fillWidth: true
                Label {
                    Layout.fillWidth: true
                    leftPadding: root.indicator ? root.indicator.width + root.spacing : 0
                    text: root.text
                    font: root.font
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    opacity: enabled ? NeptuneStyle.fontOpacityHigh : NeptuneStyle.fontOpacityDisabled
                    visible: root.text
                    color: NeptuneStyle.contrastColor
                }

                Label {
                    id: subtitle
                    Layout.fillWidth: true
                    leftPadding: root.indicator ? root.indicator.width + root.spacing : 0
                    rightPadding: root.indicator ? root.indicator.width + root.spacing : 0
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: NeptuneStyle.fontSizeS
                    visible: text
                    opacity: NeptuneStyle.fontOpacityMedium
                }
            }
            Item {
                id: spacer
                Layout.minimumWidth: Style.hspan(22/45)
                Layout.maximumWidth: Style.hspan(22/45)
                Layout.minimumHeight: parent.height
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
            Item {
                id: spacerRight
                Layout.minimumWidth: Style.hspan(22/45)
                Layout.maximumWidth: Style.hspan(22/45)
                Layout.minimumHeight: parent.height
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
            source: Style.gfx2("list-divider")
        }
    }
}
