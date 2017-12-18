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
#ifndef INSTRUMENTCLUSTERDYNAMIC_H
#define INSTRUMENTCLUSTERDYNAMIC_H

#include "abstractdynamic.h"

class InstrumentClusterDynamic : public AbstractDynamic
{
    Q_OBJECT
    Q_PROPERTY(qreal speed READ speed WRITE setSpeed NOTIFY speedChanged)
    Q_PROPERTY(qreal speedLimit READ speedLimit WRITE setSpeedLimit NOTIFY speedLimitChanged)
    Q_PROPERTY(qreal speedCruise READ speedCruise WRITE setSpeedCruise NOTIFY speedCruiseChanged)
    Q_PROPERTY(qreal ePower READ ePower WRITE setEPower NOTIFY ePowerChanged)
    Q_PROPERTY(int driveTrainState READ driveTrainState WRITE setDriveTrainState NOTIFY driveTrainStateChanged)
    Q_PROPERTY(bool lowBeamHeadlight READ lowBeamHeadlight WRITE setLowBeamHeadlight NOTIFY lowBeamHeadlightChanged)
    Q_PROPERTY(bool highBeamHeadlight READ highBeamHeadlight WRITE setHighBeamHeadlight NOTIFY highBeamHeadlightChanged)
    Q_PROPERTY(bool fogLight READ fogLight WRITE setFogLight NOTIFY fogLightChanged)
    Q_PROPERTY(bool stabilityControl READ stabilityControl WRITE setStabilityControl NOTIFY stabilityControlChanged)
    Q_PROPERTY(bool seatBeltNotFastened READ seatBeltNotFastened WRITE setSeatBeltNotFastened NOTIFY seatBeltNotFastenedChanged)
    Q_PROPERTY(bool leftTurn READ leftTurn WRITE setLeftTurn NOTIFY leftTurnChanged)
    Q_PROPERTY(bool rightTurn READ rightTurn WRITE setRightTurn NOTIFY rightTurnChanged)
    Q_PROPERTY(bool ABSFailure READ ABSFailure WRITE setABSFailure NOTIFY ABSFailureChanged)
    Q_PROPERTY(bool parkBrake READ parkBrake WRITE setParkBrake NOTIFY parkBrakeChanged)
    Q_PROPERTY(bool tyrePressureLow READ tyrePressureLow WRITE setTyrePressureLow NOTIFY tyrePressureLowChanged)
    Q_PROPERTY(bool brakeFailure READ brakeFailure WRITE setBrakeFailure NOTIFY brakeFailureChanged)
    Q_PROPERTY(bool airbagFailure READ airbagFailure WRITE setAirbagFailure NOTIFY airbagFailureChanged)

public:
    InstrumentClusterDynamic();

    void initialize() override;

    qreal speed() const;
    qreal speedLimit() const;
    qreal speedCruise() const;
    qreal ePower() const;
    int driveTrainState() const;
    bool lowBeamHeadlight() const;
    bool highBeamHeadlight() const;
    bool fogLight() const;
    bool stabilityControl() const;
    bool seatBeltNotFastened() const;
    bool leftTurn() const;
    bool rightTurn() const;
    bool ABSFailure() const;
    bool parkBrake() const;
    bool tyrePressureLow() const;
    bool brakeFailure() const;
    bool airbagFailure() const;

    void setSpeed(qreal speed);
    void setSpeedLimit(qreal speedLimit);
    void setSpeedCruise(qreal speedCruise);
    void setEPower(qreal ePower);
    void setDriveTrainState(int driveTrainState);
    void setLowBeamHeadlight(bool lowBeamHeadlight);
    void setHighBeamHeadlight(bool highBeamHeadlight);
    void setFogLight(bool fogLight);
    void setStabilityControl(bool stabilityControl);
    void setSeatBeltNotFastened(bool seatBeltNotFastened);
    void setLeftTurn(bool leftTurn);
    void setRightTurn(bool rightTurn);
    void setABSFailure(bool ABSFailure);
    void setParkBrake(bool parkBrake);
    void setTyrePressureLow(bool tyrePressureLow);
    void setBrakeFailure(bool brakeFailure);
    void setAirbagFailure(bool airbagFailure);

Q_SIGNALS:
    void speedChanged(qreal speed);
    void speedLimitChanged(qreal speedLimit);
    void speedCruiseChanged(qreal speedCruise);
    void ePowerChanged(qreal ePower);
    void driveTrainStateChanged(int driveTrainState);
    void lowBeamHeadlightChanged(bool lowBeamHeadlight);
    void highBeamHeadlightChanged(bool highBeamHeadlight);
    void fogLightChanged(bool fogLight);
    void stabilityControlChanged(bool stabilityControl);
    void seatBeltNotFastenedChanged(bool seatBeltNotFastened);
    void leftTurnChanged(bool leftTurn);
    void rightTurnChanged(bool rightTurn);
    void ABSFailureChanged(bool ABSFailure);
    void parkBrakeChanged(bool parkBrake);
    void tyrePressureLowChanged(bool tyrePressureLow);
    void brakeFailureChanged(bool brakeFailure);
    void airbagFailureChanged(bool airbagFailure);


};

#endif // INSTRUMENTCLUSTERDYNAMIC_H
