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
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import shared.utils 1.0

import shared.Style 1.0
import shared.Sizes 1.0

import "../assets"

Control {
    id: root

    property ListModel model

    signal themeRequested(int theme)

    contentItem: ListView {
        id: view
        clip: true
        interactive: contentHeight > height

        model: root.model

        delegate: ItemDelegate {
            id: delegate
            objectName: "themeNr_" + index
            onClicked: {
                if (index !== Style.theme) {
                    root.themeRequested(index);
                }
            }
            width: ListView.view.width

            contentItem: ColumnLayout {
                id: columnContent
                anchors.fill: parent

                RowLayout {
                    RadioButton {
                        checked: (index === Style.theme)
                        onToggled: { delegate.clicked(); }
                    }
                    Label {
                        text: qsTranslate("RootStore", model.title)
                    }
                }

                Image {
                    Layout.maximumWidth: columnContent.width
                    Layout.minimumWidth: columnContent.width
                    Layout.maximumHeight: Sizes.dp(sourceSize.height)
                    source: Assets.gfx("theme_" + model.theme)
                }
                Image {
                    Layout.maximumWidth: columnContent.width
                    Layout.minimumWidth: columnContent.width
                    source: Style.image("list-divider")
                    visible: index !== view.count - 1
                }
            }
        }
    }
}
