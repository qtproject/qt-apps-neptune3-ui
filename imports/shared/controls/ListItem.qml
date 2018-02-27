/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AG
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

import QtQuick 2.8
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import utils 1.0
import com.pelagicore.styles.triton 1.0

/*
    A default ListItem that is used for delegated view of a model. ListItem is inherited
    from ItemDelegate and have extra properties that support several use cases according
    to the component design spec ('components_lists').

    symbol          : This property holds the name of icon to be used as ListItem indicator
    subText         : This property holds a sub textual description of ListItem.
    secondaryText   : This property holds a textual component that is aligned to the right
                      side of ListItem.
    rightToolSymbol : This property holds the tool icon source that is aligned to the
                      right side of ListItem.

    Usage example:

    ListItem {
        Layout.fillWidth: true
        symbol: Style.symbol("ic-update")
        rightToolSymbol: Style.symbol("ic-close")
        text: "ListItem with Secondary Text"
        secondaryText: "68% of 14 MB"
    }

*/

ItemDelegate {
    id: root

    // TODO: use icon.source / icon.name
    property string symbol: ""
    property string imageSource: ""
    property alias subText: subtitle.text
    property alias secondaryText: secondaryText.text
    property alias rightToolSymbol: rightTool.symbol
    property bool dividerVisible: true

    signal rightToolClicked()

    indicator: Item  {
        implicitWidth: root.symbol || root.imageSource ? Style.hspan(2) : 0
        implicitHeight: root.symbol || root.imageSource ? root.height : 0
        Image {
            anchors.centerIn: parent
            source: root.symbol
        }
        Image {
            anchors.fill: parent
            source: root.imageSource
        }
    }

    contentItem: ColumnLayout {
        Label {
            Layout.preferredWidth: secondaryText.text ? Style.hspan(11) : root.width - rightTool.width
            leftPadding: root.indicator ? root.indicator.width + root.spacing : 0
            text: root.text
            font: root.font
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter

            opacity: enabled ? 0.94 : 0.2
            visible: root.text
            color: enabled ? TritonStyle.contrastColor : TritonStyle.disabledTextColor
        }

        Label {
            id: subtitle
            Layout.preferredWidth: secondaryText.text ? Style.hspan(11) : root.width - rightTool.width
            leftPadding: root.indicator ? root.indicator.width + root.spacing : 0
            rightPadding: root.indicator ? root.indicator.width + root.spacing : 0
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: TritonStyle.fontSizeS
            visible: text
            opacity: 0.6
        }
    }

    RowLayout {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        Label {
            id: secondaryText
            Layout.preferredWidth: Style.hspan(3.5)
            font.pixelSize: TritonStyle.fontSizeS
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter

            opacity: root.enabled ? 0.6 : 0.2
            visible: root.secondaryText
            color: root.enabled ? TritonStyle.contrastColor : TritonStyle.disabledTextColor
        }

        // additional margins when rightTool is not available.
        Item {
            implicitWidth: !rightTool.symbol && secondaryText.text ? Style.hspan(0.6) : 0
            implicitHeight: !rightTool.symbol && secondaryText.text ? root.height : 0
        }

        Tool {
            id: rightTool
            implicitWidth: rightTool.symbol ? Style.hspan(2) : 0
            implicitHeight: rightTool.symbol ? root.height : 0
            baselineOffset: 0
            onClicked: root.rightToolClicked()
        }
    }

    Image {
        width: root.width
        anchors.bottom: root.bottom
        source: Style.gfx2("list-divider")
        visible: root.dividerVisible
    }
}
