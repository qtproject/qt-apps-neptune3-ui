/****************************************************************************
**
** Copyright (C) 2017-2018 Pelagicore AG
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
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import utils 1.0
import animations 1.0
import com.pelagicore.styles.triton 1.0
import triton.controls 1.0

TritonPopup {
    id: root
    width: Style.hspan(22)
    height: Style.vspan(19)

    property var model
    onModelChanged: {
        if (model) {
            // need to set "to" and "from" before "value", as modifying them also causes
            // "value" to change

            leftTempSlider.from = model.leftSeat.minValue
            leftTempSlider.to = model.leftSeat.maxValue
            leftTempSlider.value = model.leftSeat.value

            rightTempSlider.from = model.rightSeat.minValue
            rightTempSlider.to = model.rightSeat.maxValue
            rightTempSlider.value = model.rightSeat.value
        }
    }

    TemperatureSlider {
        id: leftTempSlider
        anchors.top: parent.top
        anchors.topMargin: Style.vspan(1.3)
        anchors.left: parent.left
        anchors.leftMargin: Style.hspan(1)
        height: Style.vspan(15)
        convertFunc: model.calculateUnitValue

        property bool sliderChanging: false
        onValueChanged: {
            if (pressed) {
                sliderChanging = true;
                model.leftSeat.setValue(value);
                sliderChanging = false;
            }
        }
    }
    Connections {
        target: model ? model.leftSeat : null
        onValueChanged: if (!leftTempSlider.sliderChanging) leftTempSlider.value = target.value
    }

    ClimateButtonsGrid {
        id: buttonsGrid
        anchors.top: parent.top
        anchors.topMargin: Style.vspan(3)
        anchors.horizontalCenter: parent.horizontalCenter
        width: Style.hspan(8)
        height: width
        model: root.model
    }
    Rectangle {
        color: TritonStyle.disabledTextColor
        height: Style.vspan(0.03)
        anchors.left: buttonsGrid.left
        anchors.right: buttonsGrid.right
        anchors.verticalCenter: buttonsGrid.verticalCenter
    }
    Rectangle {
        color: TritonStyle.disabledTextColor
        width: Style.vspan(0.03)
        anchors.top: buttonsGrid.top
        anchors.bottom: buttonsGrid.bottom
        anchors.horizontalCenter: buttonsGrid.horizontalCenter
    }

    Image {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: bigFatButton.top
        anchors.bottomMargin: Style.vspan(0.5)
        source: Style.gfx2("mannequin", TritonStyle.theme)
    }

    RoundButton {
        id: bigFatButton
        width: Style.hspan(7)
        height: Style.vspan(1)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Style.vspan(5)
        contentItem: Label {
            text: bigFatButton.text
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
        background: Rectangle {
            radius: bigFatButton.radius
            color: bigFatButton.down ? Qt.lighter(TritonStyle.accentColor, 1.3) : TritonStyle.accentColor
            Behavior on color { ColorAnimation {} }
        }

        //: As in "automatic"
        text: qsTr("AUTO")
    }

    TemperatureSlider {
        id: rightTempSlider
        anchors.top: parent.top
        anchors.topMargin: Style.vspan(1.3)
        anchors.right: parent.right
        anchors.rightMargin: Style.hspan(1)
        height: Style.vspan(15)

        convertFunc: model.calculateUnitValue
        rulerSide: rightSide

        property bool sliderChanging: false
        onValueChanged: {
            if (pressed) {
                sliderChanging = true;
                model.rightSeat.setValue(value);
                sliderChanging = false;
            }
        }
    }
    Connections {
        target: model ? model.rightSeat : null
        onValueChanged: if (!rightTempSlider.sliderChanging) rightTempSlider.value = target.value
    }


    Item {
        anchors.left: parent.left
        anchors.leftMargin: Style.hspan(1)
        anchors.right: parent.right
        anchors.rightMargin: Style.hspan(1)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Style.vspan(1.3)
        Label {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            text: leftTempSlider.valueAt(leftTempSlider.position).toLocaleString(Qt.locale(), 'f', 1) + model.tempSuffix
            font.pixelSize: TritonStyle.fontSizeXL
            opacity: 0.6
        }

        Rectangle {
            anchors.right: tempLink.left
            anchors.rightMargin: Style.hspan(0.5)
            anchors.verticalCenter: parent.verticalCenter
            color: TritonStyle.primaryTextColor
            height: Style.vspan(0.03)
            width: Style.hspan(6)
            opacity: 0.25
        }
        Image {
            id: tempLink
            width: Style.hspan(1)
            height: width
            anchors.centerIn: parent
            source: Style.symbol("ic-link-status", TritonStyle.theme)
            fillMode: Image.Pad
            MouseArea {
                anchors.fill: parent
                onClicked: model.rightSeat.setValue(model.leftSeat.value)
            }
        }
        Rectangle {
            anchors.left: tempLink.right
            anchors.leftMargin: Style.hspan(0.5)
            anchors.verticalCenter: parent.verticalCenter
            color: TritonStyle.primaryTextColor
            height: Style.vspan(0.03)
            width: Style.hspan(6)
            opacity: 0.25
        }

        Label {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            text: rightTempSlider.valueAt(rightTempSlider.position).toLocaleString(Qt.locale(), 'f', 1) + model.tempSuffix
            font.pixelSize: TritonStyle.fontSizeXL
            opacity: 0.6
        }
    }
}
