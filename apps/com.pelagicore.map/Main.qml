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

import QtQuick 2.9
import application.windows 1.0
import shared.utils 1.0

import shared.com.pelagicore.remotesettings 1.0
import shared.com.pelagicore.drivedata 1.0
import shared.com.pelagicore.systeminfo 1.0
import shared.Style 1.0
import shared.com.pelagicore.map 1.0
import shared.Sizes 1.0

import "views" 1.0
import "stores" 1.0
import "helpers" 1.0

QtObject {
    property var mainWindow: ApplicationCCWindow {
        id: mainWindow

        height: Sizes.dp(Config.centerConsoleHeight)
        width: Sizes.dp(Config.centerConsoleWidth)

        // used for copying the offline DB
        readonly property var _mapsHelper: MapsHelper {
            appPath: Qt.resolvedUrl("./")

            onAppPathChanged: {
                if (appPath !== "") {
                    initMap();
                }
            }
        }

        MultiPointTouchArea {
            id: multiPoint
            anchors.fill: parent
            anchors.margins: Sizes.dp(30)
            touchPoints: [ TouchPoint { id: touchPoint1 } ]

            onReleased: {
                mainWindow.riseWindow()
            }
        }

        MapView {
            id: mainMap
            x: mainWindow.neptuneState === "Maximized" && !mainMap.store.searchViewEnabled ?
                   0 : mainWindow.exposedRect.x
            y: mainWindow.neptuneState === "Maximized" && !mainMap.store.searchViewEnabled ?
                   0 : mainWindow.exposedRect.y
            width: mainWindow.exposedRect.width
            height: mainWindow.exposedRect.height + Sizes.dp(180)
            neptuneWindowState: mainWindow.neptuneState
            mapInteractive: !mainMap.store.searchViewEnabled
            store: MapStore {
                offlineMapsEnabled: !sysinfo.internetAccess
                currentLocationCoord: positionCoordinate
            }

            onMaximizeMap: {
                mainWindow.riseWindow()
            }

            onMapCenterChanged: {
                if (mainMap.mapReady)
                    store.mainMapCenter = [mainMap.mapCenter.latitude
                                             , mainMap.mapCenter.longitude ];
            }
            onMapZoomLevelChanged: {
                if (mainMap.mapReady)
                    store.mainMapZoomLevel = mainMap.mapZoomLevel;
            }
            onMapTiltChanged: {
                if (mainMap.mapReady)
                    store.mainMapTilt = mainMap.mapTilt;
            }
            onMapBearingChanged: {
                if (mainMap.mapReady)
                    store.mainMapBearing = mainMap.mapBearing;
            }
        }

        // need a bit delay to give it a time to fetch the real internet status
        Timer {
            id: notificationDelay
            running: false
            interval: 5000
            onTriggered: {
                if (!sysinfo.internetAccess) {
                    mainMap.store.showOfflineNotification();
                }
            }
        }

        SystemInfo {
            id: sysinfo
            onInternetAccessChanged: {
                if (!sysinfo.internetAccess) {
                    mainMap.store.showOfflineNotification();
                } else {
                    mainMap.store.showOnlineNotification();
                }
            }
            Component.onCompleted: notificationDelay.start();
        }

        InstrumentCluster { id: clusterSettings }
    }

    readonly property Loader applicationICWindowLoader: Loader {
        asynchronous: true
        active: clusterSettings.available && mainMap.mapReady
        sourceComponent: Component {
            ApplicationICWindow {
                id: applicationICWindowComponent
                ICMapView {
                    id: icMapView
                    allowMapRendering: mainMap.store.allowMapRendering
                    anchors.fill: parent
                    mapPlugin: mainMap.store.mapPlugin
                    mapCenter: mainMap.mapCenter
                    mapZoomLevel: mainMap.mapZoomLevel
                    mapTilt: mainMap.mapTilt
                    mapBearing: mainMap.mapBearing
                    activeMapType: Style.theme === Style.Light ?
                                   mainMap.store.getMapType(icMapView.mapReady
                                                            , mainMap.store.defaultLightThemeId)
                                   : mainMap.store.getMapType(icMapView.mapReady
                                                              , mainMap.store.defaultDarkThemeId);

                    nextTurnDistanceMeasuredIn:
                        mainMap.store.navigationStore.nextTurnDistanceMeasuredIn
                    nextTurnDistance: mainMap.store.navigationStore.nextTurnDistance
                    naviGuideDirection: mainMap.store.navigationStore.naviGuideDirection

                    Connections {
                        target: mainMap.store
                        function onNavigationDemoActiveChanged() {
                            if (mainMap.store.navigationDemoActive) {
                                icMapView.path = mainMap.store.routeModel.get(0).path;
                                icMapView.state = "demo_driving";
                            } else {
                                icMapView.state = "initial";
                            }
                        }
                    }
                }
            }
        }
    }
}
