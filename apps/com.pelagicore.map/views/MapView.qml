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

import QtQuick 2.10
import QtQuick.Controls 2.3
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

    property MapStore store
    property Helper helper: Helper {}

    // props for secondary window
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

    onStateChanged: root.store.searchViewEnabled = false;
    Connections {
        target: root.store
        onIntentNavigationRequested: {
            mapBoxPanel.center = coord;
            root.store.startCoord = root.store.positionCoordinate;
            root.store.destCoord = coord;
            root.store.destination = address;
            if (boundingBox.isValid) {
                mapBoxPanel.visibleRegion = boundingBox;
            }
            mapBoxPanel.navigationMode = true;
        }
    }

    MapBoxPanel {
        id: mapBoxPanel
        anchors.fill: parent
        plugin: root.store.mapPlugin
        center: root.store.positionCoordinate
        state: root.state
        currentLocation: root.store.positionCoordinate
        offlineMapsEnabled: root.store.offlineMapsEnabled
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
            return NeptuneStyle.theme === NeptuneStyle.Light ? root.store.getMapType(mapBoxPanel.mapReady, root.store.defaultLightThemeId)
                                                             : root.store.getMapType(mapBoxPanel.mapReady, root.store.defaultDarkThemeId);
        }
        onOpenSearchTextInput: {
            root.maximizeMap();
            root.store.searchViewEnabled = true;
        }
        onStartNavigationRequested: {
            root.store.originalPosition = root.store.positionCoordinate;
        }
        onShowRouteRequested: {
            root.store.originalPosition = root.store.positionCoordinate;
            root.store.destCoord = destCoord;
            root.store.destination = description;
            root.store.startCoord = mapBoxPanel.currentLocation;
        }
        onStopNavigationRequested: {
            root.store.positionCoordinate = root.store.originalPosition;
            mapBoxPanel.center = root.store.positionCoordinate;
        }

        onMapReadyChanged: root.store.getAvailableMapsAndLocation(mapBoxPanel.mapReady, mapBoxPanel.supportedMapTypes);
        onMaximizeMap: root.maximizeMap();
        Component.onCompleted: {
            root.store.routingPlugin = root.store.geocodePlugin
        }
    }

    ToolButton {
        anchors.left: parent.left
        anchors.leftMargin: NeptuneStyle.dp(27)
        anchors.top: parent.top
        anchors.topMargin: NeptuneStyle.dp(48)
        opacity: root.state === "Widget1Row" ? 1 : 0
        Behavior on opacity { DefaultNumberAnimation {} }
        visible: opacity > 0
        icon.source: Qt.resolvedUrl("../assets/ic-search.png")
        width: NeptuneStyle.dp(background.sourceSize.width)
        height: width
        background: Image {
            fillMode: Image.PreserveAspectFit
            source: helper.localAsset("floating-button-bg", NeptuneStyle.theme)
        }
        onClicked: root.maximizeMap()
    }

    FastBlur {
        anchors.fill: mapBoxPanel
        source: mapBoxPanel
        radius: NeptuneStyle.dp(64)
        visible: root.store.searchViewEnabled
    }

    NeptuneControls.ScalableBorderImage {
        id: overlay
        anchors.fill: root
        border.top: NeptuneStyle.dp(322)
        border.bottom: NeptuneStyle.dp(323)
        border.left: 0
        border.right: 0
        source: Style.gfx("input-overlay")
        visible: root.store.searchViewEnabled
    }

    SearchOverlayPanel {
        id: searchOverlay
        anchors.fill: root
        anchors.topMargin: NeptuneStyle.dp(80)
        visible: root.store.searchViewEnabled
        spacing: NeptuneStyle.dp(80)
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
            mapBoxPanel.navigationMode = true;
        }
    }
}
