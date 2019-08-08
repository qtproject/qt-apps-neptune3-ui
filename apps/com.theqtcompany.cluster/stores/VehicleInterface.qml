/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
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

import shared.utils 1.0

Store {
    id: root

    property bool lowBeamHeadlight: false
    property bool highBeamHeadlight: false
    property bool fogLight: false
    property bool stabilityControl: false
    property bool seatBeltFasten: false
    property bool leftTurn: false

    property bool rightTurn: false
    property bool absFailure: false
    property bool parkBrake: false
    property bool tyrePressureLow: false
    property bool brakeFailure: false
    property bool airbagFailure: false

    property real speed: 0.0
    property real speedLimit: 0.0
    property real speedCruise: 0.0
    property int driveTrainState: 0
    property int ePower: 0

    // Vehicle mileage in km
    property real mileage: 0.0
    // Normal = 0, ECO = 1, Sport = 2
    property int  drivingMode: 0
    //Range in km for current driving mode
    property int  drivingModeRangeKm: 0
    // Range in km for ECO driving mode
    property int  drivingModeECORangeKm: 0
}
