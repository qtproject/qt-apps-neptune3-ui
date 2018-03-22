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
import QtLocation 5.9

import controls 1.0
import utils 1.0
import com.pelagicore.styles.neptune 3.0

import "../helpers"
import "../controls"

ColumnLayout {
    id: root

    property GeocodeModel model

    spacing: Style.vspan(1)

    signal backButtonClicked()
    signal searchFieldAccepted()
    signal escapePressed()
    signal searchQueryChanged(var searchQuery)
    signal itemClicked(var index, string addressText, var coordinate, var boundingBox)

    Tool {
        anchors.left: parent.left
        anchors.leftMargin: Style.hspan(1)
        symbol: Style.symbol("ic_back")
        text: qsTr("Back")
        onClicked: root.backButtonClicked()
    }

    MapSearchTextField {
        id: searchField
        anchors.left: parent.left
        anchors.leftMargin: Style.hspan(2)
        anchors.right: parent.right
        anchors.rightMargin: Style.hspan(2)
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
        anchors.left: parent.left
        anchors.leftMargin: Style.hspan(2)
        anchors.right: parent.right
        anchors.rightMargin: Style.hspan(2)
        clip: true
        visible: root.visible
        model: root.model
        delegate: ListItem {
            id: itemDelegate
            width: parent.width
            height: Style.vspan(1.5)
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
