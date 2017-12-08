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

import QtQuick 2.8
import utils 1.0

Item {
    id: root

    property alias availableAppDownloads: availableDownloadModel
    property alias availableAppUpdates: availableUpdatesModel
    property alias latestUpdateApps: latestUpdateModel

    ListModel {
        id: availableUpdatesModel

        ListElement {
            appName: "Music"
            iconSource: "ic-music-dark"
            size: "55 MB"
        }

        ListElement {
            appName: "Vehicle"
            iconSource: "ic-car-dark"
            size: "45 MB"
        }
    }

    ListModel {
        id: latestUpdateModel

        ListElement {
            appName: "Calculator"
            iconSource: "ic-calculator-dark"
            size: "10 MB"
        }

        ListElement {
            appName: "Phone"
            iconSource: "ic-phone-dark"
            size: "15 MB"
        }

        ListElement {
            appName: "Navigation"
            iconSource: "ic-navigation-dark"
            size: "80 MB"
        }
    }

    ListModel {
        id: availableDownloadModel

        ListElement {
            appName: "Spotify"
            iconSource: ""
            size: "35 MB"
        }

        ListElement {
            appName: "Netflix"
            iconSource: ""
            size: "25 MB"
        }

        ListElement {
            appName: "Waze"
            iconSource: ""
            size: "60 MB"
        }
    }
}
