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

Entity {
    id: root

    property real roofSliderValue: 0.0

    property real roofClosedPosition: -1.15
    property real roofOpenedPosition: 0.0

    Transform {
        id: transform
        property real translationZ: roofClosedPosition
        matrix: {
            var m = Qt.matrix4x4();
            m.scale(Qt.vector3d(vehicle3DView.scaleFactor,
                                vehicle3DView.scaleFactor,
                                vehicle3DView.scaleFactor * (1 - roofSliderValue)));
            m.translate(Qt.vector3d(0.0, 0.0, translationZ * roofSliderValue));
            return m;
        }
    }

    Mesh {
        id: mesh
        meshName: "sun_roof"
        source: vehicle3DView.carObjFilePath
    }

    function openRoof() {        
        roofTranslateAnimation.restart()
        roofScaleAnimation.restart()
    }

    function closeRoof() {
        roofTranslateAnimationClose.restart()
        roofScaleAnimationClose.restart()
    }

    NumberAnimation {
        id: roofScaleAnimation
        target: root
        property: "roofSliderValue"
        duration: 1000
        from: roofSliderValue
        to: 1.0
    }

    NumberAnimation {
        id: roofTranslateAnimation
        target: transform
        property: "translationZ"
        duration: 1000
        from: transform.translationZ
        to: roofOpenedPosition
    }

    NumberAnimation {
        id: roofScaleAnimationClose
        target: root
        property: "roofSliderValue"
        duration: 1000
        from: root.roofSliderValue
        to: 0.0
    }

    NumberAnimation {
        id: roofTranslateAnimationClose
        target: transform
        property: "translationZ"
        duration: 1000
        from: transform.translationZ
        to: roofClosedPosition
    }

    components: [transform, mesh, grayMaterial]
}
