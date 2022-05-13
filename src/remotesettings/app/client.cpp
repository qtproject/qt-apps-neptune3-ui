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
#include "client.h"

Q_LOGGING_CATEGORY(NeptuneCompanionApp, "NeptuneCompanion.App")

const QString Client::settingsLastUrlsPrefix = QStringLiteral("lastUrls");
const QString Client::settingsLastUrlsItem = QStringLiteral("url");
const QString Client::settingsRemoteSettingsPortItem = QStringLiteral("ports/remoteSettingsPort");
const QString Client::settingsDriveDataPortItem = QStringLiteral("ports/driveDataPort");
const QString Client::settingsIviMediaPortItem = QStringLiteral("ports/iviMediaPort");
const int Client::numOfUrlsStored = 5;
const int Client::timeoutToleranceMS = 1000;
const int Client::reconnectionIntervalMS = 3000;
const QString Client::defaultUrl = QStringLiteral("tcp://127.0.0.1");
const int Client::defaultRemoteSettingsPort = 9999;
const int Client::defaultDriveDataPort = 9998;
const int Client::defaultIviMediaPort = 9997;

Client::Client(QObject *parent) : QObject(parent),
    m_remoteSettingsPort(defaultRemoteSettingsPort),
    m_driveDataPort(defaultDriveDataPort),
    m_iviMediaPort(defaultIviMediaPort),
    m_connected(false),
    m_timedOut(false),
    m_settings(QStringLiteral("Luxoft Sweden AB"), QStringLiteral("NeptuneCompanionApp"))
{
    m_configPath = m_tmpDir.filePath(QStringLiteral("server.conf"));
    qputenv("SERVER_CONF_PATH", m_configPath.toLocal8Bit());

    setStatus(tr("Not connected"));
    connect(&m_connectionMonitoringTimer, &QTimer::timeout, this, &Client::onCMTimeout);
    connect(&m_connectionMonitoring, &ConnectionMonitoring::counterChanged,
            this, &Client::onCMCounterChanged);
    connect(&m_connectionMonitoring, &QIfAbstractFeature::isInitializedChanged,
            this, &Client::updateConnectionStatus);
    connect(&m_connectionMonitoring, &QIfAbstractFeature::errorChanged,
            this, &Client::updateConnectionStatus);
    connect(&m_reconnectionTimer, &QTimer::timeout, this, &Client::onReconnectionTimeout);
    readSettings();
    m_connectionMonitoringTimer.setSingleShot(true);
    m_reconnectionTimer.setSingleShot(false);
}

Client::~Client()
{
}

QUrl Client::serverUrl() const
{
    return m_serverUrl;
}

QString Client::status() const
{
    return m_status;
}

QStringList Client::lastUrls() const
{
    if (m_lastUrls.isEmpty())
        return {defaultUrl};
    return m_lastUrls;
}

bool Client::connected() const
{
    return m_connected;
}

void Client::connectToServer(const QString &serverUrl)
{
    QUrl url(serverUrl);
    if (!url.isValid()) {
        setStatus(tr("Invalid URL: %1").arg(url.toString()));
        return;
    }

    if (url.port() > -1) {
        setStatus(tr("Invalid URL: %1. No port should be defined").arg(url.toString()));
        return;
    }

    if (url==m_serverUrl && connected())
        return;

    QUrl remoteSettingsUrl(url);
    QUrl driveDataUrl(url);
    QUrl iviMediaUrl(url);

    remoteSettingsUrl.setPort(m_remoteSettingsPort);
    driveDataUrl.setPort(m_driveDataPort);
    iviMediaUrl.setPort(m_iviMediaPort);

    QSettings settings(m_configPath, QSettings::IniFormat);
    settings.beginGroup(QStringLiteral("remotesettings"));
    settings.setValue(QStringLiteral("Registry"), remoteSettingsUrl.toString());
    settings.endGroup();
    settings.sync();
    settings.beginGroup(QStringLiteral("drivedata"));
    settings.setValue(QStringLiteral("Registry"), driveDataUrl.toString());
    settings.endGroup();
    settings.sync();
    settings.beginGroup(QStringLiteral("qtifmedia"));
    settings.setValue(QStringLiteral("Registry"), iviMediaUrl.toString());
    settings.endGroup();
    settings.sync();

    setStatus(tr("Connecting to %1...").arg(url.toString()));
    updateLastUrls(url.toString());

    if (m_serverUrl!=url) {
        m_serverUrl=url;
        emit serverUrlChanged(m_serverUrl);
        m_reconnectionTimer.stop();
    }

    m_connectionMonitoring.setServiceObject(nullptr);
    m_connectionMonitoring.startAutoDiscovery();
}

void Client::updateConnectionStatus()
{
    bool c = m_connectionMonitoring.isInitialized() &&
             m_connectionMonitoring.error()==QIfAbstractFeature::NoError &&
             !m_timedOut;
    if (c == m_connected)
        return;
    m_connected = c;
    emit connectedChanged(m_connected);
    if (m_connected) {
        setStatus(tr("Connected to %1").arg(serverUrl().toString()));
        m_reconnectionTimer.stop();
    } else {
        setStatus(tr("Disconnected"));
        if (m_timedOut) {
            qCWarning(NeptuneCompanionApp) << "Server heartbeat timed out.";
            m_reconnectionTimer.start(reconnectionIntervalMS);
        }
    }
}

void Client::onCMCounterChanged()
{
    m_connectionMonitoringTimer.start(m_connectionMonitoring.intervalMS()+
                                      timeoutToleranceMS);
    if (m_timedOut) {
        m_timedOut = false;
        updateConnectionStatus();
    }
}

void Client::onCMTimeout()
{
    m_timedOut = true;
    updateConnectionStatus();
}

void Client::onReconnectionTimeout()
{
    connectToServer(serverUrl().toString());
}

void Client::setStatus(const QString &status)
{
    if (status==m_status)
        return;
    m_status=status;
    qCWarning(NeptuneCompanionApp) << "Client status: " << status;
    emit statusChanged(m_status);
}

void Client::readSettings()
{
    m_remoteSettingsPort = m_settings.value(settingsRemoteSettingsPortItem, defaultRemoteSettingsPort).toInt();
    m_driveDataPort = m_settings.value(settingsDriveDataPortItem, defaultDriveDataPort).toInt();
    m_iviMediaPort = m_settings.value(settingsIviMediaPortItem, defaultIviMediaPort).toInt();

    int size=m_settings.beginReadArray(settingsLastUrlsPrefix);
    for (int i=0; i<size; i++) {
        m_settings.setArrayIndex(i);
        auto url = QUrl(m_settings.value(settingsLastUrlsItem).toString());
        if (url.isValid() && !url.scheme().isEmpty()) {
            url.setPort(-1);
            m_lastUrls.append(url.toString(QUrl::None));
        }
    }

    m_settings.endArray();
    emit lastUrlsChanged(m_lastUrls);
}

void Client::writeSettings()
{
    m_settings.beginWriteArray(settingsLastUrlsPrefix);
    for (int i=0; i<m_lastUrls.size(); i++) {
        m_settings.setArrayIndex(i);
        m_settings.setValue(settingsLastUrlsItem, m_lastUrls.at(i));
    }
    m_settings.endArray();
}

void Client::updateLastUrls(const QString &url)
{
    m_lastUrls.removeOne(url);
    m_lastUrls.push_front(url);
    while (m_lastUrls.size() > numOfUrlsStored)
        m_lastUrls.pop_back();
    writeSettings();
    emit lastUrlsChanged(m_lastUrls);
}
