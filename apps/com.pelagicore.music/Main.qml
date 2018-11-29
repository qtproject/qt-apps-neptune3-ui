/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AG
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
import application.windows 1.0
import shared.utils 1.0
import shared.animations 1.0
import shared.controls 1.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import "stores" 1.0
import "views" 1.0

import shared.com.pelagicore.settings 1.0
import shared.Style 1.0
import shared.Sizes 1.0

QtObject {
    property var mainWindow: ApplicationCCWindow {
        id: mainWindow

        MultiPointTouchArea {
            id: multiPoint
            anchors.fill: parent
            anchors.margins: Sizes.dp(30)
            touchPoints: [ TouchPoint { id: touchPoint1 } ]

            property int count: 0
            onReleased: {
                count += 1;
                mainWindow.setWindowProperty("activationCount", count);
            }
        }

        ScalableBorderImage {
            id: topImage

            x: mainWindow.exposedRect.x
            y: mainWindow.exposedRect.y - Sizes.dp(224)
            width: mainWindow.exposedRect.width
            height: musicAppContent.fullscreenTopHeight + mainWindow.exposedRect.y - y
            border.top: sourceSize.height - Sizes.dp(1)

            opacity: (mainWindow.neptuneState === "Maximized") ? 1.0 : 0.0
            Behavior on opacity { DefaultNumberAnimation {} }
            visible: opacity > 0

            source: Style.image("app-fullscreen-top-bg")
        }

        MusicView {
            id: musicAppContent
            x: mainWindow.exposedRect.x
            y: mainWindow.exposedRect.y
            width: mainWindow.exposedRect.width
            height: mainWindow.exposedRect.height
            rootItem: mainWindow.contentItem

            state: mainWindow.neptuneState
            store: MusicStore { }
            onFlickableAreaClicked: {
                multiPoint.count += 1;
                mainWindow.setWindowProperty("activationCount", multiPoint.count);
            }
        }

        InstrumentCluster {
            id: clusterSettings
        }
    }

    readonly property Loader applicationICWindowLoader: Loader {
        asynchronous: true
        active: clusterSettings.available
                || Qt.platform.os !== "linux" // FIXME and then remove; remote settings doesn't really work outside of Linux

        onLoaded: {
            applicationICWindowLoader.item.icMusicView.populateModel();
        }

        sourceComponent: Component {
            ApplicationICWindow {
                property alias icMusicView: icMusicView

                ICMusicView {
                    id: icMusicView
                    anchors.fill: parent
                    store: musicAppContent.store
                }
            }
        }
    }
}
