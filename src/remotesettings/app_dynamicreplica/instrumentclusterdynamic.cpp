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
