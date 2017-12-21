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
import QtQuick 2.2

Item {
    id: root

    Vehicle3DView {
        id: car3DView

        anchors.top: root.top
        anchors.left: root.left
        width: root.width
        height: 410
    }

    VehicleControlPanel {
        id: controlPanel

        anchors.top: car3DView.bottom
        anchors.left: root.left
        width: root.width
        height: 890

        onRoofOpenedChanged: {
            if(roofOpened)
                car3DView.openRoof()
            else
                car3DView.closeRoof()
        }

        onRoofSliderValueChanged: {
            car3DView.roofSliderValue = roofSliderValue
        }

        onLeftDoorOpenedChanged: {
            if (leftDoorOpened)
                car3DView.openLeftDoor()
            else
                car3DView.closeLeftDoor()
        }

        onRightDoorOpenedChanged: {
            if (rightDoorOpened)
                car3DView.openRightDoor()
            else
                car3DView.closeRightDoor()
        }
    }
}
