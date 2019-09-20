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

#ifndef ICSETTINGSHANDLER_H
#define ICSETTINGSHANDLER_H

#include "neptunesafestatemanager.h"
#include "../drivedata/frontend/instrumentcluster.h"
#include "remotesettings_client.h"

QT_USE_NAMESPACE

class ICSettingsHandler : public QObject
{
    Q_OBJECT
public:
    explicit ICSettingsHandler(NeptuneSafeStateManager *manager, QObject *parent = nullptr);
    ~ICSettingsHandler() {
    }

private:
    void init();

public slots:
    void onLeftRightTurnTimer();
    void onSpeedChanged(qreal value);
    void onPowerChanged(qreal value);
    void onHighBeamHeadlightChanged(bool state);
    void onLowBeamHeadlightChanged(bool state);
    void onFogLightChangedChanged(bool state);
    void onStabilityControlChanged(bool state);
    void onSeatBeltNotFastenedChanged(bool state);
    void onABSFailureChanged(bool state);
    void onParkBrakeChanged(bool state);
    void onTyrePressureLowChanged(bool state);
    void onAirbagFailureChanged(bool state);
    void onBrakeFailureChanged(bool state);
    void onLeftTurnChanged(bool state);
    void onRightTurnChanged(bool state);
    void onClientConnectedChanged(bool connected);

private:
    NeptuneSafeStateManager *m_stateManager;
    RemoteSettings_Client *m_client;
    InstrumentCluster      m_ic;

    const int           m_blinkInterval = 667; //(60.0*1000.0) / 90.0;
    QTimer              m_blinkTimer;


    bool    m_rightTurnState;
    bool    m_rightTurnEnabled;
    bool    m_leftTurnState;
    bool    m_leftTurnEnabled;
};

#endif // MSGHANDLER_H
