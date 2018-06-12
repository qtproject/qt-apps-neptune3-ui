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
import QtQuick.Controls.impl 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import utils 1.0
import com.pelagicore.styles.neptune 3.0

/*!
    \qmltype ListItemBasic
    \inqmlmodule controls
    \inherits ItemDelegate
    \since 5.11
    \brief The basic list item component of Neptune 3

    The ListItemBasic provides a basic type of a list item with an indicator as an icon
    or an image and text with subtext followed by the indicator.

    See \l{Neptune 3 UI Components and Interfaces} to see more available components in
    Neptune 3 UI.

    \section2 Example Usage

    The following example uses \l{ListItemBasic}:

    \qml
    import QtQuick 2.10
    import controls 1.0

    Item {
        id: root
        ListView {
            model: 3
            delegate:  ListItemBasic {
                text: "Title ListItem"
                subText: "Subtitle ListItem"
            }
        }
    }
    \endqml

*/

ItemDelegate {
    id: root

    /*!
        \qmlproperty string ListItemBasic::subText

        This property holds text in the second line on a list item.
    */
    property alias subText: subtitle.text

    /*!
        \qmlproperty bool ListItemBasic::dividerVisible

        This property defines if there is a divider on a list item. Default value is true.
    */
    property alias dividerVisible: dividerImage.visible

    /*!
        \qmlproperty Component ListItemBasic::accessoryDelegateComponent1

        This property holds a component at the right side of list item.
    */
    property Component accessoryDelegateComponent1: null

    /*!
        \qmlproperty Component ListItemBasic::accessoryDelegateComponent2

        This property holds a component at the right side of list item next to
        accessoryDelegateComponent2 if it is defined.
    */
    property Component accessoryDelegateComponent2: null

    /*!
        \qmlproperty Component ListItemBasic::accessoryBottomDelegateComponent

        This property holds an element at the bottom of the list item.
    */
    property Component accessoryBottomDelegateComponent: null

    /*!
        \qmlproperty bool ListItemBasic::rightSpacerUsed

        This property specifies a margin between the right side of list item and the
        last element at the right side.

        This property's default is false.
    */
    property bool rightSpacerUsed: false

    /*!
        \qmlproperty bool ListItemBasic::middleSpacerUsed

        This property specifies a margin between the left and the right parts of a ListItem.

        This property's default is false.
    */
    property bool middleSpacerUsed: false

    /*!
        \qmlproperty bool ListItemBasic::wrapText

        The property defines if the text and subtext are wrapped. In notifications
        long text is shown on several lines and this property has to be set true.
        In normal lists the property value is remained false.

        This property's default is false.
    */
    property bool wrapText: false

    leftPadding: 0
    rightPadding: 0
    bottomPadding: 0
    topPadding: 0
    opacity: enabled ? root.opacity : NeptuneStyle.defaultDisabledOpacity
    icon.color: NeptuneStyle.contrastColor

    implicitHeight: Math.max(
                        listItemText.contentHeight + subtitle.contentHeight,
                        Math.max(
                            (accessoryItem1.item ? accessoryItem1.item.implicitHeight : NeptuneStyle.dp(75)),
                            (accessoryItem2.item ? accessoryItem2.item.implicitHeight : NeptuneStyle.dp(75))
                            )
                        ) + topPadding + bottomPadding
    implicitWidth: NeptuneStyle.dp(100)

    indicator: IconLabel {
        height: root.icon ? root.height : 0
        opacity: NeptuneStyle.opacityHigh
        scale: NeptuneStyle.scale
        spacing: root.spacing
        mirrored: root.mirrored
        display: root.display
        icon: root.icon
    }

    contentItem: Item {
        RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: subText ? undefined : parent.verticalCenter
            ColumnLayout {
                Layout.fillWidth: true
                Label {
                    id: listItemText
                    Layout.fillWidth: true
                    Layout.leftMargin: indicator ? indicator.width + root.spacing : 0
                    text: root.text
                    font: root.font
                    elide: Text.ElideRight
                    wrapMode: root.wrapText ? Text.WrapAtWordBoundaryOrAnywhere : Text.NoWrap
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    opacity: NeptuneStyle.opacityHigh
                    visible: root.text
                    color: NeptuneStyle.contrastColor
                }

                Label {
                    id: subtitle
                    Layout.fillWidth: true
                    Layout.leftMargin: indicator ? indicator.width + root.spacing : 0
                    elide: Text.ElideRight
                    wrapMode: root.wrapText ? Text.WrapAtWordBoundaryOrAnywhere : Text.NoWrap
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
                Layout.maximumHeight: NeptuneStyle.dp(22)
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
                Layout.minimumWidth: NeptuneStyle.dp(22)
                Layout.maximumWidth: NeptuneStyle.dp(22)
                Layout.maximumHeight:NeptuneStyle.dp(22)
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
