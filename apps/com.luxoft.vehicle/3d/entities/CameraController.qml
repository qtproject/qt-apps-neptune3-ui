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

import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Input 2.0
import Qt3D.Logic 2.0
import QtQml 2.2


Entity {
    id: root
    property Camera camera
    property real cameraPanAngle: 0.0

    QtObject {
        id: d
        readonly property vector2d base2d : Qt.vector2d(0.0, -15.0)
        property real pixelAndTimeMagicCoeff: 7.0
        property var trajectory: []
        property bool userInteraction: false

        // represents counter for rotation, when it lower than 360  car will be rotated for delta (360 - demoRotation)
        property int demoRotation: 360
        property Timer demoTimer: Timer {
            interval: 60000
            repeat: true
            running: root.enabled
            onTriggered: {
                d.demoRotation = 0
            }
        }
    }

    function getCurrentAngle() {
        var viewVec3d = root.camera.viewVector
        var vec2d = Qt.vector2d(viewVec3d.x, viewVec3d.z);
        var angle = 0.0;
        if (!vec2d.fuzzyEquals(d.base2d)) {
            var dot = vec2d.x*d.base2d.x + vec2d.y*d.base2d.y;
            var det = vec2d.x*d.base2d.y - vec2d.y*d.base2d.x;
            angle = Math.atan2(det, dot);
        }

        return angle * 180 / Math.PI;
    }

    MouseDevice {
        id: mouseSourceDevice
        sensitivity: 0.1
    }

    MouseHandler {
        id: mouseHandler
        sourceDevice: mouseSourceDevice
        onPositionChanged: {
            d.trajectory.push(mouse.x);
        }

        onPressed: {
            d.trajectory = [];
            d.userInteraction = true;
            d.demoRotation = 360;
            d.demoTimer.running = false;
        }

        onReleased: {
            d.userInteraction = false;
            d.demoTimer.running = true;
        }
    }

    components: [
        FrameAction {
            onTriggered: {
                if (d.userInteraction && dt && d.trajectory.length > 2) {
                    var dx = 0
                    for (var i = 1; i < d.trajectory.length; ++i) {
                        dx += d.trajectory[i] - d.trajectory[i - 1];
                    }

                    if (dx !== 0) {
                        root.camera.panAboutViewCenter(-dx * dt * d.pixelAndTimeMagicCoeff
                                                       , Qt.vector3d(0, 1, 0));
                        cameraPanAngle = getCurrentAngle();
                    }

                    d.trajectory = []
                } else if (!d.userInteraction && d.demoRotation < 360) {
                    ++d.demoRotation;
                    root.camera.panAboutViewCenter(-1.0, Qt.vector3d(0, 1, 0));
                    cameraPanAngle = getCurrentAngle();
                }

            }
        }
    ]
}
