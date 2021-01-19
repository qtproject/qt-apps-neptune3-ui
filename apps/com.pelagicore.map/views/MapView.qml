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

import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtPositioning 5.9
import QtLocation 5.9
import QtGraphicalEffects 1.0

import Qt.labs.platform 1.0

import shared.utils 1.0
import shared.controls 1.0 as NeptuneControls
import shared.animations 1.0

import shared.Style 1.0
import shared.Sizes 1.0

import "../controls" 1.0
import "../panels" 1.0
import "../stores" 1.0
import "../helpers" 1.0

Item {
    id: root

    property MapStore store
    property string neptuneWindowState

    // props for application IC window
    property alias mapInteractive: mapBoxPanel.mapInteractive
    property alias mapCenter: mapBoxPanel.center
    property alias mapZoomLevel: mapBoxPanel.zoomLevel
    property alias mapTilt: mapBoxPanel.tilt
    property alias mapBearing: mapBoxPanel.bearing
    readonly property alias mapReady: mapBoxPanel.mapReady

    signal maximizeMap()

    Component.onCompleted: {
        root.store.homeCoord = mapBoxPanel.mapHeader.homeAddressData;
        root.store.workCoord = mapBoxPanel.mapHeader.workAddressData;
    }

    onStateChanged: {
        if (root.neptuneWindowState !== "Maximized") {
            root.store.searchViewEnabled = false;
        }
    }

    Connections {
        target: root.store

        function onRequestNavigationReceived(address, coord, boundingBox) {
            root.maximizeMap();
            root.store.navigationDemoActive = false;
            mapBoxPanel.state = "initial";
            mapBoxPanel.center = coord;
            mapBoxPanel.currentLocation = root.store.positionCoordinate;
            root.store.startCoord = root.store.positionCoordinate;
            root.store.destCoord = coord;
            root.store.destination = address;
            if (boundingBox.isValid) {
                mapBoxPanel.visibleRegion = boundingBox;
            }
            mapBoxPanel.state = "destination_selection";
        }

        function onRequestRaiseAppReceived() { root.maximizeMap(); }
    }

    MapBoxPanel {
        id: mapBoxPanel
        visible: root.store.allowMapRendering
        anchors.fill: parent
        plugin: root.store.mapPlugin
        center: root.store.positionCoordinate
        neptuneWindowState: root.neptuneWindowState
        currentLocation: root.store.positionCoordinate
        offlineMapsEnabled: root.store.offlineMapsEnabled
        destination: root.store.destination
        model: root.store.model
        routeDistance: root.store.routeDistance
        routeTime: root.store.routeTime
        homeRouteTime: root.store.homeRouteTime
        workRouteTime: root.store.workRouteTime
        destCoord: root.store.destCoord

        directionFromNavigator: root.store.navigationStore.angle
        locationFromNavigator: root.store.navigationStore.location

        activeMapType: {
            if (!mapReady || plugin.name !== "mapboxgl") {
                return supportedMapTypes[0];
            }
            return Style.theme === Style.Light
                    ? root.store.getMapType(mapBoxPanel.mapReady, root.store.defaultLightThemeId)
                    : root.store.getMapType(mapBoxPanel.mapReady, root.store.defaultDarkThemeId);
        }
        onOpenSearchTextInput: {
            root.maximizeMap();
            root.store.searchViewEnabled = true;
        }
        onStartNavigationRequested: {
            root.store.navigationDemoActive = true;
            mapBoxPanel.state = "demo_driving";
        }
        onShowRouteRequested: {
            root.store.navigationDemoActive = false;
            mapBoxPanel.state = "route_selection";
        }
        onShowDestinationPointRequested: {
            root.store.navigationDemoActive = false;
            root.store.originalPosition = root.store.positionCoordinate;
            root.store.destCoord = destCoord;
            root.store.destination = description;
            root.store.startCoord = mapBoxPanel.currentLocation;
            mapBoxPanel.state = "destination_selection";
        }
        onStopNavigationRequested: {
            root.store.navigationDemoActive = false;
            root.store.positionCoordinate = root.store.originalPosition;
            mapBoxPanel.state = "initial";
            mapBoxPanel.zoomLevel = 10;
            mapBoxPanel.currentLocation = root.store.positionCoordinate;
            mapBoxPanel.center = root.store.positionCoordinate;
        }

        onMapReadyChanged: {
            root.store.getAvailableMapsAndLocation(mapBoxPanel.mapReady
                    , mapBoxPanel.supportedMapTypes);
        }

        onMaximizeMap: root.maximizeMap();
    }

    Loader {
        active: !root.store.allowMapRendering
        anchors.fill: root
        sourceComponent: ProxyErrorPanel {
            anchors.fill: parent
            errorText: qsTr("The map is disabled in this runtime environment")
        }
    }

    FastBlur {
        anchors.fill: mapBoxPanel
        source: mapBoxPanel
        radius: Sizes.dp(64)
        visible: root.store.searchViewEnabled
    }

    NeptuneControls.ScalableBorderImage {
        id: overlay
        anchors.fill: root
        border {
            //don't change these values without knowing the exact size of source image
            //QTBUG-73768 if border exceeds source image size, app crashes, avoid Sizes.dp here
            top: 320
            left: 0
            right: 0
        }
        source: Style.image("input-overlay")
        visible: root.store.searchViewEnabled
    }

    SearchOverlayPanel {
        id: searchOverlay
        anchors.fill: root
        anchors.topMargin: Sizes.dp(80)
        visible: root.store.searchViewEnabled
        spacing: Sizes.dp(80)
        model: root.store.geocodeModel

        onBackButtonClicked: root.store.searchViewEnabled = false

        onSearchFieldAccepted: {
            root.store.geocodeModel.query = searchOverlay.searchQuery;
            root.store.geocodeModel.update();
            root.store.searchViewEnabled = false;
        }

        onSearchQueryChanged: {
            root.store.geocodeModel.reset();
            root.store.geocodeModel.query = searchQuery;
            root.store.geocodeModel.update();
        }

        onEscapePressed: root.store.searchViewEnabled = false

        onItemClicked: {
            root.store.searchViewEnabled = false;
            mapBoxPanel.center = coordinate;
            root.store.startCoord = root.store.positionCoordinate;
            root.store.destCoord = coordinate;
            root.store.destination = addressText;
            if (boundingBox.isValid) {
                mapBoxPanel.visibleRegion = boundingBox;
            }

            mapBoxPanel.state = "destination_selection";
        }
    }
}
