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
#include "remotesettings_client.h"


Q_LOGGING_CATEGORY(QSRClientApp, "QSRClient.App")

const QString RemoteSettings_Client::settingsLastUrlsPrefix = QStringLiteral("lastUrls");
const QString RemoteSettings_Client::settingsLastUrlsItem = QStringLiteral("url");
const QString RemoteSettings_Client::settingsRemoteSettingsPortItem = QStringLiteral("ports/remoteSettingsPort");
const QString RemoteSettings_Client::settingsDriveDataPortItem = QStringLiteral("ports/driveDataPort");
const int RemoteSettings_Client::numOfUrlsStored = 5;
const int RemoteSettings_Client::timeoutToleranceMS = 1000;
const int RemoteSettings_Client::reconnectionIntervalMS = 3000;
const QString RemoteSettings_Client::defaultUrl = QStringLiteral("tcp://127.0.0.1");
const int RemoteSettings_Client::defaultRemoteSettingsPort = 9999;
const int RemoteSettings_Client::defaultDriveDataPort = 9998;

RemoteSettings_Client::RemoteSettings_Client(QObject *parent) : QObject(parent),
    m_remoteSettingsPort(defaultRemoteSettingsPort),
    m_driveDataPort(defaultDriveDataPort),
    m_connected(false),
    m_timedOut(false),
    m_settings(QStringLiteral("Luxoft Sweden AB"), QStringLiteral("QSRCluster"))
{
    m_configPath = m_tmpDir.filePath(QStringLiteral("server.conf"));
    qputenv("SERVER_CONF_PATH", m_configPath.toLocal8Bit());

    setStatus(tr("Not connected"));
    connect(&m_connectionMonitoringTimer, &QTimer::timeout, this, &RemoteSettings_Client::onCMTimeout);
    connect(&m_connectionMonitoring, &ConnectionMonitoring::counterChanged,
            this, &RemoteSettings_Client::onCMCounterChanged);
    connect(&m_connectionMonitoring, &QIfAbstractFeature::isInitializedChanged,
            this, &RemoteSettings_Client::updateConnectionStatus);
    connect(&m_connectionMonitoring, &QIfAbstractFeature::errorChanged,
            this, &RemoteSettings_Client::updateConnectionStatus);
    connect(&m_reconnectionTimer, &QTimer::timeout, this, &RemoteSettings_Client::onReconnectionTimeout);
    readSettings();
    m_connectionMonitoringTimer.setSingleShot(true);
    m_reconnectionTimer.setSingleShot(false);
}

RemoteSettings_Client::~RemoteSettings_Client()
{
}

QUrl RemoteSettings_Client::serverUrl() const
{
    return m_serverUrl;
}

QString RemoteSettings_Client::status() const
{
    return m_status;
}

QStringList RemoteSettings_Client::lastUrls() const
{
    if (m_lastUrls.isEmpty())
        return {defaultUrl};
    return m_lastUrls;
}

bool RemoteSettings_Client::connected() const
{
    return m_connected;
}

void RemoteSettings_Client::connectToServer(const QString &serverUrl)
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

    remoteSettingsUrl.setPort(m_remoteSettingsPort);
    driveDataUrl.setPort(m_driveDataPort);

    QSettings settings(m_configPath, QSettings::IniFormat);
    settings.beginGroup(QStringLiteral("remotesettings"));
    settings.setValue(QStringLiteral("Registry"), remoteSettingsUrl.toString());
    settings.endGroup();
    settings.sync();
    settings.beginGroup(QStringLiteral("drivedata"));
    settings.setValue(QStringLiteral("Registry"), driveDataUrl.toString());
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

void RemoteSettings_Client::updateConnectionStatus()
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
            qCWarning(QSRClientApp) << "Server heartbeat timed out.";
            m_reconnectionTimer.start(reconnectionIntervalMS);
        }
    }
}

void RemoteSettings_Client::onCMCounterChanged()
{
    m_connectionMonitoringTimer.start(m_connectionMonitoring.intervalMS()+
                                      timeoutToleranceMS);
    if (m_timedOut) {
        m_timedOut = false;
        updateConnectionStatus();
    }
}

void RemoteSettings_Client::onCMTimeout()
{
    m_timedOut = true;
    updateConnectionStatus();
}

void RemoteSettings_Client::onReconnectionTimeout()
{
    connectToServer(serverUrl().toString());
}

void RemoteSettings_Client::setStatus(const QString &status)
{
    if (status==m_status)
        return;
    m_status=status;
    qCWarning(QSRClientApp) << "RemoteSettings_Client status: " << status;
    emit statusChanged(m_status);
}

void RemoteSettings_Client::readSettings()
{
    m_remoteSettingsPort = m_settings.value(settingsRemoteSettingsPortItem, defaultRemoteSettingsPort).toInt();
    m_driveDataPort = m_settings.value(settingsDriveDataPortItem, defaultDriveDataPort).toInt();

    int size=m_settings.beginReadArray(settingsLastUrlsPrefix);
    for (int i=0; i<size; i++) {
        m_settings.setArrayIndex(i);
        m_lastUrls.append(m_settings.value(settingsLastUrlsItem).toString());
    }
    m_settings.endArray();
    emit lastUrlsChanged(m_lastUrls);
}

void RemoteSettings_Client::writeSettings()
{
    m_settings.beginWriteArray(settingsLastUrlsPrefix);
    for (int i=0; i<m_lastUrls.size(); i++) {
        m_settings.setArrayIndex(i);
        m_settings.setValue(settingsLastUrlsItem, m_lastUrls.at(i));
    }
    m_settings.endArray();
}

void RemoteSettings_Client::updateLastUrls(const QString &url)
{
    m_lastUrls.removeOne(url);
    m_lastUrls.push_front(url);
    while (m_lastUrls.size() > numOfUrlsStored)
        m_lastUrls.pop_back();
    writeSettings();
    emit lastUrlsChanged(m_lastUrls);
}
