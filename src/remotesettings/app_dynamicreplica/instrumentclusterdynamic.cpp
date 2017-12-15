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
#include "instrumentclusterdynamic.h"

//TODO: everything

InstrumentClusterDynamic::InstrumentClusterDynamic()
{

}

void InstrumentClusterDynamic::initialize()
{

}

qreal InstrumentClusterDynamic::speed() const
{

}

qreal InstrumentClusterDynamic::speedLimit() const
{

}

qreal InstrumentClusterDynamic::speedCruise() const
{

}

qreal InstrumentClusterDynamic::ePower() const
{

}

int InstrumentClusterDynamic::driveTrainState() const
{

}

bool InstrumentClusterDynamic::lowBeamHeadlight() const
{
    if (m_replicaPtr.isNull())
        return false;
    return m_replicaPtr.data()->property("lowBeamHeadlight").toBool();
}

bool InstrumentClusterDynamic::highBeamHeadlight() const
{
    if (m_replicaPtr.isNull())
        return false;
    return m_replicaPtr.data()->property("highBeamHeadlight").toBool();
}

bool InstrumentClusterDynamic::fogLight() const
{

}

bool InstrumentClusterDynamic::stabilityControl() const
{

}

bool InstrumentClusterDynamic::seatBeltNotFastened() const
{

}

bool InstrumentClusterDynamic::leftTurn() const
{

}

bool InstrumentClusterDynamic::rightTurn() const
{

}

bool InstrumentClusterDynamic::ABSFailure() const
{

}

bool InstrumentClusterDynamic::parkBrake() const
{

}

bool InstrumentClusterDynamic::tyrePressureLow() const
{

}

bool InstrumentClusterDynamic::brakeFailure() const
{

}

bool InstrumentClusterDynamic::airbagFailure() const
{

}
