/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AB
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
import QtPositioning 5.9
import QtLocation 5.9
import Qt.labs.platform 1.0
import shared.utils 1.0

QtObject {
    id: root

    readonly property alias model: routeModel
    property string routeDistance
    property string routeTime
    property var routeSegments
    property string homeRouteTime
    property string workRouteTime
    property bool searchViewEnabled: false
    property bool offlineMapsEnabled: false

    property var positionCoordinate: root.offlineMapsEnabled ? QtPositioning.coordinate(57.709912, 11.966632) // Gothenburg
                                                        : QtPositioning.coordinate(49.5938686, 17.2508706) // Olomouc
    property var originalPosition: positionCoordinate
    readonly property string defaultLightThemeId: "mapbox://styles/qtauto/cjcm1by3q12dk2sqnquu0gju9"
    readonly property string defaultDarkThemeId: "mapbox://styles/qtauto/cjcm1czb812co2sno1ypmp1r8"

    property var currentLocationCoord
    property var homeCoord
    property var workCoord

    property var startCoord: QtPositioning.coordinate()
    property var destCoord: QtPositioning.coordinate()
    property string destination

    property var appInterface: Connections {
        target: ApplicationInterface
        onOpenDocument: {
            var request = documentUrl.slice(8, documentUrl.length);
            var dest = "";
            if (request.indexOf("getmeto/") >= 0) {
                dest = request.slice(8, request.length);
                root.destination = dest;
                requestGeoCodeModel.reset();
                requestGeoCodeModel.query = dest;
                requestGeoCodeModel.update();
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
        locales: Style.languageLocale
        PluginParameter { name: "here.app_id"; value: "jC7kvNx3H7lFMuExMDA7" }
        PluginParameter { name: "here.token"; value: "0ehO2fWIAfkyOB5oxL6_cw" }
    }

    signal requestNavigationReceived(string address, var coord, var boundingBox)

    function fetchCurrentLocation() { // PositionSource doesn't work on Linux
        var req = new XMLHttpRequest;
        req.onreadystatechange = function() {
            if (req.readyState === XMLHttpRequest.DONE) {
                var objectArray = JSON.parse(req.responseText);
                if (objectArray.errors !== undefined) {
                    console.warn("Error fetching location:", objectArray.errors[0].message);
                } else {
                    root.positionCoordinate = QtPositioning.coordinate(objectArray.location.lat, objectArray.location.lng);
                    console.info("Current location:", root.positionCoordinate);
                }
            }
        }
        req.open("GET", "https://location.services.mozilla.com/v1/geolocate?key=geoclue");
        req.send();
    }

    function getAvailableMapsAndLocation(mapReady, supportedMapTypes) {
        if (mapReady) {
            mapTypeModel.clear();
            console.info("Supported map types:");
            for (var i = 0; i < supportedMapTypes.length; i++) {
                var map = supportedMapTypes[i];
                mapTypeModel.append({"name": map.name, "data": map}) // fill the map type model
                console.info("\t", map.name, ", description:", map.description, ", style:", map.style, ", night mode:", map.night);
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
        locales: Style.languageLocale

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
        PluginParameter { name: "mapboxgl.mapping.cache.directory";
            // needs to be an absolute filepath so strip the file:/// protocol; several leading slashes don't matter
            value: mapPlugin.cacheDirUrl.toString().substring(mapPlugin.cacheDirUrl.indexOf(':')+1) }
    }

    readonly property GeocodeModel geocodeModel: GeocodeModel {
        plugin: herePlugin
        onStatusChanged: {
            if (status === GeocodeModel.Null) {
                console.info("Search model idle");
            } else if (status === GeocodeModel.Ready) {
                console.info("Search model ready, results:", count)
            } else if (status === GeocodeModel.Loading) {
                console.info("Search model busy");
            } else if (status === GeocodeModel.Error) {
                console.warn("Search model error:", error, errorString);
            }
        }
        limit: 20
    }

    readonly property RouteModel routeModel: RouteModel {
        id: routeModel
        autoUpdate: !!root.startCoord && !!root.destCoord
        query: RouteQuery {
            waypoints: [root.startCoord, root.destCoord]
        }
        plugin: herePlugin

        onStatusChanged: {
            if (status === RouteModel.Null) {
                console.info("Route model idle");
            } else if (status === RouteModel.Ready) {
                console.info("Route model ready, results:", count)
                if (count > 0) {
                    root.routeDistance = formatMeters(get(0).distance);
                    root.routeTime = formatSeconds(get(0).travelTime);
                    root.routeSegments = get(0).segments;
                    console.info("Route distance (km):", root.routeDistance, ", time:", root.routeTime);
                    console.info("First coord:", root.routeSegments[0].path[0])
                }
            } else if (status === RouteModel.Loading) {
                console.info("Route model busy");
            } else if (status === RouteModel.Error) {
                console.warn("Route model error:", error, errorString);
            }
        }
    }

    readonly property RouteModel homeRouteModel: RouteModel {
        autoUpdate: !!root.currentLocationCoord && !!root.homeCoord
        query: RouteQuery {
            waypoints: [root.currentLocationCoord, root.homeCoord]
        }
        plugin: herePlugin

        onStatusChanged: {
            if (status === RouteModel.Ready) {
                if (count > 0) {
                    root.homeRouteTime = formatSeconds(get(0).travelTime);
                    console.info("Home route distance (km):", formatMeters(get(0).distance), ", time:", root.homeRouteTime)
                }
            }
        }
    }

    readonly property RouteModel workRouteModel: RouteModel {
        autoUpdate: !!root.currentLocationCoord && !!root.workCoord
        query: RouteQuery {
            waypoints: [root.currentLocationCoord, root.workCoord]
        }
        plugin: herePlugin
        onStatusChanged: {
            if (status === RouteModel.Ready) {
                if (count > 0) {
                    root.workRouteTime = formatSeconds(get(0).travelTime);
                    console.info("Work route distance (km):", formatMeters(get(0).distance), ", time:", root.workRouteTime)
                }
            }
        }
    }
}
