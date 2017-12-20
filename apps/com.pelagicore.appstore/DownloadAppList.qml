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

import QtQuick 2.8
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.0

import controls 1.0
import utils 1.0

ListView {
    id: root

    property string appServerUrl
    property real installationProgress: 1.0
    property var installedApp: []
    signal downloadClicked(var appId)

    onInstallationProgressChanged: {
        if (installationProgress === 1.0) {
            root.currentIndex = -1;
        }
    }

    currentIndex: -1

    delegate: ItemDelegate {
        Layout.preferredWidth: Style.hspan(15)
        Layout.preferredHeight: Style.vspan(1)
        background: null
        contentItem: RowLayout {
            spacing: Style.hspan(0.8)

            Image {
                id: appIcon
                Layout.preferredHeight: Style.hspan(1)
                fillMode: Image.PreserveAspectFit
                source: root.appServerUrl + "/app/icon?id=" + model.id
            }

            Label {
                Layout.preferredHeight: Style.vspan(0.5)
                Layout.preferredWidth: appIcon.status === Image.Ready ? Style.hspan(8.8) : Style.hspan(11)
                text: model.name
                // TODO: Check with designer, which color should be used.
                color: "grey"
                font.pixelSize: Style.fontSizeS
                horizontalAlignment: Text.AlignLeft
            }

            Tool {
                Layout.preferredWidth: Style.hspan(1)
                Layout.preferredHeight: Style.vspan(0.5)
                symbol: Style.symbol("ic-download_OFF")
                opacity: enabled ? 1.0 : 0.5
                enabled: root.installedApp.indexOf(model.id) < 0 && root.currentIndex === -1
                onClicked: {
                    root.currentIndex = index;
                    root.downloadClicked(model.id);
                }
            }
        }

        ProgressBar {
            id: control

            anchors.bottom: parent.bottom
            anchors.bottomMargin: Style.hspan(0.05)
            value: root.installationProgress
            padding: 2
            visible: root.currentIndex === index && root.installationProgress < 1.0

            background: Rectangle {
                implicitWidth: Style.hspan(15)
                implicitHeight: Style.hspan(0.08)
                color: "#828282"
                radius: 3
            }

            contentItem: Item {
                implicitWidth: Style.hspan(15)
                implicitHeight: Style.hspan(0.08)

                Rectangle {
                    width: control.visualPosition * parent.width
                    height: parent.height
                    radius: 2
                    color: "#FA9E54"
                }
            }
        }

        Rectangle {
            width: Style.hspan(15)
            height: Style.hspan(0.05)
            anchors.bottom: parent.bottom
            // TODO: Check with designer, which color should be used.
            color: "#BCBCBC"
        }
    }
}
