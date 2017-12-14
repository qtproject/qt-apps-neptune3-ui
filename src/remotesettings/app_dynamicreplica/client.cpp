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
#include "client.h"
#include <QQmlContext>

Q_LOGGING_CATEGORY(remoteSettingsDynamicApp, "remotesettings.dynamicApp")

Client::Client(QObject *parent) : QObject(parent)
{
    QObject::connect(&m_repNode, &QRemoteObjectNode::error, this, &Client::onError);
    setStatus(tr("Not connected"));
}

void Client::setContextProperties(QQmlContext *context)
{
    context->setContextProperty(QStringLiteral("uiSettings"), &m_UISettings);
    context->setContextProperty(QStringLiteral("instrumentCluster"), &m_instrumentCluster);
}

QUrl Client::serverUrl() const
{
    return m_serverUrl;
}

QString Client::status() const
{
    return m_status;
}

void Client::connectToServer(const QString &serverUrl)
{
    QUrl url(serverUrl);
    if (!url.isValid()) {
        setStatus(tr("Invalid URL: %1").arg(url.toString()));
        return;
    }

    if (url==m_serverUrl)
        return;

    if (m_repNode.connectToNode(url)) {
        m_UISettings.resetReplica(m_repNode.acquireDynamic("settings.UISettings"));
        m_instrumentCluster.resetReplica(m_repNode.acquireDynamic("settings.InstrumentCluster"));
        setStatus(tr("Connected to %1").arg(url.toString()));
    } else {
        setStatus(tr("Connection to %1 failed").arg(url.toString()));
        m_UISettings.resetReplica(nullptr);
        m_instrumentCluster.resetReplica(nullptr);
    }

    if (m_serverUrl!=url) {
        m_serverUrl=url;
        emit serverUrlChanged(m_serverUrl);
    }
}

void Client::onError(QRemoteObjectNode::ErrorCode code)
{
    qCWarning(remoteSettingsDynamicApp) << "Remote objects error, code:" << code;
}

void Client::setStatus(const QString &status)
{
    if (status==m_status)
        return;
    m_status=status;
    qCWarning(remoteSettingsDynamicApp) << "Client status: " << status;
    emit statusChanged(m_status);
}
