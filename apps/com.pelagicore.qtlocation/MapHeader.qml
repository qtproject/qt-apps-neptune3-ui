/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AB
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
import QtPositioning 5.9

import utils 1.0
import com.pelagicore.styles.triton 1.0
import controls 1.0 as TritonControls
import animations 1.0

Item {
    id: root

    height: offlineMapsEnabled ? 0 : backgroundImage.height

    property bool offlineMapsEnabled
    property bool navigationMode
    property bool guidanceMode
    property var currentLocation
    property var routingBackend

    readonly property alias homeCoord: buttonGoHome.addressData
    readonly property alias workCoord: buttonGoWork.addressData

    signal showRoute(var destCoord, string description)
    signal startNavigation()
    signal stopNavigation()
    signal openSearchTextInput()

    Image {
        id: backgroundImage
        height: secondRow.visible ? sourceSize.height : sourceSize.height/2
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: root.state === "Widget1Row" ? -root.height : (root.state === "Widget2Rows" ? -root.height/2 : 0 )
        Behavior on anchors.topMargin { DefaultNumberAnimation {} }
        fillMode: Image.TileHorizontally
        source: Qt.resolvedUrl("assets/navigation-widget-overlay-top.png")
    }

    Row {
        id: firstRow
        anchors.top: parent.top
        anchors.topMargin: Style.vspan(.4)
        anchors.horizontalCenter: parent.horizontalCenter
        width: root.width - Style.hspan(2)
        spacing: Style.hspan(.5)

        Column {
            width: parent.width / 2
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: Style.hspan(1)

            Label {
                width: root.navigationMode ? parent.width : parent.width/2
                wrapMode: Text.WordWrap
                maximumLineCount: 2
                elide: Label.ElideRight
                font.pixelSize: Style.fontSizeS
                text: root.navigationMode ? routingBackend.destination : qsTr("Where do you wanna go today?")
            }
            Label {
                width: parent.width
                maximumLineCount: 2
                elide: Label.ElideRight
                font.pixelSize: Style.fontSizeXS
                text: "%1 · %2".arg(routingBackend.routeDistance).arg(routingBackend.routeTime)
                visible: root.navigationMode
            }
        }

        Button {
            id: searchButton
            width: parent.width / 2
            height: parent.height
            scale: pressed ? 1.1 : 1.0
            Behavior on scale { NumberAnimation { duration: 50 } }
            visible: !root.navigationMode

            background: Rectangle {
                color: "lightgray"
                radius: height / 2
            }
            contentItem: Item {
                Row {
                    anchors.centerIn: parent
                    spacing: Style.hspan(0.3)
                    Image {
                        anchors.verticalCenter: parent.verticalCenter
                        fillMode: Image.Pad
                        source: Qt.resolvedUrl("assets/ic-search.png")
                    }
                    Label {
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("Search")
                        font.pixelSize: Style.fontSizeS
                    }
                }
            }
            onClicked: root.openSearchTextInput()
        }

        Button {
            id: startNavigationButton
            width: parent.width / 2 - cancelNavButton.width - firstRow.spacing
            height: parent.height
            scale: pressed ? 1.1 : 1.0
            Behavior on scale { NumberAnimation { duration: 50 } }
            visible: root.navigationMode
            enabled: !root.guidanceMode

            background: Rectangle {
                color: "lightgray"
                radius: height / 2
            }

            contentItem: Item {
                Row {
                    anchors.centerIn: parent
                    spacing: Style.hspan(0.3)
                    Image {
                        anchors.verticalCenter: parent.verticalCenter
                        fillMode: Image.Pad
                        source: Qt.resolvedUrl("assets/ic-start-navigation.png")
                        opacity: startNavigationButton.enabled ? 1.0 : 0.3
                    }
                    Label {
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("Start Navigation")
                        font.pixelSize: Style.fontSizeS
                    }
                }
            }
            onClicked: root.startNavigation()
        }

        TritonControls.Tool {
            id: cancelNavButton

            width: height
            height: parent.height
            visible: root.navigationMode

            background: Rectangle {
                color: "lightgray"
                radius: height / 2
            }

            symbol: Qt.resolvedUrl("assets/ic-end-route.png")
            onClicked: root.stopNavigation()
        }
    }

    RowLayout {
        id: secondRow
        anchors.top: firstRow.bottom
        anchors.left: parent.left
        anchors.leftMargin: Style.hspan(1)
        anchors.right: parent.right
        anchors.rightMargin: Style.hspan(1.5)
        opacity: root.state === "Widget3Rows" || root.state === "Maximized" ? 1 : 0
        Behavior on opacity {
            SequentialAnimation {
                PauseAnimation { duration: 180 }
                DefaultNumberAnimation {}
            }
        }
        visible: opacity > 0 && !root.navigationMode
        height: parent.height/2
        MapToolButton {
            id: buttonGoHome
            Layout.preferredWidth: secondRow.width/2
            anchors.verticalCenter: parent.verticalCenter
            iconSource: Qt.resolvedUrl("assets/ic-home.png")
            primaryText: qsTr("Home")
            extendedText: routingBackend.homeRouteTime
            secondaryText: "Welandergatan 29"
            // TODO make the home location configurable and dynamic
            readonly property var addressData: QtPositioning.coordinate(57.706436, 12.018661)
            onClicked: root.showRoute(addressData, secondaryText)
        }
        Rectangle {
            width: 1
            height: 150
            opacity: 0.2
            color: TritonStyle.primaryTextColor
        }
        MapToolButton {
            id: buttonGoWork
            Layout.preferredWidth: secondRow.width/2
            anchors.verticalCenter: parent.verticalCenter
            iconSource: Qt.resolvedUrl("assets/ic-work.png")
            primaryText: qsTr("Work")
            extendedText: routingBackend.workRouteTime
            secondaryText: "Östra Hamngatan 16"
            // TODO make the work location configurable and dynamic
            readonly property var addressData: QtPositioning.coordinate(57.709545, 11.967005)
            onClicked: root.showRoute(addressData, secondaryText)
        }
    }
}
