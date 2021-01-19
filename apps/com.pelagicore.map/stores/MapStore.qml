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

import QtQuick 2.8
import QtApplicationManager.Application 2.0
import QtPositioning 5.9
import QtLocation 5.9
import Qt.labs.platform 1.0
import shared.utils 1.0
import shared.com.pelagicore.systeminfo 1.0

QtObject {
    id: root

    readonly property alias model: routeModel
    property string routeDistance
    property string routeTime
    property string homeRouteTime
    property string workRouteTime
    property bool searchViewEnabled: false
    property bool offlineMapsEnabled: false
    onOfflineMapsEnabledChanged: {
        //Fetch again here as this usually changes to false after
        //the getAvailableMapsAndLocation() function is executed.
        if (!root.offlineMapsEnabled) {
            fetchCurrentLocation();
        }
    }

    readonly property SystemInfo systemInfo: SystemInfo {}
    readonly property bool allowMapRendering: sysinfo.allowOpenGLContent

    property var positionCoordinate: QtPositioning.coordinate(48.135771, 11.574052) // Munich
    property var originalPosition: positionCoordinate
    readonly property string defaultLightThemeId: "mapbox://styles/qtauto/cjcm1by3q12dk2sqnquu0gju9"
    readonly property string defaultDarkThemeId: "mapbox://styles/qtauto/cjcm1czb812co2sno1ypmp1r8"

    property var currentLocationCoord
    property var homeCoord
    property var workCoord

    property var startCoord: QtPositioning.coordinate()
    property var destCoord: QtPositioning.coordinate()
    property string destination

    property alias mainMapCenter: navigationStore.mapCenter
    property alias mainMapZoomLevel: navigationStore.mapZoomLevel
    property alias mainMapTilt: navigationStore.mapTilt
    property alias mainMapBearing: navigationStore.mapBearing
    property alias navigationDemoActive: navigationStore.active
    readonly property var navigationStore: NavigationStore {
        id: navigationStore
        model: root.routeModel
    }

    readonly property IntentHandler intentHandler: IntentHandler {
        intentIds: ["show-destination", "activate-app"]
        onRequestReceived: {
            switch (request.intentId) {
            case "show-destination":
                var destinationName  = request.parameters["destination"];
                if (!!destinationName && destinationName.length > 0) {
                    root.destination = destinationName;
                    requestGeoCodeModel.reset();
                    requestGeoCodeModel.query = destinationName;
                    requestGeoCodeModel.update();
                }
                break;

            case "activate-app":
                root.requestRaiseAppReceived();
                break;
            default:
                break;
            }
        }
    }

    property GeocodeModel requestGeoCodeModel: GeocodeModel {
        plugin: herePlugin
        limit: 20
        onCountChanged: {
            if (count > 0) {
                root.requestNavigationReceived(get(0).address.text, get(0).coordinate, get(0).boundingBox);
            }
        }
    }

    readonly property Plugin herePlugin: Plugin {
        name: "here";
        locales: Config.languageLocale
        PluginParameter { name: "here.app_id"; value: "g98JIvGyhYloA79p8e7O" }
        PluginParameter { name: "here.token"; value: "KBpimsQlfj7yTILmIr1-Pw" }
    }

    signal requestNavigationReceived(string address, var coord, var boundingBox)
    signal requestRaiseAppReceived()

    function fetchCurrentLocation() { // PositionSource doesn't work on Linux
        var req = new XMLHttpRequest;
        req.onreadystatechange = function() {
            if (req.readyState === XMLHttpRequest.DONE) {
                var objectArray = JSON.parse(req.responseText);
                if (objectArray.errors !== undefined) {
                    console.warn(qLcMaps, "Error fetching location:", objectArray.errors[0].message);
                } else {
                    root.positionCoordinate = QtPositioning.coordinate(objectArray.location.lat, objectArray.location.lng);
                    console.info(qLcMaps, "Current location:", root.positionCoordinate);
                }
            }
        }
        req.open("GET", "https://location.services.mozilla.com/v1/geolocate?key=geoclue");
        req.send();
    }

    function getAvailableMapsAndLocation(mapReady, supportedMapTypes) {
        if (mapReady) {
            mapTypeModel.clear();
            console.info(qLcMaps, "Supported map types:");
            for (var i = 0; i < supportedMapTypes.length; i++) {
                var map = supportedMapTypes[i];
                mapTypeModel.append({"name": map.name, "data": map}) // fill the map type model
                console.info(qLcMaps, "\t", map.name, ", description:", map.description, ", style:", map.style, ", night mode:", map.night);
            }
            if (!root.offlineMapsEnabled) {
                fetchCurrentLocation();
            }
        }
    }

    function getMapType(mapBoxPanelReady, name) {
        if (!mapBoxPanelReady || !mapTypeModel.count) {
            return
        }
        for (var i = 0; i < mapTypeModel.count; i++) {
            var map = mapTypeModel.get(i);
            if (map && map.name === name) {
                return map.data;
            }
        }
    }

    function formatMeters(meters) {
        return qsTr("%n kilometer(s)", "", meters/1000)
    }

    function formatSeconds(seconds) {
        const numdays = Math.floor((seconds % 31536000) / 86400)
        const numhours = Math.floor(((seconds % 31536000) % 86400) / 3600)
        const numminutes = Math.ceil((((seconds % 31536000) % 86400) % 3600) / 60)

        var result = "";
        if (numdays > 0)
            result += qsTr("%n day(s)", "", numdays) + ", ";
        if (numhours > 0)
            result += qsTr("%n hour(s)", "", numhours) + ", ";
        if (numminutes > 0)
            result += qsTr("%n minute(s)", "", numminutes);

        return result;
    }

    // lists the various map styles (including the custom ones); filled in Map.onMapReadyChanged
    readonly property ListModel mapTypeModel: ListModel { }

    readonly property Plugin mapPlugin: Plugin {
        preferred: ["mapboxgl", "osm"]
        locales: Config.languageLocale

        readonly property string cacheDirUrl: StandardPaths.writableLocation(StandardPaths.CacheLocation);

        // OSM Plugin Parameters
        PluginParameter { name: "osm.useragent"; value: "Neptune UI" }

        // Mapbox Plugin Parameters
        PluginParameter {
            name: "mapboxgl.access_token"
            value: "pk.eyJ1IjoicXRhdXRvIiwiYSI6ImNqY20wbDZidzBvcTQyd3J3NDlkZ21jdjUifQ.4KYDlP7UmQEVPYffr6VuVQ"
        }
        PluginParameter {
            name: "mapboxgl.mapping.additional_style_urls"
            value: [root.defaultLightThemeId, root.defaultDarkThemeId].join(",")
        }

        // Offline maps support
        PluginParameter {
            name: "mapboxgl.mapping.cache.size";
            value: "50 MiB"
        }
        PluginParameter {
            name: "mapboxgl.mapping.cache.directory";
            value: mapPlugin.cacheDirUrl.toString().substring(mapPlugin.cacheDirUrl.indexOf(':')+1)
        }
    }

    readonly property GeocodeModel geocodeModel: GeocodeModel {
        plugin: herePlugin
        onStatusChanged: {
            if (status === GeocodeModel.Null) {
                console.info(qLcMaps, "Search model idle");
            } else if (status === GeocodeModel.Ready) {
                console.info(qLcMaps, "Search model ready, results:", count)
            } else if (status === GeocodeModel.Loading) {
                console.info(qLcMaps, "Search model busy");
            } else if (status === GeocodeModel.Error) {
                console.warn(qLcMaps, "Search model error:", error, errorString);
            }
        }
        limit: 20
    }

    readonly property RouteModel routeModel: RouteModel {
        id: routeModel
        autoUpdate: !!root.startCoord && !!root.destCoord
        query: RouteQuery {
            waypoints: root.startCoord.isValid && root.destCoord.isValid
                       ? [root.startCoord, root.destCoord]
                       : []
        }
        plugin: herePlugin

        onStatusChanged: {
            if (status === RouteModel.Null) {
                console.info(qLcMaps, "Route model idle");
            } else if (status === RouteModel.Ready) {
                console.info(qLcMaps, "Route model ready, results:", count)
                if (count > 0) {
                    root.routeDistance = formatMeters(get(0).distance);
                    root.routeTime = formatSeconds(get(0).travelTime);
                    console.info(qLcMaps, "Route distance (km):", root.routeDistance
                                 , ", time:", root.routeTime);
                    console.info(qLcMaps, "First coord:", get(0).segments[0].path[0])
                }
            } else if (status === RouteModel.Loading) {
                console.info(qLcMaps, "Route model busy");
            } else if (status === RouteModel.Error) {
                console.warn(qLcMaps, "Route model error:", error, errorString);
            }
        }
    }

    readonly property RouteModel homeRouteModel: RouteModel {
        autoUpdate: !!root.currentLocationCoord && !!root.homeCoord
        query: RouteQuery {
            waypoints: root.currentLocationCoord.isValid && root.homeCoord.isValid
                       ? [root.currentLocationCoord, root.homeCoord]
                       : []
        }
        plugin: herePlugin

        onStatusChanged: {
            if (status === RouteModel.Ready) {
                if (count > 0) {
                    root.homeRouteTime = formatSeconds(get(0).travelTime);
                    console.info(qLcMaps, "Home route distance (km):", formatMeters(get(0).distance), ", time:", root.homeRouteTime)
                }
            }
        }
    }

    readonly property RouteModel workRouteModel: RouteModel {
        autoUpdate: !!root.currentLocationCoord && !!root.workCoord
        query: RouteQuery {
            waypoints: root.currentLocationCoord.isValid && root.workCoord.isValid
                       ? [root.currentLocationCoord, root.workCoord]
                       : []
        }
        plugin: herePlugin
        onStatusChanged: {
            if (status === RouteModel.Ready) {
                if (count > 0) {
                    root.workRouteTime = formatSeconds(get(0).travelTime);
                    console.info(qLcMaps, "Work route distance (km):", formatMeters(get(0).distance), ", time:", root.workRouteTime)
                }
            }
        }
    }

    property Timer notificationTimer: Timer {
        id: notificationTimer
        interval: 3000
        running: false
        onTriggered: showOfflineMapInfo()
    }

    readonly property LoggingCategory qLcMaps: LoggingCategory {
        name: "shared.com.pelagicore.map"
    }

    function showOfflineNotification() {
        var notification = ApplicationInterface.createNotification();
        notification.summary = qsTr("Offline mode");
        notification.body = qsTr("Search and navigation are not available in offline mode");
        notification.sticky = true;
        notification.show();
        notificationTimer.start();
    }

    function showOfflineMapInfo() {
        var notification = ApplicationInterface.createNotification();
        notification.summary = qsTr("Offline map");
        notification.body = qsTr("Offline Map only available in Light Theme");
        notification.sticky = true;
        notification.show();
    }

    function showOnlineNotification() {
        var notification = ApplicationInterface.createNotification();
        notification.summary = qsTr("Online map");
        notification.body = qsTr("You are now using online map from Mapbox server");
        notification.sticky = true;
        notification.show();
    }
}
