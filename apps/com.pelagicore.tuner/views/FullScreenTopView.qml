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

import QtQuick 2.8
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.2

import shared.utils 1.0
import shared.animations 1.0

import "../controls" 1.0
import "../panels" 1.0
import "../helpers" 1.0

import shared.Style 1.0
import shared.Sizes 1.0

Item {
    id: root

    property var store
    property bool topExpanded: false

    ToolButton {
        id: showManualViewButton
        width: contentItem.childrenRect.width + Sizes.dp(45)
        height: Sizes.dp(22.5)
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: Sizes.dp(370)
        anchors.horizontalCenter: parent.horizontalCenter
        //disable for AM band, to be implemented
        visible: (root.store.tunerBand === 1)
        enabled: !root.topExpanded
        onClicked: { root.topExpanded = true; }

        contentItem: Row {
            spacing: Sizes.dp(10)
            Label {
                font.pixelSize: Sizes.fontSizeS
                text: qsTr("MANUAL")
                anchors.verticalCenter: parent.verticalCenter
            }
            Image {
                opacity: root.topExpanded ? 0.0 : 1.0
                Behavior on opacity { DefaultNumberAnimation {} }
                source: root.topExpanded ? "" : Style.image("ic-expand-down")
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    TunerSlider {
        id: slider
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: height
        opacity: root.topExpanded ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation {} }
        visible: opacity > 0
        onOpacityChanged: {
            if (opacity > 0.0) {
                Helper.createStationIndicators(root.store.currentPresetModel, slider.width, Sizes.dp(18),
                                              slider.to, slider.from, slider.stationIndicatorComponent, slider);
            }
        }
        from: root.store.minimumFrequency
        to: root.store.maximumFrequency
        numberOfDecimals: root.store.freqPresets === 0 ? 0 : 1
        value: root.store.currentStationFreq
        onPressedChanged: {
            if (!pressed) {
                root.store.setFrequency(value.toFixed(1));
            }
        }
    }

    ToolButton {
        id: showBrowseViewButton
        width: contentItem.childrenRect.width + Sizes.dp(45)
        height: Sizes.dp(22.5)
        anchors.verticalCenter: parent.bottom
        anchors.verticalCenterOffset: Sizes.dp(44)
        anchors.horizontalCenter: parent.horizontalCenter
        opacity: root.topExpanded ? 1.0 : 0.0
        Behavior on opacity {
            SequentialAnimation {
                PauseAnimation { duration: root.topExpanded ? 0 : 100 }
                DefaultNumberAnimation {}
            }
        }
        visible: opacity > 0
        onVisibleChanged: {
            if (visible) {
                //focus 'browse' button
                showBrowseViewButton.forceActiveFocus();
            } else {
                //focus back to 'manual' button
                showManualViewButton.forceActiveFocus();
            }
        }
        onClicked: { root.topExpanded = false; }

        contentItem: Row {
            spacing: Sizes.dp(10)
            Label {
                font.pixelSize: Sizes.fontSizeS
                font.capitalization: Font.AllUppercase
                text: qsTr("BROWSE")
                anchors.verticalCenter: parent.verticalCenter
            }
            Image {
                source: Style.image("ic-expand-up")
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
