/****************************************************************************
**
** Copyright (C) 2017, 2018 Pelagicore AG
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
import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Dialog {
    id: connectionDialog
    property string url
    property string statusText
    property var lastUrls
    modal: true

    signal accepted(bool accepted)

    contentItem: Frame {
        implicitWidth: 340
        implicitHeight: 240
        ColumnLayout {
            anchors.fill: parent

            Label {
                text: qsTr("Connection settings")
                Layout.alignment: Qt.AlignCenter
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft

                Label {
                    text: qsTr("Server URL")
                }

                ComboBox {
                    id: urlCombo
                    Layout.fillWidth: true
                    editable: true
                    editText: url
                    model: lastUrls
                    onEditTextChanged: url=editText
                }
            }


            RowLayout {
                spacing: sc(10)
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter

                Button {
                    text: qsTr("Connect")
                    onClicked: connectionDialog.accepted(true)
                }

                Button {
                    text: qsTr("Cancel")
                    onClicked: connectionDialog.accepted(false)
                }
            }
        }
    }
}
