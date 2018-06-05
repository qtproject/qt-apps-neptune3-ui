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

import QtQuick 2.6
import QtQuick.Controls 2.2

import utils 1.0

import com.pelagicore.styles.neptune 3.0

PopupWindow {
    id: root

    // TODO this will be refactored in 5.12 following the API changes
    // of the appman. See PopupWindow.qml for further explanations.

    property var model: [{"text": "Purple"}, {"text" : "Deep blue"}, {"text" : "Violet"}]

    Item {
        anchors.fill: parent

        Label {
            anchors.baseline: parent.top
            anchors.baselineOffset: popupScale * 78
            font.pixelSize: popupScale * NeptuneStyle.fontSizeM
            width: parent.width
            text: "Choose color"
            horizontalAlignment: Text.AlignHCenter
        }
        Image {
            id: shadow
            anchors.top: parent.top
            anchors.topMargin: popupScale * 120
            width: parent.width
            height: popupScale * sourceSize.height
            source: Style.gfx("popup-title-shadow")
        }

        ListView {
            anchors {
                top: shadow.bottom
                left: parent.left
                leftMargin: popupScale * 40
                right: parent.right
                rightMargin: popupScale * 40
                bottom: parent.bottom
                bottomMargin: popupScale * 40
            }
            model: root.model
            interactive: false
            delegate: RadioButton {
                width: parent.width
                height:  popupScale * 96
                font.pixelSize: popupScale * NeptuneStyle.fontSizeS
                indicator.implicitHeight: popupScale * 30
                indicator.implicitWidth: popupScale * 30
                text: modelData.text
                spacing: 20
            }
        }
    }
}