/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
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
import QtQuick.Layouts 1.2

import com.pelagicore.styles.neptune 3.0

Control {
    id: root

    property string contentType: "track"
    property string albumName: ""
    property string artistName: ""
    property alias listView: listView

    // Since contentType might have some unique id's when we browse a music by going
    // from one level to another level, a content type slicing is needed to get the
    // intended content type. This property helper will return the actual content type.
    readonly property string actualContentType: root.contentType.slice(-5)

    clip: true

    signal itemClicked(var index, var item, var title)
    signal libraryGoBack(var goToArtist)
    signal nextClicked()
    signal backClicked()

    contentItem: Item {

        Component {
            id: delegatedItem
            ListItem {
                id: delegatedSong
                width: listView.width
                height: Style.vspan(1.3)
                highlighted: false
                text: {
                    if (model.item.title && (root.actualContentType === "track")) {
                        return model.item.title;
                    } else if (model.name) {
                        return model.name;
                    } else {
                        return qsTr("Unknown Track");
                    }
                }
                subText: {
                    if (model.item.artist && (root.actualContentType === "track")) {
                        return model.item.artist;
                    } else if (model.item.data.artist && root.actualContentType === "album") {
                        return model.item.data.artist;
                    }
                }
                onClicked: root.itemClicked(model.index, model.item, delegatedSong.text)
            }
        }

        ListView {
            id: listView
            implicitWidth: Style.hspan(17)
            implicitHeight: root.height
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: Style.hspan(40/45)
            anchors.rightMargin: Style.hspan(40/45)
            boundsBehavior: listView.interactive ? Flickable.DragAndOvershootBounds : Flickable.StopAtBounds
            delegate: delegatedItem
        }

        MusicScrollBar {
            attachTo: listView
        }
    }
}
