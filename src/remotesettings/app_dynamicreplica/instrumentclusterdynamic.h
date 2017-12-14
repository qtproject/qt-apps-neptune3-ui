#ifndef INSTRUMENTCLUSTERDYNAMIC_H
#define INSTRUMENTCLUSTERDYNAMIC_H

#include "abstractdynamic.h"

class InstrumentClusterDynamic : public AbstractDynamic
{
    Q_OBJECT
    Q_PROPERTY(qreal speed READ speed NOTIFY speedChanged)
    Q_PROPERTY(qreal speedLimit READ speedLimit NOTIFY speedLimitChanged)
    Q_PROPERTY(qreal speedCruise READ speedCruise NOTIFY speedCruiseChanged)
    Q_PROPERTY(qreal ePower READ ePower NOTIFY ePowerChanged)
    Q_PROPERTY(int driveTrainState READ driveTrainState NOTIFY driveTrainStateChanged)
    Q_PROPERTY(bool lowBeamHeadlight READ lowBeamHeadlight NOTIFY lowBeamHeadlightChanged)
    Q_PROPERTY(bool highBeamHeadlight READ highBeamHeadlight NOTIFY highBeamHeadlightChanged)
    Q_PROPERTY(bool fogLight READ fogLight NOTIFY fogLightChanged)
    Q_PROPERTY(bool stabilityControl READ stabilityControl NOTIFY stabilityControlChanged)
    Q_PROPERTY(bool seatBeltNotFastened READ seatBeltNotFastened NOTIFY seatBeltNotFastenedChanged)
    Q_PROPERTY(bool leftTurn READ leftTurn NOTIFY leftTurnChanged)
    Q_PROPERTY(bool rightTurn READ rightTurn NOTIFY rightTurnChanged)
    Q_PROPERTY(bool ABSFailure READ ABSFailure NOTIFY ABSFailureChanged)
    Q_PROPERTY(bool parkBrake READ parkBrake NOTIFY parkBrakeChanged)
    Q_PROPERTY(bool tyrePressureLow READ tyrePressureLow NOTIFY tyrePressureLowChanged)
    Q_PROPERTY(bool brakeFailure READ brakeFailure NOTIFY brakeFailureChanged)
    Q_PROPERTY(bool airbagFailure READ airbagFailure NOTIFY airbagFailureChanged)

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

public Q_SLOTS:

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
