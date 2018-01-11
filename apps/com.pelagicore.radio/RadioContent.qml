/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AG
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
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.2

import controls 1.0
import utils 1.0
import "stores"

import com.pelagicore.styles.triton 1.0

Item {
    id: root

    property RadioStore store

    Connections {
        target: root.store

        onCurrentFrequencyChanged: {
            if (!slider.dragging) {
                stationInfo.tuningMode = false
                slider.value = root.store.currentFrequency
            }
        }
    }

    ColumnLayout {
        id: stationControl
        width: root.width
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: Style.vspan(2)

        RowLayout {
            anchors.horizontalCenter: parent.horizontalCenter

            Tool {
                Layout.preferredWidth: Style.hspan(1)
                Layout.preferredHeight: Style.vspan(1)
                symbol: Style.symbol("ic_skipprevious")
                anchors.verticalCenter: parent.verticalCenter
                onClicked: root.store.scanBack()
            }

            Label {
                Layout.preferredWidth: Style.hspan(5)
                text: root.store.currentFreqPreset
                font.pixelSize: TritonStyle.fontSizeXXL
                horizontalAlignment: Text.AlignHCenter
            }

            StationInfo {
                id: stationInfo
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: Style.vspan(0.25)
                title: root.store.currentStation.stationName
                radioText: root.store.currentStation.radioText
                frequency: stationInfo.tuningMode ? slider.value : root.store.currentFrequency
            }

            Label {
                Layout.preferredWidth: Style.hspan(5)
                text: root.store.freqUnit
                font.pixelSize: TritonStyle.fontSizeXXL
                horizontalAlignment: Text.AlignHCenter
            }

            Tool {
                Layout.preferredWidth: Style.hspan(1)
                Layout.preferredHeight: Style.vspan(1)
                symbol: Style.symbol("ic_skipnext")
                anchors.verticalCenter: parent.verticalCenter
                onClicked: root.store.scanForward()
            }
        }

        TunerSlider {
            id: slider

            Layout.preferredWidth: Style.hspan(20)
            Layout.preferredHeight: Style.vspan(1)
            anchors.horizontalCenter: parent.horizontalCenter

            readonly property real minFrequency: root.store.minimumFrequency
            readonly property real maxFrequency: root.store.maximumFrequency

            value: root.store.currentFrequency
            minimum: minFrequency
            maximum: maxFrequency
            useAnimation: true

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

    GridView {
        id: freqPresetsGrid

        width: root.width * 0.6
        height: Style.vspan(2.5)
        anchors.top: stationControl.bottom
        anchors.topMargin: Style.vspan(2)
        anchors.horizontalCenter: parent.horizontalCenter

        model: root.store.freqPresetsModel
        cellWidth: Style.hspan(4.8); cellHeight: Style.hspan(2.2)

        delegate: DelegatedGrid {
            width: Style.hspan(4.65)
            height: Style.hspan(2)
            text: name
            onClicked: root.store.freqPresets = index
        }
    }

    GridView {
        width: root.width * 0.8
        height: Style.vspan(5)
        anchors.top: freqPresetsGrid.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        cellWidth: Style.hspan(4.8); cellHeight: cellWidth
        interactive: false

        model: {
            if (root.store.freqPresets === 0) {
                return root.store.fm1Stations;
            } else if (root.store.freqPresets === 1) {
                return root.store.fm2Stations;
            } else {
                return root.store.amStations;
            }
        }

        delegate: DelegatedGrid {
            width: Style.hspan(4.65)
            height: Style.hspan(4)
            text: freq.toLocaleString(Qt.locale(), 'f', 1)
            onClicked: {
                root.store.setFrequency(freq);
                root.store.currentStationIndex = index;
            }
        }
    }
}
