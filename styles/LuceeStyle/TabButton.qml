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

import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.impl 2.3
import QtQuick.Templates 2.3 as T

import shared.utils 1.0
import shared.Style 1.0
import shared.Sizes 1.0
import shared.controls 1.0
import shared.utils 1.0

T.TabButton {
    id: control

    //internal to avoid binding loops
    readonly property real letterSpacing: font.pixelSize === Sizes.fontSizeS ? -0.41 : -0.57

    font.pixelSize: Sizes.fontSizeS

    font.letterSpacing: selected ? control.letterSpacing : 0

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             contentItem.implicitHeight + topPadding + bottomPadding)
    baselineOffset: contentItem.y + contentItem.baselineOffset

    font.weight: selected ? Font.Normal : Font.Light

    Cursor {
        onActivated: {
            control.clicked();
        }

        onPressAndHold: {
            control.pressAndHold();
        }
    }

    contentItem: IconLabel {
        spacing: control.spacing
        mirrored: control.mirrored
        display: control.display
        icon: control.icon
        text: control.text
        font: control.font
        color: selected ? Style.mainColor : Style.contrastColor
    }

    readonly property string positionState: {
        if (TabBar.index === 0) {
            return LayoutMirroring.enabled ? "right" : "left";
        } else if (TabBar.index === TabBar.tabBar.contentModel.count - 1) {
            return LayoutMirroring.enabled ? "left" : "right";
        } else {
            return "middle";
        }
    }

    readonly property bool selected: TabBar.tabBar.currentIndex === TabBar.index

    background: ScalableBorderImage {
        id: borderImage
        anchors.fill: parent
        source: Style.image("tabbar-bg-" + control.positionState)

        opacity: (control.selected ? 0.7 : 0.3) + (control.pressed ? 0.1 : 0)

        state: control.positionState
        states: [
            State {
                name: "left"
                PropertyChanges {
                    target: borderImage

                    //don't change these values without knowing the exact size of source image
                    //QTBUG-73768 if border exceeds source image size, app crashes, avoid Sizes.dp here
                    border.left: 26
                    border.right: 0
                    border.top: 22
                    border.bottom: 48 - 25
                }
            },
            State {
                name: "right"
                PropertyChanges {
                    target: borderImage

                    //don't change these values without knowing the exact size of source image
                    //QTBUG-73768 if border exceeds source image size, app crashes, avoid Sizes.dp here
                    border.left: 0
                    border.right: 30 - 5
                    border.top: 22
                    border.bottom: 48 - 25
                }
            },
            State {
                name: "middle"
                PropertyChanges {
                    target: borderImage

                    //don't change these values without knowing the exact size of source image
                    //QTBUG-73768 if border exceeds source image size, app crashes, avoid Sizes.dp here
                    border.left: 0
                    border.right: 0
                    border.top: 0
                    border.bottom: 0
                }
            }
        ]
        horizontalTileMode: BorderImage.Stretch
        verticalTileMode: BorderImage.Stretch
    }
}
