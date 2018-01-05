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
    connect(m_replicaPtr.data(),SIGNAL(speedChanged(qreal)),
            this,SIGNAL(speedChanged(qreal)));
    connect(m_replicaPtr.data(),SIGNAL(speedLimitChanged(qreal)),
            this,SIGNAL(speedLimitChanged(qreal)));
    connect(m_replicaPtr.data(),SIGNAL(speedCruiseChanged(qreal)),
            this,SIGNAL(speedCruiseChanged(qreal)));
    connect(m_replicaPtr.data(),SIGNAL(ePowerChanged(qreal)),
            this,SIGNAL(ePowerChanged(qreal)));
    connect(m_replicaPtr.data(),SIGNAL(driveTrainStateChanged(int)),
            this,SIGNAL(driveTrainStateChanged(int)));
    connect(m_replicaPtr.data(),SIGNAL(lowBeamHeadlightChanged(bool)),
            this,SIGNAL(lowBeamHeadlightChanged(bool)));
    connect(m_replicaPtr.data(),SIGNAL(highBeamHeadlightChanged(bool)),
            this,SIGNAL(highBeamHeadlightChanged(bool)));
    connect(m_replicaPtr.data(),SIGNAL(fogLightChanged(bool)),
            this,SIGNAL(fogLightChanged(bool)));
    connect(m_replicaPtr.data(),SIGNAL(stabilityControlChanged(bool)),
            this,SIGNAL(stabilityControlChanged(bool)));
    connect(m_replicaPtr.data(),SIGNAL(seatBeltNotFastenedChanged(bool)),
            this,SIGNAL(seatBeltNotFastenedChanged(bool)));
    connect(m_replicaPtr.data(),SIGNAL(leftTurnChanged(bool)),
            this,SIGNAL(leftTurnChanged(bool)));
    connect(m_replicaPtr.data(),SIGNAL(rightTurnChanged(bool)),
            this,SIGNAL(rightTurnChanged(bool)));
    connect(m_replicaPtr.data(),SIGNAL(ABSFailureChanged(bool)),
            this,SIGNAL(ABSFailureChanged(bool)));
    connect(m_replicaPtr.data(),SIGNAL(parkBrakeChanged(bool)),
            this,SIGNAL(parkBrakeChanged(bool)));
    connect(m_replicaPtr.data(),SIGNAL(tyrePressureLowChanged(bool)),
            this,SIGNAL(tyrePressureLowChanged(bool)));
    connect(m_replicaPtr.data(),SIGNAL(brakeFailureChanged(bool)),
            this,SIGNAL(brakeFailureChanged(bool)));
    connect(m_replicaPtr.data(),SIGNAL(airbagFailureChanged(bool)),
            this,SIGNAL(airbagFailureChanged(bool)));

    emit speedChanged(speed());
    emit speedLimitChanged(speedLimit());
    emit speedCruiseChanged(speedCruise());
    emit ePowerChanged(ePower());
    emit driveTrainStateChanged(driveTrainState());
    emit lowBeamHeadlightChanged(lowBeamHeadlight());
    emit highBeamHeadlightChanged(highBeamHeadlight());
    emit fogLightChanged(fogLight());
    emit stabilityControlChanged(stabilityControl());
    emit seatBeltNotFastenedChanged(seatBeltNotFastened());
    emit leftTurnChanged(leftTurn());
    emit rightTurnChanged(rightTurn());
    emit ABSFailureChanged(ABSFailure());
    emit parkBrakeChanged(parkBrake());
    emit tyrePressureLowChanged(tyrePressureLow());
    emit brakeFailureChanged(brakeFailure());
    emit airbagFailureChanged(airbagFailure());
}

qreal InstrumentClusterDynamic::speed() const
{
    if (m_replicaPtr.isNull())
        return false;
    return m_replicaPtr.data()->property("speed").toReal();
}

qreal InstrumentClusterDynamic::speedLimit() const
{
    if (m_replicaPtr.isNull())
        return false;
    return m_replicaPtr.data()->property("speedLimit").toReal();
}

qreal InstrumentClusterDynamic::speedCruise() const
{
    if (m_replicaPtr.isNull())
        return false;
    return m_replicaPtr.data()->property("speedCruise").toReal();
}

qreal InstrumentClusterDynamic::ePower() const
{
    if (m_replicaPtr.isNull())
        return false;
    return m_replicaPtr.data()->property("ePower").toReal();
}

int InstrumentClusterDynamic::driveTrainState() const
{
    if (m_replicaPtr.isNull())
        return false;
    return m_replicaPtr.data()->property("driveTrainState").toInt();
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
    if (m_replicaPtr.isNull())
        return false;
    return m_replicaPtr.data()->property("fogLight").toBool();
}

bool InstrumentClusterDynamic::stabilityControl() const
{
    if (m_replicaPtr.isNull())
        return false;
    return m_replicaPtr.data()->property("stabilityControl").toBool();
}

bool InstrumentClusterDynamic::seatBeltNotFastened() const
{
    if (m_replicaPtr.isNull())
        return false;
    return m_replicaPtr.data()->property("seatBeltNotFastened").toBool();
}

bool InstrumentClusterDynamic::leftTurn() const
{
    if (m_replicaPtr.isNull())
        return false;
    return m_replicaPtr.data()->property("leftTurn").toBool();
}

bool InstrumentClusterDynamic::rightTurn() const
{
    if (m_replicaPtr.isNull())
        return false;
    return m_replicaPtr.data()->property("rightTurn").toBool();
}

bool InstrumentClusterDynamic::ABSFailure() const
{
    if (m_replicaPtr.isNull())
        return false;
    return m_replicaPtr.data()->property("ABSFailure").toBool();
}

bool InstrumentClusterDynamic::parkBrake() const
{
    if (m_replicaPtr.isNull())
        return false;
    return m_replicaPtr.data()->property("parkBrake").toBool();
}

bool InstrumentClusterDynamic::tyrePressureLow() const
{
    if (m_replicaPtr.isNull())
        return false;
    return m_replicaPtr.data()->property("tyrePressureLow").toBool();
}

bool InstrumentClusterDynamic::brakeFailure() const
{
    if (m_replicaPtr.isNull())
        return false;
    return m_replicaPtr.data()->property("brakeFailure").toBool();
}

bool InstrumentClusterDynamic::airbagFailure() const
{
    if (m_replicaPtr.isNull())
        return false;
    return m_replicaPtr.data()->property("airbagFailure").toBool();
}

void InstrumentClusterDynamic::setSpeed(qreal speed)
{
    if (m_replicaPtr.isNull())
        return;
    QMetaObject::invokeMethod(m_replicaPtr.data(),
                    "pushSpeed",Qt::DirectConnection,Q_ARG(qreal,speed));
}

void InstrumentClusterDynamic::setSpeedLimit(qreal speedLimit)
{
    if (m_replicaPtr.isNull())
        return;
    QMetaObject::invokeMethod(m_replicaPtr.data(),
                    "pushSpeedLimit",Qt::DirectConnection,Q_ARG(qreal,speedLimit));
}

void InstrumentClusterDynamic::setSpeedCruise(qreal speedCruise)
{
    if (m_replicaPtr.isNull())
        return;
    QMetaObject::invokeMethod(m_replicaPtr.data(),
                    "pushSpeedCruise",Qt::DirectConnection,Q_ARG(qreal,speedCruise));
}

void InstrumentClusterDynamic::setEPower(qreal ePower)
{
    if (m_replicaPtr.isNull())
        return;
    QMetaObject::invokeMethod(m_replicaPtr.data(),
                    "pushEPower",Qt::DirectConnection,Q_ARG(qreal,ePower));
}

void InstrumentClusterDynamic::setDriveTrainState(int driveTrainState)
{
    if (m_replicaPtr.isNull())
        return;
    QMetaObject::invokeMethod(m_replicaPtr.data(),
                    "pushDriveTrainState",Qt::DirectConnection,Q_ARG(int,driveTrainState));
}

void InstrumentClusterDynamic::setLowBeamHeadlight(bool lowBeamHeadlight)
{
    if (m_replicaPtr.isNull())
        return;
    QMetaObject::invokeMethod(m_replicaPtr.data(),
                    "pushLowBeamHeadlight",Qt::DirectConnection,Q_ARG(bool,lowBeamHeadlight));
}

void InstrumentClusterDynamic::setHighBeamHeadlight(bool highBeamHeadlight)
{
    if (m_replicaPtr.isNull())
        return;
    QMetaObject::invokeMethod(m_replicaPtr.data(),
                    "pushHighBeamHeadlight",Qt::DirectConnection,Q_ARG(bool,highBeamHeadlight));
}

void InstrumentClusterDynamic::setFogLight(bool fogLight)
{
    if (m_replicaPtr.isNull())
        return;
    QMetaObject::invokeMethod(m_replicaPtr.data(),
                    "pushFogLight",Qt::DirectConnection,Q_ARG(bool,fogLight));
}

void InstrumentClusterDynamic::setStabilityControl(bool stabilityControl)
{
    if (m_replicaPtr.isNull())
        return;
    QMetaObject::invokeMethod(m_replicaPtr.data(),
                    "pushStabilityControl",Qt::DirectConnection,Q_ARG(bool,stabilityControl));
}

void InstrumentClusterDynamic::setSeatBeltNotFastened(bool seatBeltNotFastened)
{
    if (m_replicaPtr.isNull())
        return;
    QMetaObject::invokeMethod(m_replicaPtr.data(),
                    "pushSeatBeltNotFastened",Qt::DirectConnection,Q_ARG(bool,seatBeltNotFastened));
}

void InstrumentClusterDynamic::setLeftTurn(bool leftTurn)
{
    if (m_replicaPtr.isNull())
        return;
    QMetaObject::invokeMethod(m_replicaPtr.data(),
                    "pushLeftTurn",Qt::DirectConnection,Q_ARG(bool,leftTurn));
}

void InstrumentClusterDynamic::setRightTurn(bool rightTurn)
{
    if (m_replicaPtr.isNull())
        return;
    QMetaObject::invokeMethod(m_replicaPtr.data(),
                    "pushRightTurn",Qt::DirectConnection,Q_ARG(bool,rightTurn));
}

void InstrumentClusterDynamic::setABSFailure(bool ABSFailure)
{
    if (m_replicaPtr.isNull())
        return;
    QMetaObject::invokeMethod(m_replicaPtr.data(),
                    "pushABSFailure",Qt::DirectConnection,Q_ARG(bool,ABSFailure));
}

void InstrumentClusterDynamic::setParkBrake(bool parkBrake)
{
    if (m_replicaPtr.isNull())
        return;
    QMetaObject::invokeMethod(m_replicaPtr.data(),
                    "pushParkBrake",Qt::DirectConnection,Q_ARG(bool,parkBrake));
}

void InstrumentClusterDynamic::setTyrePressureLow(bool tyrePressureLow)
{
    if (m_replicaPtr.isNull())
        return;
    QMetaObject::invokeMethod(m_replicaPtr.data(),
                    "pushTyrePressureLow",Qt::DirectConnection,Q_ARG(bool,tyrePressureLow));
}

void InstrumentClusterDynamic::setBrakeFailure(bool brakeFailure)
{
    if (m_replicaPtr.isNull())
        return;
    QMetaObject::invokeMethod(m_replicaPtr.data(),
                    "pushBrakeFailure",Qt::DirectConnection,Q_ARG(bool,brakeFailure));
}

void InstrumentClusterDynamic::setAirbagFailure(bool airbagFailure)
{
    if (m_replicaPtr.isNull())
        return;
    QMetaObject::invokeMethod(m_replicaPtr.data(),
                    "pushAirbagFailure",Qt::DirectConnection,Q_ARG(bool,airbagFailure));
}

bool InstrumentClusterDynamic::navigationMode() const
{
    if (m_replicaPtr.isNull())
        return false;
    return m_replicaPtr.data()->property("navigationMode").toBool();
}

void InstrumentClusterDynamic::setNavigationMode(bool navigationMode)
{
    if (m_replicaPtr.isNull())
        return;
    QMetaObject::invokeMethod(m_replicaPtr.data(),
                    "pushNavigationMode",Qt::DirectConnection,Q_ARG(bool,navigationMode));
}
