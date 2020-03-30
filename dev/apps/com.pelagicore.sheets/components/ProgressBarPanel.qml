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

import shared.Sizes 1.0

Item {
    id: root
    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(50)
        spacing: Sizes.dp(100)

        Label {
            font.pixelSize: Sizes.fontSizeS
            text: qsTr("Simple ProgressBar with background")
        }

        ProgressBar {
            implicitWidth: Sizes.dp(880)
            implicitHeight: Sizes.dp(8)
            from: 0
            to: 1
            value: 0
            indeterminate: false
            SequentialAnimation on value {
                loops: Animation.Infinite
                PropertyAnimation { to: 0; duration: 1500 }
                PropertyAnimation { to: 1; duration: 1500 }
            }
        }

        Label {
            font.pixelSize: Sizes.fontSizeS
            text: qsTr("Indeterminate ProgressBar with background")
        }

        ProgressBar {
            implicitWidth: Sizes.dp(880)
            implicitHeight: Sizes.dp(8)
            from: 0
            to: 1
            value: 0
            indeterminate: true
            SequentialAnimation on value {
                loops: Animation.Infinite
                PropertyAnimation { to: 0; duration: 1000 }
                PropertyAnimation { to: 1; duration: 1000 }
            }
        }


        Label {
            font.pixelSize: Sizes.fontSizeS
            text: qsTr("Simple ProgressBar no background")
        }

        ProgressBar {
            implicitWidth: Sizes.dp(880)
            implicitHeight: Sizes.dp(8)
            from: 0
            to: 1
            value: 0
            indeterminate: false
            backgroundVisible: false
            SequentialAnimation on value {
                loops: Animation.Infinite
                PropertyAnimation { to: 0; duration: 1000 }
                PropertyAnimation { to: 1; duration: 1000 }
            }
        }


        Label {
            font.pixelSize: Sizes.fontSizeS
            text: qsTr("Indeterminate ProgressBar no background")
        }

        ProgressBar {
            implicitWidth: Sizes.dp(880)
            implicitHeight: Sizes.dp(8)
            from: 0
            to: 1
            value: 0
            indeterminate: true
            backgroundVisible: false
            SequentialAnimation on value {
                loops: Animation.Infinite
                PropertyAnimation { to: 0; duration: 1000 }
                PropertyAnimation { to: 1; duration: 1000 }
            }
        }
    }
}

