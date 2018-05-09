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
import utils 1.0
import controls 1.0
import animations 1.0
import QtQuick.Controls 2.2

import com.pelagicore.styles.neptune 3.0

import "../stores"
import "../panels"
import "../controls"

Item {
    id: root
    property var store

    ToolsColumn {
        id: toolsColumn
        width: NeptuneStyle.dp(264)
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: NeptuneStyle.dp(53)
        model: root.store.toolsColumnModel
        currentIndex: 1
        onClicked: {
            switch (currentText) {
            case "music":
                Qt.openUrlExternally("x-music://");
                break;
            case "web radio":
                Qt.openUrlExternally("x-webradio://");
                break;
            case "spotify":
                Qt.openUrlExternally("x-spotify://");
                break;
            case "AM band":
            case "FM 1 band":
            case "FM 2 band":
                root.store.freqPresets = currentIndex - 1;
                break;
            case "favorites":
                //return favorite stations list
            default:
                break;
            }
        }
    }

    StationBrowseListPanel {
        id: stationBrowseListPanel
        anchors.left: toolsColumn.right
        anchors.right: parent.right
        anchors.top: parent.top
        height: parent.height
        listView.model: root.store.currentPresetModel
        onItemClicked: {
            root.store.setFrequency(root.store.currentPresetModel.get(index).freq);
        }
    }
}
