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
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

import utils 1.0
import com.pelagicore.styles.neptune 3.0


/*
 * ListItemProgress provides a type of a list item with an integrated progress bar.
 *
 * Properties:
 *  - minimumValue - This property holds the starting value for the progress. The default value is 0.0.
 *  - maximumValue - This property holds the end value for the progress. The default value is 1.0.
 *  - value - This property holds the progress value. The default value is 0.0.
 *  - secondaryText - This property holds a textual component that is aligned to the right
 *                    side of ListItemProgress.
 *  - indeterminate - This property holds whether the progress bar is in indeterminate mode.
 *                    A progress bar in indeterminate mode displays that an operation is in progress,
 *                    but it doesn't show how much progress has been made. The default value is false.
 *  - cancelSymbol - This property holds the name of icon to be used as the cancel icon. The default value is "ic-close"
 *  - cancelable - Defines if the progress is cancelable. In case if it's false, cancelSymbol is hidden and cannot be clicked.
 *                 The default value is true
 *
 * Signals:
 *   progressCanceled: This signal is emitted when the cancel button is clicked by the user.
 *
 *  Usage example:
 *
 *   ListItemProgress {
 *      Layout.fillWidth: true
 *      icon.name: "ic-update"
 *      text: "Downloading the application"
 *      secondaryText: value + " % of 46 MB"
 *      cancelable: true
 *   }
 */


ListItemBasic {
    id: root

    property real minimumValue: 0.0
    property real maximumValue: 1.0
    property real value: 0.0
    property bool indeterminate: false

    property string secondaryText: ""
    property string cancelSymbol: "ic-close"
    property bool cancelable: true

    signal progressCanceled()

    accessoryDelegateComponent1: Label {
        id: secondaryTextLabel
        anchors.verticalCenter: parent.verticalCenter
        opacity: root.enabled ? NeptuneStyle.fontOpacityMedium : NeptuneStyle.fontOpacityDisabled
        font.pixelSize: NeptuneStyle.fontSizeS
        text: root.secondaryText
    }

    accessoryDelegateComponent2: ToolButton {
        implicitWidth: NeptuneStyle.dp(100)
        implicitHeight: root.height
        anchors.verticalCenter: parent.verticalCenter
        icon.name: root.cancelSymbol
        visible: root.cancelable
        onClicked: root.progressCanceled()
    }

    accessoryBottomDelegateComponent: ProgressBar {
        width: root.width
        from: root.minimumValue
        to: root.maximumValue
        value: root.value
        indeterminate: root.indeterminate
    }

    middleSpacerUsed: true
}
