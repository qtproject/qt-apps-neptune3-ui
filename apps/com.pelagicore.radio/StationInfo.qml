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
import QtGraphicalEffects 1.0

import utils 1.0
import controls 1.0

import com.pelagicore.styles.triton 1.0

Control {
    id: root
    width: Style.hspan(6.5)
    height: Style.vspan(2)

    property bool tuningMode: false
    property alias title: title.text
    property alias radioText: radioText.text
    property real frequency
    property int numberOfDecimals: 1
    signal clicked()

    ColumnLayout {
        id: theLayout
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: Style.vspan(0.2)

        Label {
            id: frequency
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter

            text: root.frequency.toLocaleString(Qt.locale(), 'f', root.numberOfDecimals)
            font.pixelSize: Style.fontSizeXXL
        }

        Label {
            id: title
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            font.weight: Font.Light
            opacity: 0.5
            visible: text !== ""
        }

        Item {
            id: radioTextContainer
            width: root.width
            height: radioText.height
            clip: true

            readonly property bool scrollingText: radioText.contentWidth > radioText.width

            Text {
                id: radioText

                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: TritonStyle.fontSizeS

                onTextChanged: {
                    if (text != "" && radioTextContainer.scrollingText ) {
                        pingPongAnimation.running = true
                    } else {
                        pingPongAnimation.running = false
                        radioText.x = 0
                    }
                }
            }

            // TODO: Adjust the animation according to designer's decision.
            SequentialAnimation {
                id: pingPongAnimation
                PauseAnimation { duration: 500 }
                NumberAnimation { target: radioText; property: "x"; from: 0; to: radioTextContainer.width - radioText.contentWidth; duration: 3000;  }
                PauseAnimation { duration: 1000 }
                NumberAnimation { target: radioText; property: "x"; to: 0; duration: 3000 }
                PauseAnimation { duration: 500 }
            }
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
