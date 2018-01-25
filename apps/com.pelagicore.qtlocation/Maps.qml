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
import QtPositioning 5.9
import QtLocation 5.9
import QtGraphicalEffects 1.0

import utils 1.0
import controls 1.0 as TritonControls
import animations 1.0

import com.pelagicore.styles.triton 1.0

Item {
    id: root

    // props for secondary window
    property alias mapInteractive: mainMap.mapInteractive
    property alias mapCenter: mainMap.center
    property alias mapZoomLevel: mainMap.zoomLevel
    property alias mapTilt: mainMap.tilt
    property alias mapBearing: mainMap.bearing
    readonly property alias mapReady: mainMap.mapReady

    property bool searchViewEnabled: false

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
        readonly property var plugins: ["mapboxgl", "osm"]
        property var positionCoordinate: QtPositioning.coordinate(49.5938686, 17.2508706) // Olomouc ;)
        readonly property string defaultLightThemeId: "mapbox://styles/qtauto/cjcm1by3q12dk2sqnquu0gju9"
        readonly property string defaultDarkThemeId: "mapbox://styles/qtauto/cjcm1czb812co2sno1ypmp1r8"
    }

    ListModel {
        // lists the various map styles (including the custom ones); filled in Map.onMapReadyChanged
        id: mapTypeModel
    }

    Plugin {
        id: mapPlugin
        locales: Style.languageLocale
        preferred: priv.plugins

        // Mapbox Plugin Parameters
        PluginParameter {
            name: "mapboxgl.access_token"
            // TODO replace this personal token with a collective/company one
            value: "pk.eyJ1IjoicXRhdXRvIiwiYSI6ImNqY20wbDZidzBvcTQyd3J3NDlkZ21jdjUifQ.4KYDlP7UmQEVPYffr6VuVQ"
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
                var location = get(0);
                priv.positionCoordinate = location.coordinate;
                if (location.boundingBox.isValid) {
                    mainMap.visibleRegion = location.boundingBox;
                }
            }
        }
    }

    MapView {
        id: mainMap
        anchors.fill: parent
        plugin: mapPlugin
        center: priv.positionCoordinate
        state: root.state
        activeMapType: {
            if (!mapReady || plugin.name !== "mapboxgl") {
                return supportedMapTypes[0];
            }
            return TritonStyle.theme === TritonStyle.Light ? getMapType(priv.defaultLightThemeId) : getMapType(priv.defaultDarkThemeId);
        }
        onOpenSearchTextInput: {
            //TODO: Show textsearch
            root.maximizeMap()
            searchViewEnabled = true
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
    }

    TritonControls.Tool {
        anchors.left: parent.left
        anchors.leftMargin: Style.hspan(0.6)
        anchors.top: parent.top
        anchors.topMargin: Style.vspan(0.6)
        opacity: root.state === "Widget1Row" ? 1 : 0
        Behavior on opacity { DefaultNumberAnimation {} }
        visible: opacity > 0
        symbol: Qt.resolvedUrl("assets/ic-search.png")
        background: Image {
            fillMode: Image.Pad
            source: Qt.resolvedUrl("assets/floating-button-bg.png")
        }
        onClicked: root.maximizeMap()
        Behavior on opacity { DefaultNumberAnimation {}}
    }

    Image {
        id: overlay
        anchors.fill: mainMap
        source: Style.gfx2("input-overlay")
        visible: searchViewEnabled
    }

    FastBlur {
        anchors.fill: mainMap
        source: mainMap
        radius: 50
        visible: searchViewEnabled
    }

    Item {
        id: mapSearchField
        anchors.top: mainMap.top
        anchors.topMargin: Style.vspan(0.5)
        anchors.left: mainMap.left
        anchors.leftMargin: Style.hspan(1)
        anchors.right: mainMap.right
        anchors.rightMargin: Style.hspan(1)
        width: mainMap.width
        height: Style.hspan(1.2)
        visible: searchViewEnabled
        MapSearchTextField {
            id: searchField
            anchors.fill: parent
            selectByMouse: true
            focus: searchViewEnabled
            onAccepted: {
                geocodeModel.query = searchField.text;
                geocodeModel.update();
                searchViewEnabled = false;
            }
            BusyIndicator {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                running: geocodeModel.status == GeocodeModel.Loading
                visible: running
            }
            Keys.onEscapePressed: searchViewEnabled = false
        }
    }
}
