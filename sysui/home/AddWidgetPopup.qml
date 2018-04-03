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

import QtQuick 2.6
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.2

import controls 1.0
import utils 1.0
import animations 1.0

import neptune.controls 1.0
import com.pelagicore.styles.neptune 3.0

NeptunePopup {
    id: root

    property alias model: delegateModel.model
    readonly property int popupHeight: popupContent.height
    height: Math.max(root.minHeight, popupHeight)

    DelegateModel {
        id: delegateModel

        groups: [
            DelegateModelGroup {
                name: "supportsWidgetState"
                includeByDefault: false
            },
            DelegateModelGroup {
                id: allItemsGroup
                name: "all"
                includeByDefault: true
                onChanged: {
                    var i;
                    for (i = 0; i < inserted.length; ++i) {
                        var j = 0;
                        for (j = 0; j < inserted[i].count; ++j) {
                            var index = inserted[i].index + j;
                            var entry = get(index);
                            var appInfo = entry.model.appInfo;
                            if (appInfo.categories.indexOf("widget") !== -1) {
                                entry.groups = ["all", "supportsWidgetState"];
                            }
                        }
                    }
                }
            }
        ]

        filterOnGroup: "supportsWidgetState"

        delegate: ListItem {
            width: ListView.view.width
            height: NeptuneStyle.dp(80)
            symbol: model.appInfo ? Qt.resolvedUrl(model.appInfo.icon) : null
            text: model.appInfo ? model.appInfo.name : null
            enabled: model.appInfo ? !model.appInfo.asWidget : false
            onClicked: {
                model.appInfo.asWidget = true
                root.state = "closed"
            }
            dividerVisible: delegateModel.count - 1 !== DelegateModel.supportsWidgetStateIndex
        }
    }

    Item {
        id: popupContent
        width: parent.width
        height: widgetListview.contentHeight + widgetListview.anchors.topMargin + widgetListview.anchors.bottomMargin + shadow.anchors.topMargin + shadow.paintedHeight

        Label {
            id: header
            anchors.baseline: parent.top
            anchors.baselineOffset: NeptuneStyle.dp(78)
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
            text: qsTr("Add widget")
            font.weight: Font.Light
        }
        Image {
            id: shadow
            anchors.top: parent.top
            anchors.topMargin: NeptuneStyle.dp(120)
            width: parent.width
            height: NeptuneStyle.dp(sourceSize.height)
            source: Style.gfx2("popup-title-shadow")
        }

        ListView {
            id: widgetListview
            anchors {
                top: shadow.bottom
                topMargin: NeptuneStyle.dp(51)
                left: parent.left
                leftMargin: NeptuneStyle.dp(74)
                right: parent.right
                rightMargin: NeptuneStyle.dp(74)
                bottom: parent.bottom
                bottomMargin: NeptuneStyle.dp(74)
            }
            model: delegateModel
            interactive: false
        }
    }
}


