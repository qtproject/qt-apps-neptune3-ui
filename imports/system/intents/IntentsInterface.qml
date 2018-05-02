/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AG
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
import QtQuick 2.10
import QtApplicationManager 1.0

/*!
    \qmltype IntentsInterface
    \inqmlmodule intent
    \inherits QtObject
    \brief An object used to perform actions.

    The IntentsInterface is not meant to be used as is in the system, instead it is
    acting as the receiver of the requests coming from the applications using the
    Qt.openUrlExternally function as shown in the example below.

    \section2 Example Usage

    \qml

    Button {
        id: openRadioApp
        onClicked: {
            Qt.openUrlExternally("x-radio://");
        }
    }

    Button {
        id: openPhoneAppBluetoothMenu
        onClicked: {
            Qt.openUrlExternally("x-phone://settings/bluetooth");
        }
    }

    \endqml

    The interface to act on Intent requests. An intent request is used to request an
    application to just open or open in a certain state. That said, the action should
    be possible to be performed from wherever in the system. The application should call
    the Qt.openUrlExternally() function passing as parameter the applications' mime-Type
    and desired url to be followed. For that to be successful, the respective mime-Types
    should be added accordingly to the applications' info.yaml files (example: mimeTypes:
    [ 'x-scheme-handler/x-radio' ]) The ApplicationManager will then consult its internal
    database of applications looking for a match with x-scheme-handler/x-mimeType. If there
    is a successful match, then the openUrlRequested signal will be emitted and its receiver
    (IntentsInterface) can then either acknowledge the request by calling acknowledgeOpenUrlRequest
    function or reject (rejectOpenUrlRequest). If then the application is started, the url is
    supplied to the application as a document through the signal openDocument(string
    documentUrl, string mimeType) via its ApplicationInterface.
*/

QtObject {
    id: root

    /*!
        \qmlproperty string IntentsInterface::activeAppId

        This property holds the active application id. It is used to store the active application id
        before an intent request is submitted in
        order to be able to navigate back to it accordingly.
    */

    property string activeAppId: ""

    /*!
        \qmlproperty var IntentsInterface::history

        This property holds the history of activities started and it's used for a sequential
        navigation back to the initial state
    */


    property var history: []

    /*!
        \qmlproperty var IntentsInterface::appManConns
        \readonly

        This property is used to listen to the ApplicationManager and get the request from other
        applications.
    */

    readonly property var appManConns: Connections {
        target: ApplicationManager
        onOpenUrlRequested: {
            sendRequest(requestId, possibleAppIds);
        }
    }

    /*!
        \qmlmethod IntentsInterface::sendRequest(id, params)

        Requests the action to be taken in the UI. It uses the Application Managers' acknowledgeOpenUrlRequest
        function to open the requested application passing the given url to it. It also keeps and
        updates the history with all the steps performed each time the function is called.
    */

    function sendRequest(reqId, id) {
        //store in history previous app id
        history.push(activeAppId);
        ApplicationManager.acknowledgeOpenUrlRequest(reqId, id);
        //store in history new app id
        history.push(id);
    }

    /*!
        \qmlmethod IntentsInterface::goBack()

        The goBack function returns to the previous state from a requested action based on the history.
        It also takes care of updating the history accordingly.
    */

    function goBack() {
        if (history.length >= 1) {
            history.pop();
            ApplicationManager.startApplication(history[history.length - 1]);
            if (history.length === 1) {
                history = [];
            }
        }
    }
}
