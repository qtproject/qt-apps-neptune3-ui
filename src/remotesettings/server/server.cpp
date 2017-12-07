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
    m_cultureSettingsService.reset(new CultureSettingsService(&m_settings));
    Core::instance()->host()->enableRemoting(m_cultureSettingsService.data(), "settings.CultureSettings");
    qCDebug(remoteSettingsServer) << "register service at: settings.CultureSettings";

    m_audioSettingsService.reset(new AudioSettingsService(&m_settings));
    Core::instance()->host()->enableRemoting(m_audioSettingsService.data(), "settings.AudioSettings");
    qCDebug(remoteSettingsServer) << "register service at: settings.AudioSettings";

    m_model3DSettingsService.reset(new Model3DSettingsService(&m_settings));
    Core::instance()->host()->enableRemoting(m_model3DSettingsService.data(), "settings.Model3DSettings");
    qCDebug(remoteSettingsServer) << "register service at: settings.Model3DSettings";

    m_navigationSettingsService.reset(new NavigationSettingsService(&m_settings));
    Core::instance()->host()->enableRemoting(m_navigationSettingsService.data(), "settings.NavigationSettings");
    qCDebug(remoteSettingsServer) << "register service at: settings.NavigationSettings";

}

void Server::onROError(QRemoteObjectNode::ErrorCode code)
{
    qCWarning(remoteSettingsServer) << "Remote objects error, code:" << code;
}

void Server::onAboutToQuit()
{
    qCDebug(remoteSettingsServer) << Q_FUNC_INFO << ", saving all settings";
    m_settings.sync();
}
