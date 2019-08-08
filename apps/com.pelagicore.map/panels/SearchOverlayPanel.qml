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
import QtQuick.Layouts 1.3
import QtLocation 5.9

import shared.controls 1.0
import shared.utils 1.0
import shared.Sizes 1.0

import "../controls" 1.0

ColumnLayout {
    id: root

    property GeocodeModel model

    spacing: Sizes.dp(80)

    signal backButtonClicked()
    signal searchFieldAccepted()
    signal escapePressed()
    signal searchQueryChanged(string searchQuery)
    signal itemClicked(int index, string addressText, var coordinate, var boundingBox)

    ToolButton {
        Layout.alignment: Qt.AlignLeft
        Layout.leftMargin: Sizes.dp(45)
        Layout.rightMargin: Sizes.dp(45)
        icon.name: LayoutMirroring.enabled ? "ic_forward" : "ic_back"
        text: qsTr("Back")
        onClicked: root.backButtonClicked()
    }

    MapSearchTextField {
        id: searchField
        Layout.leftMargin: Sizes.dp(90)
        Layout.rightMargin: Sizes.dp(90)
        Layout.fillWidth: true

        selectByMouse: true
        focus: root.visible
        busy: root.model.status === GeocodeModel.Loading
        onTextChanged: {
            if (searchField.text.length > 1) {
                searchTimer.restart();
            } else {
                searchTimer.stop();
            }
        }
        onAccepted: root.searchFieldAccepted()
        Keys.onEscapePressed: root.escapePressed()
    }

    ListView {
        id: searchResultsList
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.leftMargin: Sizes.dp(90)
        Layout.rightMargin: Sizes.dp(90)
        clip: true
        visible: root.visible
        model: root.model
        delegate: ListItem {
            id: itemDelegate
            width: parent.width
            height: Sizes.dp(120)
            readonly property string addressText: locationData.address.text
            readonly property string city: locationData.address.city
            readonly property string country: locationData.address.country
            text: addressText
            subText: itemDelegate.city !== "" ? itemDelegate.city + ", " + itemDelegate.country : itemDelegate.country;
            onClicked: {
                root.itemClicked(index, itemDelegate.addressText, locationData.coordinate, locationData.boundingBox)
            }
        }
        ScrollIndicator.vertical: ScrollIndicator {}
    }

    Timer {
        id: searchTimer
        interval: 500
        onTriggered: {
            root.searchQueryChanged(searchField.text)
        }
    }
}
