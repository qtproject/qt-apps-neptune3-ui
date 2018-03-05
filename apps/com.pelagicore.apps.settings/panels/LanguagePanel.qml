/****************************************************************************
**
** Copyright (C) 2017-2018 Pelagicore AG
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

Control {
    id: root

    property ListModel model

    property string currentLanguage

    signal languageRequested(string language)

    contentItem: ListView {
        id: view
        clip: true
        interactive: contentHeight > height

        model: root.model

        delegate: AbstractButton {
            id: languageDelegate

            width: ListView.view.width
            height: Style.vspan(110/80)
            onClicked: root.languageRequested(model.language)

            contentItem: Item {
                RadioButton {
                    id: radio
                    checked: model.language === root.currentLanguage
                    width: Style.hspan(100/45)
                    height: parent.height

                    onToggled: languageDelegate.clicked()
                }

                Item {
                    anchors.left: radio.right
                    height: parent.height

                    Label {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: -20
                        text: model.title
                        font.weight: Style.fontWeight
                    }
                    Label {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 20
                        text: model.subtitle
                        font.pixelSize: Style.fontSizeS
                        font.weight: Style.fontWeight
                    }
                }
                Image {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    source: Style.gfx2("list-divider", NeptuneStyle.theme)
                    visible: index !== view.count - 1
                }
            }
        }
    }
}
