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
import QtApplicationManager 1.0

/*!
    \qmltype PopupInterface
    \inqmlmodule service
    \inherits Notification
    \brief An interface for requesting popups.

    PopupInterface inherits \l{Notification} from \l{Qt Application Manager} and
    acts like an adapter for Triton UI popups.
    The PopupInterface properties \c timeout and \c category are adopted
    to match Triton UI requirements and should not be used. In the Triton UI
    interaction, pop-ups should always be dismissed by an end user
    instead of a time-out.

    \section2 Example Usage

    \qml

    PopupInterface {
        id: popupInterfaceLowPrio
        actions: [ { text: "Cancel" } ]
        title: "Popup Prio 9"
        summary: "Popup Sample"
        priority: 9
    }

    \endqml

    Pop-up notifications are queued based on a value in \c priority. \c actions
    defines an array of buttons for a popup.
*/

Notification {
    id: root

    category: "popup"
    timeout: 0

    /*!
         \qmlproperty string AppUIScreen::title

         This property assigns a title for the popup.
    */

    property string title: ""

    /*!
         \qmlproperty string AppUIScreen::subtitle

         This property assigns a subtitle for the popup.
    */

    property string subtitle: ""

    onTitleChanged: {
        root.updatePopup();
    }

    onSubtitleChanged: {
        root.updatePopup();
    }

    /*!
        \internal
    */
    function updatePopup() {
        root.extended = {
            "title": root.title,
            "subtitle": root.subtitle
        }
        root.update();
    }
}
