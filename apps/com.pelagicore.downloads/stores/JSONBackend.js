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

.pragma library
.import shared.utils 1.0 as Utils

var errorCounter = 0
var errorFunc = 0

// Will be called when the error is not responding after a few tries
function setErrorFunction(func) {
    errorFunc = func
}

function serverCall(url, data, dataReadyFunction) {
    var i = 0;
    for (var key in data)
    {
        if (i === 0) {
            url += "?" + key + "=" + data[key];
        } else {
            url += "&" + key+ "=" + data[key];
        }
        i++;
    }

    var xhr = new XMLHttpRequest();
    console.log(Utils.Logging.apps, "HTTP GET to " + url);
    xhr.open("GET", url);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.responseText !== "") {
                errorCounter = 0;
                var data = 0;

                try {
                    data = JSON.parse(xhr.responseText);
                } catch(e) {
                    console.warn(Utils.Logging.apps, "JSONBackend error parsing answer:",
                                 xhr.responseText);
                }

                return dataReadyFunction(data);
            } else {
                console.warn(Utils.Logging.apps, "JSONBackend: status:", xhr.status,
                             xhr.statusText);
                errorCounter++;
                if (errorCounter >= 3 && errorFunc) {
                    errorFunc();
                }

                return dataReadyFunction(0);
            }
        }
    }
    xhr.send();
}
