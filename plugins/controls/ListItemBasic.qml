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


import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.impl 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import shared.utils 1.0
import shared.Style 1.0
import shared.Sizes 1.0
import shared.controls 1.0

/*!
    \qmltype ListItemBasic
    \inqmlmodule controls
    \inherits ItemDelegate
    \since 5.11
    \brief The basic list item component in Neptune 3 UI.

    The \c ListItemBasic provides a basic type of list item with an indicator as an icon
    or an image and text with subtext followed by the indicator.

    The code snippet below shows how to use \c ListItemBasic:

    \qml
    import QtQuick 2.10
    import shared.controls 1.0

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

    For a list of components available in Neptune 3 UI, see
    \l{Neptune 3 UI Components and Interfaces}.

*/

ItemDelegate {
    id: root

    /*!
        \qmlproperty string ListItemBasic::subText

        This property holds text in the second line of a ListItem.
    */
    property alias subText: subtitle.text

    /*!
        \qmlproperty bool ListItemBasic::dividerVisible

        This property specifies if there's a divider on a ListItem. The default value is true.
    */
    property alias dividerVisible: dividerImage.visible

    /*!
        \qmlproperty Component ListItemBasic::accessoryDelegateComponent1

        This property holds a component on the right side of a ListItem.
    */
    property Component accessoryDelegateComponent1: null

    /*!
        \qmlproperty Component ListItemBasic::accessoryDelegateComponent2

        This property holds a component on the right side of a ListItem, next to
        accessoryDelegateComponent2, if it's defined.
    */
    property Component accessoryDelegateComponent2: null

    /*!
        \qmlproperty Component ListItemBasic::accessoryBottomDelegateComponent

        This property holds an element at the bottom of a ListItem.
    */
    property Component accessoryBottomDelegateComponent: null

    /*!
        \qmlproperty bool ListItemBasic::rightSpacerUsed

        This property specifies a margin between the right side of a ListItem and the
        last element on the right side. The default value is false.
    */
    property bool rightSpacerUsed: false

    /*!
        \qmlproperty bool ListItemBasic::middleSpacerUsed

        This property specifies a margin between the left and the right parts of a ListItem.
        The default value is false.
    */
    property bool middleSpacerUsed: false

    /*!
        \qmlproperty bool ListItemBasic::wrapText

        The property specifies whether the text and subtext are wrapped. In notifications,
        to display long text on several lines, set this property to \c true. In normal lists,
        this property can remain at \c false. The default value is \c false.

    */
    property bool wrapText: false

    leftPadding: 0
    rightPadding: 0
    bottomPadding: 0
    topPadding: 0
    opacity: enabled ? 1.0 : Style.defaultDisabledOpacity
    icon.color: Style.contrastColor

    implicitHeight: Math.max(
                        listItemText.contentHeight + subtitle.contentHeight,
                        Math.max(
                            (accessoryItem1.item ? accessoryItem1.item.implicitHeight : Sizes.dp(75)),
                            (accessoryItem2.item ? accessoryItem2.item.implicitHeight : Sizes.dp(75))
                            )
                        ) + topPadding + bottomPadding
    implicitWidth: Sizes.dp(100)

    contentItem: Item {
        RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: subText ? undefined : parent.verticalCenter
            spacing: Sizes.dp(24)

            Item {
                //spacer, to trigger 24px margin to the left of first element
                implicitWidth: Sizes.dp(1)
                Layout.fillHeight: true
            }

            Item {
                Layout.fillHeight: true
                implicitWidth: root.implicitHeight
                visible: root.icon.source.toString() !== "" || root.icon.name !== ""
                NeptuneIconLabel {
                    opacity: Style.opacityHigh
                    iconScale: Sizes.scale
                    spacing: root.spacing
                    mirrored: root.mirrored
                    display: root.display
                    icon: root.icon
                    anchors.centerIn: parent

                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.clicked()
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 0

                Label {
                    id: listItemText
                    Layout.fillWidth: true
                    Layout.leftMargin: indicator ? indicator.width + root.spacing : 0
                    Layout.preferredHeight: root.height / 2
                    text: root.text
                    font: root.font
                    elide: Text.ElideRight
                    wrapMode: root.wrapText ? Text.WrapAtWordBoundaryOrAnywhere : Text.NoWrap
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    opacity: Style.opacityHigh
                    visible: root.text
                    color: Style.contrastColor

                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.clicked()
                    }
                }

                Label {
                    id: subtitle
                    Layout.fillWidth: true
                    Layout.leftMargin: indicator ? indicator.width + root.spacing : 0
                    Layout.preferredHeight: root.height / 2
                    elide: Text.ElideRight
                    wrapMode: root.wrapText ? Text.WrapAtWordBoundaryOrAnywhere : Text.NoWrap
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: Sizes.fontSizeS
                    visible: text
                    opacity: Style.opacityMedium
                }
            }
            Item {
                id: spacer
                Layout.minimumWidth: Sizes.dp(0.5)
                Layout.maximumWidth: Sizes.dp(0.5)
                Layout.maximumHeight: Sizes.dp(24)
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
                Layout.minimumWidth: Sizes.dp(22)
                Layout.maximumWidth: Sizes.dp(22)
                Layout.maximumHeight:Sizes.dp(22)
                visible: rightSpacerUsed
            }
            Item {
                //spacer, to trigger 24px margin to the right of the last element
                width: Sizes.dp(1)
                height: parent.height
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
            source: Style.image("list-divider")
            mirror: root.mirrored
        }
    }
}
