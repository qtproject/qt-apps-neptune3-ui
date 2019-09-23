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

import QtQuick 2.0
import shared.Connectivity.simulation 1.0

Item {
    WiFiBackend {
        id: backend
        property var settings : IviSimulator.findData(IviSimulator.simulationData, "WiFi")

        function initialize() {
            IviSimulator.initializeDefault(settings, backend)
            Base.initialize()

            for (var i = 0; i < 7; i++) {
                var ap = {}
                ap.ssid = "Access Point " + i
                ap.connected = false
                ap.strength = Math.floor( Math.random()*100 )
                ap.security = Math.floor( Math.random()*5 )

                allAccessPoints.push(ap)
            }

            backend.accessPoints = allAccessPoints
        }

        readonly property var allAccessPoints: []

        readonly property Timer timerAccessPoints : Timer {
            property int itteration: 0
            interval: 3000
            repeat: true
            running: backend.enabled
            onTriggered: {
                var sign = Math.random() <= 0.5 ? 1 : -1

                for (var j = 0; j < backend.allAccessPoints.length; j++) {
                    if ( Math.random() < 0.5 ) {
                        var strength = ( backend.allAccessPoints[j].strength + sign * 27 ) % 100;
                        if (strength < 0) {
                            strength = -1 * strength
                        }
                        backend.allAccessPoints[j].strength = strength
                    }
                }
                backend.accessPoints = backend.allAccessPoints
                backend.timerAccessPoints.itteration += 1
            }
        }

        readonly property Timer timerConnecting : Timer {
            interval: 3000
            repeat: false
            onTriggered: {
                for (var j = 0; j < backend.allAccessPoints.length; j++) {
                    if (backend.accessPoints[j].ssid == backend.activeAccessPoint.ssid) {
                        backend.allAccessPoints[j].connected = true
                        backend.activeAccessPoint.connected = true
                        backend.connectionStatus = WiFi.Connected
                        backend.timerConnectingTimeout.stop()
                    } else {
                        backend.allAccessPoints[j].connected = false
                    }
                }
                backend.accessPoints = backend.allAccessPoints
            }
        }

        readonly property Timer timerDisconnecting : Timer {
            interval: 500
            repeat: false
            onTriggered: {
                backend.activeAccessPoint.ssid = ""
                backend.activeAccessPoint.connected = false
                for (var j = 0; j < backend.allAccessPoints.length; j++) {
                    backend.allAccessPoints[j].connected = false
                    backend.connectionStatus = WiFi.Disconnected
                }
                backend.accessPoints = backend.allAccessPoints
            }
        }

        readonly property Timer timerConnectingTimeout : Timer {
            interval: 180000
            repeat: false
            onTriggered: {
                if ( backend.connectionStatus == WiFi.Connecting ) {
                    backend.errorString = "Connection timeout."
                    backend.connectionStatus = WiFi.Disconnected
                    backend.activeAccessPoint.ssid = ""
                    backend.activeAccessPoint.connected = false
                    for (var j = 0; j < backend.allAccessPoints.length; j++) {
                        backend.allAccessPoints[j].connected = false
                    }
                    backend.accessPoints = backend.allAccessPoints
                }
            }
        }

        function connectToAccessPoint(qtIviReply, ssid) {
            for (var j = 0; j < backend.allAccessPoints.length; j++) {
                if (backend.accessPoints[j].ssid == ssid) {
                    var security = backend.allAccessPoints[j].security
                    backend.connectionStatus = WiFi.Connecting
                    backend.activeAccessPoint.ssid = ssid
                    if (security != WiFi.NoSecurity) {
                        backend.credentialsRequested(ssid)
                    } else {
                        timerConnecting.start()
                        backend.timerConnectingTimeout.restart()
                    }
                    break
                }
            }

            qtIviReply.setSuccess(0)
            return qtIviReply
        }


        function sendCredentials(qtIviReply, ssid, password) {
            var success = false;
            for (var j = 0; j < backend.allAccessPoints.length; j++) {
                if ( backend.activeAccessPoint.ssid == backend.allAccessPoints[j].ssid ) {
                    timerConnecting.start()
                    backend.timerConnectingTimeout.restart()
                    success = true
                    break
                }
            }

            if (success) {
                qtIviReply.setSuccess(0)
            } else {
                qtIviReply.setFailed()
            }
            return qtIviReply
        }

        function disconnectFromAccessPoint(qtIviReply, ssid) {
            backend.connectionStatus = WiFi.Disconnecting
            timerDisconnecting.start()
            qtIviReply.setSuccess(0)
            return qtIviReply
        }

        readonly property Connections backendSignals: Connections {
            target: backend
            onEnabledChanged: {
                if (!backend.enabled) {
                    for (var j = 0; j < backend.allAccessPoints.length; j++) {
                        backend.allAccessPoints[j].connected = false
                    }
                    backend.accessPoints = backend.allAccessPoints
                    backend.activeAccessPoint.ssid = ""
                    backend.activeAccessPoint.connected = false
                    backend.connectionStatus = WiFi.Disconnected

                    backend.timerConnectingTimeout.stop()
                }
            }
        }
    }
}
