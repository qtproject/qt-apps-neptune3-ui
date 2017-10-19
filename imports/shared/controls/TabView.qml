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
import QtQuick.Controls 2.0

import controls 1.0
import utils 1.0

Control {
    id: root

    property int currentIndex: 0
    property alias tabs: repeater.model
    property real tabWidth: Style.hspan(2)
    property real tabHeight: Style.vspan(1)
    property bool horizontalAlignment: true
    property int viewLeftMargin: 0

    TabBar {
        id: tabRow
        anchors.top: parent.top
        anchors.horizontalCenter: root.horizontalAlignment ? parent.horizontalCenter : undefined
        height: root.tabHeight

        Repeater {
            id: repeater
            TabButton {
                property real maxTabWidth: repeater.count ? root.width / repeater.count : root.width
                width: Math.min(maxTabWidth, root.tabWidth)
                height: root.tabHeight
                text: modelData.title
                onClicked: {
                    if (root.currentIndex !== index) {
                        tabContent.replace(null, modelData.url, modelData.properties);
                        root.currentIndex = tabRow.currentIndex;
                    }
                }
            }
        }
    }


    StackView {
        id: tabContent

        anchors.top: tabRow.bottom;
        anchors.bottom: parent.bottom
        anchors.left: parent.left;
        anchors.right: parent.right
        anchors.leftMargin: root.viewLeftMargin

        clip: true

        Component.onCompleted: {
            console.log(Logging.sysui, 'push initial item for tab view')
            push(root.tabs[root.currentIndex].url, root.tabs[root.currentIndex].properties)
        }

        // TODO: Replace StackViewDelegate

//        delegate: QControls.StackViewDelegate {

//            function transitionFinished(properties)
//            {
//                properties.exitItem.opacity = 1
//            }

//            pushTransition: QControls.StackViewTransition {
//                PropertyAnimation {
//                    target: enterItem
//                    property: "opacity"
//                    from: 0
//                    to: 1
//                    duration: 250
//                }

//                PropertyAnimation {
//                    target: exitItem
//                    property: "opacity"
//                    from: 1
//                    to: 0
//                    duration: 250
//                }
//            }
//        }
    }
}
