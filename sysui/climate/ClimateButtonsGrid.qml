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
import QtQuick.Layouts 1.3
import utils 1.0

Grid {
    id: root
    columns: 2
    rows: 2
    columnSpacing: 0
    rowSpacing: 0

    property var model

    ClimateButton {
        width: root.width / 2
        height: root.height / 2
        icon: checked ? "ic-front-defrost_ON" : "ic-front-defrost_OFF"
        text: qsTr("Front defrost")
        checked: model.frontHeat.enabled
        onToggled: model.frontHeat.setEnabled(checked)
    }
    ClimateButton {
        width: root.width / 2
        height: root.height / 2
        icon: checked ? "ic-rear-defrost_ON" : "ic-rear-defrost_OFF"
        text: qsTr("Rear defrost")
        checked: model.rearHeat.enabled
        onToggled: model.rearHeat.setEnabled(checked)
    }
    ClimateButton {
        width: root.width / 2
        height: root.height / 2
        icon: checked ? "ic-seat-heat_ON" : "ic-seat-heat_OFF"
        text: qsTr("Driver seat heat")
        checked: model.leftSeat.heat
        onToggled: model.leftSeat.setHeat(checked)
    }
    ClimateButton {
        width: root.width / 2
        height: root.height / 2
        icon: checked ? "ic-seat-heat_ON" : "ic-seat-heat_OFF"
        text: qsTr("Passenger seat heat")
        checked: model.rightSeat.heat
        onToggled: model.rightSeat.setHeat(checked)
    }
}
