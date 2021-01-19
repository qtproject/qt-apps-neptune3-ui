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

import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0

import shared.effects 1.0
import shared.animations 1.0
import shared.Style 1.0
import shared.Sizes 1.0

Control {
    id: root

    width: Sizes.dp(890)
    height: parent.height
    property alias source: contactImage.source
    property bool lastItem: false
    property bool maximized: false
    property bool enableOpacityMasks
    signal callWidgetClicked(var handle)

    background: Image {
        id: sectionBackground
        source: Style.image("phone-widget-section-gradient")
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        fillMode: Image.Stretch
        visible: !root.lastItem
    }

    contentItem: Item {
        id: widgetContent
        height: Sizes.dp(260)
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: root.maximized ? Sizes.dp(68) : 0
        Behavior on anchors.verticalCenterOffset { DefaultNumberAnimation{} }

        RoundImage {
            id: contactImage
            width: Sizes.dp(200)
            height: width
            anchors.left: parent.left
            anchors.leftMargin: Sizes.dp(60)
            anchors.verticalCenter: parent.verticalCenter
            opacity: 1
            enabled: false
            enableOpacityMasks: root.enableOpacityMasks
        }

        Column {
            id: textColumn

            anchors.left: contactImage.right
            anchors.leftMargin: Sizes.dp(40)
            anchors.verticalCenter: parent.verticalCenter
            width: Sizes.dp(428)
            spacing: Sizes.dp(18)

            Label {
                width: parent.width
                Layout.alignment: Qt.AlignLeft
                text: model.firstName + " " + model.surname
            }

            Label {
                width: parent.width
                Layout.alignment: Qt.AlignLeft
                font.pixelSize: Sizes.fontSizeS
                opacity: Style.opacityMedium
                text: model.phoneNumbers.get(0).number + " - " + model.phoneNumbers.get(0).name
                elide: Text.ElideRight
            }
        }

        MouseArea {
            anchors.fill: parent
        }

        ToolButton {
            anchors.right: parent.right
            anchors.rightMargin: Sizes.dp(69)
            anchors.verticalCenter: parent.verticalCenter

            width: Sizes.dp(90)
            height: Sizes.dp(90)
            icon.name: "ic-call-contrast"
            icon.color: "white"

            background: Image {
                id: callButtonBackground
                anchors.centerIn: parent
                width: Sizes.dp(sourceSize.width)
                height: Sizes.dp(sourceSize.height)
                source: Style.image("ic_button-bg")
                fillMode: Image.PreserveAspectFit

                ScalableColorOverlay {
                    anchors.fill: parent
                    source: callButtonBackground
                    color: Style.accentColor
                }
            }
            onClicked: {
                root.callWidgetClicked(model.handle);
            }
        }
    }
}
