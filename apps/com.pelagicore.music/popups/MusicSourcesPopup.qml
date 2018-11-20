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
import shared.utils 1.0
import application.windows 1.0

import shared.Sizes 1.0

PopupWindow {
    id: root

    /*!
        \qmlproperty var MusicSourcesPopup::model

        The alias property of the list view's model.
    */
    property alias model: listView.model

    width: Sizes.dp(910)

    // caclulate popup height based on musicSources list items
    // + 200 for header & margins
    height: model ? Sizes.dp(200 + (model.count * 96)) : Sizes.dp(296)


    Item {
        id: popupContent

        anchors.fill: parent

        Label {
            id: header
            anchors.baseline: parent.top
            anchors.baselineOffset: Sizes.dp(75)
            width: parent.width
            text: qsTr("Choose Source")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Sizes.fontSizeM
        }
        Image {
            id: shadow
            anchors.top: parent.top
            anchors.topMargin: Sizes.dp(120)
            width: parent.width
            height: Sizes.dp(sourceSize.height)
            source: Config.gfx("popup-title-shadow")
        }

        ListView {
            id: listView
            anchors {
                top: shadow.bottom
                left: parent.left
                leftMargin: Sizes.dp(40)
                right: parent.right
                rightMargin: Sizes.dp(40)
                bottom: parent.bottom
                bottomMargin: Sizes.dp(40)
            }
            interactive: false
            delegate: RadioButton {
                width: parent.width
                height: Sizes.dp(96)
                font.pixelSize: Sizes.fontSizeS
                indicator.implicitHeight: Sizes.dp(30)
                indicator.implicitWidth: Sizes.dp(30)
                text: model.text
                spacing: Sizes.dp(20)
                onClicked: {
                    if (text === "AM/FM Radio") {
                        Qt.openUrlExternally("x-tuner://");
                    } else if (text === "Web radio") {
                        Qt.openUrlExternally("x-webradio://");
                    } else if (text === "Spotify") {
                        Qt.openUrlExternally("x-spotify://");
                    }
                    root.close();
                }
            }
        }
    }
}
