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
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.2

import utils 1.0
import "../controls"
import "../panels"

import com.pelagicore.styles.neptune 3.0

Item {
    id: root

    property var store

    Connections {
        target: root.store

        onCurrentFrequencyChanged: {
            if (!slider.dragging) {
                stationInfo.tuningMode = false
            }
        }
    }

    ColumnLayout {
        id: stationControl
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: NeptuneStyle.dp(160)

        RowLayout {
            Layout.alignment: Qt.AlignHCenter

            ToolButton {
                Layout.preferredWidth: NeptuneStyle.dp(45)
                Layout.preferredHeight: NeptuneStyle.dp(80)
                icon.name: "ic_skipprevious"
                onClicked: root.store.prevStation()
                onPressAndHold: root.store.scanBack()
            }

            Label {
                Layout.preferredWidth: NeptuneStyle.dp(225)
                text: root.store.currentFreqPreset
                font.pixelSize: NeptuneStyle.fontSizeXXL
                horizontalAlignment: Text.AlignHCenter
            }

            StationInfoPanel {
                id: stationInfo
                topPadding: NeptuneStyle.dp(20)
                Layout.preferredWidth: NeptuneStyle.dp(292)
                Layout.preferredHeight: NeptuneStyle.dp(160)
                title: root.store.currentStationName
                numberOfDecimals: root.store.freqPresets === 2 ? 0 : 1
                frequency: stationInfo.tuningMode ? slider.value : root.store.currentFrequency
            }

            Label {
                Layout.preferredWidth: NeptuneStyle.dp(225)
                text: root.store.freqUnit
                font.pixelSize: NeptuneStyle.fontSizeXXL
                horizontalAlignment: Text.AlignHCenter
            }

            ToolButton {
                Layout.preferredWidth: NeptuneStyle.dp(45)
                Layout.preferredHeight: NeptuneStyle.dp(80)
                icon.name: "ic_skipnext"
                onClicked: root.store.nextStation()
                onPressAndHold: root.store.scanForward()
            }
        }

        TunerSlider {
            id: slider

            Layout.preferredWidth: NeptuneStyle.dp(900)
            Layout.preferredHeight: NeptuneStyle.dp(80)
            Layout.alignment: Qt.AlignHCenter

            readonly property real minFrequency: root.store.minimumFrequency
            readonly property real maxFrequency: root.store.maximumFrequency

            value: root.store.currentFrequency
            minimum: minFrequency
            maximum: maxFrequency
            useAnimation: true
            numberOfDecimals: root.store.freqPresets === 2 ? 0 : 1

            onActiveValueChanged: value = activeValue

            onDraggingChanged: {
                if (dragging) {
                    stationInfo.tuningMode = true
                } else {
                    stationInfo.tuningMode = false
                    root.store.setFrequency(value)
                }
            }
        }
    }
}
