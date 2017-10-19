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

import QtQuick 2.0
import QtQuick.Controls 2.0
import utils 1.0
import controls 1.0

/*!
    \qmltype UIScreen
    \inqmlmodule utils
    \inherits Page
    \brief A base item for all Triton UI screens.

    UIScreen is a QML item that provides Triton UI application screens. UIScreen
    has a layout with back buttons that provides access to a previous
    screen.

    \section2 Example Usage

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

    For each screen an application has, UIScreen should be used as a base item.

*/

Page {
    id: root
    implicitWidth: Style.hspan(24)
    implicitHeight: Style.vspan(24)

    background: Item {}

    /*!
         \qmlproperty bool UIScreen::hideBack

         This property holds the visibility status of a back button.
         If hideBack is set to \c true, the back button is hidden. Default
         value is \c false.
    */

    property bool hideBack: false

    /*!
         \qmlsignal UIScreen::backScreen()

         The signal is emitted when a back button is selected.

    */

    signal backScreen()


    Tool {
        id: backButton
        anchors.left: parent.left
        anchors.top: parent.top
        width: Style.hspan(2)
        height: Style.vspan(2)
        visible: !root.hideBack
        symbol: 'back'
        onClicked: root.backScreen()
    }

}

