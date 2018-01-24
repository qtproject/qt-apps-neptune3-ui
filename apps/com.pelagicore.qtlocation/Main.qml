/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
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

import QtQuick 2.9
import utils 1.0

import com.pelagicore.settings 1.0

import QtApplicationManager 1.0

QtObject {
    id: root

    property var mainWindow: AppUIScreen {
        id: mainWindow

        property var secondaryWindowObject

        onTritonStateChanged: {
            if (mainWindow.secondaryWindowObject && !instrumentCluster.navigationMode) { // just switching mode
                instrumentCluster.navigationMode = true;
            } else if (mainWindow.secondaryWindowObject && !tritonState) { // widget got closed
                mainWindow.secondaryWindowObject.destroy();
                mainWindow.secondaryWindowObject = null;
                instrumentCluster.navigationMode = false;
            } else if (!mainWindow.secondaryWindowObject) { // app got killed, recreate
                timer.start();
            }
        }

        MultiPointTouchArea {
            id: multiPoint
            anchors.fill: parent
            anchors.margins: 30
            touchPoints: [ TouchPoint { id: touchPoint1 } ]

            property int count: 0
            onReleased: {
                count += 1;
                mainWindow.setWindowProperty("activationCount", count);
            }
        }

        Maps {
            id: mainMap
            x: mainWindow.exposedRect.x
            y: mainWindow.exposedRect.y
            width: mainWindow.exposedRect.width
            height: mainWindow.exposedRect.height
            state: mainWindow.tritonState

            onMapReadyChanged: {
                if (mapReady) {
                    if (mainWindow.secondaryWindowObject)
                        instrumentCluster.navigationMode = true;
                    else
                        timer.start();
                }
            }

            onMaximizeMap: {
                multiPoint.count += 1
                mainWindow.setWindowProperty("activationCount", multiPoint.count)
            }
        }

        InstrumentCluster {
            // cluster remote settings
            id: instrumentCluster
        }

        Timer {
            // this timer is needed to make sure both InstrumentCluster and the GLMap is initialized
            // MapboxGL contains an ugly timer hack in case of multi-threaded rendering
            id: timer
            interval: 1500
            onTriggered: {
                // create the secondary window and set the navigation mode
                if (!mainWindow.secondaryWindowObject) {
                    mainWindow.secondaryWindowObject = secondaryWindowComponent.createObject(root);
                }
                instrumentCluster.navigationMode = true;
            }
        }
    }

    property Component secondaryWindowComponent: Component {
        id: secondaryWindowComponent
        SecondaryWindow {
            Maps {
                anchors.fill: parent
                mapInteractive: false
                mapCenter: mainMap.mapCenter
                mapZoomLevel: mainMap.mapZoomLevel
                mapTilt: mainMap.mapTilt
                mapBearing: mainMap.mapBearing
            }
        }
    }
}
