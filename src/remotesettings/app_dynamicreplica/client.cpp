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

}

void Client::setContextProperties(QQmlContext *context)
{
    context->setContextProperty(QStringLiteral("cultureSettings"), &m_cultureSettings);
    context->setContextProperty(QStringLiteral("audioSettings"), &m_audioSettings);
    context->setContextProperty(QStringLiteral("navigationSettings"), &m_navigationSettings);
    context->setContextProperty(QStringLiteral("model3DSettings"), &m_model3DSettings);
}

void Client::connectToServer(const QString &url)
{
    QSharedPointer<QRemoteObjectDynamicReplica> cultureRep;
    QSharedPointer<QRemoteObjectDynamicReplica> audioRep;
    QSharedPointer<QRemoteObjectDynamicReplica> navigationRep;
    QSharedPointer<QRemoteObjectDynamicReplica> model3DRep;

    m_repNode.connectToNode(QUrl(url));
    //repNode.connectToNode(QUrl("tcp://10.10.1.76:9999")); // create remote object node
    //repNode.connectToNode(QUrl("local:settings"));
    QObject::connect(&m_repNode, &QRemoteObjectNode::error, this, &Client::onError);

    audioRep.reset(m_repNode.acquireDynamic("settings.AudioSettings"));
    cultureRep.reset(m_repNode.acquireDynamic("settings.CultureSettings"));
    navigationRep.reset(m_repNode.acquireDynamic("settings.NavigationSettings"));
    model3DRep.reset(m_repNode.acquireDynamic("settings.Model3DSettings"));

    m_cultureSettings.resetReplica(cultureRep);
    m_audioSettings.resetReplica(audioRep);
    m_navigationSettings.resetReplica(navigationRep);
    m_model3DSettings.resetReplica(model3DRep);
}

void Client::onError(QRemoteObjectNode::ErrorCode code)
{
    qCWarning(remoteSettingsDynamicApp) << "Remote objects error, code:" << code;
}
