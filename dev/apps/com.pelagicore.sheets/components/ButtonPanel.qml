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
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import utils 1.0

import com.pelagicore.styles.neptune 3.0

Item {
    id: root

    readonly property int largeButtonHeight: 100
    readonly property int smallButtonHeight: 52
    readonly property int largeButtonPadding: 58
    readonly property int smallButtonPadding: 26

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: Style.vspan(1)
        spacing: Style.vspan(.5)
        RowLayout {
            spacing: Style.hspan(0.3)

            Button {
                implicitWidth: Style.hspan(7)
                implicitHeight: Style.vspan(0.8)
                font.pixelSize: NeptuneStyle.fontSizeS
                text: "This is a button"
            }

            Button {
                implicitWidth: Style.hspan(7)
                implicitHeight: Style.vspan(0.8)
                font.pixelSize: NeptuneStyle.fontSizeS
                text: "Disabled Button"
                enabled: false
            }

            Button {
                implicitWidth: Style.hspan(7)
                implicitHeight: Style.vspan(0.8)
                font.pixelSize: NeptuneStyle.fontSizeS
                text: "Button Checkable"
                checkable: true
            }
        }
        RowLayout {
            spacing: Style.hspan(0.3)

            Button {
                implicitHeight: smallButtonHeight
                implicitWidth: Style.hspan(7)
                leftPadding: smallButtonPadding
                rightPadding: smallButtonPadding
                font.pixelSize: NeptuneStyle.fontSizeS
                text: "Small button"
            }
            Button {
                implicitHeight: smallButtonHeight
                implicitWidth: Style.hspan(7)
                leftPadding: smallButtonPadding
                rightPadding: smallButtonPadding
                font.pixelSize: NeptuneStyle.fontSizeS
                text: "Small button"
                icon.name: "ic-steering-wheel-heat_OFF"
            }
            Button {
                implicitHeight: smallButtonHeight
                implicitWidth: Style.hspan(7)
                leftPadding: smallButtonPadding
                rightPadding: smallButtonPadding
                font.pixelSize: NeptuneStyle.fontSizeS
                text: "Checkable"
                icon.name: checked ? "ic-steering-wheel-heat_ON" : "ic-steering-wheel-heat_OFF"
                checkable: true
            }
        }
        RowLayout {
            spacing: Style.hspan(0.3)
            Button {
                text: "Large button"
                implicitHeight: largeButtonHeight
                implicitWidth: Style.hspan(7)
                leftPadding: largeButtonPadding
                rightPadding: largeButtonPadding
                font.pixelSize: NeptuneStyle.fontSizeS

            }
            Button {
                implicitHeight: largeButtonHeight
                implicitWidth: Style.hspan(7)
                leftPadding: largeButtonPadding
                rightPadding: largeButtonPadding
                font.pixelSize: NeptuneStyle.fontSizeS
                text: "Large button"
                icon.name: "ic-steering-wheel-heat_OFF"
            }
            Button {
                implicitHeight: largeButtonHeight
                implicitWidth: Style.hspan(7)
                leftPadding: largeButtonPadding
                rightPadding: largeButtonPadding
                font.pixelSize: NeptuneStyle.fontSizeS
                text: "Checkable"
                icon.name: checked ? "ic-seat-heat-passenger_ON" : "ic-seat-heat-passenger_OFF"
                checkable: true
            }
        }
        RowLayout {
            spacing: Style.hspan(0.3)

            Button {
                implicitHeight: largeButtonHeight
                implicitWidth: 160
                icon.width: 40
                icon.height: 40
                customBackgroundColor: NeptuneStyle.clusterMarksColor
                icon.name: "ic-seat-heat-passenger_OFF"
                icon.color: "white"
            }
            Button {
                implicitHeight: largeButtonHeight
                implicitWidth: 160
                icon.width: 35
                icon.height: 35
                customBackgroundColor: NeptuneStyle.highlightedTextColor
                icon.name: "ic-seat-heat-passenger_OFF"
                text: "text"
                font.pixelSize: NeptuneStyle.fontSizeS
                display: AbstractButton.TextUnderIcon
                spacing: 0
            }
        }
        RowLayout {
            spacing: Style.hspan(0.3)
            Button {
                implicitHeight: largeButtonHeight
                implicitWidth: 500
                leftPadding: largeButtonPadding
                rightPadding: largeButtonPadding
                text: "Wide button"
                font.pixelSize: NeptuneStyle.fontSizeS
                icon.name: "ic-steering-wheel-heat_OFF"
            }
            Button {
                implicitHeight: largeButtonHeight
                implicitWidth: Style.hspan(7)
                leftPadding: largeButtonPadding
                rightPadding: largeButtonPadding
                font.pixelSize: NeptuneStyle.fontSizeS
                text: "Elide too long text"
                icon.name: "ic-steering-wheel-heat_OFF"
            }
        }
    }
}

