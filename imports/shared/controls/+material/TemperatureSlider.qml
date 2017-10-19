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

import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import utils 1.0
import controls 1.0

Control {
    id: root


    implicitWidth: Style.hspan(2)
    implicitHeight: Style.vspan(8)

    readonly property int roundingModeWhole: 1
    readonly property int roundingModeHalf: 2

    property bool mirrorSlider: false

    property alias from: slider.from
    property alias to: slider.to
    property alias value: slider.value
    property int roundingMode: roundingModeWhole
    property alias stepSize: slider.stepSize

    transform: Rotation {
        angle: mirrorSlider ? 180 : 0
        axis { x: 0; y: 1; z: 0 }
        origin { x: root.width/2; y: root.height/2 }
    }

    ColumnLayout {
        id: barRow

        spacing: 0
        width: parent.width
        height: parent.height

        Label {
            Layout.fillWidth: true
            Layout.preferredHeight: Style.vspan(2)

            font.family: Style.fontFamily
            font.pixelSize: Style.fontSizeXL

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: "+"
            color: Style.colorWhite

            MouseArea {
                anchors.fill: parent
                onClicked: slider.increase()
            }
        }

        Slider {
            id: slider
            Layout.fillHeight: true
            Layout.fillWidth: true
            orientation: Qt.Vertical
            snapMode: Slider.SnapAlways
        }

        Label {
            Layout.fillWidth: true
            Layout.preferredHeight: Style.vspan(2)

            font.family: Style.fontFamily
            font.pixelSize: Style.fontSizeXL

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: "-"
            color: Style.colorWhite

            MouseArea {
                anchors.fill: parent
                onClicked: slider.decrease()
            }
        }
    }

    function _clamp(value) {
        return Math.round(Math.min(root.maxValue, Math.max(root.minValue, value))*root.roundingMode)/root.roundingMode
    }
}
