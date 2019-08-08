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

import QtQuick 2.8
import "JSONBackend.js" as JSONBackend
import QtApplicationManager.SystemUI 2.0

import shared.utils 1.0

QtObject {
    id: root

    property bool serverOnline: false
    property string serverReason
    property string cpuArch
    property string serverUrl: ApplicationManager.systemProperties.appStoreServerUrl
    property string userName: ApplicationManager.systemProperties.userName
    property string userPassword: ApplicationManager.systemProperties.userPassword
    readonly property string imei: ApplicationManager.systemProperties.imei
    property  bool isReconnecting: false

    signal loginSuccessful()

    property var d: QtObject {

        property int attempt: 0
        property Timer retryTimer: Timer {
            interval: 2000
            onTriggered: {
                d.checkServerPrivate()
            }
        }

        function retry() {
            console.log(Logging.apps, "Neptune-UI::Application Store - Retry Connection");
            if (attempt < 5) {
                attempt += 1;
                retryTimer.start();
            } else {
                root.isReconnecting = false;
            }
        }

        function checkServerPrivate() {
            root.isReconnecting = true;
            console.log(Logging.apps, "Neptune-UI::Application Store - Check Server");
            var url = root.serverUrl + "/hello";
            var data = {"platform" : "NEPTUNE3", "version" : "1", "architecture": root.cpuArch};
            JSONBackend.setErrorFunction(function () {
                root.serverOnline = false;
                root.serverReason = "unknown";
                root.d.retry()
            })
            JSONBackend.serverCall(url, data, function(data) {
                if (data !== 0) {
                    if (data.status === "ok") {
                        root.d.attempt = 0
                        root.serverOnline = true;
                        root.isReconnecting = false;
                        root.login();
                    } else if (data.status === "maintenance") {
                        console.log(Logging.apps, "Server Call: maintenance");
                        root.serverOnline = false;
                        root.serverReason = "maintenance";
                    } else {
                        console.log(Logging.apps, "Server Call Err: " + data.error);
                        root.serverOnline = false;
                        root.d.retry()
                    }
                } else {
                    root.serverOnline = false;
                    root.serverReason = "unknown";
                    root.d.retry();
                }
            })
        }
    }

    function checkServer() {
        root.d.attempt = 0
        root.d.checkServerPrivate()
    }

    function login() {
        var url = serverUrl + "/login"
        var data = { "username" : userName, "password" : userPassword, "imei" : imei }
        JSONBackend.serverCall(url, data, function(data) {
            if (data !== 0) {
                if (data.status === "ok") {
                    console.log(Logging.apps, "Login Succeeded");
                    loginSuccessful();
                } else {
                    console.log(Logging.apps, "Login Err: " + data.error);
                }
            }
        })
    }

    Component.onCompleted: root.checkServer();
}

