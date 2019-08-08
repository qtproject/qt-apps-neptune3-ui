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

import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

import shared.utils 1.0
import shared.Style 1.0
import shared.Sizes 1.0

/*!
    \qmltype ListItemProgress
    \inqmlmodule controls
    \inherits ListItemBasic
    \since 5.11
    \brief Provides a list item with a progress bar component, for Neptune 3 UI.

    The ListItemProgress provides a type of a list item with an integrated progress bar.

    See \l{Neptune 3 UI Components and Interfaces} to see more available components in
    Neptune 3 UI.

    \section2 Example Usage

    The code snippet below shows how to use \c ListItemProgress:

    \qml
    import QtQuick 2.10
    import shared.controls 1.0

    Item {
        id: root
        ListView {
            model: 3
            delegate: ListItemProgress {
               Layout.fillWidth: true
               icon.name: "ic-update"
               text: "Downloading the application"
               secondaryText: value + " % of 46 MB"
               cancelable: true
            }
        }
    }
    \endqml
*/

ListItemBasic {
    id: root

    /*!
        \qmlproperty real ListItemProgress::minimumValue

        This property holds the starting value for the progress.

        This property's default is 0.0.
    */
    property real minimumValue: 0.0

    /*!
        \qmlproperty real ListItemProgress::maximumValue

        This property holds the end value for the progress.

        This property's default is 1.0.
    */
    property real maximumValue: 1.0

    /*!
        \qmlproperty real ListItemProgress::value

        This property holds the progress value.

        This property's default is 0.0.
    */
    property real value: 0.0

    /*!
        \qmlproperty bool ListItemProgress::indeterminate

        This property holds whether the progress bar is in indeterminate mode.
        A progress bar in indeterminate mode displays that an operation is in progress,
        but it doesn't show how much progress has been made.

        This property's default is false.
    */
    property bool indeterminate: false

    /*!
        \qmlproperty bool ListItemProgress::backgroundVisible

        This property holds whether list item background is visible or not.

        This property's default is false.
    */
    property bool backgroundVisible: false

    /*!
        \qmlproperty string ListItemProgress::secondaryText

        This property holds a textual component that is aligned to the right
        side of ListItemProgress.
    */
    property string secondaryText: ""

    /*!
        \qmlproperty string ListItemProgress::cancelSymbol

        This property holds the name of icon to be used as the cancel icon.

        This property's default is "ic-close"
    */
    property string cancelSymbol: "ic-close"

    /*!
        \qmlproperty bool ListItemProgress::cancelable

        This property holds whether the progress is cancelable or not.
        In case if it's false, cancelSymbol is hidden and cannot be clicked.

        This property's default is true.
    */
    property bool cancelable: true

    /*!
        \qmlproperty bool ListItemProgress::progressVisible

        The property defines whether the progress bar is visible or not.

        This property's default is true.
    */
    property bool progressVisible: true

    /*!
        \qmlsignal ListItemProgress::progressCanceled

        This signal is emitted when the cancel button is clicked by the user.
    */
    signal progressCanceled()

    accessoryDelegateComponent1: Label {
        id: secondaryTextLabel
        anchors.verticalCenter: parent.verticalCenter
        opacity: Style.opacityMedium
        font.pixelSize: Sizes.fontSizeS
        text: root.secondaryText
    }

    accessoryDelegateComponent2: ToolButton {
        implicitWidth: Sizes.dp(100)
        implicitHeight: root.height
        anchors.verticalCenter: parent.verticalCenter
        icon.name: root.cancelSymbol
        visible: root.cancelable
        onClicked: root.progressCanceled()
    }

    accessoryBottomDelegateComponent: ProgressBar {
        implicitWidth: root.width
        implicitHeight: Sizes.dp(8)
        from: root.minimumValue
        to: root.maximumValue
        value: root.value
        indeterminate: root.indeterminate
        backgroundVisible: root.backgroundVisible
        visible: root.progressVisible
    }

    middleSpacerUsed: true
}
