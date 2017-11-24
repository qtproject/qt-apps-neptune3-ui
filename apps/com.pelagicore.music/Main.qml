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
import animations 1.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import "stores"

AppUIScreen {
    id: root

    property int applicationWindowHeight: 279
    property string tritonState
    onWindowPropertyChanged: {

        // FIXME: Not a final solution! need to be updated once system UI already provide
        //        the required information to the client side.

        if (name === "tritonState") {
            tritonState = value;
            if (root.tritonState === "Widget1Row") {
                applicationWindowHeight = 279;
            } else if (root.tritonState === "Widget2Rows") {
                applicationWindowHeight = 590;
            } else if (root.tritonState === "Widget3Rows") {
                applicationWindowHeight = 901;
            } else if (root.tritonState === "Maximized") {
                applicationWindowHeight = 1600;
            }
        }
    }

    applicationIcon: "icon.png"
    stripeSource: musicAppContent.state === "Maximized" ? "" : Style.gfx2("widget-stripe")

    MultiPointTouchArea {
        id: multiPoint
        anchors.fill: parent
        anchors.margins: 30
        touchPoints: [ TouchPoint { id: touchPoint1 } ]

        property int count: 0
        onReleased: {
            count += 1;
            root.setWindowProperty("activationCount", count);
        }
    }

    Music {
        id: musicAppContent
        width: root.width
        height: root.applicationWindowHeight
        anchors.centerIn: parent

        state: root.tritonState
        store: MusicStore { }

        onDragAreaClicked: {
            multiPoint.count += 1;
            root.setWindowProperty("activationCount", multiPoint.count);

        }
    }
}
