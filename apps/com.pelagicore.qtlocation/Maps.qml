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

    // props for secondary window
    property bool mapInteractive: true
    property alias mapCenter: mainMap.center
    property alias mapZoomLevel: mainMap.zoomLevel
    property alias mapTilt: mainMap.tilt
    property alias mapBearing: mainMap.bearing
    readonly property alias mapReady: mainMap.mapReady

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
        name: plugins[currentPlugin]

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
        anchors.topMargin: (root.state === "Widget3Rows") || (root.state === "Maximized") ? header.height/2 : 0
        Behavior on anchors.topMargin { DefaultNumberAnimation {} }
        plugin: mapPlugin
        center: priv.positionCoordinate
        Behavior on center { enabled: root.mapInteractive; CoordinateAnimation { easing.type: Easing.InOutCirc; duration: 540 } }
        zoomLevel: 10
        copyrightsVisible: false // customize the default (c) appearance below in MapCopyrightNotice

        gesture {
            enabled: root.mapInteractive
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
            return TritonStyle.theme === TritonStyle.Light ? getMapType(priv.defaultLightThemeId) : getMapType(priv.defaultDarkThemeId);
        }

        Behavior on tilt { DefaultSmoothedAnimation {} }
    }

    TritonControls.Tool {
        anchors.left: parent.left
        anchors.leftMargin: Style.hspan(0.6)
        anchors.top: parent.top
        anchors.topMargin: Style.vspan(0.6)
        opacity: root.state === "Widget1Row" ? 1 : 0
        Behavior on opacity { DefaultNumberAnimation {} }
        visible: opacity > 0
        background: Image {
            fillMode: Image.Pad
            source: Qt.resolvedUrl("assets/floating-button-bg.png")
        }
        symbol: Qt.resolvedUrl("assets/ic-search.png")
        onClicked: root.maximizeMap()
    }

    Item {
        id: header

        height: backgroundImage.sourceSize.height

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top

        opacity: root.state && root.state !== "Widget1Row" ? 1 : 0
        visible: opacity > 0
        Behavior on opacity {
            SequentialAnimation {
                PauseAnimation { duration: 180 }
                DefaultNumberAnimation {}
            }
        }

        Image {
            id: backgroundImage
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: root.state === "Widget1Row" ? -header.height : (root.state === "Widget2Rows" ? -header.height/2 : 0 )
            Behavior on anchors.topMargin { DefaultNumberAnimation {} }
            fillMode: Image.TileHorizontally
            source: Qt.resolvedUrl("assets/navigation-widget-overlay-top.png")
            visible: TritonStyle.theme == TritonStyle.Light
        }

        RowLayout {
            id: firstRow
            anchors.top: parent.top
            anchors.topMargin: Style.vspan(.3)
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
            opacity: (root.state == "Widget3Rows") || (root.state == "Maximized") ? 1 : 0
            Behavior on opacity {
                SequentialAnimation {
                    PauseAnimation { duration: 180 }
                    DefaultNumberAnimation {}
                }
            }
            visible: opacity > 0
            height: parent.height/2
            MapToolButton {
                id: buttonGoHome
                Layout.preferredWidth: secondRow.width/2
                Layout.fillWidth: true
                anchors.verticalCenter: parent.verticalCenter
                iconSource: Qt.resolvedUrl("assets/ic-home.png")

                text: qsTr("Home")
                extendedText: "17 min"
                secondaryText: "Welandergatan 29"
            }
            MapToolButton {
                id: buttonGoWork
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

    TritonControls.Tool {
        anchors.left: parent.left
        anchors.leftMargin: Style.hspan(0.6)
        anchors.top: header.bottom
        anchors.topMargin: -Style.vspan(1.6)
        checkable: true
        opacity: root.state === "Maximized" ? 1 : 0
        Behavior on opacity { DefaultNumberAnimation {} }
        visible: opacity > 0
        background: Image {
            fillMode: Image.Pad
            source: Qt.resolvedUrl("assets/floating-button-bg.png")
        }
        symbol: checked  ? Qt.resolvedUrl("assets/ic-3D_ON.png") : Qt.resolvedUrl("assets/ic-3D_OFF.png")
        onClicked: mainMap.tilt = checked ? mainMap.maximumTilt : mainMap.minimumTilt;
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
