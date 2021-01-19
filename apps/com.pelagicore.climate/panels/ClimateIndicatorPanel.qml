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

import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import "../controls" 1.0
import "../helpers" 1.0
import shared.Style 1.0
import shared.Sizes 1.0

RowLayout {
    id: root

    property var store
    height: Sizes.dp(80)
    spacing: Sizes.dp(9)

    LayoutMirroring.enabled: false

    Image {
        Layout.preferredWidth: Sizes.dp(sourceSize.width)
        Layout.preferredHeight: Sizes.dp(sourceSize.height)
        source: Utils.localIcon("ic-seat-heat-status", Style.theme)
        fillMode: Image.PreserveAspectFit
        visible: root.store.leftSeat.heat
    }
    TemperatureLabel {
        Layout.leftMargin: Sizes.dp(36)
        Layout.rightMargin: Sizes.dp(36)
        seat: root.store ? root.store.leftSeat.localizedValue : null
    }
    Image {
        Layout.preferredWidth: Sizes.dp(sourceSize.width)
        Layout.preferredHeight: Sizes.dp(sourceSize.height)
        source: Utils.localIcon("ic-rear-defrost-status", Style.theme)
        fillMode: Image.PreserveAspectFit
        visible: root.store.rearHeat.enabled
    }
    Image {
        Layout.preferredWidth: Sizes.dp(sourceSize.width)
        Layout.preferredHeight: Sizes.dp(sourceSize.height)
        source: Utils.localIcon("ic-front-defrost-status", Style.theme)
        fillMode: Image.PreserveAspectFit
        visible: root.store.frontHeat.enabled
    }
    TemperatureLabel {
        Layout.leftMargin: Sizes.dp(36)
        Layout.rightMargin: Sizes.dp(36)
        seat: root.store ? root.store.rightSeat.localizedValue : null
    }
    Image {
        Layout.preferredWidth: Sizes.dp(sourceSize.width)
        Layout.preferredHeight: Sizes.dp(sourceSize.height)
        source: Utils.localIcon("ic-seat-heat-status", Style.theme)
        fillMode: Image.PreserveAspectFit
        visible: root.store.rightSeat.heat
    }
}
