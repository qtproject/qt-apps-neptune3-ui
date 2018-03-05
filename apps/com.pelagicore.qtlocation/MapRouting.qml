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

QtObject {
    id: root

    readonly property bool calculating: routeModel.status === RouteModel.Loading
    readonly property alias model: routeModel
    property string routeDistance
    property string routeTime
    property var routeSegments
    property string homeRouteTime
    property string workRouteTime

    property alias routingPlugin: routeModel.plugin
    property var currentLocationCoord
    property var homeCoord
    property var workCoord

    property var startCoord: QtPositioning.coordinate()
    property var destCoord: QtPositioning.coordinate()

    property string destination

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

    readonly property RouteModel routeModel: RouteModel {
        id: routeModel
        autoUpdate: !!root.startCoord && !!root.destCoord
        query: RouteQuery {
            waypoints: [root.startCoord, root.destCoord]
        }
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
        plugin: Plugin { name: "osm" }

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
        plugin: Plugin { name: "osm" }
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
