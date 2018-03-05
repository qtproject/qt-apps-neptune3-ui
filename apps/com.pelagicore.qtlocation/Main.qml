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

import QtApplicationManager 1.0

QtObject {
    id: root

    property var mainWindow: AppUIScreen {
        id: mainWindow

        property var secondaryWindowObject

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
            x: state === "Maximized" ? mainWindow.x : mainWindow.exposedRect.x
            y: state === "Maximized" ? mainWindow.y : mainWindow.exposedRect.y
            width: state === "Maximized" ? mainWindow.width : mainWindow.exposedRect.width
            height: state === "Maximized" ? mainWindow.height : mainWindow.exposedRect.height
            state: mainWindow.neptuneState
            offlineMapsEnabled: !sysinfo.online && Qt.platform.os === "linux"

            onMapReadyChanged: {
                if (mapReady && !mainWindow.secondaryWindowObject) {
                    mainWindow.secondaryWindowObject = secondaryWindowComponent.createObject(root);
                }
            }

            onMaximizeMap: {
                multiPoint.count += 1
                mainWindow.setWindowProperty("activationCount", multiPoint.count)
            }

            SystemInfo { id: sysinfo }
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
                offlineMapsEnabled: mainMap.offlineMapsEnabled
            }
        }
    }
}
