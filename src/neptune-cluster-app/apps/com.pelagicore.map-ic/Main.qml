/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
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

import QtQuick.Controls 2.2

import QtQuick 2.9
import QtPositioning 5.9

import shared.com.pelagicore.map 1.0
import shared.utils 1.0
import shared.Style 1.0
import shared.Sizes 1.0

import "views" 1.0
import "stores" 1.0

Item {
    MapStore {
        id: store
    }

    // used for copying the offline DB
    readonly property var _mapsHelper: MapsHelper {
        appPath: Qt.resolvedUrl("./")

        onAppPathChanged: {
            if (appPath !== "") {
                initMap("ic");
            }
        }
    }

    ICMapView {
        id: icMapView
        anchors.fill: parent
        mapPlugin: store.mapPlugin
        mapCenter: store.mapCenter
        mapZoomLevel: store.mapZoomLevel
        mapTilt: store.mapTilt
        mapBearing: store.mapBearing
        activeMapType: Style.theme === Style.Light ?
                       store.getMapType(icMapView.mapReady, store.defaultLightThemeId)
                       : store.getMapType(icMapView.mapReady, store.defaultDarkThemeId);

        nextTurnDistanceMeasuredIn: store.nextTurnDistanceMeasuredIn
        nextTurnDistance: store.nextTurnDistance
        naviGuideDirection: store.naviGuideDirection

        onMapReadyChanged: {
            store.getAvailableMapsAndLocation(icMapView.mapReady, icMapView.supportedMapTypes);
        }

        Connections {
            target: store
            onNavigationDemoActiveChanged: {
                if (store.navigationDemoActive) {
                    icMapView.path = store.routePoints;
                    icMapView.state = "demo_driving";
                } else {
                    icMapView.state = "initial";
                }
            }
        }
    }
}
