/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Copyright (C) 2018 Pelagicore AG
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
#include "server.h"
#include <QCoreApplication>

Q_LOGGING_CATEGORY(remoteSettingsServer, "remotesettings.server")

Server::Server(QObject *parent) : QObject(parent)
{
    connect(QCoreApplication::instance(),&QCoreApplication::aboutToQuit,
            this,&Server::onAboutToQuit);

}

void Server::start()
{
    m_UISettingsService.reset(new UISettingsSimpleSource());
    Core::instance()->host()->enableRemoting(m_UISettingsService.data(), "Settings.UISettings");
    qCDebug(remoteSettingsServer) << "register service at: Settings.UISettings";

    m_instrumentClusterService.reset(new InstrumentClusterSimpleSource());
    Core::instance()->host()->enableRemoting(m_instrumentClusterService.data(), "Settings.InstrumentCluster");
    qCDebug(remoteSettingsServer) << "register service at: Settings.InstrumentCluster";

    m_systemUIService.reset(new SystemUISimpleSource());
    Core::instance()->host()->enableRemoting(m_systemUIService.data(), "Settings.SystemUI");
    qCDebug(remoteSettingsServer) << "register service at: Settings.SystemUI";

    m_connectionMonitoringService.reset(new ConnectionMonitoringSimpleSource());
    Core::instance()->host()->enableRemoting(m_connectionMonitoringService.data(), "Settings.ConnectionMonitoring");
    qCDebug(remoteSettingsServer) << "register service at: Settings.ConnectionMonitoring";

    setInstrumentClusterDefaultValues();
    initConnectionMonitoring();
}

void Server::onROError(QRemoteObjectNode::ErrorCode code)
{
    qCWarning(remoteSettingsServer) << "Remote objects error, code:" << code;
}

void Server::onAboutToQuit()
{
}

void Server::onTimeout()
{
    m_connectionMonitoringService->setCounter(
                            m_connectionMonitoringService->counter() + 1);
}

void Server::setInstrumentClusterDefaultValues()
{
    // Make it look like the car is cruising along a highway instead of
    // having everything zeroed or turned off.

    m_instrumentClusterService->setSpeed(102);
    m_instrumentClusterService->setSpeedLimit(120);
    m_instrumentClusterService->setSpeedCruise(100);
    m_instrumentClusterService->setEPower(41);
    m_instrumentClusterService->setDriveTrainState(2); // 2 == D (drive)
    m_instrumentClusterService->setLowBeamHeadlight(true);
}

void Server::initConnectionMonitoring()
{
    m_connectionMonitoringService->setIntervalMS(2000);
    connect(&m_heartBeatTimer, &QTimer::timeout, this, &Server::onTimeout);
    m_heartBeatTimer.setSingleShot(false);
    m_heartBeatTimer.start(m_connectionMonitoringService->intervalMS());
}
