/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
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

#include <QtSafeRenderer/qsafeevent.h>
#include <QtSafeRenderer/qsafechecksum.h>

#include "icsettingshandler.h"

ICSettingsHandler::ICSettingsHandler(StateManager *manager, QObject *parent)
    : QObject(parent), m_stateManager(manager),
      m_rightTurnState(false), m_rightTurnEnabled(false),
      m_leftTurnState(false), m_leftTurnEnabled(false)
{
    //init qt connections
    init();

    //Remote settings client
    m_client = new RemoteSettings_Client(this);
    m_client->connectToServer(m_client->lastUrls()[0]);

    m_ic.setServiceObject(nullptr);
    m_ic.startAutoDiscovery();

    QObject::connect(m_client, &RemoteSettings_Client::connectedChanged,
                     this, &ICSettingsHandler::onClientConnectedChanged);
}

void ICSettingsHandler::init()
{
    QObject::connect(&m_ic, &InstrumentCluster::highBeamHeadlightChanged,
                     this, &ICSettingsHandler::onHighBeamHeadlightChanged);
    QObject::connect(&m_ic, &InstrumentCluster::speedChanged,
                     this, &ICSettingsHandler::onSpeedChanged);
    QObject::connect(&m_ic, &InstrumentCluster::ePowerChanged,
                     this, &ICSettingsHandler::onPowerChanged);
    QObject::connect(&m_ic, &InstrumentCluster::lowBeamHeadlightChanged,
                     this, &ICSettingsHandler::onLowBeamHeadlightChanged);
    QObject::connect(&m_ic, &InstrumentCluster::fogLightChanged,
                     this, &ICSettingsHandler::onFogLightChangedChanged);
    QObject::connect(&m_ic, &InstrumentCluster::stabilityControlChanged,
                     this, &ICSettingsHandler::onStabilityControlChanged);
    QObject::connect(&m_ic, &InstrumentCluster::ABSFailureChanged,
                     this, &ICSettingsHandler::onABSFailureChanged);
    QObject::connect(&m_ic, &InstrumentCluster::parkBrakeChanged,
                     this, &ICSettingsHandler::onParkBrakeChanged);
    QObject::connect(&m_ic, &InstrumentCluster::seatBeltNotFastenedChanged,
                     this, &ICSettingsHandler::onSeatBeltNotFastenedChanged);
    QObject::connect(&m_ic, &InstrumentCluster::tyrePressureLowChanged,
                     this, &ICSettingsHandler::onTyrePressureLowChanged);
    QObject::connect(&m_ic, &InstrumentCluster::airbagFailureChanged,
                     this, &ICSettingsHandler::onAirbagFailureChanged);
    QObject::connect(&m_ic, &InstrumentCluster::brakeFailureChanged,
                     this, &ICSettingsHandler::onBrakeFailureChanged);
    QObject::connect(&m_ic, &InstrumentCluster::leftTurnChanged,
                     this, &ICSettingsHandler::onLeftTurnChanged);
    QObject::connect(&m_ic, &InstrumentCluster::rightTurnChanged,
                     this, &ICSettingsHandler::onRightTurnChanged);

    //90 tick per minute timer for right and left turn
    QObject::connect(&m_blinkTimer, &QTimer::timeout, this, &ICSettingsHandler::onLeftRightTurnTimer);
}

void ICSettingsHandler::onSpeedChanged(qreal value)
{
    QSafeEventSetText event;
    const char* item = "speedText";
    event.setId(qsafe_hash(item, safe_strlen(item)));

    QByteArray valueBa = QString::number(value, 'f', 0).toLocal8Bit();
    event.setValue(valueBa.data(), safe_strlen(valueBa.data()));
    m_stateManager->handleEvent(event);
}

void ICSettingsHandler::onPowerChanged(qreal value)
{
    QSafeEventSetText event;
    const char* item = "powerText";
    event.setId(qsafe_hash(item, safe_strlen(item)));

    QByteArray valueBa = QString::number(value, 'f', 0).toLocal8Bit();
    event.setValue(valueBa.data(), safe_strlen(valueBa.data()));
    m_stateManager->handleEvent(event);
}

void ICSettingsHandler::onHighBeamHeadlightChanged(bool state)
{
    QSafeEventVisibility event;
    const char* item = "telltalesHighBeam";
    event.setId(qsafe_hash(item, safe_strlen(item)));
    event.setValue(state);
    m_stateManager->handleEvent(event);
}

void ICSettingsHandler::onLowBeamHeadlightChanged(bool state)
{
    QSafeEventVisibility event;
    const char* item = "telltalesLowBeam";
    event.setId(qsafe_hash(item, safe_strlen(item)));
    event.setValue(state);
    m_stateManager->handleEvent(event);
}

void ICSettingsHandler::onFogLightChangedChanged(bool state)
{
    QSafeEventVisibility event;
    const char* item = "telltalesFogLights";
    event.setId(qsafe_hash(item, safe_strlen(item)));
    event.setValue(state);
    m_stateManager->handleEvent(event);
}

void ICSettingsHandler::onStabilityControlChanged(bool state)
{
    QSafeEventVisibility event;
    const char* item = "telltalesStabilityControl";
    event.setId(qsafe_hash(item, safe_strlen(item)));
    event.setValue(state);
    m_stateManager->handleEvent(event);
}

void ICSettingsHandler::onSeatBeltNotFastenedChanged(bool state)
{
    QSafeEventVisibility event;
    const char* item = "telltalesSeatBelt";
    event.setId(qsafe_hash(item, safe_strlen(item)));
    event.setValue(state);
    m_stateManager->handleEvent(event);
}

void ICSettingsHandler::onABSFailureChanged(bool state)
{
    QSafeEventVisibility event;
    const char* item = "telltalesAbsFault";
    event.setId(qsafe_hash(item, safe_strlen(item)));
    event.setValue(state);
    m_stateManager->handleEvent(event);
}

void ICSettingsHandler::onParkBrakeChanged(bool state)
{
    QSafeEventVisibility event;
    const char* item = "telltalesParkingBrake";
    event.setId(qsafe_hash(item, safe_strlen(item)));
    event.setValue(state);
    m_stateManager->handleEvent(event);
}

void ICSettingsHandler::onTyrePressureLowChanged(bool state)
{
    QSafeEventVisibility event;
    const char* item = "telltalesTyrePressure";
    event.setId(qsafe_hash(item, safe_strlen(item)));
    event.setValue(state);
    m_stateManager->handleEvent(event);
}

void ICSettingsHandler::onAirbagFailureChanged(bool state)
{
    QSafeEventVisibility event;
    const char* item = "telltalesAirbag";
    event.setId(qsafe_hash(item, safe_strlen(item)));
    event.setValue(state);
    m_stateManager->handleEvent(event);
}

void ICSettingsHandler::onBrakeFailureChanged(bool state)
{
    QSafeEventVisibility event;
    const char* item = "telltalesBrakeFault";
    event.setId(qsafe_hash(item, safe_strlen(item)));
    event.setValue(state);
    m_stateManager->handleEvent(event);
}

void ICSettingsHandler::onLeftTurnChanged(bool state)
{
    m_leftTurnEnabled = state;
    if (state) {
        m_leftTurnState = m_rightTurnState;
        if (!m_blinkTimer.isActive())
            m_blinkTimer.start(m_blinkInterval);
    }
}

void ICSettingsHandler::onRightTurnChanged(bool state)
{
    m_rightTurnEnabled = state;
    if (state) {
        m_rightTurnState = m_leftTurnState;
        if (!m_blinkTimer.isActive())
            m_blinkTimer.start(m_blinkInterval);
    }
}

void ICSettingsHandler::onLeftRightTurnTimer()
{
    //left
    if (m_leftTurnEnabled) {
        m_leftTurnState = !m_leftTurnState;
    } else {
        m_leftTurnState = false;
    }

    QSafeEventVisibility event;
    const char* itemLeft = "telltalesLeftTurn";
    event.setId(qsafe_hash(itemLeft, safe_strlen(itemLeft)));
    event.setValue(m_leftTurnState);
    m_stateManager->handleEvent(event);

    //right
    if (m_rightTurnEnabled) {
        m_rightTurnState = !m_rightTurnState;
    } else {
        m_rightTurnState = false;
    }

    const char* itemRight = "telltalesRightTurn";
    event.setId(qsafe_hash(itemRight, safe_strlen(itemRight)));
    event.setValue(m_rightTurnState);
    m_stateManager->handleEvent(event);

    if (!m_rightTurnEnabled && !m_leftTurnEnabled)
        m_blinkTimer.stop();

}

void ICSettingsHandler::onClientConnectedChanged(bool connected)
{
    if (connected)
    {
        qWarning() << "Connected to Remote Settings Service...";
        onHighBeamHeadlightChanged(m_ic.highBeamHeadlight());
        onLowBeamHeadlightChanged(m_ic.lowBeamHeadlight());
        onFogLightChangedChanged(m_ic.fogLight());
        onStabilityControlChanged(m_ic.stabilityControl());
        onABSFailureChanged(m_ic.ABSFailure());
        onParkBrakeChanged(m_ic.parkBrake());
        onSeatBeltNotFastenedChanged(m_ic.seatBeltNotFastened());
        onTyrePressureLowChanged(m_ic.tyrePressureLow());
        onAirbagFailureChanged(m_ic.airbagFailure());
        onBrakeFailureChanged(m_ic.brakeFailure());
        onRightTurnChanged(m_ic.rightTurn());
        onLeftTurnChanged(m_ic.leftTurn());
        onSpeedChanged(m_ic.speed());
        onPowerChanged(m_ic.ePower());
        onLeftRightTurnTimer();
    } else {
        qWarning() << "Disconnected to Remote Settings Service...";
    }
}
