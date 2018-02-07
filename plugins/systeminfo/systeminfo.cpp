/****************************************************************************
**
** Copyright (C) 2017-2018 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune IVI UI.
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

#include <QNetworkInterface>

#include <QDBusConnection>
#include <QDBusPendingReply>

#include "systeminfo.h"

#define NM_SERVICE QStringLiteral("org.freedesktop.NetworkManager")
#define NM_PATH QStringLiteral("/org/freedesktop/NetworkManager")
#define NM_IFACE QStringLiteral("org.freedesktop.NetworkManager")

SystemInfo::SystemInfo(QObject *parent)
    : QObject(parent)
{
}

void SystemInfo::init()
{
    getAddress();
}

/*
 * This function will return all available Addresses of your device in list.
*/
void SystemInfo::getAddress()
{
    for (const QNetworkInterface &interface : QNetworkInterface::allInterfaces())
    {
        if (interface.flags().testFlag(QNetworkInterface::IsUp) && !interface.flags().testFlag(QNetworkInterface::IsLoopBack)) {
            for (const QNetworkAddressEntry &entry : interface.addressEntries())
            {
                if (interface.hardwareAddress() != QLatin1String("00:00:00:00:00:00")) {
                    m_addressList.append(interface.name() + QLatin1String(" ") + entry.ip().toString() + QLatin1String(" ") + interface.hardwareAddress());
                    emit addressListChanged();
                }
            }
        }
    }
}

void SystemInfo::updateOnlineStatus(quint32 state)
{
    const bool online = state == 70; // NM_STATE_CONNECTED_GLOBAL
    if (online != m_online) {
        m_online = online;
        emit onlineChanged();
    }
}

QStringList SystemInfo::addressList() const
{
    return m_addressList;
}

bool SystemInfo::online() const
{
    return m_online;
}

void SystemInfo::classBegin()
{
    auto conn = QDBusConnection::systemBus();
    conn.connect(NM_SERVICE, NM_PATH, NM_IFACE, QStringLiteral("StateChanged"),
                 this, SLOT(updateOnlineStatus(quint32)));


    QDBusMessage msg = QDBusMessage::createMethodCall(NM_SERVICE, NM_PATH, NM_IFACE, QStringLiteral("state"));
    QDBusPendingCall pCall = conn.asyncCall(msg);
    QDBusPendingCallWatcher *watcher = new QDBusPendingCallWatcher(pCall, this);
    connect(watcher, &QDBusPendingCallWatcher::finished, [this](QDBusPendingCallWatcher *self) {
        QDBusPendingReply<quint32> reply = *self;
        self->deleteLater();
        if (reply.isValid()) {
            updateOnlineStatus(reply.value());
        } else {
            qWarning() << "Error getting online status" << reply.error().name() << reply.error().message();
        }
    });
}

void SystemInfo::componentComplete()
{
    metaObject()->invokeMethod(this, "init", Qt::QueuedConnection);
}
