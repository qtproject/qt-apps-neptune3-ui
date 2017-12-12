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

import QtApplicationManager 1.0

QtObject {
    property var mainWindow: AppUIScreen {
        id: mainWindow

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

        Item {
            height: mainWindow.currentHeight
            width: mainWindow.exposedRect.width
            Music {
                id: musicAppContent
                width: mainWindow.width
                height: mainWindow.targetHeight
                anchors.centerIn: parent

                state: mainWindow.tritonState
                store: MusicStore { }
                bottomWidgetHide: mainWindow.exposedRect.height === mainWindow.targetHeight

                onDragAreaClicked: {
                    multiPoint.count += 1;
                    mainWindow.setWindowProperty("activationCount", multiPoint.count);
                }
            }
        }

    }

    property var secondaryWindow: ApplicationManagerWindow {
        id: secondaryWindow

        Image {
            anchors.fill: parent
            source: "assets/bg.png"
            fillMode: Image.Stretch

            // TODO: Replace this placeholder image with real content
            Image {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height * 0.1
                anchors.horizontalCenter: parent.horizontalCenter
                source: "assets/secondary-window-mock-content.png"
                width: parent.width * 0.3
                height: parent.height * 0.6
                fillMode: Image.PreserveAspectFit
            }
        }

        Component.onCompleted: {
            secondaryWindow.setWindowProperty("windowType", "secondary")
            secondaryWindow.visible = true
        }
    }
}
