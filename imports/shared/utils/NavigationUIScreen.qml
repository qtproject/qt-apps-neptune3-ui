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
    \qmltype NavigationUIScreen
    \inqmlmodule utils 1.0
    \inherits AppUIScreen
    \brief A base item for developing navigation applications.

    NavigationUIScreen is a QML item which should be the root element in
    Triton UI navigation applications. It provides APIs for interacting with a system UI and
    for positioning the application's visual elements. NavigationUIScreen extends
    \l AppUIScreen with additional properties for setting a home page map widget.

    See \l{Triton UI Application Development} for best practices on how to use the APIs.

    \section2 Example Usage

    \qml

    NavigationUIScreen {
        id: root
        title: "Triton Template"

        cluster: ClusterMapWidget {}

        widget: HomePageMapWidget {}

        UIScreen {
            MapContent {
                anchors.centerIn: parent
                width: Style.hspan(13)
                height: Style.vspan(24)
            }

            onBackScreen: root.back()
        }
    }
    \endqml

    This documentation is part of \l{utils}.
*/

AppUIScreen {
    id: root

    /*!
         \qmlproperty Item AppUIScreen::widget

         This property specifies a content area for a map widget. The content
         area will be placed in a system UI home page.
    */

    property alias widget: widgetContainer.children

    /*!
        \internal
    */
    property var widgetSurface: ApplicationManagerWindow {
        width: Style.hspan(12)
        height: Style.vspan(19)
        visible: widgetContainer.children.length > 0

        Item {
            id: widgetContainer
            anchors.fill: parent
        }

        Component.onCompleted: {
            widgetSurface.setWindowProperty("windowType", "widgetMap")
        }
    }
}
