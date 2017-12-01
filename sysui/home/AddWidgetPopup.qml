/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
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

import controls 1.0
import utils 1.0
import animations 1.0

import triton.controls 1.0

TritonPopup {
    id: root

    property alias model: listView.model

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.hspan(1)
        Label {
            id: header
            text: qsTr("Add widget")
            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
            Layout.preferredHeight: Style.vspan(1)
        }
        ListView {
            id: listView
            width: parent.width
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            delegate: MouseArea {
                width: parent.width
                height: Style.vspan(1)
                enabled: !model.appInfo.asWidget
                Label {
                    anchors.fill: parent
                    text: model.name
                    enabled: parent.enabled // doesn't seem to be propagating, so making it explicit
                }
                onClicked: {
                    model.appInfo.asWidget = true
                    root.state = "closed"
                }
            }
        }
    }
}
