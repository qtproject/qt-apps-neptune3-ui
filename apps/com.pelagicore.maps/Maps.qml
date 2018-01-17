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
import controls 1.0 as TritonControls
import animations 1.0

import com.pelagicore.styles.triton 1.0

Item {
    id: root

    readonly property var plugins: ["mapboxgl", "osm"]
    property int currentPlugin: 0 // 0: mapboxgl; 1: osm

    signal maximizeMap()

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

    function getMapType(name) {
        if (!mainMap.mapReady || !mapTypeModel.count) {
            return
        }
        for (var i = 0; i < mapTypeModel.count; i++) {
            var map = mapTypeModel.get(i);
            if (map && map.name === name) {
                return map.data;
            }
        }
    }

    QtObject {
        id: priv
        property var positionCoordinate: QtPositioning.coordinate(49.5938686, 17.2508706) // Olomouc ;)
        Behavior on positionCoordinate { CoordinateAnimation {} }
        readonly property string defaultLightThemeId: "mapbox://styles/caybro/cjcg9k4pn66or2rpxxemwy2ub"
        readonly property string defaultDarkThemeId: "mapbox://styles/caybro/cjcgd636468xo2rqqn1mius8h"
    }

    ListModel {
        // lists the various map styles (including the custom ones); filled in Map.onMapReadyChanged
        id: mapTypeModel
    }

    Plugin {
        id: mapPlugin
        locales: Style.languageLocale
        name: plugins[currentPlugin]

        // Mapbox Plugin Parameters
        PluginParameter {
            name: "mapboxgl.access_token"
            // TODO replace this personal token with a collective/company one
            value: "pk.eyJ1IjoiY2F5YnJvIiwiYSI6ImNpczUxZDZnazAwMTMyeXAwZHZ2d2lxZ3kifQ.Pw2IOSDXeujXnbQA5GSDNg"
        }
        PluginParameter {
            name: "mapboxgl.mapping.additional_style_urls"
            value: [priv.defaultLightThemeId, priv.defaultDarkThemeId].join(",")
        }

        // OSM Plugin Parameters
        PluginParameter { name: "osm.useragent"; value: "Triton UI" }
    }

    // This is needed since MapBox plugin does not support geocoding yet. TODO: find a better way to support geocoding.
    Plugin {
        id: geocodePlugin
        name: "osm"
        locales: Style.languageLocale

        // OSM Plugin Parameters
        PluginParameter { name: "osm.useragent"; value: "Triton UI" }
    }

    GeocodeModel {
        id: geocodeModel
        plugin: geocodePlugin
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
        plugin: mapPlugin
        center: priv.positionCoordinate
        zoomLevel: 10
        copyrightsVisible: false // customize the default (c) appearance below in MapCopyrightNotice

        gesture {
            enabled: true
            // effectively disable the rotation gesture
            acceptedGestures: MapGestureArea.PanGesture | MapGestureArea.PinchGesture | MapGestureArea.FlickGesture
        }

        onErrorChanged: {
            console.warn("Map error:", error, errorString)
        }

        onMapReadyChanged: {
            if (mapReady) {
                console.info("Supported map types:");
                for (var i = 0; i < supportedMapTypes.length; i++) {
                    var map = supportedMapTypes[i];
                    mapTypeModel.append({"name": map.name, "data": map}) // fill the map type model
                    console.info("\t", map.name, ", description:", map.description, ", style:", map.style, ", night mode:", map.night);
                }
                fetchCurrentLocation();
            }
        }

        activeMapType: {
            if (!mapReady) {
                return supportedMapTypes[0];
            }
            return TritonStyle.theme == TritonStyle.Light ? getMapType(priv.defaultLightThemeId) : getMapType(priv.defaultDarkThemeId);
        }

        MapParameter {
            type: "source"

            property var name: "routeSource"
            property var sourceType: "geojson"
            property var data: '{ "type": "FeatureCollection", "features": \
                    [{ "type": "Feature", "properties": {}, "geometry": { \
                    "type": "LineString", "coordinates": [[ 24.934938848018646, \
                    60.16830257086771 ], [ 24.943315386772156, 60.16227776476442 ]]}}]}'
        }

        MapParameter {
            type: "layer"

            property var name: "route"
            property var layerType: "line"
            property var source: "routeSource"

            // Draw under the first road label layer
            // of the mapbox-streets style.
            property var before: "road-label-small"
        }

        MapParameter {
            type: "paint"

            property var layer: "route"
            property var lineColor: "blue"
            property var lineWidth: 8.0
        }

        MapParameter {
            type: "layout"

            property var layer: "route"
            property var lineJoin: "round"
            property var lineCap: "round"
        }
    }

    DefaultNumberAnimation {
        id: animationMovement
    }

    TritonControls.Tool {
        anchors.left: parent.left
        anchors.leftMargin: Style.hspan(0.6)
        anchors.top: parent.top
        anchors.topMargin: Style.hspan(0.6)
        opacity: root.state === "Widget1Row" ? 1 : 0
        visible: opacity > 0
        background: Image {
            fillMode: Image.Pad
            source: Qt.resolvedUrl("assets/floating-button-bg.png")
        }
        contentItem: Image {
            fillMode: Image.Pad
            // todo[mh]: check icon with designer
            source: Qt.resolvedUrl("assets/ic-search.png")
        }
        onClicked: root.maximizeMap()
        Behavior on opacity { animation: animationMovement }
    }

    Image {
        id: header
        visible: root.state !== "Widget1Row"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: root.state === "Widget2Rows" ? -header.sourceSize.height/2 : 0

        fillMode: Image.TileHorizontally
        source: "assets/navigation-widget-overlay-top.png"

        RowLayout {
            id: firstRow
            anchors.top: parent.top
            anchors.topMargin: root.state === "Widget2Rows" ? header.sourceSize.height/2 + Style.vspan(.3) : Style.vspan(.3)
            anchors.left: parent.left
            anchors.leftMargin: Style.hspan(1)
            anchors.right: parent.right
            anchors.rightMargin: Style.hspan(1.5)
            Item {
                Layout.preferredWidth: firstRow.width/2
                Layout.fillWidth: true
                anchors.verticalCenter: parent.verticalCenter
                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    width: parent.width/2
                    wrapMode: Text.WordWrap
                    font.pixelSize: Style.fontSizeS
                    text: qsTr("Where do you wanna go today?")
                }
            }
            MapSearchTextField {
                id: searchField
                Layout.preferredWidth: firstRow.width/2
                selectByMouse: true
                Layout.fillWidth: true
                anchors.verticalCenter: parent.verticalCenter
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
        RowLayout {
            id: secondRow
            anchors.top: firstRow.bottom
            anchors.left: parent.left
            anchors.leftMargin: Style.hspan(1)
            anchors.right: parent.right
            anchors.rightMargin: Style.hspan(1.5)
            visible: (root.state == "Widget3Rows") || (root.state == "Maximized")
            height: parent.height/2
            MapToolButton {
                Layout.preferredWidth: secondRow.width/2
                Layout.fillWidth: true
                anchors.verticalCenter: parent.verticalCenter
                iconSource: Qt.resolvedUrl("assets/ic-home.png")
                text: qsTr("Home")
                extendedText: "17 min"
                secondaryText: "Welandergatan 29"
            }
            MapToolButton {
                Layout.preferredWidth: secondRow.width/2
                Layout.fillWidth: true
                anchors.verticalCenter: parent.verticalCenter
                iconSource: Qt.resolvedUrl("assets/ic-work.png")
                text: qsTr("Work")
                extendedText: "23 min"
                secondaryText: "Östra Hamngatan 20"
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
        .arg(TritonStyle.primaryTextColor).arg(TritonStyle.fontFamily).arg(TritonStyle.fontSizeXXS)
    }
}
