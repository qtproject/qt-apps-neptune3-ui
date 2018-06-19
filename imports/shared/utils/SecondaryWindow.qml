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

import QtQuick 2.8
import QtApplicationManager 1.0

import com.pelagicore.settings 1.0
import com.pelagicore.styles.neptune 3.0
import utils 1.0

/*!
    \qmltype SecondaryWindow
    \inqmlmodule utils
    \inherits ApplicationManagerWindow
    \since 5.11
    \brief The secondary window of a Neptune 3 application

    The secondary window of a Neptune 3 application is displayed on the \l{Instrument Cluster}.
    The content of a secondary window will be rendered below the gauges. \l{SecondaryWindow}
    is used by an application that wants to share content between the \l{center stack display}
    and the \l{instrument cluster}.

    See \l{Neptune 3 UI Application Development} for best practices on how to use the APIs.

    \section2 Example Usage

    The following example uses \l{SecondaryWindow}:

    \qml
    import QtQuick 2.10
    import utils 1.0

    QtObject {
        property var mainWindow: PrimaryWindow {
           id: mainWindow
           Background {
            anchors.fill: parent
           }

           Content {
               x: root.exposedRect.x
               y: root.exposedRect.x
               width: root.exposedRect.width
               height: root.exposedRect.height
           }
        }

        property var secondaryWindow: SecondaryWindow {
           id: secondaryWindow
           Background {
            anchors.fill: parent
           }
        }
    }
    \endqml

*/

ApplicationManagerWindow {
    id: root

    LayoutMirroring.enabled: isRightToLeft || uiSettings.rtlMode
    LayoutMirroring.childrenInherit: true

    readonly property bool isRightToLeft: Qt.locale().textDirection === Qt.RightToLeft

    Component.onCompleted: {
        setWindowProperty("windowType", "secondary")
        visible = true
    }

    onWindowPropertyChanged: {
        switch (name) {
        case "neptuneScale":
            root.NeptuneStyle.scale = value;
            break;
        case "performanceMonitorEnabled":
            performanceOverlay.fpsVisible = value;
            break;
        }
    }

    MonitorOverlay {
        id: performanceOverlay
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        fpsVisible: false
        window: root
        z: 9999
    }

    UISettings {
        id: uiSettings
        onThemeChanged: updateTheme()
        onAccentColorChanged: updateAccentColor()
        Component.onCompleted: {
            updateTheme()
            updateAccentColor()
        }
        function updateTheme() {
            root.NeptuneStyle.theme = theme === 0 ? NeptuneStyle.Light : NeptuneStyle.Dark;
        }
        function updateAccentColor() {
            root.NeptuneStyle.accentColor = accentColor
        }
    }
}
