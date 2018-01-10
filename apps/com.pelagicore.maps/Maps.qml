/****************************************************************************
**
** Copyright (C) 2017-2018 Pelagicore AG
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
import QtPositioning 5.8
import QtLocation 5.9

import utils 1.0

import com.pelagicore.styles.triton 1.0

Item {
    id: root

    function fetchCurrentLocation() { // PositionSource doesn't work on Linux
        var req = new XMLHttpRequest;
        req.open("GET", "https://location.services.mozilla.com/v1/geolocate?key=geoclue");
        req.onreadystatechange = function() {
            if (req.readyState === XMLHttpRequest.DONE) {
                var objectArray = JSON.parse(req.responseText);
                if (objectArray.errors !== undefined) {
                    console.info("Error fetching location:", objectArray.errors[0].message);
                } else {
                    priv.positionCoordinate = QtPositioning.coordinate(objectArray.location.lat, objectArray.location.lng);
                    console.info("Current location:", priv.positionCoordinate);
                }
            }
        }
        req.send();
    }

    function zoomIn() {
        mainMap.zoomLevel += 1.0;
    }

    function zoomOut() {
        mainMap.zoomLevel -= 1.0;
    }

    QtObject {
        id: priv
        property var positionCoordinate: QtPositioning.coordinate(49.5938686, 17.2508706) // Olomouc ;)
        Behavior on positionCoordinate { CoordinateAnimation {} }
    }

    Plugin {
        id: osmPlugin
        name: "osm"
        locales: Style.languageLocale
        PluginParameter { name: "osm.useragent"; value: "Triton UI" }
        PluginParameter { name: "osm.mapping.highdpi_tiles"; value: true }
    }

    GeocodeModel {
        id: geocodeModel
        plugin: osmPlugin
        onLocationsChanged: {
            if (count > 0) {
                var location = get(0); // TODO implement presenting the other results? this just takes the first one
                priv.positionCoordinate = location.coordinate;
                if (location.boundingBox.isValid) {
                    mainMap.visibleRegion = location.boundingBox;
                }
            }
        }
    }

    Map {
        id: mainMap
        anchors.fill: parent
        plugin: osmPlugin
        center: priv.positionCoordinate
        zoomLevel: 13
        gesture {
            enabled: true
            // effectively disable the rotation gesture
            acceptedGestures: MapGestureArea.PanGesture | MapGestureArea.PinchGesture | MapGestureArea.FlickGesture
        }

        copyrightsVisible: false // customize the default (c) appearance below in MapCopyrightNotice

        onErrorChanged: {
            console.warn("Map error:", error, errorString)
        }

        onMapReadyChanged: {
            if (mapReady) {
                console.info("Supported map types:");
                for (var i = 0; i < supportedMapTypes.length; i++) {
                    var map = supportedMapTypes[i];
                    console.info("\t", map.name, ", description:", map.description, ", style:", map.style, ", night mode:", map.night);
                }

                // TODO choose a suitable night map when the theme changes to Dark

                fetchCurrentLocation();
            }
        }
    }

    Item {
        id: header
        anchors.left: parent.left
        anchors.leftMargin: Style.hspan(1)
        anchors.right: parent.right
        anchors.rightMargin: root.state !== "Maximized" ? Style.hspan(1.5) : 0
        anchors.top: parent.top
        anchors.topMargin: Style.vspan(.3)

        RowLayout {
            anchors.fill: parent
            spacing: Style.hspan(1)
            Label {
                text: qsTr("Where do you wanna go today?")
            }
            TextField {
                id: searchField
                Layout.fillWidth: true
                onAccepted: {
                    geocodeModel.query = searchField.text;
                    geocodeModel.update();
                }
                BusyIndicator {
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    running: geocodeModel.status == GeocodeModel.Loading
                    visible: running
                }
            }
        }
    }

    ToolButton {
        id: zoomInBtn
        anchors {
            right: mainMap.right
            top: header.bottom
            topMargin: Style.vspan(.5)
        }
        text: "＋"
        font.pixelSize: TritonStyle.fontSizeL
        enabled: mainMap.zoomLevel + 1 <= mainMap.maximumZoomLevel
        onClicked: zoomIn()
    }

    ToolButton {
        id: zoomOutBtn
        anchors {
            right: mainMap.right
            top: zoomInBtn.bottom
        }
        text: "－"
        font.pixelSize: TritonStyle.fontSizeL
        enabled: mainMap.zoomLevel - 1 >= mainMap.minimumZoomLevel
        onClicked: zoomOut()
    }

    MapCopyrightNotice {
        anchors.left: mainMap.left
        anchors.bottom: mainMap.bottom
        anchors.leftMargin: Style.hspan(.5)
        mapSource: mainMap
        styleSheet: "* { color: '%1'; font-family: '%2'; font-size: %3px}"
        .arg(TritonStyle.primaryTextColor).arg(TritonStyle.fontFamily).arg(TritonStyle.fontSizeXS)
    }
}
