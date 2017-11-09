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

import QtApplicationManager 1.0
import controls 1.0
import utils 1.0

/*!
    \qmltype AppUIScreen
    \inqmlmodule utils
    \inherits ApplicationManagerWindow
    \brief A base QML item for developing applications.

    AppUIScreen is a QML item which should be a root element in every
    Triton UI application. It provides APIs for interacting with a system UI and
    for positioning the application's visual elements.

    See \l{Triton UI Application Development} for best practices on how to use the APIs.

    \section2 Example Usage

    The following example uses \l{AppUIScreen} as a root element:

    \qml

    AppUIScreen {
        id: root
        title: "Triton Template"

        UIScreen {
            Content {
                anchors.centerIn: parent
                width: Style.hspan(13)
                height: Style.vspan(24)
            }

            onBackScreen: root.back()
        }
    }
    \endqml

*/

ApplicationManagerWindow {
    id: root
    width: Style.hspan(24)
    height: Style.vspan(24)

    color: "transparent"

    /*!
         \qmlproperty Item AppUIScreen::content

         A default property that specifies a content area for the application's visual content.
    */

    default property alias content: content.children

    /*!
         \qmlproperty AppUIScreen::applicationIcon

         This property specify the application icon and shown in the left widget bar.

    */

    property alias applicationIcon: appIcon.source

    /*!
         \qmlproperty AppUIScreen::stripeSource

         This property specify the stripe image source of the application.

    */

    property alias stripeSource: widgetStripe.source

    BorderImage {
        id: widgetStripe
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        border { top: 30; bottom: 30 }
        horizontalTileMode: BorderImage.Stretch
        verticalTileMode: BorderImage.Stretch
        source: Style.gfx2("widget-stripe")

        Image {
            id: appIcon
            width: parent.width * 0.6
            fillMode: Image.PreserveAspectFit
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: widgetStripe.border.top * 0.8
        }
    }

    Item {
        id: content
        anchors.fill: parent
    }
}
