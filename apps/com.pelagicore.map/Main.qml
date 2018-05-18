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

import QtQuick 2.9
import utils 1.0

import com.pelagicore.systeminfo 1.0
import com.pelagicore.styles.neptune 3.0
import com.pelagicore.map 1.0

import "views"
import "stores"
import "helpers"

QtObject {
    id: root

    // used for copying the offline DB
    readonly property var _mapsHelper: MapsHelper {}

    property var mainWindow: PrimaryWindow {
        id: mainWindow

        property var secondaryWindowObject

        readonly property Helper helper: Helper {}

        onNeptuneStateChanged: {
            if (mainWindow.secondaryWindowObject && !neptuneState) { // widget got closed
                mainWindow.secondaryWindowObject.destroy();
                mainWindow.secondaryWindowObject = null;
            } else if (!mainWindow.secondaryWindowObject) { // app got killed, recreate
                mainWindow.secondaryWindowObject = secondaryWindowComponent.createObject(root);
            }
        }

        MultiPointTouchArea {
            id: multiPoint
            anchors.fill: parent
            anchors.margins: NeptuneStyle.dp(30)
            touchPoints: [ TouchPoint { id: touchPoint1 } ]

            property int count: 0
            onReleased: {
                count += 1;
                mainWindow.setWindowProperty("activationCount", count);
            }
        }

        MapView {
            id: mainMap
            x: state === "Maximized" && !mainMap.store.searchViewEnabled ? mainWindow.x : mainWindow.exposedRect.x
            y: state === "Maximized" && !mainMap.store.searchViewEnabled ? mainWindow.y : mainWindow.exposedRect.y
            width: state === "Maximized" && !mainMap.store.searchViewEnabled ? mainWindow.width : mainWindow.exposedRect.width
            height: state === "Maximized" && !mainMap.store.searchViewEnabled ? mainWindow.height : mainWindow.exposedRect.height
            state: mainWindow.neptuneState
            mapInteractive: !mainMap.store.searchViewEnabled
            store: MapStore {
                offlineMapsEnabled: !sysinfo.online && Qt.platform.os === "linux"
                currentLocationCoord: positionCoordinate
            }

            onMapReadyChanged: {
                if (mapReady) {
                    if (!mainWindow.secondaryWindowObject) {
                        mainWindow.secondaryWindowObject = secondaryWindowComponent.createObject(root);
                    }
                    if (store.offlineMapsEnabled) {
                        helper.showOfflineNotification();
                    }
                }
            }

            onMaximizeMap: {
                multiPoint.count += 1
                mainWindow.setWindowProperty("activationCount", multiPoint.count)
            }

            SystemInfo { id: sysinfo }
        }
    }

    property var secondaryWindowComponent: Component {
        SecondaryWindow {
            id: secondaryWindowComponent
            ICMapView {
                id: icMapView
                anchors.fill: parent
                mapPlugin: mainMap.store.mapPlugin
                mapCenter: mainMap.mapCenter
                mapZoomLevel: mainMap.mapZoomLevel
                mapTilt: mainMap.mapTilt
                mapBearing: mainMap.mapBearing
            }
        }
    }
}
