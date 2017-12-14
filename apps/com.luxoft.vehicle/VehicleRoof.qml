/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AB
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
import QtQuick 2.0
import Qt3D.Core 2.0
import Qt3D.Render 2.9
import Qt3D.Extras 2.9
import Qt3D.Input 2.0
import QtQuick.Scene3D 2.0

VehiclePart {
    id: root

    Transform {
        id: transform
        property real scale: 1.0
        property real translationZ: 0.0
        matrix: {
            var m = Qt.matrix4x4();
            m.translate(Qt.vector3d(0.0, 0.0, translationZ))
            m.scale(Qt.vector3d(1.0, 1.0, scale))
            return m;
        }
    }

    function openRoof() {
        roofAnimation.restart()
        roofAnimationT.restart()
    }

    function closeRoof() {
    }

    NumberAnimation {
        id: roofAnimation
        target: transform
        property: "scale"
        duration: 1000
        from: 1.0
        to: 0.0
    }
    NumberAnimation {
        id: roofAnimationT
        target: transform
        property: "translationZ"
        duration: 1000
        from: 0.0
        to: -1.15
    }

    components: [transform, myMesh, material]
}
