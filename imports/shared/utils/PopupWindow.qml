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
import QtApplicationManager 1.0
import com.pelagicore.styles.neptune 3.0

/*!
    \qmltype PopupWindow
    \inqmlmodule utils
    \inherits ApplicationManageWindow
    \since 5.11
    \brief A window used from applications to display modal popups in sysui.

    The popup window of a Neptune 3 application is displayed on the Center Console. This
    component gives the application the flexibility to create a popup containing any kind
    of custom content and display it in system ui as a modal popup.

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
                devicesListPopup.popupWidth = 910;
                devicesListPopup.popupHeight = 500;
                deviceListPopup.openPopup = true;
            }
        }
        ......
        DevicesListPopup {
            id: devicesListPopup
        }
    }

    \endqml

    The PopupWindow should be inherited by the application's custom popup component.
    That said, the custom popup should then be instantiated inside the file which
    will use it and the element responsible of opening it should set its originItemX,
    originItemY, popupWidth and popupHeight and then request to show it by setting the
    openPopup property to true as shown in the example.

    As an exception, all children should use the scale property multiplied with the desired
    value for their dimensions and / or margins, to make sure that they'll scale correclty
    if the main window is being resized.
*/

// TODO use visible, width & height properties instead.
// Currently width & height properties are not passed down to the
// server so the popup doesn't scale when the window is resizing.
// Also onVisibleChanged signal is not emitted in single process.
// These issues should be solved with the appman Window API
// improvements which are currently under development. Until those
// are in, we keep the window properties as a workaround.

ApplicationManagerWindow {
    id: root
    color: "transparent"

    /*!
        \qmlproperty bool PopupWindow::openPopup

        This property indicates whether the popup should open. It can be set from both
        systemUI and application. It will be read from \l{PopupModel} which will then take
        care of showing the popup with whatever else this action implies.

    */
    property bool openPopup

    /*!
        \qmlproperty real PopupWindow::originItemX

        This property holds the x position from the item that called the popup.
        It is used internally in PopupItem to trigger transition animations.
    */
    property real originItemX

    /*!
        \qmlproperty real PopupWindow::originItemY

        This property holds the y position from the item that called the popup.
        It is used internally in PopupItem to trigger transition animations.
    */
    property real originItemY

    /*!
        \qmlproperty int PopupWindow::popupWidth

        The popup width. Set by the user on the application side and passed down to the system UI
        which then sets it to the PopupItem and the PopupWindow for rendering.
    */
    property int popupWidth: 0

    /*!
        \qmlproperty int PopupWindow::popupHeight

        The popup height. Set by the user on the application side and passed down to the system UI
        which then sets it to the PopupItem and the PopupWindow for rendering.
    */
    property int popupHeight: 0

    onOpenPopupChanged: {
        setWindowProperty("openPopup", openPopup);
    }

    onPopupWidthChanged: {
        setWindowProperty("popupWidth", popupWidth);
    }

    onPopupHeightChanged: {
        setWindowProperty("popupHeight", popupHeight);
    }

    onOriginItemXChanged: {
        setWindowProperty("originItemX", originItemX);
    }

    onOriginItemYChanged: {
        setWindowProperty("originItemY", originItemY);
    }

    onWindowPropertyChanged: {
        if (name === "openPopup") {
            openPopup = value;
        } else if (name === "neptuneScale") {
            root.NeptuneStyle.scale = value;
        }
    }

    Component.onCompleted: {
        setWindowProperty("windowType", "popup");
    }
}
