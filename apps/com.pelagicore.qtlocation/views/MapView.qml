/****************************************************************************
**
** Copyright (C) 2017-2018 Pelagicore AG
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

import QtQuick 2.8
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtPositioning 5.9
import QtLocation 5.9
import QtGraphicalEffects 1.0

import Qt.labs.platform 1.0

import utils 1.0
import controls 1.0 as NeptuneControls
import animations 1.0

import com.pelagicore.styles.neptune 3.0

import "../controls"
import "../panels"
import "../stores"
import "../helpers"

Item {
    id: root

    property bool offlineMapsEnabled
    onOfflineMapsEnabledChanged: getAvailableMapsAndLocation()

    property MapStore store

    // props for secondary window
    property alias mapInteractive: mapBoxView.mapInteractive
    property alias mapCenter: mapBoxView.center
    property alias mapZoomLevel: mapBoxView.zoomLevel
    property alias mapTilt: mapBoxView.tilt
    property alias mapBearing: mapBoxView.bearing
    readonly property alias mapReady: mapBoxView.mapReady
    readonly property alias currentLocation: priv.positionCoordinate

    property bool searchViewEnabled: false
    property Helper helper: Helper {}

    signal maximizeMap()

    Component.onCompleted: {
        root.store.homeCoord = mapBoxView.mapHeader.homeAddressData;
        root.store.workCoord = mapBoxView.mapHeader.workAddressData;
    }

    onStateChanged: root.searchViewEnabled = false;

    function fetchCurrentLocation() { // PositionSource doesn't work on Linux
        var req = new XMLHttpRequest;
        req.onreadystatechange = function() {
            if (req.readyState === XMLHttpRequest.DONE) {
                var objectArray = JSON.parse(req.responseText);
                if (objectArray.errors !== undefined) {
                    console.warn("Error fetching location:", objectArray.errors[0].message);
                } else {
                    priv.positionCoordinate = QtPositioning.coordinate(objectArray.location.lat, objectArray.location.lng);
                    console.info("Current location:", priv.positionCoordinate);
                }
            }
        }
        req.open("GET", "https://location.services.mozilla.com/v1/geolocate?key=geoclue");
        req.send();
    }

    function getAvailableMapsAndLocation() {
        if (mapBoxView.mapReady) {
            mapTypeModel.clear();
            console.info("Supported map types:");
            for (var i = 0; i < mapBoxView.supportedMapTypes.length; i++) {
                var map = mapBoxView.supportedMapTypes[i];
                mapTypeModel.append({"name": map.name, "data": map}) // fill the map type model
                console.info("\t", map.name, ", description:", map.description, ", style:", map.style, ", night mode:", map.night);
            }
            if (!root.offlineMapsEnabled) {
                fetchCurrentLocation();
            }
        }
    }

    function getMapType(name) {
        if (!mapBoxView.mapReady || !mapTypeModel.count) {
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
        property var positionCoordinate: offlineMapsEnabled ? QtPositioning.coordinate(57.709912, 11.966632) // Gothenburg
                                                            : QtPositioning.coordinate(49.5938686, 17.2508706) // Olomouc
        property var originalPosition: positionCoordinate
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

        readonly property string cacheDirUrl: StandardPaths.writableLocation(StandardPaths.CacheLocation);

        // Mapbox Plugin Parameters
        PluginParameter {
            name: "mapboxgl.access_token"
            value: "pk.eyJ1IjoicXRhdXRvIiwiYSI6ImNqY20wbDZidzBvcTQyd3J3NDlkZ21jdjUifQ.4KYDlP7UmQEVPYffr6VuVQ"
        }
        PluginParameter {
            name: "mapboxgl.mapping.additional_style_urls"
            value: [priv.defaultLightThemeId, priv.defaultDarkThemeId].join(",")
        }

        // OSM Plugin Parameters
        PluginParameter { name: "osm.useragent"; value: "Neptune UI" }

        // Offline maps support
        PluginParameter { name: "mapboxgl.mapping.cache.directory";
            // needs to be an absolute filepath so strip the file:/// protocol; several leading slashes don't matter
            value: mapPlugin.cacheDirUrl.toString().substring(mapPlugin.cacheDirUrl.indexOf(':')+1) }
    }

    // This is needed since MapBox plugin does not support geocoding yet. TODO: find a better way to support geocoding.
    Plugin {
        id: geocodePlugin
        name: "osm"
        locales: Style.languageLocale

        // OSM Plugin Parameters
        PluginParameter { name: "osm.useragent"; value: "Neptune UI" }
    }

    GeocodeModel {
        id: geocodeModel
        plugin: geocodePlugin
        limit: 20
    }

    MapBoxPanel {
        id: mapBoxView
        anchors.fill: parent
        plugin: mapPlugin
        center: priv.positionCoordinate
        state: root.state
        currentLocation: priv.positionCoordinate
        offlineMapsEnabled: root.offlineMapsEnabled
        destination: root.store.destination
        model: root.store.model
        routeDistance: root.store.routeDistance
        routeTime: root.store.routeTime
        routeSegments: root.store.routeSegments
        homeRouteTime: root.store.homeRouteTime
        workRouteTime: root.store.workRouteTime
        destCoord: root.store.destCoord

        activeMapType: {
            if (!mapReady || plugin.name !== "mapboxgl") {
                return supportedMapTypes[0];
            }
            return NeptuneStyle.theme === NeptuneStyle.Light ? getMapType(priv.defaultLightThemeId) : getMapType(priv.defaultDarkThemeId);
        }
        onOpenSearchTextInput: {
            root.maximizeMap();
            searchViewEnabled = true;
        }
        onStartNavigationRequested: {
            priv.originalPosition = priv.positionCoordinate;
        }
        onShowRouteRequested: {
            priv.originalPosition = priv.positionCoordinate;
            root.store.destCoord = destCoord;
            root.store.destination = description;
            root.store.startCoord = mapBoxView.currentLocation;
        }
        onStopNavigationRequested: {
            priv.positionCoordinate = priv.originalPosition;
            mapBoxView.center = priv.positionCoordinate;
        }

        onMapReadyChanged: getAvailableMapsAndLocation();
        onMaximizeMap: root.maximizeMap();
        Component.onCompleted: {
            root.store.routingPlugin = geocodePlugin
        }
    }

    NeptuneControls.Tool {
        anchors.left: parent.left
        anchors.leftMargin: NeptuneStyle.dp(27)
        anchors.top: parent.top
        anchors.topMargin: NeptuneStyle.dp(48)
        opacity: root.state === "Widget1Row" ? 1 : 0
        Behavior on opacity { DefaultNumberAnimation {} }
        visible: opacity > 0
        symbol: Qt.resolvedUrl("../assets/ic-search.png")
        width: NeptuneStyle.dp(background.sourceSize.width)
        height: width
        background: Image {
            fillMode: Image.PreserveAspectFit
            source: helper.localAsset("floating-button-bg", NeptuneStyle.theme)
        }
        onClicked: root.maximizeMap()
    }

    FastBlur {
        anchors.fill: mapBoxView
        source: mapBoxView
        radius: NeptuneStyle.dp(64)
        visible: searchViewEnabled
    }

    NeptuneControls.ScalableBorderImage {
        id: overlay
        anchors.fill: root
        border.top: NeptuneStyle.dp(322)
        border.bottom: NeptuneStyle.dp(323)
        border.left: 0
        border.right: 0
        source: Style.gfx2("input-overlay")
        visible: searchViewEnabled
    }

    SearchOverlayPanel {
        id: searchOverlay
        anchors.fill: root
        anchors.topMargin: NeptuneStyle.dp(80)
        visible: searchViewEnabled
        spacing: NeptuneStyle.dp(80)
        model: geocodeModel

        onBackButtonClicked: searchViewEnabled = false

        onSearchFieldAccepted: {
            geocodeModel.query = searchOverlay.searchQuery;
            geocodeModel.update();
            searchViewEnabled = false;
        }

        onSearchQueryChanged: {
            geocodeModel.reset();
            geocodeModel.query = searchQuery;
            geocodeModel.update();
        }

        onEscapePressed: searchViewEnabled = false

        onItemClicked: {
            searchViewEnabled = false;
            mapBoxView.center = coordinate;
            root.store.startCoord = priv.positionCoordinate;
            root.store.destCoord = coordinate;
            root.store.destination = addressText;
            if (boundingBox.isValid) {
                mapBoxView.visibleRegion = boundingBox;
            }
            mapBoxView.navigationMode = true;
        }
    }
}
