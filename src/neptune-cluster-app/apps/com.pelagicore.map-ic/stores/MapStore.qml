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

import QtQuick
import QtPositioning
import QtLocation
import Qt.labs.platform
import shared.utils

import shared.com.pelagicore.remotesettings
import shared.com.pelagicore.drivedata

QtObject {
    id: root

    property var mapCenter: QtPositioning.coordinate(48.135771, 11.574052) // Munich
    readonly property string defaultLightThemeId: "mapbox://styles/qtauto/cjcm1by3q12dk2sqnquu0gju9"
    readonly property string defaultDarkThemeId: "mapbox://styles/qtauto/cjcm1czb812co2sno1ypmp1r8"

    function getAvailableMapsAndLocation(mapReady, supportedMapTypes) {
        if (mapReady) {
            mapTypeModel.clear();
            console.info("Supported map types:");
            for (var i = 0; i < supportedMapTypes.length; i++) {
                var map = supportedMapTypes[i];
                mapTypeModel.append({"name": map.name, "data": map}) // fill the map type model
                console.info("\t", map.name, ", description:", map.description
                             , ", style:", map.style, ", night mode:", map.night);
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

    function createRouteFromRaw(rawPoints) {
        var routePath = [];
        if (!!rawPoints) {
            for (var i=0; i < rawPoints.length; ++i) {
                routePath.push(QtPositioning.coordinate(rawPoints[i][0], rawPoints[i][1]));
            }
        }

        return routePath;
    }

    // lists the various map styles (including the custom ones); filled in Map.onMapReadyChanged
    readonly property ListModel mapTypeModel: ListModel { }

    readonly property Plugin mapPlugin: Plugin {
        preferred: ["mapboxgl", "osm"]
        locales: Config.languageLocale

        readonly property string cacheDirUrl: {
            StandardPaths.writableLocation(StandardPaths.CacheLocation) + "/ic";
        }

        // OSM Plugin Parameters
        PluginParameter { name: "osm.useragent"; value: "Neptune UI" }

        // Mapbox Plugin Parameters
        PluginParameter {
            name: "mapboxgl.access_token"
            value: "pk.eyJ1IjoicXRhdXRvIiwiYSI6ImNqY20wbDZidzBvcTQyd3J3NDlkZ21jdjUifQ"
                   +".4KYDlP7UmQEVPYffr6VuVQ"
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

    readonly property NavigationState naviState: NavigationState {
        id: naviState
        onMapCenterChanged: {
            if (naviState.mapCenter) {
                root.mapCenter =
                    QtPositioning.coordinate(naviState.mapCenter[0], naviState.mapCenter[1]);
            }
        }
        onRoutePointsChanged: root.routePoints = createRouteFromRaw(naviState.routePoints);
    }

    property var routePoints: [];
    property bool navigationDemoActive: routePoints.length > 0;
    property alias mapZoomLevel: naviState.mapZoomLevel;
    property alias mapTilt: naviState.mapTilt;
    property alias mapBearing: naviState.mapBearing;
    property alias naviGuideDirection: naviState.nextTurn;
    property alias nextTurnDistanceMeasuredIn: naviState.nextTurnDistanceMeasuredIn;
    property alias nextTurnDistance: naviState.nextTurnDistance;
}
