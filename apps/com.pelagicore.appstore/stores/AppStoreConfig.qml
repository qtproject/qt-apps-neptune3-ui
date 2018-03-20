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

import QtQuick 2.8
import "JSONBackend.js" as JSONBackend
import QtApplicationManager 1.0

import utils 1.0

QtObject {
    id: root

    property bool serverOnline: false
    property string serverReason
    property string serverUrl: ApplicationManager.systemProperties.appStoreServerUrl

    signal loginSuccessful()

    function checkServer() {
        console.log(Logging.apps, "Neptune-UI::Application Store - Check Server");
        var url = serverUrl + "/hello";
        var data = {"platform" : "NEPTUNE3", "version" : "1"};
        JSONBackend.setErrorFunction(function () {
            serverOnline = false;
            serverReason = "unknown";
        })
        JSONBackend.serverCall(url, data, function(data) {
            if (data !== 0) {
                if (data.status === "ok") {
                    serverOnline = true;
                    root.login();
                } else if (data.status === "maintenance") {
                    serverOnline = false;
                    serverReason = "maintenance";
                } else {
                    console.log(Logging.apps, "Server Call Err: " + data.error);
                    serverOnline = false;
                }
            } else {
                serverOnline = false;
                serverReason = "unknown";
            }
        })
    }

    function login() {
        var url = serverUrl + "/login"
        var data = { "username" : "t", "password" : "t", "imei" : "112163001487801" }
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

