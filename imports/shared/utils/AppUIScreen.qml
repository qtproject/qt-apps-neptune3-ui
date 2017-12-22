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
import com.pelagicore.settings 1.0
import com.pelagicore.styles.triton 1.0

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

    color: "transparent"

    /*
        Area of the window that is exposed to the user (ie, not blocked or occluded by other UI elements)

        A window can be occluded by some other UI elements such as floating widgets, virtual keyboards
        etc. In such cases you will want to relayout to that the important content is contained within
        exposedRect boundaries.
     */
    property rect exposedRect: Qt.rect(0, 0, d.currentWidth, d.exposedRectHeight)

    property int targetHeight: {
        if (tritonState === "Maximized") {
            return root.height;
        } else {
            return d.widgetHeight;
        }
    }

    property int currentHeight

    property string tritonState

    QtObject {
        id: d
        property real exposedRectBottomMargin: 0
        property int widgetHeight: 0
        property int currentWidth: 0
        property int exposedRectHeight: Math.min(root.currentHeight, root.height - exposedRectBottomMargin);
    }

    onWindowPropertyChanged: {
        if (name === "cellWidth") {
            Style.cellWidth = value;
        } else if (name === "cellHeight") {
            Style.cellHeight = value;
        } else if (name === "exposedRectBottomMargin") {
            d.exposedRectBottomMargin = value;
        } else if (name === "tritonWidgetHeight") {
            d.widgetHeight = value;
        } else if (name === "tritonCurrentWidth") {
            d.currentWidth = value;
        } else if (name === "tritonCurrentHeight") {
            root.currentHeight = value;
        } else if (name === "tritonState") {
            root.tritonState = value;
        } else if (name === "locale") {
            Style.languageLocale = value;
        }
    }

    UISettings {
        onThemeChanged: updateTheme()
        Component.onCompleted: updateTheme()
        function updateTheme() {
            contentItem.TritonStyle.theme = theme === 0 ? TritonStyle.Light : TritonStyle.Dark;
        }
    }
}
