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


import QtQuick 2.6
import shared.Style 1.0

/*!
    \qmltype PopupWindow
    \inqmlmodule application.windows
    \inherits ApplicationManageWindow
    \since 5.11
    \brief A window used from applications to display modal popups in sysui.

    The popup window of a Neptune 3 application is displayed on the Center Console. This
    component gives the application the flexibility to create a popup containing any kind
    of custom content and display it in system ui as a system modal popup.

    \section2 Example Usage

    \qml
    //DevicesListPopup.qml

    PopupWindow {
        id: root

        property var deviceModel

        Item {
            id: popupContent
            anchors.fill: parent

            Label {
                id: headerText
                text: "Please choose device"
            }

            ListView {
                id: deviceList
                model: root.deviceModel
                delegate: RadioButton {
                    .....
                }
                .....
            }
        }
    }


    //DevicesMenu.qml

    Item {
        id: root

        Button {
            id: button
            text: "Choose Device"
            onClicked: {
                var pos = button.mapToItem(root, button.width/2, button.height/2);
                devicesListPopup.originItemX = pos.x;
                devicesListPopup.originItemY = pos.y;
                deviceListPopup.visible = true;
            }
        }
        ......
        DevicesListPopup {
            width: 910
            height: 500
            id: devicesListPopup
        }
    }

    \endqml

    The application's custom popup component should inherit from PopupWindow.
    That said, the custom popup should then be instantiated inside the file which
    will use it and the element responsible of opening it should set its originItemX,
    originItemY, width and height and then request to show it by setting the
    visible property to true as shown in the example.
*/

NeptuneWindow {
    id: root

    /*!
        \qmlproperty real PopupWindow::originItemX

        This property holds the x position from the item that called the popup.
        It is used internally in PopupItem to trigger transition animations.
    */
    property real originItemX: 0

    /*!
        \qmlproperty real PopupWindow::originItemY

        This property holds the y position from the item that called the popup.
        It is used internally in PopupItem to trigger transition animations.
    */
    property real originItemY: 0

    /*!
        \qmlproperty real PopupWindow::popupY
        This property holds the y position of the popup.
    */
    property real popupY: 0

    // You have to explicitly make it visible
    visible: false

    onOriginItemXChanged: {
        setWindowProperty("originItemX", originItemX);
    }

    onOriginItemYChanged: {
        setWindowProperty("originItemY", originItemY);
    }

    onPopupYChanged: {
        setWindowProperty("popupY", popupY);
    }

    Component.onCompleted: {
        setWindowProperty("windowType", "popup");
    }
}
