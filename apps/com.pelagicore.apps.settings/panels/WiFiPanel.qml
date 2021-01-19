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

import shared.controls 1.0
import shared.utils 1.0

import shared.Style 1.0
import shared.Sizes 1.0

import "../controls"
import "../assets"

Control {
    id: root

    property bool wifiEnabled: false
    property string selectedWiFiStatus: "Disconnected" //Disconnected, Connecting, Connected or Disconnecting
    property string selectedWiFiSSID: ""
    property bool _wifiSelected: selectedWiFiStatus !== "Disconnected"
    property string _selectedWiFiStatusText: selectedWiFiStatus === "Disconnected" ? "Disconnecting" : selectedWiFiStatus
    property Item rootItem
    property var wifiAccessPointsList

    signal connectToWiFiClicked ( string ssid )
    signal disconnectFromWiFiClicked ( string ssid )
    signal backButtonClicked()
    signal passwordProvided( string ssid, string password )
    signal connectionCancelled()

    onConnectToWiFiClicked: flickable.contentY = 0

    contentItem: Flickable {
        id: flickable
        width: parent.width
        height: parent.height
        clip: true
        flickableDirection: Flickable.VerticalFlick
        interactive: contentHeight > height
        contentHeight: column1.height

        ScrollIndicator.vertical: ScrollIndicator { }

        Column {
            id:column1

            Item {
                id: listHeader
                width: Sizes.dp(720)
                height: Sizes.dp(94)

                ToolButton {
                    id: backButton
                    objectName: "backButton"
                    anchors.left: parent.left
                    anchors.leftMargin: Sizes.dp(13.5)
                    anchors.verticalCenter: parent.verticalCenter
                    icon.name: LayoutMirroring.enabled ? "ic_forward" : "ic_back"
                    onClicked: root.backButtonClicked()
                }
                Label {
                    id: headerLabel
                    width: Sizes.dp(600)
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: Sizes.fontSizeS
                    elide: Text.ElideRight
                    text: qsTr("Wi-Fi")
                }
                Rectangle {
                    id: headerDivider
                    width: parent.width
                    height: Sizes.dp(1)
                    anchors.bottom: parent.bottom
                    color: "grey"
                }
            }

            Item {
                id: spacing0
                width: parent.width
                height: Sizes.dp(53)
            }

            SwitchDelegate {
                text: qsTr("Wi-Fi Enabled")
                width: root.width
                checked: root.wifiEnabled
                onToggled: root.wifiEnabled = checked
            }

            Item {
                width: root.width
                height: root.wifiEnabled && root._wifiSelected ? activeWiFi.height + spacing1.height : 0.0
                clip: true
                opacity: root.wifiEnabled && root._wifiSelected ? 1.0 : 0.4
                Behavior on height { NumberAnimation { duration: 200; easing.type: Easing.InOutQuad } }
                Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.InOutQuad } }
                visible: height > 0.0

                Column {
                    width: parent.width

                    Item {
                        id: spacing1
                        width: parent.width
                        height: Sizes.dp(40)
                    }

                    ListItemBasic {
                        id: activeWiFi
                        text: root.selectedWiFiSSID
                        subText: root._selectedWiFiStatusText
                        width: parent.width
                        dividerVisible: false

                        accessoryDelegateComponent1: Button {
                            implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding
                            implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
                            leftPadding: Sizes.dp(30)
                            rightPadding: Sizes.dp(30)
                            topPadding: Sizes.dp(8)
                            bottomPadding: Sizes.dp(8)
                            text: qsTr("Disconnect")
                            enabled: root.selectedWiFiStatus !== "Disconnecting"
                            font.pixelSize: Sizes.fontSizeS
                            onClicked: root.disconnectFromWiFiClicked( root.selectedWiFiSSID )
                        }
                    }
                }
            }

            Item {
                width: root.width
                height: root.wifiEnabled ? contentColumn2.height : 0.0
                clip: true
                opacity: root.wifiEnabled ? 1.0 : 0.4
                Behavior on height { NumberAnimation { duration: 200; easing.type: Easing.InOutQuad } }
                Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.InOutQuad } }
                visible: height > 0.0

                Column {
                    id: contentColumn2
                    width: parent.width

                    Item {
                        id: spacing2
                        width: root.width
                        height: Sizes.dp(40)
                    }

                    ListView {
                        id: wifiListView
                        width: root.width
                        height: Sizes.dp(96) * count
                        interactive: false

                        model: wifiAccessPointsList

                        delegate: ListItem {
                            width: root.width
                            height: Sizes.dp(96)
                            icon.source: {
                                if (model.modelData.strength >= 80) {
                                    return Assets.icon("ic-wifi-signal-4");
                                } else if (model.modelData.strength >= 60) {
                                    return Assets.icon("ic-wifi-signal-3");
                                } else if (model.modelData.strength >= 40) {
                                    return Assets.icon("ic-wifi-signal-2");
                                } else if (model.modelData.strength >= 20) {
                                    return Assets.icon("ic-wifi-signal-1");
                                } else {
                                    return Assets.icon("ic-wifi-signal-0");
                                }
                            }
                            text: model.modelData.ssid
                            secondaryText: model.modelData.connected ? qsTr("Connected") : ""
                            rightToolSymbol: model.modelData.security != 0 ? "ic_secured_connection" : ""
                            dividerVisible: index !== wifiListView.count - 1
                            onClicked: root.connectToWiFiClicked(model.modelData.ssid)
                        }
                    }

                    Item {
                        id: spacing3
                        width: root.width
                        height: Sizes.dp(40)
                    }

                    /* TODO: The backend is not ready yet for hidden networks
                    ListItem {
                        id: manualConnection
                        rightToolSymbol: "ic-next-level"
                        dividerVisible: false
                        onClicked: {
                            var pos = mapToItem(root.rootItem, width/2, height/2);
                            wifiPopup.ssid = ""
                            wifiPopup.password = ""
                            wifiPopup.manual = true
                            wifiPopup.originItemX = pos.x;
                            wifiPopup.originItemY = pos.y;
                            wifiPopup.popupY = Sizes.dp(Math.round(Config.centerConsoleHeight/2 - 410))
                            wifiPopup.visible = true;
                        }
                    }
                    */
                }
            }
        }
    }

}
